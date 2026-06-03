from datetime import datetime, timedelta, timezone
import os
from werkzeug.utils import secure_filename
from flask import Blueprint, request, jsonify, render_template, redirect, url_for, flash, current_app
from flask_login import login_required, current_user
from app.models import Incidente, Usuario, Alerta, TipoIncidente, Validacion, Evidencia, Comentario, Barrio, Rol
from app.forms import IncidenteForm
from app import db, limiter
from app.utils.security import requiere_rol, junta_or_admin_required

incidentes_bp = Blueprint("incidentes", __name__, url_prefix="/incidentes")


@incidentes_bp.route("/reportar", methods=["GET", "POST"])
@login_required
def reportar():
    form = IncidenteForm()
    if form.validate_on_submit():
        tipo_obj = TipoIncidente.query.get(form.tipo_incidente_id.data)
        fecha_raw = form.fecha_hora.data
        if fecha_raw:
            try:
                tz_offset_min = int(request.form.get("tz_offset", 240))
                local_tz = timezone(timedelta(minutes=-tz_offset_min))
                fecha_utc = fecha_raw.replace(tzinfo=local_tz).astimezone(timezone.utc)
            except Exception:
                fecha_utc = fecha_raw.replace(tzinfo=timezone.utc)
        else:
            fecha_utc = datetime.now(timezone.utc)
        incidente = Incidente(
            tipo_incidente_id=form.tipo_incidente_id.data,
            descripcion=form.descripcion.data.strip() if form.descripcion.data else None,
            fecha_hora=fecha_utc,
            latitud=form.latitud.data,
            longitud=form.longitud.data,
            direccion=form.direccion.data.strip() if form.direccion.data else None,
            reportado_por=current_user.id,
            reportado_anonimamente=False,
            riesgo_nivel=tipo_obj.nivel_riesgo_default if tipo_obj else "bajo",
            barrio_id=current_user.barrio_id,
        )
        db.session.add(incidente)
        db.session.commit()

        flash("Incidente reportado exitosamente.", "success")

        from app.utils.alerts import enviar_alertas_por_incidente, crear_alerta
        enviar_alertas_por_incidente(incidente.id)
        crear_alerta(
            usuario_id=current_user.id,
            tipo_nombre="nuevo_incidente",
            mensaje="Reportaste un incidente: %s (riesgo %s). Recibirás notificaciones si hay novedades." % (incidente.tipo, incidente.riesgo_nivel),
            incidente_id=incidente.id,
            nivel_riesgo=incidente.riesgo_nivel,
        )

        files = request.files.getlist("evidencias")
        upload_dir = current_app.config.get("UPLOAD_FOLDER", os.path.join(current_app.root_path, "static", "uploads"))
        for f in files:
            if f and f.filename and f.filename.strip():
                safe_name = "%d_%s" % (int(datetime.now().timestamp() * 1000), secure_filename(f.filename))
                path = os.path.join(upload_dir, safe_name)
                f.save(path)
                ev = Evidencia(
                    incidente_id=incidente.id,
                    subido_por=current_user.id,
                    archivo_url="uploads/" + safe_name,
                    tipo="foto",
                )
                db.session.add(ev)
        if files:
            db.session.commit()

        return redirect(url_for("mapa.mapa"))

    tipos = TipoIncidente.query.filter_by(activo=True).all()
    return render_template("reportar.html", form=form, tipos=tipos)


@incidentes_bp.route("/<int:id>")
@login_required
def detalle(id):
    incidente = Incidente.query.get_or_404(id)
    evidencias = Evidencia.query.filter_by(incidente_id=id).all()
    return render_template("incidente_detalle.html", inc=incidente, evidencias=evidencias)


@incidentes_bp.route("/historial")
@login_required
def historial():
    page = request.args.get("page", 1, type=int)
    per_page = 10
    if current_user.es_admin():
        query = Incidente.query
    else:
        query = Incidente.query.filter(Incidente.reportado_por == current_user.id)
    pagination = query.order_by(Incidente.fecha_hora.desc()).paginate(page=page, per_page=per_page, error_out=False)
    return render_template("historial.html", incidentes=pagination.items, pagination=pagination, page=page)


