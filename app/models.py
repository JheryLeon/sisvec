from datetime import datetime, timezone
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from app import db


class Rol(db.Model):
    __tablename__ = "rol"
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(50), unique=True, nullable=False)
    descripcion = db.Column(db.Text, nullable=True)
    usuarios = db.relationship("Usuario", backref="rol_obj", lazy="dynamic")

    def __repr__(self):
        return self.nombre


class Barrio(db.Model):
    __tablename__ = "barrio"
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    ciudad = db.Column(db.String(100), nullable=True)
    lat_centro = db.Column(db.Float, nullable=True)
    lng_centro = db.Column(db.Float, nullable=True)
    poligono = db.Column(db.JSON, nullable=True)
    usuarios = db.relationship("Usuario", backref="barrio_obj", lazy="dynamic")
    incidentes = db.relationship("Incidente", backref="barrio_obj", lazy="dynamic")
    predicciones = db.relationship("Prediccion", backref="barrio_obj", lazy="dynamic")

    def __repr__(self):
        return self.nombre


class Usuario(UserMixin, db.Model):
    __tablename__ = "usuarios"
    id = db.Column(db.Integer, primary_key=True)
    rol_id = db.Column(db.Integer, db.ForeignKey("rol.id"), nullable=False)
    barrio_id = db.Column(db.Integer, db.ForeignKey("barrio.id"), nullable=True)
    email = db.Column(db.String(255), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(255), nullable=False)
    nombre = db.Column(db.String(100), nullable=False)
    telefono = db.Column(db.String(20), nullable=True)
    activo = db.Column(db.Boolean, default=True, server_default="true")
    email_verified = db.Column(db.Boolean, default=False, server_default="false")
    verification_token = db.Column(db.String(200), nullable=True, unique=True)
    foto_url = db.Column(db.String(500), nullable=True)
    fecha_registro = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    incidentes = db.relationship("Incidente", backref="reportante", lazy="dynamic", foreign_keys="Incidente.reportado_por")
    alertas = db.relationship("Alerta", backref="usuario", lazy="dynamic")
    sesiones = db.relationship("Auditoria", backref="usuario", lazy="dynamic")

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def es_admin(self):
        return self.rol_obj and self.rol_obj.nombre == "admin"

    def es_junta(self):
        return self.rol_obj and self.rol_obj.nombre in ("junta", "admin")

    @property
    def rol(self):
        return self.rol_obj.nombre if self.rol_obj else None

    def to_dict(self):
        return {
            "id": self.id,
            "email": self.email,
            "nombre": self.nombre,
            "rol": self.rol,
            "activo": self.activo,
            "email_verified": self.email_verified,
            "barrio_id": self.barrio_id,
            "fecha_registro": self.fecha_registro.isoformat() if self.fecha_registro else None,
        }

    def __repr__(self):
        return f"<Usuario {self.email} ({self.rol})>"


class TipoIncidente(db.Model):
    __tablename__ = "tipo_incidente"
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(50), unique=True, nullable=False)
    descripcion = db.Column(db.Text, nullable=True)
    nivel_riesgo_default = db.Column(db.String(20), nullable=False, default="bajo")
    icono = db.Column(db.String(50), nullable=True)
    color = db.Column(db.String(7), nullable=True, default="#6c757d")
    activo = db.Column(db.Boolean, default=True, server_default="true")
    incidentes = db.relationship("Incidente", backref="tipo_incidente", lazy="dynamic")

    def __repr__(self):
        return self.nombre


