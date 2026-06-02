from flask import Flask
from flask_login import current_user
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager
from flask_wtf.csrf import CSRFProtect
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from config import config

# =========================
# EXTENSIONES (OBLIGATORIO)
# =========================
db = SQLAlchemy()
migrate = Migrate()
login_manager = LoginManager()
login_manager.login_view = "auth.login"
login_manager.login_message = ""
csrf = CSRFProtect()
limiter = Limiter(key_func=get_remote_address)


def create_app(config_name="default"):
    app = Flask(__name__)
    app.config.from_object(config[config_name])

    import os
    upload_dir = app.config.get("UPLOAD_FOLDER", os.path.join(app.root_path, "static", "uploads"))
    os.makedirs(upload_dir, exist_ok=True)
    os.makedirs(os.path.join(upload_dir, "profiles"), exist_ok=True)

    # INIT EXTENSIONS
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)
    csrf.init_app(app)
    limiter.init_app(app)

    # MODELOS
    from app.models import Usuario

    @login_manager.user_loader
    def load_user(user_id):
        return Usuario.query.get(int(user_id))

    # CONTEXT PROCESSOR: info del modelo para el dashboard
    from app.utils.ml_model import obtener_info_ultimo_entrenamiento

    @app.context_processor
    def inject_modelo_info():
        if hasattr(current_user, "is_authenticated") and current_user.is_authenticated:
            return {"info_modelo": obtener_info_ultimo_entrenamiento()}
        return {}

    # BLUEPRINTS
    from .api.auth import auth_bp
    from .api.incidentes import incidentes_bp
    from .api.mapa import mapa_bp
    from .api.predicciones import predicciones_bp
    from .api.alertas import alertas_bp
    from .api.usuarios import usuarios_bp

    app.register_blueprint(auth_bp)
    app.register_blueprint(incidentes_bp)
    app.register_blueprint(mapa_bp)
    app.register_blueprint(predicciones_bp)
    app.register_blueprint(alertas_bp)
    app.register_blueprint(usuarios_bp)

    # CONTEXT PROCESSOR: alertas_no_leidas en todas las páginas
    from app.models import Alerta

    @app.context_processor
    def inject_alertas():
        if hasattr(current_user, "is_authenticated") and current_user.is_authenticated:
            no_leidas = Alerta.query.filter_by(usuario_id=current_user.id, leida=False).count()
            return {"alertas_no_leidas": no_leidas}
        return {}

    # JINJA2 FILTER: UTC → Bolivia (UTC-4)
    from datetime import timezone, timedelta, datetime as _dt

    @app.template_filter("bolivia")
    def bolivia_time(dt):
        if dt is None:
            return "—"
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        b = dt.astimezone(timezone(timedelta(hours=-4)))
        return b.strftime("%d/%m/%Y %H:%M")

    # SESSION VALIDATOR
    from app.models import UserSession
    from datetime import datetime, timezone
    from flask import request as _req

    @app.before_request
    def validate_session():
        if not current_user.is_authenticated:
            return
        from flask_login import logout_user as _logout
        if hasattr(current_user, "is_authenticated") and current_user.is_authenticated:
            token = _req.cookies.get("session_token")
            if not token:
                _logout()
                return
            session = UserSession.query.filter_by(token=token, user_id=current_user.id).first()
            if not session:
                _logout()
                return
            session.last_activity = datetime.now(timezone.utc)
            db.session.commit()

    # ROUTES EXTRA
    from . import routes
    routes.init_app(app)

    return app