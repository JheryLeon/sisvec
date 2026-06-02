from flask import current_app
from itsdangerous import URLSafeTimedSerializer, SignatureExpired, BadSignature


def _get_serializer():
    return URLSafeTimedSerializer(
        current_app.config["SECRET_KEY"], salt="email-verification"
    )


def generar_token(email):
    s = _get_serializer()
    return s.dumps(email)


def verificar_token(token, max_age=86400):
    s = _get_serializer()
    try:
        email = s.loads(token, max_age=max_age)
        return email
    except SignatureExpired:
        return None
    except BadSignature:
        return None
