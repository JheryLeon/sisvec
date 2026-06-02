import os
from dotenv import load_dotenv

load_dotenv()

basedir = os.path.abspath(os.path.dirname(__file__))

PG_URI = os.environ.get(
    "DATABASE_URL",
    "postgresql://postgres:1234@localhost:5432/seguridad_vecinal2",
)


class Config:
    SECRET_KEY = os.environ.get(
        "SECRET_KEY"
    ) or "clave-secreta-temporal-cambiar-en-produccion"
    SQLALCHEMY_DATABASE_URI = PG_URI
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ENGINE_OPTIONS = {
        "pool_pre_ping": True,
        "pool_size": 5,
        "max_overflow": 10,
        "connect_args": {"client_encoding": "utf8", "connect_timeout": 10},
    }
    WTF_CSRF_ENABLED = True
    DEBUG = os.environ.get("FLASK_DEBUG", "1") == "1"
    UPLOAD_FOLDER = os.path.join(basedir, "app", "static", "uploads")
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024

    # Mail
    MAIL_SERVER = os.environ.get("MAIL_SERVER")
    MAIL_PORT = int(os.environ.get("MAIL_PORT", 587))
    MAIL_USERNAME = os.environ.get("MAIL_USERNAME")
    MAIL_PASSWORD = os.environ.get("MAIL_PASSWORD")
    MAIL_FROM = os.environ.get("MAIL_FROM")
    APP_URL = os.environ.get("APP_URL", "http://localhost:5000")


class DevelopmentConfig(Config):
    DEBUG = True


class ProductionConfig(Config):
    DEBUG = False
    SESSION_COOKIE_SECURE = True
    SESSION_COOKIE_SAMESITE = "Lax"
    PREFERRED_URL_SCHEME = "https"


class TestingConfig(Config):
    TESTING = True


config = {
    "development": DevelopmentConfig,
    "production": ProductionConfig,
    "testing": TestingConfig,
    "default": DevelopmentConfig,
}
