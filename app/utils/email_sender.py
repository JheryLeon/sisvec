import smtplib
from email.mime.text import MIMEText
from flask import current_app, render_template
from app.utils.sendgrid_sender import enviar_email_sendgrid


def enviar_email(destinatario, asunto, cuerpo_html):
    api_key = current_app.config.get("SENDGRID_API_KEY")
    mail_from = current_app.config.get("MAIL_FROM") or current_app.config.get("MAIL_USERNAME")

    if api_key:
        try:
            ok = enviar_email_sendgrid(destinatario, asunto, cuerpo_html, api_key, mail_from)
            if not ok:
                current_app.logger.error("SendGrid devolvio error al enviar a %s", destinatario)
            return ok
        except Exception as e:
            current_app.logger.error("Error SendGrid a %s: %s", destinatario, e)
            return False

    mail_server = current_app.config.get("MAIL_SERVER")
    mail_port = current_app.config.get("MAIL_PORT", 587)
    mail_user = current_app.config.get("MAIL_USERNAME")
    mail_pass = current_app.config.get("MAIL_PASSWORD")

    if not mail_server or not mail_user or not mail_pass:
        current_app.logger.warning(
            "Mail no configurado (ni SMTP ni SendGrid). No se pudo enviar email a %s", destinatario
        )
        return False

    msg = MIMEText(cuerpo_html, "html")
    msg["Subject"] = asunto
    msg["From"] = mail_from
    msg["To"] = destinatario

    try:
        if mail_port == 465:
            server = smtplib.SMTP_SSL(mail_server, mail_port, timeout=10)
        else:
            server = smtplib.SMTP(mail_server, mail_port, timeout=10)
            server.starttls()
        with server:
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
