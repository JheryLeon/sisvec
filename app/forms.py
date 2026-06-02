from flask_wtf import FlaskForm
from flask_wtf.file import FileAllowed, FileField
from wtforms import (
    StringField, PasswordField, SelectField, TextAreaField,
    FloatField, BooleanField, DateTimeLocalField, SubmitField,
)
from wtforms.validators import DataRequired, Length, Optional, NumberRange
from app.models import TipoIncidente, TipoAlerta, Barrio


class LoginForm(FlaskForm):
    email = StringField("Email", validators=[DataRequired(), Length(max=255)], render_kw={"placeholder": "tu@email.com"})
    password = PasswordField("Contraseña", validators=[DataRequired(), Length(min=6, max=128)], render_kw={"placeholder": "••••••••"})
    submit = SubmitField("Iniciar Sesión")


class RegisterForm(FlaskForm):
    nombre = StringField("Nombre Completo", validators=[DataRequired(), Length(min=2, max=100)], render_kw={"placeholder": "Juan Pérez"})
    email = StringField("Email", validators=[DataRequired(), Length(max=255)], render_kw={"placeholder": "tu@email.com"})
    password = PasswordField("Contraseña", validators=[DataRequired(), Length(min=6, max=128)], render_kw={"placeholder": "Mínimo 6 caracteres"})
    confirm_password = PasswordField("Confirmar Contraseña", validators=[DataRequired()], render_kw={"placeholder": "Repite la contraseña"})
    telefono = StringField("Teléfono", validators=[Optional(), Length(max=20)], render_kw={"placeholder": "Ej: +591 71234567"})
    barrio_id = SelectField("Barrio", validators=[DataRequired()], coerce=int)
    foto = FileField("Foto de Perfil", validators=[Optional(), FileAllowed(["jpg", "jpeg", "png", "gif"], "Solo imágenes (jpg, png, gif)")])
    submit = SubmitField("Crear Cuenta")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.barrio_id.choices = [
            (b.id, f"{b.nombre} ({b.ciudad})" if b.ciudad else b.nombre)
            for b in Barrio.query.order_by(Barrio.nombre).all()
        ]


class IncidenteForm(FlaskForm):
    tipo_incidente_id = SelectField("Tipo de Incidente", validators=[DataRequired()], coerce=int)
    descripcion = TextAreaField("Descripción", validators=[Optional(), Length(max=1000)], render_kw={"placeholder": "Describe el incidente (opcional)", "rows": 4})
    fecha_hora = DateTimeLocalField("Fecha y Hora", validators=[DataRequired()], format="%Y-%m-%dT%H:%M")
    latitud = FloatField("Latitud", validators=[DataRequired(), NumberRange(min=-90, max=90)])
    longitud = FloatField("Longitud", validators=[DataRequired(), NumberRange(min=-180, max=180)])
    direccion = StringField("Dirección", validators=[Optional(), Length(max=300)], render_kw={"placeholder": "Calle y número (opcional)"})
    submit = SubmitField("Reportar Incidente")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.tipo_incidente_id.choices = [
            (t.id, t.nombre) for t in TipoIncidente.query.filter_by(activo=True).all()
        ]


class AlertaForm(FlaskForm):
    tipo_alerta_id = SelectField("Tipo de Alerta", validators=[DataRequired()], coerce=int)
    mensaje = TextAreaField("Mensaje", validators=[DataRequired(), Length(max=500)], render_kw={"placeholder": "Contenido de la alerta", "rows": 3})
    zona_afectada = StringField("Zona Afectada", validators=[Optional(), Length(max=100)], render_kw={"placeholder": "Ej: Colonia Centro, Zona Norte"})
    nivel_riesgo = SelectField("Nivel de Riesgo", choices=[("bajo", "Bajo"), ("medio", "Medio"), ("alto", "Alto")], validators=[Optional()])
    submit = SubmitField("Enviar Alerta")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.tipo_alerta_id.choices = [
            (t.id, t.nombre) for t in TipoAlerta.query.all()
        ]


class PerfilForm(FlaskForm):
    nombre = StringField("Nombre Completo", validators=[DataRequired(), Length(min=2, max=100)], render_kw={"placeholder": "Tu nombre"})
    email = StringField("Email", validators=[DataRequired(), Length(max=255)], render_kw={"placeholder": "tu@email.com"})
    telefono = StringField("Teléfono", validators=[Optional(), Length(max=20)], render_kw={"placeholder": "Ej: +591 71234567"})
    barrio_id = SelectField("Barrio", validators=[DataRequired()], coerce=int)
    foto = FileField("Cambiar Foto", validators=[Optional(), FileAllowed(["jpg", "jpeg", "png", "gif"], "Solo imágenes")])
    password = PasswordField("Nueva Contraseña (opcional)", validators=[Optional(), Length(min=6, max=128)], render_kw={"placeholder": "Dejar vacío para mantener"})
    confirm_password = PasswordField("Confirmar Contraseña", validators=[Optional()], render_kw={"placeholder": "Repite la contraseña"})
    submit = SubmitField("Guardar Cambios")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.barrio_id.choices = [
            (b.id, f"{b.nombre} ({b.ciudad})" if b.ciudad else b.nombre)
            for b in Barrio.query.order_by(Barrio.nombre).all()
        ]


class ForgotPasswordForm(FlaskForm):
    email = StringField("Email", validators=[DataRequired(), Length(max=255)], render_kw={"placeholder": "tu@email.com"})
    submit = SubmitField("Enviar enlace")


class ResetPasswordForm(FlaskForm):
    password = PasswordField("Nueva Contraseña", validators=[DataRequired(), Length(min=6, max=128)], render_kw={"placeholder": "Mínimo 6 caracteres"})
    confirm_password = PasswordField("Confirmar Contraseña", validators=[DataRequired()], render_kw={"placeholder": "Repite la contraseña"})
    submit = SubmitField("Restablecer contraseña")
