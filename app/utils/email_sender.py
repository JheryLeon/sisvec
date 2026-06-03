import smtplib
from email.mime.text import MIMEText
from flask import current_app, render_template


def enviar_email(destinatario, asunto, cuerpo_html):
    mail_server = current_app.config.get("MAIL_SERVER")
    mail_port = current_app.config.get("MAIL_PORT", 587)
    mail_user = current_app.config.get("MAIL_USERNAME")
    mail_pass = current_app.config.get("MAIL_PASSWORD")
    mail_from = current_app.config.get("MAIL_FROM") or mail_user

    if not mail_server or not mail_user or not mail_pass:
        current_app.logger.warning(
            "Mail no configurado. No se pudo enviar email a %s", destinatario
        )
        return False

    msg = MIMEText(cuerpo_html, "html")
    msg["Subject"] = asunto
    msg["From"] = mail_from
    msg["To"] = destinatario

    try:
        with smtplib.SMTP(mail_server, mail_port) as server:
            server.starttls()
            server.login(mail_user, mail_pass)
            server.sendmail(mail_from, [destinatario], msg.as_string())
        return True
    except Exception as e:
        current_app.logger.error("Error enviando email a %s: %s", destinatario, e)
        return False


def enviar_verificacion_email(usuario, token):
    asunto = "Verifica tu cuenta - SISVEC"
    link = f"{current_app.config.get('APP_URL', 'http://localhost:5000')}/auth/verify-email/{token}"
    cuerpo = (
        "<h2>Bienvenido a SISVEC</h2>"
        f"<p>Hola <b>{usuario.nombre}</b>,</p>"
        "<p>Hacé clic en el siguiente enlace para verificar tu cuenta:</p>"
        f'<p><a href="{link}" style="display:inline-block;padding:12px 24px;background:#198754;color:#fff;text-decoration:none;border-radius:6px;">Verificar mi cuenta</a></p>'
        f"<p>O copiá este enlace en tu navegador:</p>"
        f"<p><code>{link}</code></p>"
        "<p>Este enlace expira en 24 horas.</p>"
        "<hr><p style='color:#888;font-size:12px;'>SISVEC - Sistema de Seguridad Predictiva Vecinal</p>"
    )
    return enviar_email(usuario.email, asunto, cuerpo)


def enviar_reset_password_email(usuario, token):
    asunto = "Restablece tu contraseña - SISVEC"
    link = f"{current_app.config.get('APP_URL', 'http://localhost:5000')}/auth/reset-password/{token}"
    cuerpo = (
        "<h2>Restablecer contraseña</h2>"
        f"<p>Hola <b>{usuario.nombre}</b>,</p>"
        "<p>Recibimos una solicitud para restablecer tu contraseña. Hacé clic en el siguiente enlace:</p>"
        f'<p><a href="{link}" style="display:inline-block;padding:12px 24px;background:#dc3545;color:#fff;text-decoration:none;border-radius:6px;">Restablecer contraseña</a></p>'
        f"<p>O copiá este enlace en tu navegador:</p>"
        f"<p><code>{link}</code></p>"
        "<p>Este enlace expira en 1 hora. Si no solicitaste esto, ignorá este mensaje.</p>"
        "<hr><p style='color:#888;font-size:12px;'>SISVEC - Sistema de Seguridad Predictiva Vecinal</p>"
    )
    return enviar_email(usuario.email, asunto, cuerpo)
