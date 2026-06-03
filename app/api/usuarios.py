from flask import Blueprint, request, jsonify, render_template, redirect, url_for, flash
from flask_login import login_required, current_user
from app.models import Usuario, Incidente, Rol
from app import db
from app.utils.security import admin_required

usuarios_bp = Blueprint("usuarios", __name__, url_prefix="/usuarios")


@usuarios_bp.route("/admin")
@admin_required
def admin_panel():
    usuarios = Usuario.query.order_by(Usuario.fecha_registro.desc()).all()
    stats = {
        "total": len(usuarios),
        "vecinos": sum(1 for u in usuarios if u.rol == "vecino"),
        "juntas": sum(1 for u in usuarios if u.rol == "junta"),
        "admins": sum(1 for u in usuarios if u.rol == "admin"),
    }
    return render_template("admin.html", usuarios=usuarios, stats=stats)


@usuarios_bp.route("/cambiar-rol/<int:id>", methods=["POST"])
@admin_required
def cambiar_rol(id):
    usuario = Usuario.query.get_or_404(id)
    nuevo_rol = request.form.get("rol")
    roles_validos = ["vecino", "junta", "admin"]

    if nuevo_rol not in roles_validos:
        flash("Rol inválido.", "error")
        return redirect(url_for("usuarios.admin_panel"))

    if usuario.id == current_user.id:
        flash("No puedes cambiar tu propio rol.", "error")
        return redirect(url_for("usuarios.admin_panel"))

    rol_obj = Rol.query.filter_by(nombre=nuevo_rol).first()
    if not rol_obj:
        flash("Rol no encontrado.", "error")
        return redirect(url_for("usuarios.admin_panel"))
    usuario.rol_id = rol_obj.id
    db.session.commit()
    flash(f"Rol de {usuario.nombre} cambiado a {nuevo_rol}.", "success")
    return redirect(url_for("usuarios.admin_panel"))


@usuarios_bp.route("/toggle-activo/<int:id>", methods=["POST"])
@admin_required
def toggle_activo(id):
    usuario = Usuario.query.get_or_404(id)
    if usuario.id == current_user.id:
        flash("No puedes desactivarte a ti mismo.", "error")
        return redirect(url_for("usuarios.admin_panel"))

    usuario.activo = not usuario.activo
    db.session.commit()
    estado = "activado" if usuario.activo else "desactivado"
    flash(f"Usuario {usuario.nombre} {estado}.", "success")
    return redirect(url_for("usuarios.admin_panel"))


@usuarios_bp.route("/api/listar", methods=["GET"])
@admin_required
def api_listar_usuarios():
    usuarios = Usuario.query.order_by(Usuario.fecha_registro.desc()).all()
    return jsonify({
        "usuarios": [u.to_dict() for u in usuarios],
        "total": len(usuarios),
    })
