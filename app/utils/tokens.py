from flask import current_app
from itsdangerous import URLSafeTimedSerializer, SignatureExpired, BadSignature


def _get_serializer(salt="email-verification"):
    return URLSafeTimedSerializer(current_app.config["SECRET_KEY"], salt=salt)


def generar_token(email, salt="email-verification"):
    s = _get_serializer(salt)
    return s.dumps(email)


def verificar_token(token, max_age=86400, salt="email-verification"):
    s = _get_serializer(salt)
    try:
        email = s.loads(token, max_age=max_age)
        return email
    except SignatureExpired:
        return None
    except BadSignature:
        return None
