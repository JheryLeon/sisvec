--
-- PostgreSQL database dump
--

\restrict UGfgFSfo9fhhxUha2wrLeeAiKyRmcdAVdgonk7tNTezMhVWVXNamKob26pdW8AO

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alertas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alertas (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    incidente_id integer,
    mensaje text NOT NULL,
    fecha_envio timestamp with time zone NOT NULL,
    leida boolean DEFAULT false,
    zona_afectada character varying(100),
    nivel_riesgo character varying(20),
    tipo_alerta_id integer NOT NULL
);


--
-- Name: alertas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alertas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alertas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alertas_id_seq OWNED BY public.alertas.id;


--
-- Name: auditoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auditoria (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    accion character varying(50) NOT NULL,
    entidad character varying(50) NOT NULL,
    entidad_id integer,
    detalle text,
    ip character varying(45),
    fecha timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: auditoria_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auditoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auditoria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auditoria_id_seq OWNED BY public.auditoria.id;


--
-- Name: barrio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.barrio (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    ciudad character varying(100),
    lat_centro double precision,
    lng_centro double precision,
    poligono json
);


--
-- Name: barrio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.barrio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: barrio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.barrio_id_seq OWNED BY public.barrio.id;


--
-- Name: comentario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comentario (
    id integer NOT NULL,
    incidente_id integer NOT NULL,
    usuario_id integer NOT NULL,
    texto text CONSTRAINT comentario_contenido_not_null NOT NULL,
    fecha timestamp with time zone DEFAULT now() CONSTRAINT comentario_fecha_creacion_not_null NOT NULL
);


--
-- Name: comentario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comentario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comentario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comentario_id_seq OWNED BY public.comentario.id;


--
-- Name: evidencia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.evidencia (
    id integer NOT NULL,
    incidente_id integer NOT NULL,
    tipo character varying(20) NOT NULL,
    archivo_url character varying(500) NOT NULL,
    fecha_subida timestamp with time zone DEFAULT now() NOT NULL,
    subido_por integer
);


--
-- Name: evidencia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.evidencia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evidencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.evidencia_id_seq OWNED BY public.evidencia.id;


--
-- Name: incidentes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.incidentes (
    id integer NOT NULL,
    descripcion text,
    fecha_hora timestamp with time zone NOT NULL,
    latitud double precision NOT NULL,
    longitud double precision NOT NULL,
    riesgo_nivel character varying(20) DEFAULT 'bajo'::character varying NOT NULL,
    reportado_por integer,
    reportado_anonimamente boolean DEFAULT false,
    verificado boolean DEFAULT false,
    direccion character varying(300),
    fecha_creacion timestamp with time zone NOT NULL,
    tipo_incidente_id integer NOT NULL,
    barrio_id integer,
    editable boolean DEFAULT true,
    resuelto boolean DEFAULT false NOT NULL,
    resuelto_por integer,
    fecha_resolucion timestamp with time zone
);


--
-- Name: incidentes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.incidentes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: incidentes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.incidentes_id_seq OWNED BY public.incidentes.id;


--
-- Name: predicciones_riesgo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.predicciones_riesgo (
    id integer NOT NULL,
    lat_centro double precision NOT NULL,
    lng_centro double precision NOT NULL,
    lat_min double precision NOT NULL,
    lat_max double precision NOT NULL,
    lng_min double precision NOT NULL,
    lng_max double precision NOT NULL,
    probabilidad_alto double precision NOT NULL,
    probabilidad_medio double precision NOT NULL,
    probabilidad_bajo double precision NOT NULL,
    nivel_predominante character varying(20) NOT NULL,
    fecha_prediccion timestamp with time zone NOT NULL,
    modelo_version character varying(50),
    incidentes_ultima_hora integer,
    activa boolean DEFAULT true,
    barrio_id integer
);


--
-- Name: predicciones_riesgo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.predicciones_riesgo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: predicciones_riesgo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.predicciones_riesgo_id_seq OWNED BY public.predicciones_riesgo.id;


--
-- Name: reporte; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reporte (
    id integer NOT NULL,
    tipo character varying(20) NOT NULL,
    fecha_generacion timestamp with time zone DEFAULT now() NOT NULL,
    generado_por integer,
    parametros json,
    archivo_url character varying(500),
    tamano_bytes integer
);


--
-- Name: reporte_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reporte_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reporte_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reporte_id_seq OWNED BY public.reporte.id;


--
-- Name: rol; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rol (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text
);


--
-- Name: rol_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rol_id_seq OWNED BY public.rol.id;


--
-- Name: tipo_alerta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tipo_alerta (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text,
    prioridad integer DEFAULT 3
);


--
-- Name: tipo_alerta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tipo_alerta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tipo_alerta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tipo_alerta_id_seq OWNED BY public.tipo_alerta.id;


--
-- Name: tipo_incidente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tipo_incidente (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    nivel_riesgo_default character varying(20) DEFAULT 'bajo'::character varying NOT NULL,
    icono character varying(50),
    color character varying(7) DEFAULT '#6c757d'::character varying,
    activo boolean DEFAULT true,
    descripcion text
);


--
-- Name: tipo_incidente_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tipo_incidente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tipo_incidente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tipo_incidente_id_seq OWNED BY public.tipo_incidente.id;


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_sessions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token character varying(128) NOT NULL,
    ip_address character varying(45),
    user_agent character varying(300),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    last_activity timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: user_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_sessions_id_seq OWNED BY public.user_sessions.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    nombre character varying(100) NOT NULL,
    rol_id integer DEFAULT 3 CONSTRAINT usuarios_rol_not_null NOT NULL,
    activo boolean DEFAULT true,
    telefono character varying(20),
    fecha_registro timestamp with time zone NOT NULL,
    barrio_id integer,
    foto_url character varying(500),
    email_verified boolean DEFAULT false,
    verification_token character varying(200)
);


