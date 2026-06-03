from datetime import datetime, timedelta, timezone
from flask import Blueprint, request, jsonify, render_template
from app.models import Incidente, Prediccion, TipoIncidente
from app import db

mapa_bp = Blueprint("mapa", __name__, url_prefix="/mapa")


@mapa_bp.route("/")
def mapa():
    tipos = TipoIncidente.query.filter_by(activo=True).all()
    return render_template("mapa.html", tipos=tipos)


@mapa_bp.route("/api/incidentes-recientes", methods=["GET"])
def api_incidentes_recientes():
    horas = request.args.get("horas", 8760, type=int)
    limite = request.args.get("limite", 500, type=int)
    tipo = request.args.get("tipo")
    filtro_resueltos = request.args.get("resueltos")
    filtro_verificado = request.args.get("verificado")

    query = Incidente.query.join(TipoIncidente)

    if horas > 0:
        fecha_limite = datetime.now(timezone.utc) - timedelta(hours=horas)
        query = query.filter(Incidente.fecha_hora >= fecha_limite)

    if filtro_resueltos == "true":
        query = query.filter(Incidente.resuelto == True)
    elif filtro_resueltos == "false":
        query = query.filter(Incidente.resuelto == False)

    if filtro_verificado == "true":
        query = query.filter(Incidente.verificado == True)
    elif filtro_verificado == "false":
        query = query.filter(Incidente.verificado == False)

    if tipo:
        query = query.filter(TipoIncidente.nombre == tipo)

    incidentes = query.order_by(Incidente.fecha_hora.desc()).limit(limite).all()

    features = [i.to_geojson() for i in incidentes]

    return jsonify({
        "type": "FeatureCollection",
        "features": features,
    })


@mapa_bp.route("/api/heatmap", methods=["GET"])
def api_heatmap():
    horas = request.args.get("horas", 8760, type=int)
    filtro_resueltos = request.args.get("resueltos")
    filtro_verificado = request.args.get("verificado")

    q = Incidente.query

    if horas > 0:
        fecha_limite = datetime.now(timezone.utc) - timedelta(hours=horas)
        q = q.filter(Incidente.fecha_hora >= fecha_limite)

    if filtro_resueltos == "true":
        q = q.filter(Incidente.resuelto == True)
    elif filtro_resueltos == "false":
        q = q.filter(Incidente.resuelto == False)

    if filtro_verificado == "true":
        q = q.filter(Incidente.verificado == True)
    elif filtro_verificado == "false":
        q = q.filter(Incidente.verificado == False)

    incidentes = q.all()

    puntos = []
    for i in incidentes:
        peso = _peso_riesgo(i.riesgo_nivel)
        if horas > 0:
            antiguedad_horas = (datetime.now(timezone.utc) - i.fecha_hora).total_seconds() / 3600
            peso *= max(0.2, 1.0 - (antiguedad_horas / horas))

        puntos.append({
            "lat": i.latitud,
            "lng": i.longitud,
            "peso": round(peso, 3),
        })

    return jsonify({
        "puntos": puntos,
        "total": len(puntos),
    })


@mapa_bp.route("/api/predicciones", methods=["GET"])
def api_predicciones_mapa():
    preds = Prediccion.query.filter(
        Prediccion.activa == True
    ).order_by(Prediccion.fecha_prediccion.desc()).limit(200).all()

    features = []
    for p in preds:
        color = _color_nivel(p.nivel_predominante)
        features.append({
            "type": "Feature",
            "geometry": {
                "type": "Polygon",
                "coordinates": [[
                    [p.lng_min, p.lat_min],
                    [p.lng_max, p.lat_min],
                    [p.lng_max, p.lat_max],
                    [p.lng_min, p.lat_max],
                    [p.lng_min, p.lat_min],
                ]],
            },
            "properties": {
                "id": p.id,
                "nivel": p.nivel_predominante,
                "prob_alto": p.probabilidad_alto,
                "prob_medio": p.probabilidad_medio,
                "color": color,
                "centro": {"lat": p.lat_centro, "lng": p.lng_centro},
            },
        })

    return jsonify({
        "type": "FeatureCollection",
        "features": features,
    })


def _peso_riesgo(nivel):
    pesos = {"alto": 1.0, "medio": 0.6, "bajo": 0.3}
    return pesos.get(nivel, 0.3)


def _color_nivel(nivel):
    colores = {"alto": "#dc3545", "medio": "#ffc107", "bajo": "#28a745"}
    return colores.get(nivel, "#6c757d")
