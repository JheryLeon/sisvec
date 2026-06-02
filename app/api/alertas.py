from flask import Blueprint, request, jsonify, render_template, redirect, url_for, flash
from flask_login import login_required, current_user
from app.models import Alerta
from app import db, limiter, csrf
from app.utils.alerts import (
    obtener_alertas_no_leidas,
    contar_alertas_no_leidas,
    marcar_alerta_leida,
    crear_alerta,
)
from app.utils.security import junta_or_admin_required
from app.forms import AlertaForm

alertas_bp = Blueprint("alertas", __name__, url_prefix="/alertas")


@alertas_bp.route("/")
@login_required
def listar_alertas():
    page = request.args.get("page", 1, type=int)
    filtro = request.args.get("filtro", "todas")

    query = Alerta.query.filter(Alerta.usuario_id == current_user.id)

    if filtro == "no_leidas":
        query = query.filter(Alerta.leida == False)

    pagination = (
        query.order_by(Alerta.fecha_envio.desc())
        .paginate(page=page, per_page=20, error_out=False)
    )

    return render_template(
        "alertas.html",
        alertas=pagination.items,
        pagination=pagination,
        page=page,
        filtro=filtro,
    )


@alertas_bp.route("/api/no-leidas", methods=["GET"])
@login_required
def api_alertas_no_leidas():
    alertas = obtener_alertas_no_leidas(current_user.id)
    return jsonify({
        "alertas": [a.to_dict() for a in alertas],
        "total": len(alertas),
    })


@alertas_bp.route("/api/contar", methods=["GET"])
@login_required
def api_contar_alertas():
    count = contar_alertas_no_leidas(current_user.id)
    return jsonify({"no_leidas": count})


@alertas_bp.route("/api/marcar-leida/<int:id>", methods=["PUT"])
@csrf.exempt
@login_required
def api_marcar_leida(id):
    if marcar_alerta_leida(id, current_user.id):
        return jsonify({"success": True})
    return jsonify({"error": "Alerta no encontrada"}), 404


@alertas_bp.route("/api/marcar-todas-leidas", methods=["PUT"])
@csrf.exempt
@login_required
def api_marcar_todas_leidas():
    Alerta.query.filter_by(
        usuario_id=current_user.id, leida=False
    ).update({"leida": True})
    db.session.commit()
    return jsonify({"success": True})


@alertas_bp.route("/crear", methods=["GET", "POST"])
@junta_or_admin_required
def crear_alerta_masiva():
    form = AlertaForm()
    if form.validate_on_submit():
        from app.models import Usuario, TipoAlerta

        tipo_alerta = TipoAlerta.query.get(form.tipo_alerta_id.data)
        usuarios = Usuario.query.filter(Usuario.activo == True).all()
        count = 0
        for usuario in usuarios:
            crear_alerta(
                usuario_id=usuario.id,
                tipo_nombre=tipo_alerta.nombre if tipo_alerta else "general",
                mensaje=form.mensaje.data.strip(),
                zona=form.zona_afectada.data,
                nivel_riesgo=form.nivel_riesgo.data,
            )
            count += 1

        flash(f"Alerta enviada a {count} usuarios.", "success")
        return redirect(url_for("alertas.listar_alertas"))

    return render_template("crear_alerta.html", form=form)