--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: validacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.validacion (
    id integer NOT NULL,
    incidente_id integer NOT NULL,
    validador_id integer,
    fecha timestamp with time zone DEFAULT now() CONSTRAINT validacion_fecha_validacion_not_null NOT NULL,
    estado character varying(20) DEFAULT 'pendiente'::character varying NOT NULL,
    observacion text
);


--
-- Name: validacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.validacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: validacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.validacion_id_seq OWNED BY public.validacion.id;


--
-- Name: alertas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas ALTER COLUMN id SET DEFAULT nextval('public.alertas_id_seq'::regclass);


--
-- Name: auditoria id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auditoria ALTER COLUMN id SET DEFAULT nextval('public.auditoria_id_seq'::regclass);


--
-- Name: barrio id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.barrio ALTER COLUMN id SET DEFAULT nextval('public.barrio_id_seq'::regclass);


--
-- Name: comentario id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comentario ALTER COLUMN id SET DEFAULT nextval('public.comentario_id_seq'::regclass);


--
-- Name: evidencia id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evidencia ALTER COLUMN id SET DEFAULT nextval('public.evidencia_id_seq'::regclass);


--
-- Name: incidentes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidentes ALTER COLUMN id SET DEFAULT nextval('public.incidentes_id_seq'::regclass);


--
-- Name: predicciones_riesgo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.predicciones_riesgo ALTER COLUMN id SET DEFAULT nextval('public.predicciones_riesgo_id_seq'::regclass);


--
-- Name: reporte id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reporte ALTER COLUMN id SET DEFAULT nextval('public.reporte_id_seq'::regclass);


--
-- Name: rol id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol ALTER COLUMN id SET DEFAULT nextval('public.rol_id_seq'::regclass);


--
-- Name: tipo_alerta id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_alerta ALTER COLUMN id SET DEFAULT nextval('public.tipo_alerta_id_seq'::regclass);


--
-- Name: tipo_incidente id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_incidente ALTER COLUMN id SET DEFAULT nextval('public.tipo_incidente_id_seq'::regclass);