@incidentes_bp.route("/lista")
@login_required
def lista_incidentes():
    page = request.args.get("page", 1, type=int)
    per_page = 20
    tipo = request.args.get("tipo")
    riesgo = request.args.get("riesgo")
    fecha_desde = request.args.get("fecha_desde")
    fecha_hasta = request.args.get("fecha_hasta")
    resuelto_filter = request.args.get("resuelto")

    query = Incidente.query.join(TipoIncidente)
    if tipo:
        query = query.filter(TipoIncidente.nombre == tipo)
    if riesgo:
        query = query.filter(Incidente.riesgo_nivel == riesgo)
    if fecha_desde:
        query = query.filter(Incidente.fecha_hora >= datetime.fromisoformat(fecha_desde))
    if fecha_hasta:
        query = query.filter(Incidente.fecha_hora <= datetime.fromisoformat(fecha_hasta))
    if resuelto_filter == "activos":
        query = query.filter(Incidente.resuelto == False)
    elif resuelto_filter == "resueltos":
        query = query.filter(Incidente.resuelto == True)

    pagination = query.order_by(Incidente.fecha_hora.desc()).paginate(page=page, per_page=per_page, error_out=False)
    tipos = TipoIncidente.query.filter_by(activo=True).all()
    return render_template("incidentes.html", incidentes=pagination.items, pagination=pagination, page=page, tipos=tipos)


@incidentes_bp.route("/verificar/<int:id>", methods=["POST"])
@junta_or_admin_required
def verificar(id):
    incidente = Incidente.query.get_or_404(id)
    validacion = incidente.validacion
    if not validacion:
        validacion = Validacion(incidente_id=id, validador_id=current_user.id, estado="verificado")
        db.session.add(validacion)
    else:
        validacion.estado = "verificado"
        validacion.validador_id = current_user.id
        validacion.fecha = datetime.now(timezone.utc)
    incidente.verificado = True
    db.session.commit()
    flash("Incidente verificado.", "success")
    return redirect(request.referrer or url_for("incidentes.lista_incidentes"))


@incidentes_bp.route("/eliminar/<int:id>", methods=["POST"])
@junta_or_admin_required
def eliminar(id):
    incidente = Incidente.query.get_or_404(id)
    Alerta.query.filter_by(incidente_id=id).delete()
    Evidencia.query.filter_by(incidente_id=id).delete()
    Comentario.query.filter_by(incidente_id=id).delete()
    if incidente.validacion:
        db.session.delete(incidente.validacion)
    db.session.delete(incidente)
    db.session.commit()
    flash("Incidente eliminado.", "success")
    return redirect(request.referrer or url_for("incidentes.lista_incidentes"))


@incidentes_bp.route("/api/listar", methods=["GET"])
def api_listar_incidentes():
    page = request.args.get("page", 1, type=int)
    per_page = request.args.get("per_page", 50, type=int)
    per_page = min(per_page, 200)
    tipo = request.args.get("tipo")
    riesgo = request.args.get("riesgo")
    dias = request.args.get("dias", type=int)
    resuelto_filter = request.args.get("resuelto")

    query = Incidente.query.join(TipoIncidente)
    if tipo:
        query = query.filter(TipoIncidente.nombre == tipo)
    if riesgo:
        query = query.filter(Incidente.riesgo_nivel == riesgo)
    if dias:
        fecha_limite = datetime.now(timezone.utc) - timedelta(days=dias)
        query = query.filter(Incidente.fecha_hora >= fecha_limite)
    if resuelto_filter == "activos":
        query = query.filter(Incidente.resuelto == False)
    elif resuelto_filter == "resueltos":
        query = query.filter(Incidente.resuelto == True)

    pagination = query.order_by(Incidente.fecha_hora.desc()).paginate(page=page, per_page=per_page, error_out=False)
    return jsonify({
        "incidentes": [i.to_dict() for i in pagination.items],
        "total": pagination.total,
        "page": page,
        "pages": pagination.pages,
    })


@incidentes_bp.route("/api/marcar-resuelto/<int:id>", methods=["POST", "PUT"])
@login_required
def api_marcar_resuelto(id):
    incidente = Incidente.query.get_or_404(id)
    if not (current_user.es_admin() or current_user.es_junta()):
        return jsonify({"error": "Solo admin o junta pueden marcar como resuelto"}), 403
    data = request.get_json(silent=True) or {}
    resolver = data.get("resuelto", True)
    if resolver:
        incidente.resuelto = True
        incidente.resuelto_por = current_user.id
        incidente.fecha_resolucion = datetime.now(timezone.utc)
    else:
        incidente.resuelto = False
        incidente.resuelto_por = None
        incidente.fecha_resolucion = None
    db.session.commit()
    if request.content_type and "application/json" in request.content_type:
        return jsonify({"success": True, "incidente": incidente.to_dict()})
    accion = "resuelto" if resolver else "reactivado"
    flash(f"Incidente {accion}.", "success")
    return redirect(url_for("incidentes.detalle", id=incidente.id))


