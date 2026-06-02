import math
import numpy as np
import pandas as pd
from datetime import datetime, timedelta, timezone
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from app import db
from app.models import Incidente, Prediccion

MODEL_VERSION = "v1.0-rf"
GRID_SIZE_DEGREES = 0.01
MAX_GRID_CELLS = 5000
HOURS_HISTORY = 2160
AUTO_TRAIN_HOURS = 1


def _extract_features(incidentes_df, hora_objetivo=None):
    if incidentes_df.empty:
        return pd.DataFrame()

    if hora_objetivo is None:
        hora_objetivo = datetime.now(timezone.utc)

    features = []
    for _, row in incidentes_df.iterrows():
        feature = {
            "hora_del_dia": row["fecha_hora"].hour,
            "dia_de_semana": row["fecha_hora"].weekday(),
            "es_fin_de_semana": 1 if row["fecha_hora"].weekday() >= 5 else 0,
            "es_noche": 1 if row["fecha_hora"].hour < 6 or row["fecha_hora"].hour >= 20 else 0,
            "latitud": round(row["latitud"] / GRID_SIZE_DEGREES) * GRID_SIZE_DEGREES,
            "longitud": round(row["longitud"] / GRID_SIZE_DEGREES) * GRID_SIZE_DEGREES,
        }

        if "riesgo_nivel" in row:
            if row["riesgo_nivel"] == "alto":
                feature["target"] = 2
            elif row["riesgo_nivel"] == "medio":
                feature["target"] = 1
            else:
                feature["target"] = 0

        features.append(feature)

    return pd.DataFrame(features)


def _crear_cuadricula(lat_min, lat_max, lng_min, lng_max):
    cells = []
    lat = lat_min
    while lat < lat_max:
        lng = lng_min
        while lng < lng_max:
            cells.append({
                "lat_min": lat,
                "lat_max": lat + GRID_SIZE_DEGREES,
                "lng_min": lng,
                "lng_max": lng + GRID_SIZE_DEGREES,
                "lat_centro": lat + GRID_SIZE_DEGREES / 2,
                "lng_centro": lng + GRID_SIZE_DEGREES / 2,
            })
            lng += GRID_SIZE_DEGREES
        lat += GRID_SIZE_DEGREES
    return cells