class Incidente(db.Model):
    __tablename__ = "incidentes"
    id = db.Column(db.Integer, primary_key=True)
    tipo_incidente_id = db.Column(db.Integer, db.ForeignKey("tipo_incidente.id"), nullable=False, index=True)
    barrio_id = db.Column(db.Integer, db.ForeignKey("barrio.id"), nullable=True, index=True)
    reportado_por = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=True)
    descripcion = db.Column(db.Text, nullable=True)
    latitud = db.Column(db.Float, nullable=False)
    longitud = db.Column(db.Float, nullable=False)
    direccion = db.Column(db.String(300), nullable=True)
    fecha_hora = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc), index=True)
    riesgo_nivel = db.Column(db.String(20), nullable=False, default="bajo", server_default="bajo")
    reportado_anonimamente = db.Column(db.Boolean, default=False, server_default="false")
    verificado = db.Column(db.Boolean, default=False, server_default="false")
    editable = db.Column(db.Boolean, default=True, server_default="true")
    fecha_creacion = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    resuelto = db.Column(db.Boolean, default=False, server_default="false")
    resuelto_por = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=True)
    fecha_resolucion = db.Column(db.DateTime(timezone=True), nullable=True)
    resuelto_por_usuario = db.relationship("Usuario", backref="incidentes_resueltos", lazy="joined", foreign_keys=[resuelto_por])
    validacion = db.relationship("Validacion", backref="incidente", uselist=False, lazy="joined")
    evidencias = db.relationship("Evidencia", backref="incidente", lazy="dynamic")
    comentarios = db.relationship("Comentario", backref="incidente", lazy="dynamic")
    alertas = db.relationship("Alerta", backref="incidente", lazy="dynamic")

    @property
    def tipo(self):
        return self.tipo_incidente.nombre if self.tipo_incidente else None

    def to_dict(self):
        return {
            "id": self.id,
            "tipo": self.tipo,
            "descripcion": self.descripcion,
            "fecha_hora": self.fecha_hora.isoformat() if self.fecha_hora else None,
            "latitud": self.latitud,
            "longitud": self.longitud,
            "riesgo_nivel": self.riesgo_nivel,
            "reportado_por": self.reportado_por,
            "reportado_anonimamente": self.reportado_anonimamente,
            "verificado": self.verificado,
            "direccion": self.direccion,
            "editable": self.editable,
            "barrio_id": self.barrio_id,
            "fecha_creacion": self.fecha_creacion.isoformat() if self.fecha_creacion else None,
            "resuelto": self.resuelto,
            "resuelto_por": self.resuelto_por,
            "fecha_resolucion": self.fecha_resolucion.isoformat() if self.fecha_resolucion else None,
        }

    def to_geojson(self):
        evs = [{"id": e.id, "url": e.archivo_url, "tipo": e.tipo} for e in self.evidencias.all()] if self.evidencias else []
        return {
            "type": "Feature",
            "geometry": {"type": "Point", "coordinates": [self.longitud, self.latitud]},
            "properties": {
                "id": self.id,
                "tipo": self.tipo,
                "tipo_color": self.tipo_incidente.color if self.tipo_incidente else "#6c757d",
                "descripcion": self.descripcion,
                "fecha_hora": self.fecha_hora.isoformat() if self.fecha_hora else None,
                "riesgo_nivel": self.riesgo_nivel,
                "verificado": self.verificado,
                "resuelto": self.resuelto,
                "direccion": self.direccion,
                "evidencias": evs,
            },
        }

    def __repr__(self):
        return f"<Incidente {self.id} - {self.tipo} ({self.riesgo_nivel})>"


class Evidencia(db.Model):
    __tablename__ = "evidencia"
    id = db.Column(db.Integer, primary_key=True)
    incidente_id = db.Column(db.Integer, db.ForeignKey("incidentes.id"), nullable=False, index=True)
    subido_por = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=True)
    archivo_url = db.Column(db.String(500), nullable=False)
    tipo = db.Column(db.String(20), nullable=False, default="foto")
    fecha_subida = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))

    def __repr__(self):
        return f"<Evidencia {self.id} ({self.tipo})>"


class Comentario(db.Model):
    __tablename__ = "comentario"
    id = db.Column(db.Integer, primary_key=True)
    incidente_id = db.Column(db.Integer, db.ForeignKey("incidentes.id"), nullable=False, index=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=False)
    texto = db.Column(db.Text, nullable=False)
    fecha = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    usuario = db.relationship("Usuario", backref="comentarios", lazy="joined")

    def __repr__(self):
        return f"<Comentario {self.id}>"


class Validacion(db.Model):
    __tablename__ = "validacion"
    id = db.Column(db.Integer, primary_key=True)
    incidente_id = db.Column(db.Integer, db.ForeignKey("incidentes.id"), unique=True, nullable=False, index=True)
    validador_id = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=False)
    estado = db.Column(db.String(20), nullable=False, default="pendiente")
    observacion = db.Column(db.Text, nullable=True)
    fecha = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    validador = db.relationship("Usuario", backref="validaciones", lazy="joined")

    def __repr__(self):
        return f"<Validacion {self.id} - {self.estado}>"


class TipoAlerta(db.Model):
    __tablename__ = "tipo_alerta"
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(50), unique=True, nullable=False)
    descripcion = db.Column(db.Text, nullable=True)
    prioridad = db.Column(db.Integer, default=3)
    alertas = db.relationship("Alerta", backref="tipo_alerta", lazy="dynamic")

    def __repr__(self):
        return self.nombre


