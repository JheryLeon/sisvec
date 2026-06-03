import requests


def enviar_email_sendgrid(destinatario, asunto, cuerpo_html, api_key, mail_from):
    url = "https://api.sendgrid.com/v3/mail/send"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }
    data = {
        "personalizations": [{"to": [{"email": destinatario}]}],
        "from": {"email": mail_from},
        "subject": asunto,
        "content": [{"type": "text/html", "value": cuerpo_html}],
    }
    resp = requests.post(url, json=data, headers=headers, timeout=15)
    return resp.status_code == 202
