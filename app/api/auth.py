import traceback, os, time, secrets
from datetime import datetime, timezone
from flask import Blueprint, render_template, redirect, url_for, flash, request, jsonify, current_app, make_response
from flask_login import login_user, logout_user, login_required, current_user
from werkzeug.utils import secure_filename

from app.models import Usuario, UserSession
from app.forms import LoginForm, RegisterForm
from app import db, limiter
from app.utils.tokens import generar_token
from app.utils.email_sender import enviar_verificacion_email

auth_bp = Blueprint("auth", __name__, url_prefix="/auth")


@auth_bp.route("/login", methods=["GET", "POST"])
@limiter.limit("10 per minute")
def login():
    if current_user.is_authenticated:
        return redirect(url_for("routes.dashboard"))

    form = LoginForm()
    if form.validate_on_submit():
        email = form.email.data.strip().lower()
        password = form.password.data
        user = Usuario.query.filter_by(email=email).first()

        if user and user.check_password(password):
            if not user.activo:
                flash("Cuenta desactivada. Contacta al administrador.", "error")
                return render_template("login.html", form=form)

            if not user.email_verified:
                flash(
                    "Debés verificar tu email antes de iniciar sesión. "
                    "Revisá tu bandeja de entrada (y spam).",
                    "warning",
                )
                return render_template("login.html", form=form)

            # -- Session limit: remove oldest if at limit (max 2) --
            active_sessions = UserSession.query.filter_by(user_id=user.id).order_by(UserSession.last_activity.asc()).all()
            if len(active_sessions) >= 2:
                db.session.delete(active_sessions[0])

            token = secrets.token_hex(32)
            session = UserSession(
                user_id=user.id,
                token=token,
                ip_address=request.remote_addr,
                user_agent=request.user_agent.string[:300] if request.user_agent else None,
            )
            db.session.add(session)
            db.session.commit()

            login_user(user)
            resp = make_response(redirect(request.args.get("next") or url_for("routes.dashboard")))
            resp.set_cookie("session_token", token, httponly=True, samesite="Lax", max_age=86400 * 7)
            flash(f"Bienvenido de nuevo, {user.nombre}!", "success")

            if user.es_admin():
                from app.utils.ml_model import autoentrenar_si_es_necesario
                autoentrenar_si_es_necesario()

            return resp
        else:
            flash("Email o contraseña incorrectos.", "error")

    return render_template("login.html", form=form)


@auth_bp.route("/register", methods=["GET", "POST"])
@limiter.limit("5 per minute")
def register():
    if current_user.is_authenticated:
        return redirect(url_for("routes.dashboard"))

    form = RegisterForm()
    if form.validate_on_submit():
        if form.password.data != form.confirm_password.data:
            flash("Las contraseñas no coinciden.", "error")
            return render_template("register.html", form=form)

        existing = Usuario.query.filter_by(email=form.email.data.strip().lower()).first()
        if existing:
            flash("Este email ya está registrado.", "error")
            return render_template("register.html", form=form)

        from app.models import Rol

        foto_url = None
        if form.foto.data and form.foto.data.filename:
            f = form.foto.data
            ext = f.filename.rsplit(".", 1)[-1].lower() if "." in f.filename else "jpg"
            filename = f"profile_{int(time.time())}_{secure_filename(f.filename)}"
            profiles_dir = os.path.join(current_app.root_path, "static", "uploads", "profiles")
            os.makedirs(profiles_dir, exist_ok=True)
            path = os.path.join(profiles_dir, filename)
            f.save(path)
            foto_url = f"uploads/profiles/{filename}"

        rol_vecino = Rol.query.filter_by(nombre="vecino").first()
        user = Usuario(
            email=form.email.data.strip().lower(),
            nombre=form.nombre.data.strip(),
            telefono=form.telefono.data.strip() if form.telefono.data else None,
            barrio_id=form.barrio_id.data,
            foto_url=foto_url,
            rol_id=rol_vecino.id if rol_vecino else 1,
        )
        user.set_password(form.password.data)

        token = generar_token(user.email)
        user.verification_token = token
        db.session.add(user)
        db.session.commit()

        enviar_verificacion_email(user, token)

        flash(
            "Cuenta creada. Te enviamos un email para verificar tu dirección. "
            "Revisá tu bandeja de entrada (y la carpeta de spam).",
            "success",
        )
        return redirect(url_for("auth.login"))

    return render_template("register.html", form=form)


@auth_bp.route("/verify-email/<token>")
def verify_email(token):
    from app.utils.tokens import verificar_token

    email = verificar_token(token)
    if not email:
        flash("El enlace de verificación es inválido o expiró (24hs).", "error")
        return redirect(url_for("auth.login"))

    user = Usuario.query.filter_by(email=email).first()
    if not user:
        flash("Usuario no encontrado.", "error")
        return redirect(url_for("auth.login"))

    if user.email_verified:
        flash("Tu email ya estaba verificado. Podés iniciar sesión.", "success")
        return redirect(url_for("auth.login"))

    user.email_verified = True
    user.verification_token = None
    db.session.commit()

    flash("Email verificado exitosamente. Ya podés iniciar sesión.", "success")
    return redirect(url_for("auth.login"))


@auth_bp.route("/logout")
@login_required
def logout():
    token = request.cookies.get("session_token")
    if token:
        UserSession.query.filter_by(token=token).delete()
        db.session.commit()
    logout_user()
    resp = make_response(redirect(url_for("auth.login")))
    resp.set_cookie("session_token", "", expires=0)
    flash("Has cerrado sesión.", "info")
    return resp


@auth_bp.route("/api/usuario", methods=["GET"])
@login_required
def api_usuario_actual():
    return jsonify(current_user.to_dict())


@auth_bp.route("/api/check")
def api_check_auth():
    if current_user.is_authenticated:
        return jsonify({"authenticated": True, "user": current_user.to_dict()})
    return jsonify({"authenticated": False}), 401