class Alerta(db.Model):
    __tablename__ = "alertas"
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=False, index=True)
    incidente_id = db.Column(db.Integer, db.ForeignKey("incidentes.id"), nullable=True)
    tipo_alerta_id = db.Column(db.Integer, db.ForeignKey("tipo_alerta.id"), nullable=False)
    mensaje = db.Column(db.Text, nullable=False)
    fecha_envio = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    leida = db.Column(db.Boolean, default=False, server_default="false")
    zona_afectada = db.Column(db.String(100), nullable=True)
    nivel_riesgo = db.Column(db.String(20), nullable=True)

    @property
    def tipo(self):
        return self.tipo_alerta.nombre if self.tipo_alerta else None

    def to_dict(self):
        return {
            "id": self.id,
            "usuario_id": self.usuario_id,
            "incidente_id": self.incidente_id,
            "tipo": self.tipo,
            "mensaje": self.mensaje,
            "fecha_envio": self.fecha_envio.isoformat() if self.fecha_envio else None,
            "leida": self.leida,
            "zona_afectada": self.zona_afectada,
            "nivel_riesgo": self.nivel_riesgo,
        }

    def __repr__(self):
        return f"<Alerta {self.id} - {self.tipo}>"


class Prediccion(db.Model):
    __tablename__ = "predicciones_riesgo"
    id = db.Column(db.Integer, primary_key=True)
    barrio_id = db.Column(db.Integer, db.ForeignKey("barrio.id"), nullable=True, index=True)
    lat_centro = db.Column(db.Float, nullable=False)
    lng_centro = db.Column(db.Float, nullable=False)
    lat_min = db.Column(db.Float, nullable=False)
    lat_max = db.Column(db.Float, nullable=False)
    lng_min = db.Column(db.Float, nullable=False)
    lng_max = db.Column(db.Float, nullable=False)
    probabilidad_alto = db.Column(db.Float, nullable=False)
    probabilidad_medio = db.Column(db.Float, nullable=False)
    probabilidad_bajo = db.Column(db.Float, nullable=False)
    nivel_predominante = db.Column(db.String(20), nullable=False)
    fecha_prediccion = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc), index=True)
    modelo_version = db.Column(db.String(50), nullable=True)
    incidentes_ultima_hora = db.Column(db.Integer, default=0)
    activa = db.Column(db.Boolean, default=True, server_default="true")

    def to_dict(self):
        return {
            "id": self.id,
            "barrio_id": self.barrio_id,
            "bounds": {"lat_min": self.lat_min, "lat_max": self.lat_max, "lng_min": self.lng_min, "lng_max": self.lng_max},
            "center": {"lat": self.lat_centro, "lng": self.lng_centro},
            "probabilidades": {"alto": self.probabilidad_alto, "medio": self.probabilidad_medio, "bajo": self.probabilidad_bajo},
            "nivel_predominante": self.nivel_predominante,
            "fecha_prediccion": self.fecha_prediccion.isoformat() if self.fecha_prediccion else None,
            "modelo_version": self.modelo_version,
            "incidentes_ultima_hora": self.incidentes_ultima_hora,
        }

    def __repr__(self):
        return f"<Prediccion ({self.nivel_predominante}) [{self.lat_centro:.4f}, {self.lng_centro:.4f}]>"


class Auditoria(db.Model):
    __tablename__ = "auditoria"
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=False, index=True)
    accion = db.Column(db.String(50), nullable=False)
    entidad = db.Column(db.String(50), nullable=False)
    entidad_id = db.Column(db.Integer, nullable=True)
    detalle = db.Column(db.Text, nullable=True)
    ip = db.Column(db.String(45), nullable=True)
    fecha = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))

    def __repr__(self):
        return f"<Auditoria {self.id} - {self.accion} {self.entidad}>"


class UserSession(db.Model):
    __tablename__ = "user_sessions"
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=False, index=True)
    token = db.Column(db.String(128), unique=True, nullable=False, index=True)
    ip_address = db.Column(db.String(45), nullable=True)
    user_agent = db.Column(db.String(300), nullable=True)
    created_at = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    last_activity = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))

    usuario = db.relationship("Usuario", backref="sessions")

    def __repr__(self):
        return f"<UserSession {self.id} user={self.user_id}>"


class Reporte(db.Model):
    __tablename__ = "reporte"
    id = db.Column(db.Integer, primary_key=True)
    tipo = db.Column(db.String(20), nullable=False)
    generado_por = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=True)
    parametros = db.Column(db.JSON, nullable=True)
    archivo_url = db.Column(db.String(500), nullable=True)
    tamano_bytes = db.Column(db.Integer, nullable=True)
    fecha_generacion = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))

    def __repr__(self):
        return f"<Reporte {self.id} ({self.tipo})>"
