from flask import Blueprint, request, jsonify, current_app
from flask_login import login_required, current_user
from app import db, csrf
from app.utils.ml_model import (
    entrenar_modelo,
    predecir_para_usuario,
    obtener_resumen_predicciones,
    obtener_resumen_riesgo_actual,
)
from app.utils.security import admin_required

predicciones_bp = Blueprint("predicciones", __name__, url_prefix="/predicciones")


@predicciones_bp.route("/api/riesgo-actual", methods=["GET"])
def api_riesgo_actual():
    resumen = obtener_resumen_riesgo_actual()
    return jsonify(resumen)


@predicciones_bp.route("/api/para-ubicacion", methods=["GET"])
def api_predecir_ubicacion():
    lat = request.args.get("lat", type=float)
    lng = request.args.get("lng", type=float)
    radio = request.args.get("radio", 0.5, type=float)

    if lat is None or lng is None:
        return jsonify({"error": "lat y lng son requeridos"}), 400

    resultado = predecir_para_usuario(lat, lng, radio)
    return jsonify(resultado)


@predicciones_bp.route("/api/resumen", methods=["GET"])
def api_resumen_predicciones():
    predicciones = obtener_resumen_predicciones()
    return jsonify({
        "predicciones": predicciones,
        "total": len(predicciones),
    })


@predicciones_bp.route("/admin/entrenar", methods=["POST"])
@csrf.exempt
@admin_required
def admin_entrenar():
    lat_min = request.args.get("lat_min", type=float)
    lat_max = request.args.get("lat_max", type=float)
    lng_min = request.args.get("lng_min", type=float)
    lng_max = request.args.get("lng_max", type=float)

    try:
        resultado = entrenar_modelo(lat_min, lat_max, lng_min, lng_max)
        return jsonify(resultado)
    except Exception as e:
        current_app.logger.error(f"Error entrenando modelo: {e}")
        return jsonify({"success": False, "error": str(e)}), 500


@predicciones_bp.route("/api/tendencias", methods=["GET"])
def api_tendencias():
    from datetime import datetime, timedelta, timezone
    from app.models import Incidente

    dias = request.args.get("dias", 30, type=int)
    resultado = []

    for i in range(dias):
        dia = datetime.now(timezone.utc) - timedelta(days=dias - 1 - i)
        inicio = dia.replace(hour=0, minute=0, second=0, microsecond=0)
        fin = dia.replace(hour=23, minute=59, second=59)

        total = Incidente.query.filter(
            Incidente.fecha_hora >= inicio,
            Incidente.fecha_hora <= fin,
        ).count()

        altos = Incidente.query.filter(
            Incidente.fecha_hora >= inicio,
            Incidente.fecha_hora <= fin,
            Incidente.riesgo_nivel == "alto",
        ).count()

        resultado.append({
            "fecha": dia.strftime("%Y-%m-%d"),
            "total": total,
            "altos": altos,
        })

    return jsonify({"tendencias": resultado})