def entrenar_modelo(lat_min=None, lat_max=None, lng_min=None, lng_max=None):
    fecha_limite = datetime.now(timezone.utc) - timedelta(hours=HOURS_HISTORY)

    if lat_min is None:
        bounds = (
            db.session.query(
                db.func.min(Incidente.latitud),
                db.func.max(Incidente.latitud),
                db.func.min(Incidente.longitud),
                db.func.max(Incidente.longitud),
            )
            .filter(Incidente.fecha_hora >= fecha_limite)
            .first()
        )
        if bounds and bounds[0] is not None:
            lat_min, lat_max, lng_min, lng_max = bounds
            lat_min -= 0.02
            lat_max += 0.02
            lng_min -= 0.02
            lng_max += 0.02
        else:
            lat_min, lat_max, lng_min, lng_max = -90, 90, -180, 180

    incidentes = Incidente.query.filter(
        Incidente.fecha_hora >= fecha_limite,
        Incidente.latitud.between(lat_min, lat_max),
        Incidente.longitud.between(lng_min, lng_max),
    ).all()

    if len(incidentes) < 10:
        return {"success": False, "error": "Datos insuficientes para entrenar (mínimo 10 incidentes)"}

    df = pd.DataFrame([i.to_dict() for i in incidentes])
    df["fecha_hora"] = pd.to_datetime(df["fecha_hora"], format="ISO8601")
    features_df = _extract_features(df)

    if features_df.empty or "target" not in features_df.columns:
        _generar_predicciones_base(incidentes)
        return {
            "success": True,
            "message": "Modelo base generado por falta de features",
            "model_version": MODEL_VERSION,
        }

    X = features_df.drop("target", axis=1)
    y = features_df["target"]

    label_encoders = {}
    for col in X.select_dtypes(include=["object"]).columns:
        le = LabelEncoder()
        X[col] = le.fit_transform(X[col].astype(str))
        label_encoders[col] = le

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    model = RandomForestClassifier(
        n_estimators=100,
        max_depth=10,
        random_state=42,
        n_jobs=-1,
    )
    model.fit(X_train, y_train)

    accuracy = model.score(X_test, y_test)

    cuadricula = _crear_cuadricula(lat_min, lat_max, lng_min, lng_max)

    if len(cuadricula) > MAX_GRID_CELLS:
        return {"success": False, "error": f"Demasiadas celdas ({len(cuadricula)}). Máximo permitido: {MAX_GRID_CELLS}. La zona de búsqueda es muy amplia."}

    Prediccion.query.filter_by(activa=True).update({"activa": False})
    db.session.commit()

    predicciones_creadas = 0
    for cell in cuadricula:
        hora_actual = datetime.now(timezone.utc)
        sample = pd.DataFrame([{
            "hora_del_dia": hora_actual.hour,
            "dia_de_semana": hora_actual.weekday(),
            "es_fin_de_semana": 1 if hora_actual.weekday() >= 5 else 0,
            "es_noche": 1 if hora_actual.hour < 6 or hora_actual.hour >= 20 else 0,
            "latitud": cell["lat_centro"],
            "longitud": cell["lng_centro"],
        }])
        for col in label_encoders:
            if col in sample.columns:
                sample[col] = label_encoders[col].transform(sample[col].astype(str))

        probas = model.predict_proba(sample)[0]

        prob_alto = float(probas[2]) if len(probas) > 2 else 0.0
        prob_medio = float(probas[1]) if len(probas) > 1 else 0.0
        prob_bajo = float(probas[0]) if len(probas) > 0 else 1.0

        if prob_alto > 0.1 or prob_medio > 0.2:
            nivel = "alto" if prob_alto > prob_medio and prob_alto > prob_bajo else (
                "medio" if prob_medio > prob_bajo else "bajo"
            )

            incidentes_vecinos = sum(
                1 for i in incidentes
                if cell["lat_min"] <= i.latitud < cell["lat_max"]
                and cell["lng_min"] <= i.longitud < cell["lng_max"]
                and (datetime.now(timezone.utc) - i.fecha_hora).total_seconds() < 3600
            )

            pred = Prediccion(
                lat_centro=cell["lat_centro"],
                lng_centro=cell["lng_centro"],
                lat_min=cell["lat_min"],
                lat_max=cell["lat_max"],
                lng_min=cell["lng_min"],
                lng_max=cell["lng_max"],
                probabilidad_alto=prob_alto,
                probabilidad_medio=prob_medio,
                probabilidad_bajo=prob_bajo,
                nivel_predominante=nivel,
                modelo_version=MODEL_VERSION,
                incidentes_ultima_hora=incidentes_vecinos,
                activa=True,
            )
            db.session.add(pred)
            predicciones_creadas += 1

    db.session.commit()

    return {
        "success": True,
        "accuracy": float(accuracy),
        "predictions_created": predicciones_creadas,
        "model_version": MODEL_VERSION,
    }


def _generar_predicciones_base(incidentes):
    Prediccion.query.filter_by(activa=True).update({"activa": False})
    db.session.commit()

    if not incidentes:
        return

    df = pd.DataFrame(
        [(i.latitud, i.longitud, i.riesgo_nivel) for i in incidentes],
        columns=["lat", "lng", "riesgo"],
    )

    lat_min, lat_max = df["lat"].min() - 0.02, df["lat"].max() + 0.02
    lng_min, lng_max = df["lng"].min() - 0.02, df["lng"].max() + 0.02

    cuadricula = _crear_cuadricula(lat_min, lat_max, lng_min, lng_max)
    total = len(incidentes)

    for cell in cuadricula:
        incidentes_celda = [
            i for i in incidentes
            if cell["lat_min"] <= i.latitud < cell["lat_max"]
            and cell["lng_min"] <= i.longitud < cell["lng_max"]
        ]

        if not incidentes_celda:
            continue

        altos = sum(1 for i in incidentes_celda if i.riesgo_nivel == "alto")
        medios = sum(1 for i in incidentes_celda if i.riesgo_nivel == "medio")
        n = len(incidentes_celda)

        prob_alto = altos / n
        prob_medio = medios / n
        prob_bajo = (n - altos - medios) / n

        nivel = "alto" if prob_alto > 0.2 else ("medio" if prob_medio > 0.3 else "bajo")

        pred = Prediccion(
            lat_centro=cell["lat_centro"],
            lng_centro=cell["lng_centro"],
            lat_min=cell["lat_min"],
            lat_max=cell["lat_max"],
            lng_min=cell["lng_min"],
            lng_max=cell["lng_max"],
            probabilidad_alto=prob_alto,
            probabilidad_medio=prob_medio,
            probabilidad_bajo=prob_bajo,
            nivel_predominante=nivel,
            modelo_version=MODEL_VERSION + "-base",
            incidentes_ultima_hora=n,
            activa=True,
        )
        db.session.add(pred)

    db.session.commit()


