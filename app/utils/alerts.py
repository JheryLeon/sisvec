import math
from datetime import datetime, timedelta, timezone
from flask import current_app
from app import db
from app.models import Alerta, Incidente, Usuario, TipoIncidente, TipoAlerta


def crear_alerta(usuario_id, tipo_nombre, mensaje, incidente_id=None, zona=None, nivel_riesgo=None):
    tipo_alerta = TipoAlerta.query.filter_by(nombre=tipo_nombre).first()
    if not tipo_alerta:
        tipo_alerta = TipoAlerta.query.first()
        if not tipo_alerta:
            tipo_alerta = TipoAlerta(nombre=tipo_nombre, descripcion="", prioridad=3)
            db.session.add(tipo_alerta)
            db.session.commit()
    alerta = Alerta(
        usuario_id=usuario_id,
        incidente_id=incidente_id,
        tipo_alerta_id=tipo_alerta.id,
        mensaje=mensaje,
        zona_afectada=zona,
        nivel_riesgo=nivel_riesgo,
    )
    db.session.add(alerta)
    db.session.commit()
    return alerta


TIPOS_RIESGO_CRITICO = ("violencia", "robo", "robo_vehiculo", "drogas")


def enviar_alertas_por_incidente(incidente_id):
    incidente = Incidente.query.get(incidente_id)
    if not incidente or not incidente.tipo_incidente:
        return

    nivel = incidente.riesgo_nivel
    tipo_nombre = incidente.tipo_incidente.nombre
    lat, lng = incidente.latitud, incidente.longitud

    usuarios_cercanos = Usuario.query.filter(
        Usuario.activo == True, Usuario.id != incidente.reportado_por
    ).all()

    for usuario in usuarios_cercanos:
        if not usuario.telefono:
            continue
        crear_alerta(
            usuario_id=usuario.id,
            tipo_nombre="nuevo_incidente",
            mensaje="%s Incidente reportado en tu barrio: %s. Nivel de riesgo: %s. Toma precauciones." % (
                "🔴" if nivel == "alto" else "🟡" if nivel == "medio" else "🟢",
                tipo_nombre,
                nivel,
            ),
            incidente_id=incidente.id,
            zona=incidente.barrio_obj.nombre if incidente.barrio_obj else "Zona cercana a [%.4f, %.4f]" % (lat, lng),
            nivel_riesgo=nivel,
        )


def enviar_alertas_incidente_critico(incidente_id):
    incidente = Incidente.query.get(incidente_id)
    if not incidente or not incidente.tipo_incidente:
        return
    if incidente.tipo_incidente.nombre not in TIPOS_RIESGO_CRITICO:
        return

    lat, lng = incidente.latitud, incidente.longitud

    usuarios_cercanos = Usuario.query.filter(
        Usuario.activo == True, Usuario.id != incidente.reportado_por
    ).all()

    for usuario in usuarios_cercanos:
        if usuario.telefono:
            crear_alerta(
                usuario_id=usuario.id,
                tipo_nombre="nuevo_incidente",
                mensaje="⚠️ Incidente reportado en tu barrio: %s. "
                "Toma precauciones. %s" % (
                    incidente.tipo_incidente.nombre,
                    "Descripción: " + incidente.descripcion[:100] if incidente.descripcion else "",
                ),
                incidente_id=incidente.id,
                zona=incidente.barrio_obj.nombre if incidente.barrio_obj else "Zona cercana a [%.4f, %.4f]" % (lat, lng),
                nivel_riesgo=incidente.riesgo_nivel,
            )


def enviar_alertas_riesgo_alto(usuario_id, zona, probabilidad):
    alertas_existentes = Alerta.query.join(TipoAlerta).filter(
        Alerta.usuario_id == usuario_id,
        TipoAlerta.nombre == "riesgo_alto",
        Alerta.fecha_envio >= datetime.now(timezone.utc) - timedelta(hours=24),
        Alerta.zona_afectada == zona,
    ).count()

    if alertas_existentes == 0:
        crear_alerta(
            usuario_id=usuario_id,
            tipo_nombre="riesgo_alto",
            mensaje=f"🔴 Alerta: Zona de alto riesgo detectada en {zona}. "
            f"Probabilidad de incidente: {probabilidad:.0%}. "
            f"Recomendamos extremar precauciones y reportar cualquier actividad sospechosa.",
            zona=zona,
            nivel_riesgo="alto",
        )


def marcar_alerta_leida(alerta_id, usuario_id):
    alerta = Alerta.query.get(alerta_id)
    if alerta and alerta.usuario_id == usuario_id:
        alerta.leida = True
        db.session.commit()
        return True
    return False


def obtener_alertas_no_leidas(usuario_id):
    return Alerta.query.filter(
        Alerta.usuario_id == usuario_id, Alerta.leida == False
    ).order_by(Alerta.fecha_envio.desc()).all()


def contar_alertas_no_leidas(usuario_id):
    return Alerta.query.filter(
        Alerta.usuario_id == usuario_id, Alerta.leida == False
    ).count()