@incidentes_bp.route("/api/<int:id>", methods=["GET"])
def api_incidente(id):
    incidente = Incidente.query.get_or_404(id)
    return jsonify(incidente.to_dict())


@incidentes_bp.route("/api/reportar", methods=["POST"])
@login_required
@limiter.limit("30 per minute")
def api_crear_incidente():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Datos JSON requeridos"}), 400

    tipo_nombre = data.get("tipo", "otro")
    tipo_obj = TipoIncidente.query.filter_by(nombre=tipo_nombre).first()
    if not tipo_obj:
        tipo_obj = TipoIncidente.query.filter_by(nombre="otro").first()
    if not tipo_obj:
        return jsonify({"error": "Tipo de incidente inválido"}), 400

    incidente = Incidente(
        tipo_incidente_id=tipo_obj.id,
        descripcion=data.get("descripcion"),
        fecha_hora=data.get("fecha_hora", datetime.now(timezone.utc).isoformat()),
        latitud=data["latitud"],
        longitud=data["longitud"],
        direccion=data.get("direccion"),
        reportado_por=current_user.id,
        reportado_anonimamente=False,
        riesgo_nivel=tipo_obj.nivel_riesgo_default,
        barrio_id=current_user.barrio_id,
    )

    try:
        if isinstance(incidente.fecha_hora, str):
            incidente.fecha_hora = datetime.fromisoformat(incidente.fecha_hora)
    except (ValueError, TypeError):
        incidente.fecha_hora = datetime.now(timezone.utc)

    db.session.add(incidente)
    db.session.commit()

    from app.utils.alerts import enviar_alertas_por_incidente
    enviar_alertas_por_incidente(incidente.id)

    return jsonify(incidente.to_dict()), 201


@incidentes_bp.route("/api/stats/resumen", methods=["GET"])
def api_resumen_stats():
    ahora = datetime.now(timezone.utc)
    hace_30_dias = ahora - timedelta(days=30)
    hace_7_dias = ahora - timedelta(days=7)

    total_30d = Incidente.query.filter(Incidente.fecha_hora >= hace_30_dias).count()
    total_7d = Incidente.query.filter(Incidente.fecha_hora >= hace_7_dias).count()
    altos = Incidente.query.filter(Incidente.fecha_hora >= hace_30_dias, Incidente.riesgo_nivel == "alto").count()
    medios = Incidente.query.filter(Incidente.fecha_hora >= hace_30_dias, Incidente.riesgo_nivel == "medio").count()

    reportantes_unicos = db.session.query(Incidente.reportado_por).filter(
        Incidente.fecha_hora >= hace_30_dias, Incidente.reportado_por.isnot(None)
    ).distinct().count()

    tipos_query = db.session.query(TipoIncidente.nombre, db.func.count(Incidente.id)).join(
        Incidente, TipoIncidente.id == Incidente.tipo_incidente_id
    ).filter(Incidente.fecha_hora >= hace_30_dias).group_by(TipoIncidente.nombre).all()

    tendencia = []
    for i in range(30):
        dia = ahora - timedelta(days=29 - i)
        count = Incidente.query.filter(
            Incidente.fecha_hora >= dia.replace(hour=0, minute=0, second=0, microsecond=0),
            Incidente.fecha_hora < dia.replace(hour=23, minute=59, second=59),
        ).count()
        tendencia.append({"fecha": dia.strftime("%Y-%m-%d"), "count": count})

    return jsonify({
        "total_30d": total_30d,
        "total_7d": total_7d,
        "altos_30d": altos,
        "medios_30d": medios,
        "bajos_30d": total_30d - altos - medios,
        "reportantes_unicos": reportantes_unicos,
        "tipos": [{"tipo": t, "count": c} for t, c in tipos_query],
        "tendencia": tendencia,
    })


@incidentes_bp.route("/api/stats/dashboard", methods=["GET"])
def api_dashboard_stats():
    total_incidentes = Incidente.query.count()
    total_vecinos = Usuario.query.join(Rol).filter(Rol.nombre == "vecino").count()
    total_alertas = Alerta.query.count()

    return jsonify({
        "total_incidentes": total_incidentes,
        "total_vecinos": total_vecinos,
        "total_alertas": total_alertas,
    })