def predecir_para_usuario(latitud, longitud, radio_km=0.5):
    delta_lat = radio_km / 111.0
    delta_lng = radio_km / (111.0 * abs(np.cos(np.radians(latitud))) + 0.001)

    predicciones = Prediccion.query.filter(
        Prediccion.activa == True,
        Prediccion.lat_centro.between(latitud - delta_lat, latitud + delta_lat),
        Prediccion.lng_centro.between(longitud - delta_lng, longitud + delta_lng),
    ).all()

    if not predicciones:
        return {"nivel": "desconocido", "probabilidad_alto": 0.0}

    max_alto = max(p.probabilidad_alto for p in predicciones)

    if max_alto > 0.5:
        nivel = "alto"
    elif max_alto > 0.2:
        nivel = "medio"
    else:
        nivel = "bajo"

    return {
        "nivel": nivel,
        "probabilidad_alto": float(max_alto),
        "celdas_cercanas": len(predicciones),
    }


def obtener_resumen_predicciones():
    ultimas = (
        Prediccion.query.filter_by(activa=True)
        .order_by(Prediccion.fecha_prediccion.desc())
        .limit(100)
        .all()
    )

    if not ultimas:
        return []

    return [p.to_dict() for p in ultimas]


def obtener_resumen_riesgo_actual():
    zonas_altas = Prediccion.query.filter(
        Prediccion.activa == True,
        Prediccion.nivel_predominante == "alto",
    ).count()

    zonas_medias = Prediccion.query.filter(
        Prediccion.activa == True,
        Prediccion.nivel_predominante == "medio",
    ).count()

    total = zonas_altas + zonas_medias
    zonas_altas_parcial = Prediccion.query.filter(
        Prediccion.activa == True,
        Prediccion.nivel_predominante == "bajo",
    ).count()

    if total + zonas_altas_parcial == 0:
        return {"nivel_global": "desconocido", "zonas_altas": 0, "zonas_medias": 0, "zonas_bajas": 0}

    if zonas_altas > total * 0.3:
        nivel = "alto"
    elif zonas_medias > total * 0.5:
        nivel = "medio"
    else:
        nivel = "bajo"

    return {
        "nivel_global": nivel,
        "zonas_altas": zonas_altas,
        "zonas_medias": zonas_medias,
        "zonas_bajas": zonas_altas_parcial,
    }


def obtener_info_ultimo_entrenamiento():
    ultima = Prediccion.query.order_by(Prediccion.fecha_prediccion.desc()).first()
    if not ultima:
        return {"entrenado": False, "necesita_entrenar": True, "mensaje": "Nunca se ha entrenado"}
    total = Prediccion.query.filter_by(activa=True).count()
    desde = ultima.fecha_prediccion
    hace_un_hora = datetime.now(timezone.utc) - timedelta(hours=AUTO_TRAIN_HOURS)
    return {
        "entrenado": True,
        "fecha": desde.isoformat() if desde else None,
        "zonas_activas": total,
        "necesita_entrenar": desde < hace_un_hora if desde else True,
        "mensaje": f"Último entrenamiento: {desde.strftime('%d/%m/%Y %H:%M') if desde else '—'} ({total} zonas activas)",
    }


def autoentrenar_si_es_necesario():
    info = obtener_info_ultimo_entrenamiento()
    if info["necesita_entrenar"]:
        try:
            return entrenar_modelo()
        except Exception as e:
            return {"success": False, "error": str(e)}
    return {"success": True, "message": "Ya entrenado recientemente", "accuracy": None, "predictions_created": 0}