--
-- Name: user_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions ALTER COLUMN id SET DEFAULT nextval('public.user_sessions_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Name: validacion id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.validacion ALTER COLUMN id SET DEFAULT nextval('public.validacion_id_seq'::regclass);


--
-- Name: alertas alertas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_pkey PRIMARY KEY (id);


--
-- Name: auditoria auditoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT auditoria_pkey PRIMARY KEY (id);


--
-- Name: barrio barrio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.barrio
    ADD CONSTRAINT barrio_pkey PRIMARY KEY (id);


--
-- Name: comentario comentario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT comentario_pkey PRIMARY KEY (id);


--
-- Name: evidencia evidencia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evidencia
    ADD CONSTRAINT evidencia_pkey PRIMARY KEY (id);


--
-- Name: incidentes incidentes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidentes
    ADD CONSTRAINT incidentes_pkey PRIMARY KEY (id);


--
-- Name: predicciones_riesgo predicciones_riesgo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.predicciones_riesgo
    ADD CONSTRAINT predicciones_riesgo_pkey PRIMARY KEY (id);


--
-- Name: reporte reporte_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reporte
    ADD CONSTRAINT reporte_pkey PRIMARY KEY (id);


--
-- Name: rol rol_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_nombre_key UNIQUE (nombre);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- Name: tipo_alerta tipo_alerta_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_alerta
    ADD CONSTRAINT tipo_alerta_nombre_key UNIQUE (nombre);


--
-- Name: tipo_alerta tipo_alerta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_alerta
    ADD CONSTRAINT tipo_alerta_pkey PRIMARY KEY (id);


--
-- Name: tipo_incidente tipo_incidente_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_incidente
    ADD CONSTRAINT tipo_incidente_nombre_key UNIQUE (nombre);


--
-- Name: tipo_incidente tipo_incidente_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_incidente
    ADD CONSTRAINT tipo_incidente_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_token_key UNIQUE (token);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: validacion validacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.validacion
    ADD CONSTRAINT validacion_pkey PRIMARY KEY (id);


--
-- Name: idx_alertas_tipo_alerta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alertas_tipo_alerta ON public.alertas USING btree (tipo_alerta_id);


--
-- Name: idx_auditoria_usuario; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_auditoria_usuario ON public.auditoria USING btree (usuario_id);


--
-- Name: idx_user_sessions_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_sessions_token ON public.user_sessions USING btree (token);


--
-- Name: idx_user_sessions_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_sessions_user_id ON public.user_sessions USING btree (user_id);


--
-- Name: ix_alertas_usuario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_alertas_usuario_id ON public.alertas USING btree (usuario_id);


--
-- Name: ix_incidentes_barrio_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_incidentes_barrio_id ON public.incidentes USING btree (barrio_id);


--
-- Name: ix_incidentes_fecha_hora; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_incidentes_fecha_hora ON public.incidentes USING btree (fecha_hora);


--
-- Name: ix_incidentes_tipo_incidente_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_incidentes_tipo_incidente_id ON public.incidentes USING btree (tipo_incidente_id);


--
-- Name: ix_predicciones_riesgo_fecha_prediccion; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_predicciones_riesgo_fecha_prediccion ON public.predicciones_riesgo USING btree (fecha_prediccion);


--
-- Name: ix_usuarios_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_usuarios_email ON public.usuarios USING btree (email);


--
-- Name: alertas alertas_incidente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_incidente_id_fkey FOREIGN KEY (incidente_id) REFERENCES public.incidentes(id);


--
-- Name: alertas alertas_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- Name: auditoria auditoria_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT auditoria_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- Name: comentario comentario_incidente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT comentario_incidente_id_fkey FOREIGN KEY (incidente_id) REFERENCES public.incidentes(id);


--
-- Name: comentario comentario_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT comentario_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- Name: evidencia evidencia_incidente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evidencia
    ADD CONSTRAINT evidencia_incidente_id_fkey FOREIGN KEY (incidente_id) REFERENCES public.incidentes(id);


--
-- Name: evidencia evidencia_subido_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evidencia
    ADD CONSTRAINT evidencia_subido_por_fkey FOREIGN KEY (subido_por) REFERENCES public.usuarios(id);


--
-- Name: alertas fk_alertas_tipo_alerta; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT fk_alertas_tipo_alerta FOREIGN KEY (tipo_alerta_id) REFERENCES public.tipo_alerta(id);


--
-- Name: incidentes incidentes_barrio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidentes
    ADD CONSTRAINT incidentes_barrio_id_fkey FOREIGN KEY (barrio_id) REFERENCES public.barrio(id);


--
-- Name: incidentes incidentes_reportado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidentes
    ADD CONSTRAINT incidentes_reportado_por_fkey FOREIGN KEY (reportado_por) REFERENCES public.usuarios(id);


--
-- Name: incidentes incidentes_resuelto_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidentes
    ADD CONSTRAINT incidentes_resuelto_por_fkey FOREIGN KEY (resuelto_por) REFERENCES public.usuarios(id);


--
-- Name: incidentes incidentes_tipo_incidente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidentes
    ADD CONSTRAINT incidentes_tipo_incidente_id_fkey FOREIGN KEY (tipo_incidente_id) REFERENCES public.tipo_incidente(id);


--
-- Name: predicciones_riesgo predicciones_riesgo_barrio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.predicciones_riesgo
    ADD CONSTRAINT predicciones_riesgo_barrio_id_fkey FOREIGN KEY (barrio_id) REFERENCES public.barrio(id);


--
-- Name: reporte reporte_generado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reporte
    ADD CONSTRAINT reporte_generado_por_fkey FOREIGN KEY (generado_por) REFERENCES public.usuarios(id);


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.usuarios(id);


--
-- Name: usuarios usuarios_barrio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_barrio_id_fkey FOREIGN KEY (barrio_id) REFERENCES public.barrio(id);


--
-- Name: usuarios usuarios_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.rol(id);


--
-- Name: validacion validacion_incidente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.validacion
    ADD CONSTRAINT validacion_incidente_id_fkey FOREIGN KEY (incidente_id) REFERENCES public.incidentes(id);


--
-- Name: validacion validacion_validado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.validacion
    ADD CONSTRAINT validacion_validado_por_fkey FOREIGN KEY (validador_id) REFERENCES public.usuarios(id);


--
-- PostgreSQL database dump complete
--

\unrestrict UGfgFSfo9fhhxUha2wrLeeAiKyRmcdAVdgonk7tNTezMhVWVXNamKob26pdW8AO

