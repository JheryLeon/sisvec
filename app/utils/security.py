from functools import wraps
from flask import abort, redirect, url_for
from flask_login import current_user


def requiere_rol(*roles_permitidos):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if not current_user.is_authenticated:
                return redirect(url_for("auth.login"))
            if current_user.rol_obj.nombre not in roles_permitidos:
                abort(403)
            return f(*args, **kwargs)
        return decorated_function
    return decorator


def admin_required(f):
    return requiere_rol("admin")(f)


def junta_or_admin_required(f):
    return requiere_rol("junta", "admin")(f)


def verificar_acceso(incidente, usuario):
    if usuario.es_admin():
        return True
    return incidente.reportado_por == usuario.id
