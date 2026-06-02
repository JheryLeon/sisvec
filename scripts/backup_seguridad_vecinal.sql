--
-- PostgreSQL database dump
--

\restrict b4yvZHYhMzZ6iz24ZGnNVCv7XGSgVZbTlNX0GFkq6vlUcZAmSiP5Q77u74i54eK

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

ALTER TABLE IF EXISTS ONLY public.validacion DROP CONSTRAINT IF EXISTS validacion_validado_por_fkey;
ALTER TABLE IF EXISTS ONLY public.validacion DROP CONSTRAINT IF EXISTS validacion_incidente_id_fkey;
ALTER TABLE IF EXISTS ONLY public.usuarios DROP CONSTRAINT IF EXISTS usuarios_rol_id_fkey;
ALTER TABLE IF EXISTS ONLY public.usuarios DROP CONSTRAINT IF EXISTS usuarios_barrio_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_sessions DROP CONSTRAINT IF EXISTS user_sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reporte DROP CONSTRAINT IF EXISTS reporte_generado_por_fkey;
ALTER TABLE IF EXISTS ONLY public.predicciones_riesgo DROP CONSTRAINT IF EXISTS predicciones_riesgo_barrio_id_fkey;
ALTER TABLE IF EXISTS ONLY public.incidentes DROP CONSTRAINT IF EXISTS incidentes_tipo_incidente_id_fkey;
ALTER TABLE IF EXISTS ONLY public.incidentes DROP CONSTRAINT IF EXISTS incidentes_resuelto_por_fkey;
ALTER TABLE IF EXISTS ONLY public.incidentes DROP CONSTRAINT IF EXISTS incidentes_reportado_por_fkey;
ALTER TABLE IF EXISTS ONLY public.incidentes DROP CONSTRAINT IF EXISTS incidentes_barrio_id_fkey;
ALTER TABLE IF EXISTS ONLY public.alertas DROP CONSTRAINT IF EXISTS fk_alertas_tipo_alerta;
ALTER TABLE IF EXISTS ONLY public.evidencia DROP CONSTRAINT IF EXISTS evidencia_subido_por_fkey;
ALTER TABLE IF EXISTS ONLY public.evidencia DROP CONSTRAINT IF EXISTS evidencia_incidente_id_fkey;
ALTER TABLE IF EXISTS ONLY public.comentario DROP CONSTRAINT IF EXISTS comentario_usuario_id_fkey;
ALTER TABLE IF EXISTS ONLY public.comentario DROP CONSTRAINT IF EXISTS comentario_incidente_id_fkey;
ALTER TABLE IF EXISTS ONLY public.auditoria DROP CONSTRAINT IF EXISTS auditoria_usuario_id_fkey;
ALTER TABLE IF EXISTS ONLY public.alertas DROP CONSTRAINT IF EXISTS alertas_usuario_id_fkey;
ALTER TABLE IF EXISTS ONLY public.alertas DROP CONSTRAINT IF EXISTS alertas_incidente_id_fkey;
DROP INDEX IF EXISTS public.ix_usuarios_email;
DROP INDEX IF EXISTS public.ix_predicciones_riesgo_fecha_prediccion;
DROP INDEX IF EXISTS public.ix_incidentes_tipo_incidente_id;
DROP INDEX IF EXISTS public.ix_incidentes_fecha_hora;
DROP INDEX IF EXISTS public.ix_incidentes_barrio_id;
DROP INDEX IF EXISTS public.ix_alertas_usuario_id;
DROP INDEX IF EXISTS public.idx_user_sessions_user_id;
DROP INDEX IF EXISTS public.idx_user_sessions_token;
DROP INDEX IF EXISTS public.idx_auditoria_usuario;
DROP INDEX IF EXISTS public.idx_alertas_tipo_alerta;
ALTER TABLE IF EXISTS ONLY public.validacion DROP CONSTRAINT IF EXISTS validacion_pkey;
ALTER TABLE IF EXISTS ONLY public.usuarios DROP CONSTRAINT IF EXISTS usuarios_pkey;
ALTER TABLE IF EXISTS ONLY public.user_sessions DROP CONSTRAINT IF EXISTS user_sessions_token_key;
ALTER TABLE IF EXISTS ONLY public.user_sessions DROP CONSTRAINT IF EXISTS user_sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.tipo_incidente DROP CONSTRAINT IF EXISTS tipo_incidente_pkey;
ALTER TABLE IF EXISTS ONLY public.tipo_incidente DROP CONSTRAINT IF EXISTS tipo_incidente_nombre_key;
ALTER TABLE IF EXISTS ONLY public.tipo_alerta DROP CONSTRAINT IF EXISTS tipo_alerta_pkey;
ALTER TABLE IF EXISTS ONLY public.tipo_alerta DROP CONSTRAINT IF EXISTS tipo_alerta_nombre_key;
ALTER TABLE IF EXISTS ONLY public.rol DROP CONSTRAINT IF EXISTS rol_pkey;
ALTER TABLE IF EXISTS ONLY public.rol DROP CONSTRAINT IF EXISTS rol_nombre_key;
ALTER TABLE IF EXISTS ONLY public.reporte DROP CONSTRAINT IF EXISTS reporte_pkey;
ALTER TABLE IF EXISTS ONLY public.predicciones_riesgo DROP CONSTRAINT IF EXISTS predicciones_riesgo_pkey;
ALTER TABLE IF EXISTS ONLY public.incidentes DROP CONSTRAINT IF EXISTS incidentes_pkey;
ALTER TABLE IF EXISTS ONLY public.evidencia DROP CONSTRAINT IF EXISTS evidencia_pkey;
ALTER TABLE IF EXISTS ONLY public.comentario DROP CONSTRAINT IF EXISTS comentario_pkey;
ALTER TABLE IF EXISTS ONLY public.barrio DROP CONSTRAINT IF EXISTS barrio_pkey;
ALTER TABLE IF EXISTS ONLY public.auditoria DROP CONSTRAINT IF EXISTS auditoria_pkey;
ALTER TABLE IF EXISTS ONLY public.alertas DROP CONSTRAINT IF EXISTS alertas_pkey;
ALTER TABLE IF EXISTS public.validacion ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.usuarios ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_sessions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tipo_incidente ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tipo_alerta ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.rol ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.reporte ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.predicciones_riesgo ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.incidentes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.evidencia ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.comentario ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.barrio ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.auditoria ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.alertas ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.validacion_id_seq;
DROP TABLE IF EXISTS public.validacion;
DROP SEQUENCE IF EXISTS public.usuarios_id_seq;
DROP TABLE IF EXISTS public.usuarios;
DROP SEQUENCE IF EXISTS public.user_sessions_id_seq;
DROP TABLE IF EXISTS public.user_sessions;
DROP SEQUENCE IF EXISTS public.tipo_incidente_id_seq;
DROP TABLE IF EXISTS public.tipo_incidente;
DROP SEQUENCE IF EXISTS public.tipo_alerta_id_seq;
DROP TABLE IF EXISTS public.tipo_alerta;
DROP SEQUENCE IF EXISTS public.rol_id_seq;
DROP TABLE IF EXISTS public.rol;
DROP SEQUENCE IF EXISTS public.reporte_id_seq;
DROP TABLE IF EXISTS public.reporte;
DROP SEQUENCE IF EXISTS public.predicciones_riesgo_id_seq;
DROP TABLE IF EXISTS public.predicciones_riesgo;
DROP SEQUENCE IF EXISTS public.incidentes_id_seq;
DROP TABLE IF EXISTS public.incidentes;
DROP SEQUENCE IF EXISTS public.evidencia_id_seq;
DROP TABLE IF EXISTS public.evidencia;
DROP SEQUENCE IF EXISTS public.comentario_id_seq;
DROP TABLE IF EXISTS public.comentario;
DROP SEQUENCE IF EXISTS public.barrio_id_seq;
DROP TABLE IF EXISTS public.barrio;
DROP SEQUENCE IF EXISTS public.auditoria_id_seq;
DROP TABLE IF EXISTS public.auditoria;
DROP SEQUENCE IF EXISTS public.alertas_id_seq;
DROP TABLE IF EXISTS public.alertas;
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
-- Data for Name: alertas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alertas (id, usuario_id, incidente_id, mensaje, fecha_envio, leida, zona_afectada, nivel_riesgo, tipo_alerta_id) FROM stdin;
2	3	101	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 17:58:25.718679-04	f	Zona cercana a [-17.8253, -63.1313]	alto	1
3	4	101	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 17:58:25.720538-04	f	Zona cercana a [-17.8253, -63.1313]	alto	1
5	3	102	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:00:51.357655-04	f	Zona cercana a [-17.8253, -63.1313]	alto	1
6	4	102	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:00:51.360754-04	f	Zona cercana a [-17.8253, -63.1313]	alto	1
8	3	103	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:00:53.625488-04	f	Zona cercana a [-17.8253, -63.1313]	alto	1
9	4	103	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:00:53.628487-04	f	Zona cercana a [-17.8253, -63.1313]	alto	1
11	3	104	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:02:21.598791-04	f	Zona cercana a [-17.7938, -63.1871]	alto	1
12	4	104	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:02:21.60188-04	f	Zona cercana a [-17.7938, -63.1871]	alto	1
14	3	105	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:02:59.00317-04	f	Zona cercana a [-17.7938, -63.1871]	alto	1
15	4	105	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:02:59.019689-04	f	Zona cercana a [-17.7938, -63.1871]	alto	1
17	3	106	⚠️ Incidente reportado cerca de tu zona: drogas. Toma precauciones. Descripción: Personas en mal estado	2026-05-23 18:04:50.23143-04	f	Zona cercana a [-17.7636, -63.2050]	medio	1
18	4	106	⚠️ Incidente reportado cerca de tu zona: drogas. Toma precauciones. Descripción: Personas en mal estado	2026-05-23 18:04:50.234701-04	f	Zona cercana a [-17.7636, -63.2050]	medio	1
21	3	\N	Motocicleta sospechosa merodeando la zona	2026-05-23 18:11:28.546211-04	f	Barrio El Dorado	alto	2
22	4	\N	Motocicleta sospechosa merodeando la zona	2026-05-23 18:11:28.546211-04	f	Barrio El Dorado	alto	2
19	1	\N	Motocicleta sospechosa merodeando la zona	2026-05-23 18:11:28.546211-04	t	Barrio El Dorado	alto	2
1	2	101	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 17:58:25.701502-04	t	Zona cercana a [-17.8253, -63.1313]	alto	1
4	2	102	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:00:51.354615-04	t	Zona cercana a [-17.8253, -63.1313]	alto	1
7	2	103	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:00:53.624415-04	t	Zona cercana a [-17.8253, -63.1313]	alto	1
10	2	104	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:02:21.59658-04	t	Zona cercana a [-17.7938, -63.1871]	alto	1
13	2	105	⚠️ Incidente reportado cerca de tu zona: robo. Toma precauciones. Descripción: Robo de Celulares	2026-05-23 18:02:59.00317-04	t	Zona cercana a [-17.7938, -63.1871]	alto	1
16	2	106	⚠️ Incidente reportado cerca de tu zona: drogas. Toma precauciones. Descripción: Personas en mal estado	2026-05-23 18:04:50.229079-04	t	Zona cercana a [-17.7636, -63.2050]	medio	1
20	2	\N	Motocicleta sospechosa merodeando la zona	2026-05-23 18:11:28.546211-04	t	Barrio El Dorado	alto	2
23	2	107	🟢 Incidente reportado cerca de tu zona: alumbrado. Nivel de riesgo: bajo. Toma precauciones.	2026-05-31 19:20:34.13078-04	f	Zona cercana a [-17.7975, -63.2019]	bajo	1
24	3	107	🟢 Incidente reportado cerca de tu zona: alumbrado. Nivel de riesgo: bajo. Toma precauciones.	2026-05-31 19:20:34.137983-04	f	Zona cercana a [-17.7975, -63.2019]	bajo	1
25	4	107	🟢 Incidente reportado cerca de tu zona: alumbrado. Nivel de riesgo: bajo. Toma precauciones.	2026-05-31 19:20:34.145131-04	f	Zona cercana a [-17.7975, -63.2019]	bajo	1
26	1	107	Reportaste un incidente: alumbrado (riesgo bajo). Recibirás notificaciones si hay novedades.	2026-05-31 19:20:34.152939-04	t	\N	bajo	1
27	2	108	🟡 Incidente reportado cerca de tu zona: accidente. Nivel de riesgo: medio. Toma precauciones.	2026-05-31 19:32:20.596146-04	f	Zona cercana a [-17.7704, -63.2059]	medio	1
28	3	108	🟡 Incidente reportado cerca de tu zona: accidente. Nivel de riesgo: medio. Toma precauciones.	2026-05-31 19:32:20.596146-04	f	Zona cercana a [-17.7704, -63.2059]	medio	1
29	4	108	🟡 Incidente reportado cerca de tu zona: accidente. Nivel de riesgo: medio. Toma precauciones.	2026-05-31 19:32:20.611025-04	f	Zona cercana a [-17.7704, -63.2059]	medio	1
30	1	108	Reportaste un incidente: accidente (riesgo medio). Recibirás notificaciones si hay novedades.	2026-05-31 19:32:20.61246-04	t	\N	medio	1
31	1	109	Reportaste un incidente: ruido (riesgo bajo). Recibirás notificaciones si hay novedades.	2026-05-31 20:19:43.455515-04	t	\N	bajo	1
32	2	110	🔴 Incidente reportado en tu barrio: asalto. Nivel de riesgo: alto. Toma precauciones.	2026-05-31 20:21:57.375054-04	f	Este	alto	1
33	3	110	🔴 Incidente reportado en tu barrio: asalto. Nivel de riesgo: alto. Toma precauciones.	2026-05-31 20:21:57.377096-04	f	Este	alto	1
34	4	110	🔴 Incidente reportado en tu barrio: asalto. Nivel de riesgo: alto. Toma precauciones.	2026-05-31 20:21:57.377096-04	f	Este	alto	1
35	1	110	Reportaste un incidente: asalto (riesgo alto). Recibirás notificaciones si hay novedades.	2026-05-31 20:21:57.391745-04	t	\N	alto	1
\.


--
-- Data for Name: auditoria; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auditoria (id, usuario_id, accion, entidad, entidad_id, detalle, ip, fecha) FROM stdin;
\.


--
-- Data for Name: barrio; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.barrio (id, nombre, ciudad, lat_centro, lng_centro, poligono) FROM stdin;
1	Centro	Santa Cruz	-17.7833	-63.1825	\N
2	Norte	Santa Cruz	-17.77	-63.18	\N
3	Sur	Santa Cruz	-17.8	-63.185	\N
4	Este	Santa Cruz	-17.7833	-63.16	\N
5	Oeste	Santa Cruz	-17.7833	-63.2	\N
\.


--
-- Data for Name: comentario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.comentario (id, incidente_id, usuario_id, texto, fecha) FROM stdin;
\.


--
-- Data for Name: evidencia; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.evidencia (id, incidente_id, tipo, archivo_url, fecha_subida, subido_por) FROM stdin;
\.


--
-- Data for Name: incidentes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.incidentes (id, descripcion, fecha_hora, latitud, longitud, riesgo_nivel, reportado_por, reportado_anonimamente, verificado, direccion, fecha_creacion, tipo_incidente_id, barrio_id, editable, resuelto, resuelto_por, fecha_resolucion) FROM stdin;
107	Falta de luz	2026-05-31 15:19:00-04	-17.797482	-63.201879	bajo	1	f	f	Carlitox's Home, Calle Estrella, Urbarí, El Pari, Santa Cruz de la Sierra, Provincia Andrés Ibáñez, Santa Cruz, Bolivia	2026-05-31 19:20:34.108787-04	6	\N	t	t	1	2026-05-31 19:48:56.019506-04
54	Sustracción de pertenencias en vía pública	2026-05-04 07:26:10.215102-04	-17.783952335903255	-63.20804845248655	bajo	\N	t	t	Calle 35, Col. Centro	2026-05-23 17:53:10.248414-04	1	\N	t	f	\N	\N
53	Poste de luz caído	2026-05-08 02:33:10.215102-04	-17.787548841634298	-63.21042049492712	medio	3	f	t	Calle 36, Col. Centro	2026-05-23 17:53:10.248414-04	6	\N	t	f	\N	\N
55	Tapa de alcantarilla robada	2026-05-20 04:28:10.215102-04	-17.772480024817813	-63.16906244640318	medio	2	f	f	Calle 62, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
51	Bache peligroso	2026-05-01 04:32:10.215102-04	-17.79070934680756	-63.197719313515705	bajo	2	f	f	Calle 58, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
52	Posible punto de venta en la esquina	2026-05-04 18:11:10.215102-04	-17.765227865682025	-63.194713012127515	medio	\N	t	f	Calle 58, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
56	Motocicleta sustraída	2026-05-21 11:28:10.215102-04	-17.775790250655593	-63.209617555513994	bajo	\N	t	f	Calle 1, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
108	accidente moto	2026-05-31 15:32:00-04	-17.77043	-63.205916	medio	1	f	f	El Carmen, Piraí, Santa Cruz de la Sierra, Provincia Andrés Ibáñez, Santa Cruz, Bolivia	2026-05-31 19:32:20.595265-04	10	\N	t	f	\N	\N
105	Robo de Celulares	2026-05-23 18:01:00-04	-17.793774	-63.187149	alto	1	f	f	Zona Ramada	2026-05-23 18:02:59.00317-04	1	\N	t	f	\N	\N
104	Robo de Celulares	2026-05-23 18:01:00-04	-17.793774	-63.187149	alto	1	f	f	Zona Ramada	2026-05-23 18:02:21.593337-04	1	\N	t	f	\N	\N
103	Robo de Celulares	2026-05-23 17:56:00-04	-17.825327	-63.131263	alto	1	f	f	Rotonda del Plan 3000	2026-05-23 18:00:53.622116-04	1	\N	t	f	\N	\N
102	Robo de Celulares	2026-05-23 17:56:00-04	-17.825327	-63.131263	alto	1	f	f	Rotonda del Plan 3000	2026-05-23 18:00:51.350398-04	1	\N	t	f	\N	\N
101	Robo de Celulares	2026-05-23 17:56:00-04	-17.825327	-63.131263	alto	1	f	f	Rotonda del Plan 3000	2026-05-23 17:58:25.681432-04	1	\N	t	f	\N	\N
94	Carterista en el mercado	2026-05-21 16:57:10.215102-04	-17.786180718030487	-63.17687916792339	medio	\N	t	t	Calle 16, Col. Centro	2026-05-23 17:53:10.248414-04	1	\N	t	f	\N	\N
109	fiesta	2026-05-31 16:19:00-04	-17.792619	-63.220508	bajo	1	f	f	Avenida El Palmar, Santa Cruz de la Sierra, Provincia Andrés Ibáñez, Santa Cruz, Bolivia	2026-05-31 20:19:43.445014-04	5	4	t	t	1	2026-05-31 20:21:11.708131-04
93	Sustracción de pertenencias en vía pública	2026-05-19 04:58:10.215102-04	-17.772174303096453	-63.19155289330219	bajo	\N	t	t	Calle 21, Col. Centro	2026-05-23 17:53:10.248414-04	1	\N	t	f	\N	\N
82	Robo a negocio en la madrugada	2026-05-12 10:04:10.215102-04	-17.765216466087427	-63.162065440400355	bajo	2	f	t	Calle 14, Col. Centro	2026-05-23 17:53:10.248414-04	1	\N	t	f	\N	\N
75	Carterista en el mercado	2026-04-30 18:58:10.215102-04	-17.786441101816266	-63.17315760429842	bajo	3	f	f	Calle 42, Col. Centro	2026-05-23 17:53:10.248414-04	1	\N	t	f	\N	\N
64	Carterista en el mercado	2026-05-22 04:02:10.215102-04	-17.80545583881849	-63.19605555017083	medio	2	f	t	Calle 29, Col. Centro	2026-05-23 17:53:10.248414-04	1	\N	t	f	\N	\N
98	Lámpara pública dañada	2026-05-16 05:09:10.215102-04	-17.77221208640604	-63.18629116705777	medio	\N	t	t	Calle 23, Col. Centro	2026-05-23 17:53:10.248414-04	3	\N	t	f	\N	\N
91	Contenedor de basura volcado	2026-04-25 01:54:10.215102-04	-17.787922236727884	-63.16749252729678	medio	2	f	f	Calle 51, Col. Centro	2026-05-23 17:53:10.248414-04	3	\N	t	f	\N	\N
84	Lámpara pública dañada	2026-05-12 17:05:10.215102-04	-17.76165309189516	-63.16730711677215	medio	2	f	t	Calle 77, Col. Centro	2026-05-23 17:53:10.248414-04	3	\N	t	f	\N	\N
81	Grafiti en fachada	2026-05-17 00:53:10.215102-04	-17.806761601695868	-63.180252257817436	bajo	2	f	f	Calle 90, Col. Centro	2026-05-23 17:53:10.248414-04	3	\N	t	f	\N	\N
68	Lámpara pública dañada	2026-05-20 11:58:10.215102-04	-17.759247575416325	-63.171198924941116	medio	\N	t	f	Calle 40, Col. Centro	2026-05-23 17:53:10.248414-04	3	\N	t	f	\N	\N
60	Lámpara pública dañada	2026-05-17 04:55:10.215102-04	-17.77551952809632	-63.185547676458846	bajo	\N	t	t	Calle 8, Col. Centro	2026-05-23 17:53:10.248414-04	3	\N	t	f	\N	\N
80	Individuo tomando fotos de casas	2026-05-01 18:45:10.215102-04	-17.811159486909023	-63.168384992111136	bajo	\N	t	f	Calle 18, Col. Centro	2026-05-23 17:53:10.248414-04	4	\N	t	f	\N	\N
79	Actividad nocturna inusual en local cerrado	2026-04-27 12:13:10.215102-04	-17.783952056338833	-63.1789752772776	medio	2	f	f	Calle 64, Col. Centro	2026-05-23 17:53:10.248414-04	4	\N	t	f	\N	\N
77	Actividad nocturna inusual en local cerrado	2026-04-25 22:14:10.215102-04	-17.787453398266305	-63.20616767274534	alto	\N	t	f	Calle 44, Col. Centro	2026-05-23 17:53:10.248414-04	4	\N	t	f	\N	\N
69	Actividad nocturna inusual en local cerrado	2026-04-30 14:00:10.215102-04	-17.759511887649662	-63.16036655336596	medio	\N	t	f	Calle 6, Col. Centro	2026-05-23 17:53:10.248414-04	4	\N	t	f	\N	\N
97	Zona oscura sin iluminación	2026-05-02 04:30:10.215102-04	-17.795782348859824	-63.200347525278914	medio	\N	t	f	Calle 88, Col. Centro	2026-05-23 17:53:10.248414-04	6	\N	t	f	\N	\N
89	Zona oscura sin iluminación	2026-04-26 11:37:10.215102-04	-17.770931241142296	-63.187693230487966	bajo	\N	t	t	Calle 59, Col. Centro	2026-05-23 17:53:10.248414-04	6	\N	t	f	\N	\N
61	Lámpara fundida en la calle	2026-05-05 08:06:10.215102-04	-17.773049702196534	-63.17262608012588	medio	2	f	f	Calle 33, Col. Centro	2026-05-23 17:53:10.248414-04	6	\N	t	f	\N	\N
57	Poste de luz caído	2026-05-21 02:52:10.215102-04	-17.787647504195956	-63.20327410105224	alto	2	f	f	Calle 51, Col. Centro	2026-05-23 17:53:10.248414-04	6	\N	t	f	\N	\N
90	Árbol caído obstruyendo paso	2026-05-11 07:49:10.215102-04	-17.810470577563624	-63.178217984639254	bajo	\N	t	f	Calle 67, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
87	Tapa de alcantarilla robada	2026-05-07 13:16:10.215102-04	-17.790822775156112	-63.16590725713517	medio	2	f	f	Calle 42, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
83	Bache peligroso	2026-05-01 18:29:10.215102-04	-17.789332782657294	-63.18345134456191	bajo	3	f	t	Calle 45, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
73	Tapa de alcantarilla robada	2026-05-09 11:27:10.215102-04	-17.754534956895693	-63.169899456034884	bajo	\N	t	t	Calle 88, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
72	Árbol caído obstruyendo paso	2026-05-12 00:53:10.215102-04	-17.783941531969443	-63.15864835535696	bajo	2	f	f	Calle 43, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
63	Árbol caído obstruyendo paso	2026-05-18 05:03:10.215102-04	-17.79829617667487	-63.21239179310308	medio	\N	t	f	Calle 20, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
58	Vehículo estacionado con vidrio roto	2026-05-07 06:41:10.215102-04	-17.773297411089537	-63.15486181259998	bajo	\N	t	f	Calle 96, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
59	Posible punto de venta en la esquina	2026-04-29 09:31:10.215102-04	-17.792658927682048	-63.15847618976612	medio	3	f	t	Calle 69, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
62	Auto robado frente al domicilio	2026-05-07 23:09:10.215102-04	-17.78763515504523	-63.16105142548339	medio	2	f	t	Calle 81, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
65	Acoso en parque público	2026-05-09 22:27:10.215102-04	-17.7646282731438	-63.18902606373371	bajo	2	f	t	Calle 26, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
66	Intento de agresión	2026-05-07 15:32:10.215102-04	-17.76558410941834	-63.206722354288395	medio	3	f	f	Calle 19, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
67	Motocicleta sustraída	2026-05-22 09:12:10.215102-04	-17.78524533240807	-63.18756948153518	bajo	2	f	f	Calle 52, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
70	Acoso en parque público	2026-05-05 12:42:10.215102-04	-17.79587930346433	-63.15263300872985	bajo	\N	t	f	Calle 45, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
71	Intento de agresión	2026-05-16 14:07:10.215102-04	-17.77365507902993	-63.180482502020546	bajo	3	f	t	Calle 43, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
74	Posible punto de venta en la esquina	2026-05-08 15:25:10.215102-04	-17.799192731684702	-63.193190622543355	medio	\N	t	t	Calle 20, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
76	Consumo en vía pública	2026-05-12 16:22:10.215102-04	-17.767726888056004	-63.210221704331786	bajo	2	f	f	Calle 99, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
78	Intento de agresión	2026-04-26 16:51:10.215102-04	-17.79713478001937	-63.18003056874257	bajo	2	f	f	Calle 14, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
85	Pelea callejera entre dos personas	2026-05-07 20:21:10.215102-04	-17.775439184663608	-63.1960296210289	medio	2	f	f	Calle 71, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
86	Auto robado frente al domicilio	2026-05-06 00:01:10.215102-04	-17.763943560826014	-63.18349236646413	alto	3	f	f	Calle 21, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
88	Consumo en vía pública	2026-04-28 21:46:10.215102-04	-17.76031250044598	-63.162855446477224	medio	2	f	f	Calle 66, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
92	Motocicleta sustraída	2026-05-12 21:57:10.215102-04	-17.77448538252394	-63.15755921138788	bajo	2	f	f	Calle 3, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
95	Posible punto de venta en la esquina	2026-05-05 12:27:10.215102-04	-17.784038186769365	-63.16040685272208	bajo	\N	t	t	Calle 96, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
96	Vehículo estacionado con vidrio roto	2026-05-18 09:07:10.215102-04	-17.77959003397662	-63.16393503474868	alto	2	f	f	Calle 14, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
99	Motocicleta sustraída	2026-04-25 11:45:10.215102-04	-17.757016606456126	-63.184779614765965	bajo	3	f	f	Calle 23, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
100	Motocicleta sustraída	2026-05-09 05:18:10.215102-04	-17.78639194623929	-63.208268818022816	bajo	\N	t	f	Calle 71, Col. Centro	2026-05-23 17:53:10.248414-04	10	\N	t	f	\N	\N
106	Personas en mal estado	2026-05-23 18:03:00-04	-17.763645	-63.205043	medio	1	f	f	Cordon Ecologico	2026-05-23 18:04:50.225049-04	10	\N	t	f	\N	\N
110	joven asaltado	2026-05-31 16:21:00-04	-17.816931	-63.225576	alto	1	f	f	YPF Elaion, Radial 17 1/2, Urbanizacion Los Jardines, El Bajío, Santa Cruz de la Sierra, Provincia Andrés Ibáñez, Santa Cruz, Bolivia	2026-05-31 20:21:57.361026-04	2	4	t	f	\N	\N
\.


--
-- Data for Name: predicciones_riesgo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.predicciones_riesgo (id, lat_centro, lng_centro, lat_min, lat_max, lng_min, lng_max, probabilidad_alto, probabilidad_medio, probabilidad_bajo, nivel_predominante, fecha_prediccion, modelo_version, incidentes_ultima_hora, activa, barrio_id) FROM stdin;
1	-17.840327000000002	-63.22739179310308	-17.845327	-17.835327	-63.23239179310308	-63.222391793103085	0.51	0.33	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
2	-17.840327000000002	-63.21739179310308	-17.845327	-17.835327	-63.222391793103085	-63.21239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
3	-17.840327000000002	-63.207391793103085	-17.845327	-17.835327	-63.21239179310309	-63.20239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
4	-17.840327000000002	-63.19739179310309	-17.845327	-17.835327	-63.20239179310309	-63.19239179310309	0.56	0.29	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
5	-17.840327000000002	-63.18739179310309	-17.845327	-17.835327	-63.19239179310309	-63.18239179310309	0.53	0.3	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
6	-17.840327000000002	-63.17739179310309	-17.845327	-17.835327	-63.18239179310309	-63.172391793103095	0.55	0.25	0.2	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
7	-17.840327000000002	-63.16739179310309	-17.845327	-17.835327	-63.172391793103095	-63.1623917931031	0.53	0.27	0.2	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
8	-17.840327000000002	-63.157391793103095	-17.845327	-17.835327	-63.1623917931031	-63.1523917931031	0.55	0.24	0.21	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
9	-17.840327000000002	-63.1473917931031	-17.845327	-17.835327	-63.1523917931031	-63.1423917931031	0.53	0.22	0.25	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
10	-17.840327000000002	-63.1373917931031	-17.845327	-17.835327	-63.1423917931031	-63.1323917931031	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
11	-17.840327000000002	-63.1273917931031	-17.845327	-17.835327	-63.1323917931031	-63.122391793103105	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
12	-17.840327000000002	-63.1173917931031	-17.845327	-17.835327	-63.122391793103105	-63.11239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
13	-17.840327000000002	-63.107391793103105	-17.845327	-17.835327	-63.11239179310311	-63.10239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
14	-17.830327	-63.22739179310308	-17.835327	-17.825326999999998	-63.23239179310308	-63.222391793103085	0.51	0.33	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
15	-17.830327	-63.21739179310308	-17.835327	-17.825326999999998	-63.222391793103085	-63.21239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
16	-17.830327	-63.207391793103085	-17.835327	-17.825326999999998	-63.21239179310309	-63.20239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
17	-17.830327	-63.19739179310309	-17.835327	-17.825326999999998	-63.20239179310309	-63.19239179310309	0.56	0.29	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
18	-17.830327	-63.18739179310309	-17.835327	-17.825326999999998	-63.19239179310309	-63.18239179310309	0.53	0.3	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
19	-17.830327	-63.17739179310309	-17.835327	-17.825326999999998	-63.18239179310309	-63.172391793103095	0.55	0.25	0.2	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
20	-17.830327	-63.16739179310309	-17.835327	-17.825326999999998	-63.172391793103095	-63.1623917931031	0.53	0.27	0.2	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
21	-17.830327	-63.157391793103095	-17.835327	-17.825326999999998	-63.1623917931031	-63.1523917931031	0.55	0.24	0.21	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
22	-17.830327	-63.1473917931031	-17.835327	-17.825326999999998	-63.1523917931031	-63.1423917931031	0.53	0.22	0.25	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
23	-17.830327	-63.1373917931031	-17.835327	-17.825326999999998	-63.1423917931031	-63.1323917931031	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
24	-17.830327	-63.1273917931031	-17.835327	-17.825326999999998	-63.1323917931031	-63.122391793103105	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
25	-17.830327	-63.1173917931031	-17.835327	-17.825326999999998	-63.122391793103105	-63.11239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
26	-17.830327	-63.107391793103105	-17.835327	-17.825326999999998	-63.11239179310311	-63.10239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
27	-17.820327	-63.22739179310308	-17.825326999999998	-17.815326999999996	-63.23239179310308	-63.222391793103085	0.51	0.33	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
28	-17.820327	-63.21739179310308	-17.825326999999998	-17.815326999999996	-63.222391793103085	-63.21239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
29	-17.820327	-63.207391793103085	-17.825326999999998	-17.815326999999996	-63.21239179310309	-63.20239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
30	-17.820327	-63.19739179310309	-17.825326999999998	-17.815326999999996	-63.20239179310309	-63.19239179310309	0.56	0.29	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
31	-17.820327	-63.18739179310309	-17.825326999999998	-17.815326999999996	-63.19239179310309	-63.18239179310309	0.53	0.3	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
32	-17.820327	-63.17739179310309	-17.825326999999998	-17.815326999999996	-63.18239179310309	-63.172391793103095	0.55	0.25	0.2	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
33	-17.820327	-63.16739179310309	-17.825326999999998	-17.815326999999996	-63.172391793103095	-63.1623917931031	0.53	0.27	0.2	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
34	-17.820327	-63.157391793103095	-17.825326999999998	-17.815326999999996	-63.1623917931031	-63.1523917931031	0.55	0.24	0.21	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
35	-17.820327	-63.1473917931031	-17.825326999999998	-17.815326999999996	-63.1523917931031	-63.1423917931031	0.53	0.22	0.25	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
36	-17.820327	-63.1373917931031	-17.825326999999998	-17.815326999999996	-63.1423917931031	-63.1323917931031	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
37	-17.820327	-63.1273917931031	-17.825326999999998	-17.815326999999996	-63.1323917931031	-63.122391793103105	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
38	-17.820327	-63.1173917931031	-17.825326999999998	-17.815326999999996	-63.122391793103105	-63.11239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
39	-17.820327	-63.107391793103105	-17.825326999999998	-17.815326999999996	-63.11239179310311	-63.10239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
40	-17.810326999999997	-63.22739179310308	-17.815326999999996	-17.805326999999995	-63.23239179310308	-63.222391793103085	0.37	0.41	0.22	medio	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
41	-17.810326999999997	-63.21739179310308	-17.815326999999996	-17.805326999999995	-63.222391793103085	-63.21239179310309	0.37	0.41	0.22	medio	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
42	-17.810326999999997	-63.207391793103085	-17.815326999999996	-17.805326999999995	-63.21239179310309	-63.20239179310309	0.37	0.41	0.22	medio	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
43	-17.810326999999997	-63.19739179310309	-17.815326999999996	-17.805326999999995	-63.20239179310309	-63.19239179310309	0.44	0.34	0.22	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
44	-17.810326999999997	-63.18739179310309	-17.815326999999996	-17.805326999999995	-63.19239179310309	-63.18239179310309	0.41	0.35	0.24	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
45	-17.810326999999997	-63.17739179310309	-17.815326999999996	-17.805326999999995	-63.18239179310309	-63.172391793103095	0.44	0.29	0.27	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
46	-17.810326999999997	-63.16739179310309	-17.815326999999996	-17.805326999999995	-63.172391793103095	-63.1623917931031	0.43	0.31	0.26	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
47	-17.810326999999997	-63.157391793103095	-17.815326999999996	-17.805326999999995	-63.1623917931031	-63.1523917931031	0.44	0.29	0.27	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
48	-17.810326999999997	-63.1473917931031	-17.815326999999996	-17.805326999999995	-63.1523917931031	-63.1423917931031	0.41	0.27	0.32	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
49	-17.810326999999997	-63.1373917931031	-17.815326999999996	-17.805326999999995	-63.1423917931031	-63.1323917931031	0.58	0.19	0.23	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
50	-17.810326999999997	-63.1273917931031	-17.815326999999996	-17.805326999999995	-63.1323917931031	-63.122391793103105	0.58	0.19	0.23	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
51	-17.810326999999997	-63.1173917931031	-17.815326999999996	-17.805326999999995	-63.122391793103105	-63.11239179310311	0.58	0.19	0.23	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
52	-17.810326999999997	-63.107391793103105	-17.815326999999996	-17.805326999999995	-63.11239179310311	-63.10239179310311	0.58	0.19	0.23	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
53	-17.800326999999996	-63.22739179310308	-17.805326999999995	-17.795326999999993	-63.23239179310308	-63.222391793103085	0.42	0.43	0.15	medio	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
54	-17.800326999999996	-63.21739179310308	-17.805326999999995	-17.795326999999993	-63.222391793103085	-63.21239179310309	0.42	0.43	0.15	medio	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
55	-17.800326999999996	-63.207391793103085	-17.805326999999995	-17.795326999999993	-63.21239179310309	-63.20239179310309	0.42	0.43	0.15	medio	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
56	-17.800326999999996	-63.19739179310309	-17.805326999999995	-17.795326999999993	-63.20239179310309	-63.19239179310309	0.5	0.35	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
57	-17.800326999999996	-63.18739179310309	-17.805326999999995	-17.795326999999993	-63.19239179310309	-63.18239179310309	0.47	0.38	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
58	-17.800326999999996	-63.17739179310309	-17.805326999999995	-17.795326999999993	-63.18239179310309	-63.172391793103095	0.5	0.32	0.18	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
59	-17.800326999999996	-63.16739179310309	-17.805326999999995	-17.795326999999993	-63.172391793103095	-63.1623917931031	0.5	0.33	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
60	-17.800326999999996	-63.157391793103095	-17.805326999999995	-17.795326999999993	-63.1623917931031	-63.1523917931031	0.5	0.3	0.2	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
61	-17.800326999999996	-63.1473917931031	-17.805326999999995	-17.795326999999993	-63.1523917931031	-63.1423917931031	0.45	0.28	0.27	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
62	-17.800326999999996	-63.1373917931031	-17.805326999999995	-17.795326999999993	-63.1423917931031	-63.1323917931031	0.6	0.21	0.19	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
63	-17.800326999999996	-63.1273917931031	-17.805326999999995	-17.795326999999993	-63.1323917931031	-63.122391793103105	0.6	0.21	0.19	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
64	-17.800326999999996	-63.1173917931031	-17.805326999999995	-17.795326999999993	-63.122391793103105	-63.11239179310311	0.6	0.21	0.19	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
65	-17.800326999999996	-63.107391793103105	-17.805326999999995	-17.795326999999993	-63.11239179310311	-63.10239179310311	0.6	0.21	0.19	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
66	-17.790326999999994	-63.22739179310308	-17.795326999999993	-17.78532699999999	-63.23239179310308	-63.222391793103085	0.53	0.3	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
67	-17.790326999999994	-63.21739179310308	-17.795326999999993	-17.78532699999999	-63.222391793103085	-63.21239179310309	0.53	0.3	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
68	-17.790326999999994	-63.207391793103085	-17.795326999999993	-17.78532699999999	-63.21239179310309	-63.20239179310309	0.53	0.3	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
69	-17.790326999999994	-63.19739179310309	-17.795326999999993	-17.78532699999999	-63.20239179310309	-63.19239179310309	0.61	0.23	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
70	-17.790326999999994	-63.18739179310309	-17.795326999999993	-17.78532699999999	-63.19239179310309	-63.18239179310309	0.58	0.27	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
71	-17.790326999999994	-63.17739179310309	-17.795326999999993	-17.78532699999999	-63.18239179310309	-63.172391793103095	0.59	0.28	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
72	-17.790326999999994	-63.16739179310309	-17.795326999999993	-17.78532699999999	-63.172391793103095	-63.1623917931031	0.58	0.28	0.14	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
73	-17.790326999999994	-63.157391793103095	-17.795326999999993	-17.78532699999999	-63.1623917931031	-63.1523917931031	0.58	0.25	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
74	-17.790326999999994	-63.1473917931031	-17.795326999999993	-17.78532699999999	-63.1523917931031	-63.1423917931031	0.52	0.23	0.25	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
75	-17.790326999999994	-63.1373917931031	-17.795326999999993	-17.78532699999999	-63.1423917931031	-63.1323917931031	0.67	0.18	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
76	-17.790326999999994	-63.1273917931031	-17.795326999999993	-17.78532699999999	-63.1323917931031	-63.122391793103105	0.67	0.18	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
77	-17.790326999999994	-63.1173917931031	-17.795326999999993	-17.78532699999999	-63.122391793103105	-63.11239179310311	0.67	0.18	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
78	-17.790326999999994	-63.107391793103105	-17.795326999999993	-17.78532699999999	-63.11239179310311	-63.10239179310311	0.67	0.18	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
79	-17.780326999999993	-63.22739179310308	-17.78532699999999	-17.77532699999999	-63.23239179310308	-63.222391793103085	0.53	0.32	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
80	-17.780326999999993	-63.21739179310308	-17.78532699999999	-17.77532699999999	-63.222391793103085	-63.21239179310309	0.53	0.32	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
81	-17.780326999999993	-63.207391793103085	-17.78532699999999	-17.77532699999999	-63.21239179310309	-63.20239179310309	0.53	0.32	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
82	-17.780326999999993	-63.19739179310309	-17.78532699999999	-17.77532699999999	-63.20239179310309	-63.19239179310309	0.61	0.26	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
83	-17.780326999999993	-63.18739179310309	-17.78532699999999	-17.77532699999999	-63.19239179310309	-63.18239179310309	0.59	0.29	0.12	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
84	-17.780326999999993	-63.17739179310309	-17.78532699999999	-17.77532699999999	-63.18239179310309	-63.172391793103095	0.61	0.29	0.1	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
85	-17.780326999999993	-63.16739179310309	-17.78532699999999	-17.77532699999999	-63.172391793103095	-63.1623917931031	0.61	0.28	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
86	-17.780326999999993	-63.157391793103095	-17.78532699999999	-17.77532699999999	-63.1623917931031	-63.1523917931031	0.64	0.22	0.14	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
87	-17.780326999999993	-63.1473917931031	-17.78532699999999	-17.77532699999999	-63.1523917931031	-63.1423917931031	0.58	0.2	0.22	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
88	-17.780326999999993	-63.1373917931031	-17.78532699999999	-17.77532699999999	-63.1423917931031	-63.1323917931031	0.72	0.15	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
89	-17.780326999999993	-63.1273917931031	-17.78532699999999	-17.77532699999999	-63.1323917931031	-63.122391793103105	0.72	0.15	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
90	-17.780326999999993	-63.1173917931031	-17.78532699999999	-17.77532699999999	-63.122391793103105	-63.11239179310311	0.72	0.15	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
91	-17.780326999999993	-63.107391793103105	-17.78532699999999	-17.77532699999999	-63.11239179310311	-63.10239179310311	0.72	0.15	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
92	-17.77032699999999	-63.22739179310308	-17.77532699999999	-17.76532699999999	-63.23239179310308	-63.222391793103085	0.53	0.32	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
93	-17.77032699999999	-63.21739179310308	-17.77532699999999	-17.76532699999999	-63.222391793103085	-63.21239179310309	0.53	0.32	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
94	-17.77032699999999	-63.207391793103085	-17.77532699999999	-17.76532699999999	-63.21239179310309	-63.20239179310309	0.53	0.32	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
95	-17.77032699999999	-63.19739179310309	-17.77532699999999	-17.76532699999999	-63.20239179310309	-63.19239179310309	0.6	0.28	0.12	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
96	-17.77032699999999	-63.18739179310309	-17.77532699999999	-17.76532699999999	-63.19239179310309	-63.18239179310309	0.58	0.31	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
97	-17.77032699999999	-63.17739179310309	-17.77532699999999	-17.76532699999999	-63.18239179310309	-63.172391793103095	0.62	0.29	0.09	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
98	-17.77032699999999	-63.16739179310309	-17.77532699999999	-17.76532699999999	-63.172391793103095	-63.1623917931031	0.6	0.3	0.1	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
99	-17.77032699999999	-63.157391793103095	-17.77532699999999	-17.76532699999999	-63.1623917931031	-63.1523917931031	0.62	0.25	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
100	-17.77032699999999	-63.1473917931031	-17.77532699999999	-17.76532699999999	-63.1523917931031	-63.1423917931031	0.55	0.24	0.21	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
101	-17.77032699999999	-63.1373917931031	-17.77532699999999	-17.76532699999999	-63.1423917931031	-63.1323917931031	0.69	0.19	0.12	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
102	-17.77032699999999	-63.1273917931031	-17.77532699999999	-17.76532699999999	-63.1323917931031	-63.122391793103105	0.69	0.19	0.12	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
103	-17.77032699999999	-63.1173917931031	-17.77532699999999	-17.76532699999999	-63.122391793103105	-63.11239179310311	0.69	0.19	0.12	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
104	-17.77032699999999	-63.107391793103105	-17.77532699999999	-17.76532699999999	-63.11239179310311	-63.10239179310311	0.69	0.19	0.12	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
105	-17.76032699999999	-63.22739179310308	-17.76532699999999	-17.755326999999987	-63.23239179310308	-63.222391793103085	0.57	0.28	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
106	-17.76032699999999	-63.21739179310308	-17.76532699999999	-17.755326999999987	-63.222391793103085	-63.21239179310309	0.57	0.28	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
107	-17.76032699999999	-63.207391793103085	-17.76532699999999	-17.755326999999987	-63.21239179310309	-63.20239179310309	0.57	0.28	0.15	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
108	-17.76032699999999	-63.19739179310309	-17.76532699999999	-17.755326999999987	-63.20239179310309	-63.19239179310309	0.62	0.25	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
109	-17.76032699999999	-63.18739179310309	-17.76532699999999	-17.755326999999987	-63.19239179310309	-63.18239179310309	0.61	0.27	0.12	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
110	-17.76032699999999	-63.17739179310309	-17.76532699999999	-17.755326999999987	-63.18239179310309	-63.172391793103095	0.65	0.26	0.09	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
111	-17.76032699999999	-63.16739179310309	-17.76532699999999	-17.755326999999987	-63.172391793103095	-63.1623917931031	0.58	0.34	0.08	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
112	-17.76032699999999	-63.157391793103095	-17.76532699999999	-17.755326999999987	-63.1623917931031	-63.1523917931031	0.6	0.31	0.09	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
113	-17.76032699999999	-63.1473917931031	-17.76532699999999	-17.755326999999987	-63.1523917931031	-63.1423917931031	0.55	0.28	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
114	-17.76032699999999	-63.1373917931031	-17.76532699999999	-17.755326999999987	-63.1423917931031	-63.1323917931031	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
115	-17.76032699999999	-63.1273917931031	-17.76532699999999	-17.755326999999987	-63.1323917931031	-63.122391793103105	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
116	-17.76032699999999	-63.1173917931031	-17.76532699999999	-17.755326999999987	-63.122391793103105	-63.11239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
117	-17.76032699999999	-63.107391793103105	-17.76532699999999	-17.755326999999987	-63.11239179310311	-63.10239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
118	-17.750326999999988	-63.22739179310308	-17.755326999999987	-17.745326999999985	-63.23239179310308	-63.222391793103085	0.56	0.28	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
119	-17.750326999999988	-63.21739179310308	-17.755326999999987	-17.745326999999985	-63.222391793103085	-63.21239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
120	-17.750326999999988	-63.207391793103085	-17.755326999999987	-17.745326999999985	-63.21239179310309	-63.20239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
121	-17.750326999999988	-63.19739179310309	-17.755326999999987	-17.745326999999985	-63.20239179310309	-63.19239179310309	0.61	0.25	0.14	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
122	-17.750326999999988	-63.18739179310309	-17.755326999999987	-17.745326999999985	-63.19239179310309	-63.18239179310309	0.6	0.27	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
123	-17.750326999999988	-63.17739179310309	-17.755326999999987	-17.745326999999985	-63.18239179310309	-63.172391793103095	0.64	0.26	0.1	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
124	-17.750326999999988	-63.16739179310309	-17.755326999999987	-17.745326999999985	-63.172391793103095	-63.1623917931031	0.57	0.34	0.09	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
125	-17.750326999999988	-63.157391793103095	-17.755326999999987	-17.745326999999985	-63.1623917931031	-63.1523917931031	0.6	0.31	0.09	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
126	-17.750326999999988	-63.1473917931031	-17.755326999999987	-17.745326999999985	-63.1523917931031	-63.1423917931031	0.55	0.28	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
127	-17.750326999999988	-63.1373917931031	-17.755326999999987	-17.745326999999985	-63.1423917931031	-63.1323917931031	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
128	-17.750326999999988	-63.1273917931031	-17.755326999999987	-17.745326999999985	-63.1323917931031	-63.122391793103105	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
129	-17.750326999999988	-63.1173917931031	-17.755326999999987	-17.745326999999985	-63.122391793103105	-63.11239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
130	-17.750326999999988	-63.107391793103105	-17.755326999999987	-17.745326999999985	-63.11239179310311	-63.10239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
131	-17.740326999999986	-63.22739179310308	-17.745326999999985	-17.735326999999984	-63.23239179310308	-63.222391793103085	0.56	0.28	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
132	-17.740326999999986	-63.21739179310308	-17.745326999999985	-17.735326999999984	-63.222391793103085	-63.21239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
133	-17.740326999999986	-63.207391793103085	-17.745326999999985	-17.735326999999984	-63.21239179310309	-63.20239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
134	-17.740326999999986	-63.19739179310309	-17.745326999999985	-17.735326999999984	-63.20239179310309	-63.19239179310309	0.61	0.25	0.14	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
135	-17.740326999999986	-63.18739179310309	-17.745326999999985	-17.735326999999984	-63.19239179310309	-63.18239179310309	0.6	0.27	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
136	-17.740326999999986	-63.17739179310309	-17.745326999999985	-17.735326999999984	-63.18239179310309	-63.172391793103095	0.64	0.26	0.1	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
137	-17.740326999999986	-63.16739179310309	-17.745326999999985	-17.735326999999984	-63.172391793103095	-63.1623917931031	0.57	0.34	0.09	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
138	-17.740326999999986	-63.157391793103095	-17.745326999999985	-17.735326999999984	-63.1623917931031	-63.1523917931031	0.6	0.31	0.09	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
139	-17.740326999999986	-63.1473917931031	-17.745326999999985	-17.735326999999984	-63.1523917931031	-63.1423917931031	0.55	0.28	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
140	-17.740326999999986	-63.1373917931031	-17.745326999999985	-17.735326999999984	-63.1423917931031	-63.1323917931031	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
141	-17.740326999999986	-63.1273917931031	-17.745326999999985	-17.735326999999984	-63.1323917931031	-63.122391793103105	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
142	-17.740326999999986	-63.1173917931031	-17.745326999999985	-17.735326999999984	-63.122391793103105	-63.11239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
143	-17.740326999999986	-63.107391793103105	-17.745326999999985	-17.735326999999984	-63.11239179310311	-63.10239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
144	-17.730326999999985	-63.22739179310308	-17.735326999999984	-17.725326999999982	-63.23239179310308	-63.222391793103085	0.56	0.28	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
145	-17.730326999999985	-63.21739179310308	-17.735326999999984	-17.725326999999982	-63.222391793103085	-63.21239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
146	-17.730326999999985	-63.207391793103085	-17.735326999999984	-17.725326999999982	-63.21239179310309	-63.20239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
147	-17.730326999999985	-63.19739179310309	-17.735326999999984	-17.725326999999982	-63.20239179310309	-63.19239179310309	0.61	0.25	0.14	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
148	-17.730326999999985	-63.18739179310309	-17.735326999999984	-17.725326999999982	-63.19239179310309	-63.18239179310309	0.6	0.27	0.13	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
149	-17.730326999999985	-63.17739179310309	-17.735326999999984	-17.725326999999982	-63.18239179310309	-63.172391793103095	0.64	0.26	0.1	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
150	-17.730326999999985	-63.16739179310309	-17.735326999999984	-17.725326999999982	-63.172391793103095	-63.1623917931031	0.57	0.34	0.09	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
151	-17.730326999999985	-63.157391793103095	-17.735326999999984	-17.725326999999982	-63.1623917931031	-63.1523917931031	0.6	0.31	0.09	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
152	-17.730326999999985	-63.1473917931031	-17.735326999999984	-17.725326999999982	-63.1523917931031	-63.1423917931031	0.55	0.28	0.17	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
153	-17.730326999999985	-63.1373917931031	-17.735326999999984	-17.725326999999982	-63.1423917931031	-63.1323917931031	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
154	-17.730326999999985	-63.1273917931031	-17.735326999999984	-17.725326999999982	-63.1323917931031	-63.122391793103105	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
155	-17.730326999999985	-63.1173917931031	-17.735326999999984	-17.725326999999982	-63.122391793103105	-63.11239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
156	-17.730326999999985	-63.107391793103105	-17.735326999999984	-17.725326999999982	-63.11239179310311	-63.10239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:49.876459-04	v1.0-rf	0	f	\N
157	-17.840327000000002	-63.22739179310308	-17.845327	-17.835327	-63.23239179310308	-63.222391793103085	0.51	0.33	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
158	-17.840327000000002	-63.21739179310308	-17.845327	-17.835327	-63.222391793103085	-63.21239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
159	-17.840327000000002	-63.207391793103085	-17.845327	-17.835327	-63.21239179310309	-63.20239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
160	-17.840327000000002	-63.19739179310309	-17.845327	-17.835327	-63.20239179310309	-63.19239179310309	0.56	0.29	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
161	-17.840327000000002	-63.18739179310309	-17.845327	-17.835327	-63.19239179310309	-63.18239179310309	0.53	0.3	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
162	-17.840327000000002	-63.17739179310309	-17.845327	-17.835327	-63.18239179310309	-63.172391793103095	0.55	0.25	0.2	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
163	-17.840327000000002	-63.16739179310309	-17.845327	-17.835327	-63.172391793103095	-63.1623917931031	0.53	0.27	0.2	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
164	-17.840327000000002	-63.157391793103095	-17.845327	-17.835327	-63.1623917931031	-63.1523917931031	0.55	0.24	0.21	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
165	-17.840327000000002	-63.1473917931031	-17.845327	-17.835327	-63.1523917931031	-63.1423917931031	0.53	0.22	0.25	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
166	-17.840327000000002	-63.1373917931031	-17.845327	-17.835327	-63.1423917931031	-63.1323917931031	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
167	-17.840327000000002	-63.1273917931031	-17.845327	-17.835327	-63.1323917931031	-63.122391793103105	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
168	-17.840327000000002	-63.1173917931031	-17.845327	-17.835327	-63.122391793103105	-63.11239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
169	-17.840327000000002	-63.107391793103105	-17.845327	-17.835327	-63.11239179310311	-63.10239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
170	-17.830327	-63.22739179310308	-17.835327	-17.825326999999998	-63.23239179310308	-63.222391793103085	0.51	0.33	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
171	-17.830327	-63.21739179310308	-17.835327	-17.825326999999998	-63.222391793103085	-63.21239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
172	-17.830327	-63.207391793103085	-17.835327	-17.825326999999998	-63.21239179310309	-63.20239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
173	-17.830327	-63.19739179310309	-17.835327	-17.825326999999998	-63.20239179310309	-63.19239179310309	0.56	0.29	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
174	-17.830327	-63.18739179310309	-17.835327	-17.825326999999998	-63.19239179310309	-63.18239179310309	0.53	0.3	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
175	-17.830327	-63.17739179310309	-17.835327	-17.825326999999998	-63.18239179310309	-63.172391793103095	0.55	0.25	0.2	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
176	-17.830327	-63.16739179310309	-17.835327	-17.825326999999998	-63.172391793103095	-63.1623917931031	0.53	0.27	0.2	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
177	-17.830327	-63.157391793103095	-17.835327	-17.825326999999998	-63.1623917931031	-63.1523917931031	0.55	0.24	0.21	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
178	-17.830327	-63.1473917931031	-17.835327	-17.825326999999998	-63.1523917931031	-63.1423917931031	0.53	0.22	0.25	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
179	-17.830327	-63.1373917931031	-17.835327	-17.825326999999998	-63.1423917931031	-63.1323917931031	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
180	-17.830327	-63.1273917931031	-17.835327	-17.825326999999998	-63.1323917931031	-63.122391793103105	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
181	-17.830327	-63.1173917931031	-17.835327	-17.825326999999998	-63.122391793103105	-63.11239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
182	-17.830327	-63.107391793103105	-17.835327	-17.825326999999998	-63.11239179310311	-63.10239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
183	-17.820327	-63.22739179310308	-17.825326999999998	-17.815326999999996	-63.23239179310308	-63.222391793103085	0.51	0.33	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
184	-17.820327	-63.21739179310308	-17.825326999999998	-17.815326999999996	-63.222391793103085	-63.21239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
185	-17.820327	-63.207391793103085	-17.825326999999998	-17.815326999999996	-63.21239179310309	-63.20239179310309	0.51	0.33	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
186	-17.820327	-63.19739179310309	-17.825326999999998	-17.815326999999996	-63.20239179310309	-63.19239179310309	0.56	0.29	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
187	-17.820327	-63.18739179310309	-17.825326999999998	-17.815326999999996	-63.19239179310309	-63.18239179310309	0.53	0.3	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
188	-17.820327	-63.17739179310309	-17.825326999999998	-17.815326999999996	-63.18239179310309	-63.172391793103095	0.55	0.25	0.2	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
189	-17.820327	-63.16739179310309	-17.825326999999998	-17.815326999999996	-63.172391793103095	-63.1623917931031	0.53	0.27	0.2	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
190	-17.820327	-63.157391793103095	-17.825326999999998	-17.815326999999996	-63.1623917931031	-63.1523917931031	0.55	0.24	0.21	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
191	-17.820327	-63.1473917931031	-17.825326999999998	-17.815326999999996	-63.1523917931031	-63.1423917931031	0.53	0.22	0.25	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
192	-17.820327	-63.1373917931031	-17.825326999999998	-17.815326999999996	-63.1423917931031	-63.1323917931031	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
193	-17.820327	-63.1273917931031	-17.825326999999998	-17.815326999999996	-63.1323917931031	-63.122391793103105	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
194	-17.820327	-63.1173917931031	-17.825326999999998	-17.815326999999996	-63.122391793103105	-63.11239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
195	-17.820327	-63.107391793103105	-17.825326999999998	-17.815326999999996	-63.11239179310311	-63.10239179310311	0.7	0.14	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
196	-17.810326999999997	-63.22739179310308	-17.815326999999996	-17.805326999999995	-63.23239179310308	-63.222391793103085	0.37	0.41	0.22	medio	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
197	-17.810326999999997	-63.21739179310308	-17.815326999999996	-17.805326999999995	-63.222391793103085	-63.21239179310309	0.37	0.41	0.22	medio	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
198	-17.810326999999997	-63.207391793103085	-17.815326999999996	-17.805326999999995	-63.21239179310309	-63.20239179310309	0.37	0.41	0.22	medio	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
199	-17.810326999999997	-63.19739179310309	-17.815326999999996	-17.805326999999995	-63.20239179310309	-63.19239179310309	0.44	0.34	0.22	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
200	-17.810326999999997	-63.18739179310309	-17.815326999999996	-17.805326999999995	-63.19239179310309	-63.18239179310309	0.41	0.35	0.24	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
201	-17.810326999999997	-63.17739179310309	-17.815326999999996	-17.805326999999995	-63.18239179310309	-63.172391793103095	0.44	0.29	0.27	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
202	-17.810326999999997	-63.16739179310309	-17.815326999999996	-17.805326999999995	-63.172391793103095	-63.1623917931031	0.43	0.31	0.26	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
203	-17.810326999999997	-63.157391793103095	-17.815326999999996	-17.805326999999995	-63.1623917931031	-63.1523917931031	0.44	0.29	0.27	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
204	-17.810326999999997	-63.1473917931031	-17.815326999999996	-17.805326999999995	-63.1523917931031	-63.1423917931031	0.41	0.27	0.32	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
205	-17.810326999999997	-63.1373917931031	-17.815326999999996	-17.805326999999995	-63.1423917931031	-63.1323917931031	0.58	0.19	0.23	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
206	-17.810326999999997	-63.1273917931031	-17.815326999999996	-17.805326999999995	-63.1323917931031	-63.122391793103105	0.58	0.19	0.23	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
207	-17.810326999999997	-63.1173917931031	-17.815326999999996	-17.805326999999995	-63.122391793103105	-63.11239179310311	0.58	0.19	0.23	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
208	-17.810326999999997	-63.107391793103105	-17.815326999999996	-17.805326999999995	-63.11239179310311	-63.10239179310311	0.58	0.19	0.23	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
209	-17.800326999999996	-63.22739179310308	-17.805326999999995	-17.795326999999993	-63.23239179310308	-63.222391793103085	0.42	0.43	0.15	medio	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
210	-17.800326999999996	-63.21739179310308	-17.805326999999995	-17.795326999999993	-63.222391793103085	-63.21239179310309	0.42	0.43	0.15	medio	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
211	-17.800326999999996	-63.207391793103085	-17.805326999999995	-17.795326999999993	-63.21239179310309	-63.20239179310309	0.42	0.43	0.15	medio	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
212	-17.800326999999996	-63.19739179310309	-17.805326999999995	-17.795326999999993	-63.20239179310309	-63.19239179310309	0.5	0.35	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
213	-17.800326999999996	-63.18739179310309	-17.805326999999995	-17.795326999999993	-63.19239179310309	-63.18239179310309	0.47	0.38	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
214	-17.800326999999996	-63.17739179310309	-17.805326999999995	-17.795326999999993	-63.18239179310309	-63.172391793103095	0.5	0.32	0.18	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
215	-17.800326999999996	-63.16739179310309	-17.805326999999995	-17.795326999999993	-63.172391793103095	-63.1623917931031	0.5	0.33	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
216	-17.800326999999996	-63.157391793103095	-17.805326999999995	-17.795326999999993	-63.1623917931031	-63.1523917931031	0.5	0.3	0.2	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
217	-17.800326999999996	-63.1473917931031	-17.805326999999995	-17.795326999999993	-63.1523917931031	-63.1423917931031	0.45	0.28	0.27	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
218	-17.800326999999996	-63.1373917931031	-17.805326999999995	-17.795326999999993	-63.1423917931031	-63.1323917931031	0.6	0.21	0.19	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
219	-17.800326999999996	-63.1273917931031	-17.805326999999995	-17.795326999999993	-63.1323917931031	-63.122391793103105	0.6	0.21	0.19	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
220	-17.800326999999996	-63.1173917931031	-17.805326999999995	-17.795326999999993	-63.122391793103105	-63.11239179310311	0.6	0.21	0.19	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
221	-17.800326999999996	-63.107391793103105	-17.805326999999995	-17.795326999999993	-63.11239179310311	-63.10239179310311	0.6	0.21	0.19	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
222	-17.790326999999994	-63.22739179310308	-17.795326999999993	-17.78532699999999	-63.23239179310308	-63.222391793103085	0.53	0.3	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
223	-17.790326999999994	-63.21739179310308	-17.795326999999993	-17.78532699999999	-63.222391793103085	-63.21239179310309	0.53	0.3	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
224	-17.790326999999994	-63.207391793103085	-17.795326999999993	-17.78532699999999	-63.21239179310309	-63.20239179310309	0.53	0.3	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
225	-17.790326999999994	-63.19739179310309	-17.795326999999993	-17.78532699999999	-63.20239179310309	-63.19239179310309	0.61	0.23	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
226	-17.790326999999994	-63.18739179310309	-17.795326999999993	-17.78532699999999	-63.19239179310309	-63.18239179310309	0.58	0.27	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
227	-17.790326999999994	-63.17739179310309	-17.795326999999993	-17.78532699999999	-63.18239179310309	-63.172391793103095	0.59	0.28	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
228	-17.790326999999994	-63.16739179310309	-17.795326999999993	-17.78532699999999	-63.172391793103095	-63.1623917931031	0.58	0.28	0.14	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
229	-17.790326999999994	-63.157391793103095	-17.795326999999993	-17.78532699999999	-63.1623917931031	-63.1523917931031	0.58	0.25	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
230	-17.790326999999994	-63.1473917931031	-17.795326999999993	-17.78532699999999	-63.1523917931031	-63.1423917931031	0.52	0.23	0.25	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
231	-17.790326999999994	-63.1373917931031	-17.795326999999993	-17.78532699999999	-63.1423917931031	-63.1323917931031	0.67	0.18	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
232	-17.790326999999994	-63.1273917931031	-17.795326999999993	-17.78532699999999	-63.1323917931031	-63.122391793103105	0.67	0.18	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
233	-17.790326999999994	-63.1173917931031	-17.795326999999993	-17.78532699999999	-63.122391793103105	-63.11239179310311	0.67	0.18	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
234	-17.790326999999994	-63.107391793103105	-17.795326999999993	-17.78532699999999	-63.11239179310311	-63.10239179310311	0.67	0.18	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
235	-17.780326999999993	-63.22739179310308	-17.78532699999999	-17.77532699999999	-63.23239179310308	-63.222391793103085	0.53	0.32	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
236	-17.780326999999993	-63.21739179310308	-17.78532699999999	-17.77532699999999	-63.222391793103085	-63.21239179310309	0.53	0.32	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
237	-17.780326999999993	-63.207391793103085	-17.78532699999999	-17.77532699999999	-63.21239179310309	-63.20239179310309	0.53	0.32	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
238	-17.780326999999993	-63.19739179310309	-17.78532699999999	-17.77532699999999	-63.20239179310309	-63.19239179310309	0.61	0.26	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
239	-17.780326999999993	-63.18739179310309	-17.78532699999999	-17.77532699999999	-63.19239179310309	-63.18239179310309	0.59	0.29	0.12	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
240	-17.780326999999993	-63.17739179310309	-17.78532699999999	-17.77532699999999	-63.18239179310309	-63.172391793103095	0.61	0.29	0.1	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
241	-17.780326999999993	-63.16739179310309	-17.78532699999999	-17.77532699999999	-63.172391793103095	-63.1623917931031	0.61	0.28	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
242	-17.780326999999993	-63.157391793103095	-17.78532699999999	-17.77532699999999	-63.1623917931031	-63.1523917931031	0.64	0.22	0.14	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
243	-17.780326999999993	-63.1473917931031	-17.78532699999999	-17.77532699999999	-63.1523917931031	-63.1423917931031	0.58	0.2	0.22	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
244	-17.780326999999993	-63.1373917931031	-17.78532699999999	-17.77532699999999	-63.1423917931031	-63.1323917931031	0.72	0.15	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
245	-17.780326999999993	-63.1273917931031	-17.78532699999999	-17.77532699999999	-63.1323917931031	-63.122391793103105	0.72	0.15	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
246	-17.780326999999993	-63.1173917931031	-17.78532699999999	-17.77532699999999	-63.122391793103105	-63.11239179310311	0.72	0.15	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
247	-17.780326999999993	-63.107391793103105	-17.78532699999999	-17.77532699999999	-63.11239179310311	-63.10239179310311	0.72	0.15	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
248	-17.77032699999999	-63.22739179310308	-17.77532699999999	-17.76532699999999	-63.23239179310308	-63.222391793103085	0.53	0.32	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
249	-17.77032699999999	-63.21739179310308	-17.77532699999999	-17.76532699999999	-63.222391793103085	-63.21239179310309	0.53	0.32	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
250	-17.77032699999999	-63.207391793103085	-17.77532699999999	-17.76532699999999	-63.21239179310309	-63.20239179310309	0.53	0.32	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
251	-17.77032699999999	-63.19739179310309	-17.77532699999999	-17.76532699999999	-63.20239179310309	-63.19239179310309	0.6	0.28	0.12	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
252	-17.77032699999999	-63.18739179310309	-17.77532699999999	-17.76532699999999	-63.19239179310309	-63.18239179310309	0.58	0.31	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
253	-17.77032699999999	-63.17739179310309	-17.77532699999999	-17.76532699999999	-63.18239179310309	-63.172391793103095	0.62	0.29	0.09	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
254	-17.77032699999999	-63.16739179310309	-17.77532699999999	-17.76532699999999	-63.172391793103095	-63.1623917931031	0.6	0.3	0.1	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
255	-17.77032699999999	-63.157391793103095	-17.77532699999999	-17.76532699999999	-63.1623917931031	-63.1523917931031	0.62	0.25	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
256	-17.77032699999999	-63.1473917931031	-17.77532699999999	-17.76532699999999	-63.1523917931031	-63.1423917931031	0.55	0.24	0.21	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
257	-17.77032699999999	-63.1373917931031	-17.77532699999999	-17.76532699999999	-63.1423917931031	-63.1323917931031	0.69	0.19	0.12	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
258	-17.77032699999999	-63.1273917931031	-17.77532699999999	-17.76532699999999	-63.1323917931031	-63.122391793103105	0.69	0.19	0.12	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
259	-17.77032699999999	-63.1173917931031	-17.77532699999999	-17.76532699999999	-63.122391793103105	-63.11239179310311	0.69	0.19	0.12	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
260	-17.77032699999999	-63.107391793103105	-17.77532699999999	-17.76532699999999	-63.11239179310311	-63.10239179310311	0.69	0.19	0.12	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
261	-17.76032699999999	-63.22739179310308	-17.76532699999999	-17.755326999999987	-63.23239179310308	-63.222391793103085	0.57	0.28	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
262	-17.76032699999999	-63.21739179310308	-17.76532699999999	-17.755326999999987	-63.222391793103085	-63.21239179310309	0.57	0.28	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
263	-17.76032699999999	-63.207391793103085	-17.76532699999999	-17.755326999999987	-63.21239179310309	-63.20239179310309	0.57	0.28	0.15	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
264	-17.76032699999999	-63.19739179310309	-17.76532699999999	-17.755326999999987	-63.20239179310309	-63.19239179310309	0.62	0.25	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
265	-17.76032699999999	-63.18739179310309	-17.76532699999999	-17.755326999999987	-63.19239179310309	-63.18239179310309	0.61	0.27	0.12	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
266	-17.76032699999999	-63.17739179310309	-17.76532699999999	-17.755326999999987	-63.18239179310309	-63.172391793103095	0.65	0.26	0.09	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
267	-17.76032699999999	-63.16739179310309	-17.76532699999999	-17.755326999999987	-63.172391793103095	-63.1623917931031	0.58	0.34	0.08	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
268	-17.76032699999999	-63.157391793103095	-17.76532699999999	-17.755326999999987	-63.1623917931031	-63.1523917931031	0.6	0.31	0.09	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
269	-17.76032699999999	-63.1473917931031	-17.76532699999999	-17.755326999999987	-63.1523917931031	-63.1423917931031	0.55	0.28	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
270	-17.76032699999999	-63.1373917931031	-17.76532699999999	-17.755326999999987	-63.1423917931031	-63.1323917931031	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
271	-17.76032699999999	-63.1273917931031	-17.76532699999999	-17.755326999999987	-63.1323917931031	-63.122391793103105	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
272	-17.76032699999999	-63.1173917931031	-17.76532699999999	-17.755326999999987	-63.122391793103105	-63.11239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
273	-17.76032699999999	-63.107391793103105	-17.76532699999999	-17.755326999999987	-63.11239179310311	-63.10239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
274	-17.750326999999988	-63.22739179310308	-17.755326999999987	-17.745326999999985	-63.23239179310308	-63.222391793103085	0.56	0.28	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
275	-17.750326999999988	-63.21739179310308	-17.755326999999987	-17.745326999999985	-63.222391793103085	-63.21239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
276	-17.750326999999988	-63.207391793103085	-17.755326999999987	-17.745326999999985	-63.21239179310309	-63.20239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
277	-17.750326999999988	-63.19739179310309	-17.755326999999987	-17.745326999999985	-63.20239179310309	-63.19239179310309	0.61	0.25	0.14	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
278	-17.750326999999988	-63.18739179310309	-17.755326999999987	-17.745326999999985	-63.19239179310309	-63.18239179310309	0.6	0.27	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
279	-17.750326999999988	-63.17739179310309	-17.755326999999987	-17.745326999999985	-63.18239179310309	-63.172391793103095	0.64	0.26	0.1	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
280	-17.750326999999988	-63.16739179310309	-17.755326999999987	-17.745326999999985	-63.172391793103095	-63.1623917931031	0.57	0.34	0.09	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
281	-17.750326999999988	-63.157391793103095	-17.755326999999987	-17.745326999999985	-63.1623917931031	-63.1523917931031	0.6	0.31	0.09	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
282	-17.750326999999988	-63.1473917931031	-17.755326999999987	-17.745326999999985	-63.1523917931031	-63.1423917931031	0.55	0.28	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
283	-17.750326999999988	-63.1373917931031	-17.755326999999987	-17.745326999999985	-63.1423917931031	-63.1323917931031	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
284	-17.750326999999988	-63.1273917931031	-17.755326999999987	-17.745326999999985	-63.1323917931031	-63.122391793103105	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
285	-17.750326999999988	-63.1173917931031	-17.755326999999987	-17.745326999999985	-63.122391793103105	-63.11239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
286	-17.750326999999988	-63.107391793103105	-17.755326999999987	-17.745326999999985	-63.11239179310311	-63.10239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
287	-17.740326999999986	-63.22739179310308	-17.745326999999985	-17.735326999999984	-63.23239179310308	-63.222391793103085	0.56	0.28	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
288	-17.740326999999986	-63.21739179310308	-17.745326999999985	-17.735326999999984	-63.222391793103085	-63.21239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
289	-17.740326999999986	-63.207391793103085	-17.745326999999985	-17.735326999999984	-63.21239179310309	-63.20239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
290	-17.740326999999986	-63.19739179310309	-17.745326999999985	-17.735326999999984	-63.20239179310309	-63.19239179310309	0.61	0.25	0.14	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
291	-17.740326999999986	-63.18739179310309	-17.745326999999985	-17.735326999999984	-63.19239179310309	-63.18239179310309	0.6	0.27	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
292	-17.740326999999986	-63.17739179310309	-17.745326999999985	-17.735326999999984	-63.18239179310309	-63.172391793103095	0.64	0.26	0.1	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
293	-17.740326999999986	-63.16739179310309	-17.745326999999985	-17.735326999999984	-63.172391793103095	-63.1623917931031	0.57	0.34	0.09	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
294	-17.740326999999986	-63.157391793103095	-17.745326999999985	-17.735326999999984	-63.1623917931031	-63.1523917931031	0.6	0.31	0.09	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
295	-17.740326999999986	-63.1473917931031	-17.745326999999985	-17.735326999999984	-63.1523917931031	-63.1423917931031	0.55	0.28	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
296	-17.740326999999986	-63.1373917931031	-17.745326999999985	-17.735326999999984	-63.1423917931031	-63.1323917931031	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
297	-17.740326999999986	-63.1273917931031	-17.745326999999985	-17.735326999999984	-63.1323917931031	-63.122391793103105	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
298	-17.740326999999986	-63.1173917931031	-17.745326999999985	-17.735326999999984	-63.122391793103105	-63.11239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
299	-17.740326999999986	-63.107391793103105	-17.745326999999985	-17.735326999999984	-63.11239179310311	-63.10239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
300	-17.730326999999985	-63.22739179310308	-17.735326999999984	-17.725326999999982	-63.23239179310308	-63.222391793103085	0.56	0.28	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
301	-17.730326999999985	-63.21739179310308	-17.735326999999984	-17.725326999999982	-63.222391793103085	-63.21239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
302	-17.730326999999985	-63.207391793103085	-17.735326999999984	-17.725326999999982	-63.21239179310309	-63.20239179310309	0.56	0.28	0.16	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
303	-17.730326999999985	-63.19739179310309	-17.735326999999984	-17.725326999999982	-63.20239179310309	-63.19239179310309	0.61	0.25	0.14	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
304	-17.730326999999985	-63.18739179310309	-17.735326999999984	-17.725326999999982	-63.19239179310309	-63.18239179310309	0.6	0.27	0.13	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
305	-17.730326999999985	-63.17739179310309	-17.735326999999984	-17.725326999999982	-63.18239179310309	-63.172391793103095	0.64	0.26	0.1	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
306	-17.730326999999985	-63.16739179310309	-17.735326999999984	-17.725326999999982	-63.172391793103095	-63.1623917931031	0.57	0.34	0.09	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
307	-17.730326999999985	-63.157391793103095	-17.735326999999984	-17.725326999999982	-63.1623917931031	-63.1523917931031	0.6	0.31	0.09	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
308	-17.730326999999985	-63.1473917931031	-17.735326999999984	-17.725326999999982	-63.1523917931031	-63.1423917931031	0.55	0.28	0.17	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
309	-17.730326999999985	-63.1373917931031	-17.735326999999984	-17.725326999999982	-63.1423917931031	-63.1323917931031	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
310	-17.730326999999985	-63.1273917931031	-17.735326999999984	-17.725326999999982	-63.1323917931031	-63.122391793103105	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
311	-17.730326999999985	-63.1173917931031	-17.735326999999984	-17.725326999999982	-63.122391793103105	-63.11239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
312	-17.730326999999985	-63.107391793103105	-17.735326999999984	-17.725326999999982	-63.11239179310311	-63.10239179310311	0.69	0.2	0.11	alto	2026-05-31 20:07:59.450333-04	v1.0-rf	0	f	\N
313	-17.840327000000002	-63.240576	-17.845327	-17.835327	-63.245576	-63.235576	0.37	0.31	0.32	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
314	-17.840327000000002	-63.230576	-17.845327	-17.835327	-63.235576	-63.225576000000004	0.37	0.31	0.32	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
315	-17.840327000000002	-63.220576	-17.845327	-17.835327	-63.225576000000004	-63.215576000000006	0.36	0.31	0.33	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
316	-17.840327000000002	-63.210576	-17.845327	-17.835327	-63.215576000000006	-63.20557600000001	0.35	0.32	0.33	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
317	-17.840327000000002	-63.200576000000005	-17.845327	-17.835327	-63.20557600000001	-63.19557600000001	0.34	0.33	0.33	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
318	-17.840327000000002	-63.19057600000001	-17.845327	-17.835327	-63.19557600000001	-63.18557600000001	0.34	0.345	0.315	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
319	-17.840327000000002	-63.18057600000001	-17.845327	-17.835327	-63.18557600000001	-63.175576000000014	0.35	0.355	0.295	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
320	-17.840327000000002	-63.17057600000001	-17.845327	-17.835327	-63.175576000000014	-63.165576000000016	0.33	0.305	0.365	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
321	-17.840327000000002	-63.16057600000001	-17.845327	-17.835327	-63.165576000000016	-63.15557600000002	0.33	0.225	0.445	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
322	-17.840327000000002	-63.150576000000015	-17.845327	-17.835327	-63.15557600000002	-63.14557600000002	0.33	0.195	0.475	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
323	-17.840327000000002	-63.14057600000002	-17.845327	-17.835327	-63.14557600000002	-63.13557600000002	0.39	0.195	0.415	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
324	-17.840327000000002	-63.13057600000002	-17.845327	-17.835327	-63.13557600000002	-63.125576000000024	0.52	0.17	0.31	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
325	-17.840327000000002	-63.12057600000002	-17.845327	-17.835327	-63.125576000000024	-63.115576000000026	0.52	0.17	0.31	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
326	-17.840327000000002	-63.11057600000002	-17.845327	-17.835327	-63.115576000000026	-63.10557600000003	0.52	0.17	0.31	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
327	-17.830327	-63.240576	-17.835327	-17.825326999999998	-63.245576	-63.235576	0.37	0.31	0.32	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
328	-17.830327	-63.230576	-17.835327	-17.825326999999998	-63.235576	-63.225576000000004	0.37	0.31	0.32	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
329	-17.830327	-63.220576	-17.835327	-17.825326999999998	-63.225576000000004	-63.215576000000006	0.36	0.31	0.33	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
330	-17.830327	-63.210576	-17.835327	-17.825326999999998	-63.215576000000006	-63.20557600000001	0.35	0.32	0.33	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
331	-17.830327	-63.200576000000005	-17.835327	-17.825326999999998	-63.20557600000001	-63.19557600000001	0.34	0.33	0.33	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
332	-17.830327	-63.19057600000001	-17.835327	-17.825326999999998	-63.19557600000001	-63.18557600000001	0.34	0.345	0.315	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
333	-17.830327	-63.18057600000001	-17.835327	-17.825326999999998	-63.18557600000001	-63.175576000000014	0.35	0.355	0.295	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
334	-17.830327	-63.17057600000001	-17.835327	-17.825326999999998	-63.175576000000014	-63.165576000000016	0.33	0.305	0.365	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
335	-17.830327	-63.16057600000001	-17.835327	-17.825326999999998	-63.165576000000016	-63.15557600000002	0.33	0.225	0.445	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
336	-17.830327	-63.150576000000015	-17.835327	-17.825326999999998	-63.15557600000002	-63.14557600000002	0.33	0.195	0.475	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
337	-17.830327	-63.14057600000002	-17.835327	-17.825326999999998	-63.14557600000002	-63.13557600000002	0.39	0.195	0.415	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
338	-17.830327	-63.13057600000002	-17.835327	-17.825326999999998	-63.13557600000002	-63.125576000000024	0.52	0.17	0.31	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
339	-17.830327	-63.12057600000002	-17.835327	-17.825326999999998	-63.125576000000024	-63.115576000000026	0.52	0.17	0.31	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
340	-17.830327	-63.11057600000002	-17.835327	-17.825326999999998	-63.115576000000026	-63.10557600000003	0.52	0.17	0.31	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
341	-17.820327	-63.240576	-17.825326999999998	-17.815326999999996	-63.245576	-63.235576	0.37	0.31	0.32	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
342	-17.820327	-63.230576	-17.825326999999998	-17.815326999999996	-63.235576	-63.225576000000004	0.37	0.31	0.32	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
343	-17.820327	-63.220576	-17.825326999999998	-17.815326999999996	-63.225576000000004	-63.215576000000006	0.36	0.31	0.33	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
344	-17.820327	-63.210576	-17.825326999999998	-17.815326999999996	-63.215576000000006	-63.20557600000001	0.35	0.32	0.33	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
345	-17.820327	-63.200576000000005	-17.825326999999998	-17.815326999999996	-63.20557600000001	-63.19557600000001	0.34	0.33	0.33	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
346	-17.820327	-63.19057600000001	-17.825326999999998	-17.815326999999996	-63.19557600000001	-63.18557600000001	0.34	0.345	0.315	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
347	-17.820327	-63.18057600000001	-17.825326999999998	-17.815326999999996	-63.18557600000001	-63.175576000000014	0.35	0.355	0.295	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
348	-17.820327	-63.17057600000001	-17.825326999999998	-17.815326999999996	-63.175576000000014	-63.165576000000016	0.33	0.305	0.365	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
349	-17.820327	-63.16057600000001	-17.825326999999998	-17.815326999999996	-63.165576000000016	-63.15557600000002	0.33	0.225	0.445	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
350	-17.820327	-63.150576000000015	-17.825326999999998	-17.815326999999996	-63.15557600000002	-63.14557600000002	0.33	0.195	0.475	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
351	-17.820327	-63.14057600000002	-17.825326999999998	-17.815326999999996	-63.14557600000002	-63.13557600000002	0.39	0.195	0.415	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
352	-17.820327	-63.13057600000002	-17.825326999999998	-17.815326999999996	-63.13557600000002	-63.125576000000024	0.52	0.17	0.31	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
353	-17.820327	-63.12057600000002	-17.825326999999998	-17.815326999999996	-63.125576000000024	-63.115576000000026	0.52	0.17	0.31	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
354	-17.820327	-63.11057600000002	-17.825326999999998	-17.815326999999996	-63.115576000000026	-63.10557600000003	0.52	0.17	0.31	alto	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
355	-17.810326999999997	-63.240576	-17.815326999999996	-17.805326999999995	-63.245576	-63.235576	0.11	0.41	0.48	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
356	-17.810326999999997	-63.230576	-17.815326999999996	-17.805326999999995	-63.235576	-63.225576000000004	0.11	0.41	0.48	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
357	-17.810326999999997	-63.220576	-17.815326999999996	-17.805326999999995	-63.225576000000004	-63.215576000000006	0.1	0.41	0.49	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
358	-17.810326999999997	-63.210576	-17.815326999999996	-17.805326999999995	-63.215576000000006	-63.20557600000001	0.09	0.43	0.48	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
359	-17.810326999999997	-63.200576000000005	-17.815326999999996	-17.805326999999995	-63.20557600000001	-63.19557600000001	0.06	0.45	0.49	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
360	-17.810326999999997	-63.19057600000001	-17.815326999999996	-17.805326999999995	-63.19557600000001	-63.18557600000001	0.06	0.475	0.465	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
361	-17.810326999999997	-63.18057600000001	-17.815326999999996	-17.805326999999995	-63.18557600000001	-63.175576000000014	0.05	0.475	0.475	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
362	-17.810326999999997	-63.17057600000001	-17.815326999999996	-17.805326999999995	-63.175576000000014	-63.165576000000016	0.03	0.415	0.555	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
363	-17.810326999999997	-63.16057600000001	-17.815326999999996	-17.805326999999995	-63.165576000000016	-63.15557600000002	0.03	0.315	0.655	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
364	-17.810326999999997	-63.150576000000015	-17.815326999999996	-17.805326999999995	-63.15557600000002	-63.14557600000002	0.03	0.275	0.695	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
365	-17.810326999999997	-63.14057600000002	-17.815326999999996	-17.805326999999995	-63.14557600000002	-63.13557600000002	0.09	0.275	0.635	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
366	-17.810326999999997	-63.13057600000002	-17.815326999999996	-17.805326999999995	-63.13557600000002	-63.125576000000024	0.23	0.25	0.52	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
367	-17.810326999999997	-63.12057600000002	-17.815326999999996	-17.805326999999995	-63.125576000000024	-63.115576000000026	0.23	0.25	0.52	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
368	-17.810326999999997	-63.11057600000002	-17.815326999999996	-17.805326999999995	-63.115576000000026	-63.10557600000003	0.23	0.25	0.52	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
369	-17.800326999999996	-63.240576	-17.805326999999995	-17.795326999999993	-63.245576	-63.235576	0.12	0.44	0.44	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
370	-17.800326999999996	-63.230576	-17.805326999999995	-17.795326999999993	-63.235576	-63.225576000000004	0.12	0.44	0.44	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
371	-17.800326999999996	-63.220576	-17.805326999999995	-17.795326999999993	-63.225576000000004	-63.215576000000006	0.11	0.44	0.45	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
372	-17.800326999999996	-63.210576	-17.805326999999995	-17.795326999999993	-63.215576000000006	-63.20557600000001	0.1	0.46	0.44	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
373	-17.800326999999996	-63.200576000000005	-17.805326999999995	-17.795326999999993	-63.20557600000001	-63.19557600000001	0.07	0.49	0.44	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
374	-17.800326999999996	-63.19057600000001	-17.805326999999995	-17.795326999999993	-63.19557600000001	-63.18557600000001	0.07	0.525	0.405	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
375	-17.800326999999996	-63.18057600000001	-17.805326999999995	-17.795326999999993	-63.18557600000001	-63.175576000000014	0.06	0.525	0.415	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
376	-17.800326999999996	-63.17057600000001	-17.805326999999995	-17.795326999999993	-63.175576000000014	-63.165576000000016	0.04	0.455	0.505	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
377	-17.800326999999996	-63.16057600000001	-17.805326999999995	-17.795326999999993	-63.165576000000016	-63.15557600000002	0.04	0.3735714285714286	0.5864285714285714	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
378	-17.800326999999996	-63.150576000000015	-17.805326999999995	-17.795326999999993	-63.15557600000002	-63.14557600000002	0.03	0.305	0.665	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
379	-17.800326999999996	-63.14057600000002	-17.805326999999995	-17.795326999999993	-63.14557600000002	-63.13557600000002	0.09	0.305	0.605	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
380	-17.800326999999996	-63.13057600000002	-17.805326999999995	-17.795326999999993	-63.13557600000002	-63.125576000000024	0.23	0.28	0.49	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
381	-17.800326999999996	-63.12057600000002	-17.805326999999995	-17.795326999999993	-63.125576000000024	-63.115576000000026	0.23	0.28	0.49	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
382	-17.800326999999996	-63.11057600000002	-17.805326999999995	-17.795326999999993	-63.115576000000026	-63.10557600000003	0.23	0.28	0.49	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
383	-17.790326999999994	-63.240576	-17.795326999999993	-17.78532699999999	-63.245576	-63.235576	0.15	0.4	0.45	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
384	-17.790326999999994	-63.230576	-17.795326999999993	-17.78532699999999	-63.235576	-63.225576000000004	0.15	0.4	0.45	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
385	-17.790326999999994	-63.220576	-17.795326999999993	-17.78532699999999	-63.225576000000004	-63.215576000000006	0.14	0.4	0.46	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
386	-17.790326999999994	-63.210576	-17.795326999999993	-17.78532699999999	-63.215576000000006	-63.20557600000001	0.13	0.42	0.45	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
387	-17.790326999999994	-63.200576000000005	-17.795326999999993	-17.78532699999999	-63.20557600000001	-63.19557600000001	0.09	0.48	0.43	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
388	-17.790326999999994	-63.19057600000001	-17.795326999999993	-17.78532699999999	-63.19557600000001	-63.18557600000001	0.09	0.525	0.385	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
389	-17.790326999999994	-63.18057600000001	-17.795326999999993	-17.78532699999999	-63.18557600000001	-63.175576000000014	0.07	0.545	0.385	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
390	-17.790326999999994	-63.17057600000001	-17.795326999999993	-17.78532699999999	-63.175576000000014	-63.165576000000016	0.04	0.505	0.455	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
391	-17.790326999999994	-63.16057600000001	-17.795326999999993	-17.78532699999999	-63.165576000000016	-63.15557600000002	0.05	0.40357142857142864	0.5464285714285715	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
392	-17.790326999999994	-63.150576000000015	-17.795326999999993	-17.78532699999999	-63.15557600000002	-63.14557600000002	0.04	0.345	0.615	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
393	-17.790326999999994	-63.14057600000002	-17.795326999999993	-17.78532699999999	-63.14557600000002	-63.13557600000002	0.1	0.345	0.555	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
394	-17.790326999999994	-63.13057600000002	-17.795326999999993	-17.78532699999999	-63.13557600000002	-63.125576000000024	0.24	0.29	0.47	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
395	-17.790326999999994	-63.12057600000002	-17.795326999999993	-17.78532699999999	-63.125576000000024	-63.115576000000026	0.24	0.29	0.47	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
396	-17.790326999999994	-63.11057600000002	-17.795326999999993	-17.78532699999999	-63.115576000000026	-63.10557600000003	0.24	0.29	0.47	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
397	-17.780326999999993	-63.240576	-17.78532699999999	-17.77532699999999	-63.245576	-63.235576	0.1	0.42	0.48	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
398	-17.780326999999993	-63.230576	-17.78532699999999	-17.77532699999999	-63.235576	-63.225576000000004	0.1	0.42	0.48	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
399	-17.780326999999993	-63.220576	-17.78532699999999	-17.77532699999999	-63.225576000000004	-63.215576000000006	0.09	0.42	0.49	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
400	-17.780326999999993	-63.210576	-17.78532699999999	-17.77532699999999	-63.215576000000006	-63.20557600000001	0.08	0.43	0.49	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
401	-17.780326999999993	-63.200576000000005	-17.78532699999999	-17.77532699999999	-63.20557600000001	-63.19557600000001	0.04	0.5066666666666666	0.4533333333333333	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
402	-17.780326999999993	-63.19057600000001	-17.78532699999999	-17.77532699999999	-63.19557600000001	-63.18557600000001	0.05	0.5416666666666666	0.40833333333333327	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
403	-17.780326999999993	-63.18057600000001	-17.78532699999999	-17.77532699999999	-63.18557600000001	-63.175576000000014	0.05	0.545	0.405	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
404	-17.780326999999993	-63.17057600000001	-17.78532699999999	-17.77532699999999	-63.175576000000014	-63.165576000000016	0.03	0.515	0.455	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
405	-17.780326999999993	-63.16057600000001	-17.78532699999999	-17.77532699999999	-63.165576000000016	-63.15557600000002	0.05	0.3635714285714286	0.5864285714285714	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
406	-17.780326999999993	-63.150576000000015	-17.78532699999999	-17.77532699999999	-63.15557600000002	-63.14557600000002	0.04	0.305	0.655	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
407	-17.780326999999993	-63.14057600000002	-17.78532699999999	-17.77532699999999	-63.14557600000002	-63.13557600000002	0.1	0.305	0.595	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
408	-17.780326999999993	-63.13057600000002	-17.78532699999999	-17.77532699999999	-63.13557600000002	-63.125576000000024	0.24	0.25	0.51	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
409	-17.780326999999993	-63.12057600000002	-17.78532699999999	-17.77532699999999	-63.125576000000024	-63.115576000000026	0.24	0.25	0.51	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
410	-17.780326999999993	-63.11057600000002	-17.78532699999999	-17.77532699999999	-63.115576000000026	-63.10557600000003	0.24	0.25	0.51	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
411	-17.77032699999999	-63.240576	-17.77532699999999	-17.76532699999999	-63.245576	-63.235576	0.08	0.37	0.55	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
412	-17.77032699999999	-63.230576	-17.77532699999999	-17.76532699999999	-63.235576	-63.225576000000004	0.08	0.37	0.55	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
413	-17.77032699999999	-63.220576	-17.77532699999999	-17.76532699999999	-63.225576000000004	-63.215576000000006	0.07	0.37	0.56	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
414	-17.77032699999999	-63.210576	-17.77532699999999	-17.76532699999999	-63.215576000000006	-63.20557600000001	0.06	0.3766666666666667	0.5633333333333334	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
415	-17.77032699999999	-63.200576000000005	-17.77532699999999	-17.76532699999999	-63.20557600000001	-63.19557600000001	0.02	0.42333333333333334	0.5566666666666668	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
416	-17.77032699999999	-63.19057600000001	-17.77532699999999	-17.76532699999999	-63.19557600000001	-63.18557600000001	0.03	0.44833333333333336	0.5216666666666667	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
417	-17.77032699999999	-63.18057600000001	-17.77532699999999	-17.76532699999999	-63.18557600000001	-63.175576000000014	0.04	0.4316666666666667	0.5283333333333333	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
418	-17.77032699999999	-63.17057600000001	-17.77532699999999	-17.76532699999999	-63.175576000000014	-63.165576000000016	0.02	0.425	0.555	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
419	-17.77032699999999	-63.16057600000001	-17.77532699999999	-17.76532699999999	-63.165576000000016	-63.15557600000002	0.02	0.25357142857142856	0.7264285714285714	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
420	-17.77032699999999	-63.150576000000015	-17.77532699999999	-17.76532699999999	-63.15557600000002	-63.14557600000002	0.01	0.215	0.775	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
421	-17.77032699999999	-63.14057600000002	-17.77532699999999	-17.76532699999999	-63.14557600000002	-63.13557600000002	0.07	0.215	0.715	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
422	-17.77032699999999	-63.13057600000002	-17.77532699999999	-17.76532699999999	-63.13557600000002	-63.125576000000024	0.21	0.19	0.6	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
423	-17.77032699999999	-63.12057600000002	-17.77532699999999	-17.76532699999999	-63.125576000000024	-63.115576000000026	0.21	0.19	0.6	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
424	-17.77032699999999	-63.11057600000002	-17.77532699999999	-17.76532699999999	-63.115576000000026	-63.10557600000003	0.21	0.19	0.6	bajo	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
425	-17.76032699999999	-63.240576	-17.76532699999999	-17.755326999999987	-63.245576	-63.235576	0.14	0.54	0.32	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
426	-17.76032699999999	-63.230576	-17.76532699999999	-17.755326999999987	-63.235576	-63.225576000000004	0.14	0.54	0.32	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
427	-17.76032699999999	-63.220576	-17.76532699999999	-17.755326999999987	-63.225576000000004	-63.215576000000006	0.13	0.55	0.32	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
428	-17.76032699999999	-63.210576	-17.76532699999999	-17.755326999999987	-63.215576000000006	-63.20557600000001	0.12	0.56	0.32	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
429	-17.76032699999999	-63.200576000000005	-17.76532699999999	-17.755326999999987	-63.20557600000001	-63.19557600000001	0.08	0.5866666666666667	0.33333333333333326	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
430	-17.76032699999999	-63.19057600000001	-17.76532699999999	-17.755326999999987	-63.19557600000001	-63.18557600000001	0.09	0.6516666666666666	0.2583333333333333	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
431	-17.76032699999999	-63.18057600000001	-17.76532699999999	-17.755326999999987	-63.18557600000001	-63.175576000000014	0.11	0.645	0.245	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
432	-17.76032699999999	-63.17057600000001	-17.76532699999999	-17.755326999999987	-63.175576000000014	-63.165576000000016	0.07	0.785	0.145	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
433	-17.76032699999999	-63.16057600000001	-17.76532699999999	-17.755326999999987	-63.165576000000016	-63.15557600000002	0.04	0.7635714285714286	0.19642857142857142	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
434	-17.76032699999999	-63.150576000000015	-17.76532699999999	-17.755326999999987	-63.15557600000002	-63.14557600000002	0.03	0.685	0.285	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
435	-17.76032699999999	-63.14057600000002	-17.76532699999999	-17.755326999999987	-63.14557600000002	-63.13557600000002	0.09	0.645	0.265	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
436	-17.76032699999999	-63.13057600000002	-17.76532699999999	-17.755326999999987	-63.13557600000002	-63.125576000000024	0.22	0.57	0.21	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
437	-17.76032699999999	-63.12057600000002	-17.76532699999999	-17.755326999999987	-63.125576000000024	-63.115576000000026	0.22	0.57	0.21	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
438	-17.76032699999999	-63.11057600000002	-17.76532699999999	-17.755326999999987	-63.115576000000026	-63.10557600000003	0.22	0.57	0.21	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
439	-17.750326999999988	-63.240576	-17.755326999999987	-17.745326999999985	-63.245576	-63.235576	0.14	0.53	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
440	-17.750326999999988	-63.230576	-17.755326999999987	-17.745326999999985	-63.235576	-63.225576000000004	0.14	0.53	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
441	-17.750326999999988	-63.220576	-17.755326999999987	-17.745326999999985	-63.225576000000004	-63.215576000000006	0.13	0.54	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
442	-17.750326999999988	-63.210576	-17.755326999999987	-17.745326999999985	-63.215576000000006	-63.20557600000001	0.12	0.55	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
443	-17.750326999999988	-63.200576000000005	-17.755326999999987	-17.745326999999985	-63.20557600000001	-63.19557600000001	0.08	0.5766666666666667	0.34333333333333327	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
444	-17.750326999999988	-63.19057600000001	-17.755326999999987	-17.745326999999985	-63.19557600000001	-63.18557600000001	0.09	0.6316666666666666	0.2783333333333333	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
445	-17.750326999999988	-63.18057600000001	-17.755326999999987	-17.745326999999985	-63.18557600000001	-63.175576000000014	0.11	0.635	0.255	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
446	-17.750326999999988	-63.17057600000001	-17.755326999999987	-17.745326999999985	-63.175576000000014	-63.165576000000016	0.07	0.765	0.165	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
447	-17.750326999999988	-63.16057600000001	-17.755326999999987	-17.745326999999985	-63.165576000000016	-63.15557600000002	0.04	0.745	0.215	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
448	-17.750326999999988	-63.150576000000015	-17.755326999999987	-17.745326999999985	-63.15557600000002	-63.14557600000002	0.03	0.675	0.295	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
449	-17.750326999999988	-63.14057600000002	-17.755326999999987	-17.745326999999985	-63.14557600000002	-63.13557600000002	0.09	0.635	0.275	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
450	-17.750326999999988	-63.13057600000002	-17.755326999999987	-17.745326999999985	-63.13557600000002	-63.125576000000024	0.22	0.56	0.22	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
451	-17.750326999999988	-63.12057600000002	-17.755326999999987	-17.745326999999985	-63.125576000000024	-63.115576000000026	0.22	0.56	0.22	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
452	-17.750326999999988	-63.11057600000002	-17.755326999999987	-17.745326999999985	-63.115576000000026	-63.10557600000003	0.22	0.56	0.22	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
453	-17.740326999999986	-63.240576	-17.745326999999985	-17.735326999999984	-63.245576	-63.235576	0.14	0.53	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
454	-17.740326999999986	-63.230576	-17.745326999999985	-17.735326999999984	-63.235576	-63.225576000000004	0.14	0.53	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
455	-17.740326999999986	-63.220576	-17.745326999999985	-17.735326999999984	-63.225576000000004	-63.215576000000006	0.13	0.54	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
456	-17.740326999999986	-63.210576	-17.745326999999985	-17.735326999999984	-63.215576000000006	-63.20557600000001	0.12	0.55	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
457	-17.740326999999986	-63.200576000000005	-17.745326999999985	-17.735326999999984	-63.20557600000001	-63.19557600000001	0.08	0.5766666666666667	0.34333333333333327	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
458	-17.740326999999986	-63.19057600000001	-17.745326999999985	-17.735326999999984	-63.19557600000001	-63.18557600000001	0.09	0.6316666666666666	0.2783333333333333	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
459	-17.740326999999986	-63.18057600000001	-17.745326999999985	-17.735326999999984	-63.18557600000001	-63.175576000000014	0.11	0.635	0.255	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
460	-17.740326999999986	-63.17057600000001	-17.745326999999985	-17.735326999999984	-63.175576000000014	-63.165576000000016	0.07	0.765	0.165	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
461	-17.740326999999986	-63.16057600000001	-17.745326999999985	-17.735326999999984	-63.165576000000016	-63.15557600000002	0.04	0.745	0.215	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
462	-17.740326999999986	-63.150576000000015	-17.745326999999985	-17.735326999999984	-63.15557600000002	-63.14557600000002	0.03	0.675	0.295	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
463	-17.740326999999986	-63.14057600000002	-17.745326999999985	-17.735326999999984	-63.14557600000002	-63.13557600000002	0.09	0.635	0.275	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
464	-17.740326999999986	-63.13057600000002	-17.745326999999985	-17.735326999999984	-63.13557600000002	-63.125576000000024	0.22	0.56	0.22	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
465	-17.740326999999986	-63.12057600000002	-17.745326999999985	-17.735326999999984	-63.125576000000024	-63.115576000000026	0.22	0.56	0.22	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
466	-17.740326999999986	-63.11057600000002	-17.745326999999985	-17.735326999999984	-63.115576000000026	-63.10557600000003	0.22	0.56	0.22	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
467	-17.730326999999985	-63.240576	-17.735326999999984	-17.725326999999982	-63.245576	-63.235576	0.14	0.53	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
468	-17.730326999999985	-63.230576	-17.735326999999984	-17.725326999999982	-63.235576	-63.225576000000004	0.14	0.53	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
469	-17.730326999999985	-63.220576	-17.735326999999984	-17.725326999999982	-63.225576000000004	-63.215576000000006	0.13	0.54	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
470	-17.730326999999985	-63.210576	-17.735326999999984	-17.725326999999982	-63.215576000000006	-63.20557600000001	0.12	0.55	0.33	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
471	-17.730326999999985	-63.200576000000005	-17.735326999999984	-17.725326999999982	-63.20557600000001	-63.19557600000001	0.08	0.5766666666666667	0.34333333333333327	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
472	-17.730326999999985	-63.19057600000001	-17.735326999999984	-17.725326999999982	-63.19557600000001	-63.18557600000001	0.09	0.6316666666666666	0.2783333333333333	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
473	-17.730326999999985	-63.18057600000001	-17.735326999999984	-17.725326999999982	-63.18557600000001	-63.175576000000014	0.11	0.635	0.255	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
474	-17.730326999999985	-63.17057600000001	-17.735326999999984	-17.725326999999982	-63.175576000000014	-63.165576000000016	0.07	0.765	0.165	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
475	-17.730326999999985	-63.16057600000001	-17.735326999999984	-17.725326999999982	-63.165576000000016	-63.15557600000002	0.04	0.745	0.215	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
476	-17.730326999999985	-63.150576000000015	-17.735326999999984	-17.725326999999982	-63.15557600000002	-63.14557600000002	0.03	0.675	0.295	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
477	-17.730326999999985	-63.14057600000002	-17.735326999999984	-17.725326999999982	-63.14557600000002	-63.13557600000002	0.09	0.635	0.275	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
478	-17.730326999999985	-63.13057600000002	-17.735326999999984	-17.725326999999982	-63.13557600000002	-63.125576000000024	0.22	0.56	0.22	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
479	-17.730326999999985	-63.12057600000002	-17.735326999999984	-17.725326999999982	-63.125576000000024	-63.115576000000026	0.22	0.56	0.22	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
480	-17.730326999999985	-63.11057600000002	-17.735326999999984	-17.725326999999982	-63.115576000000026	-63.10557600000003	0.22	0.56	0.22	medio	2026-06-02 16:43:56.314513-04	v1.0-rf	0	t	\N
\.


--
-- Data for Name: reporte; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reporte (id, tipo, fecha_generacion, generado_por, parametros, archivo_url, tamano_bytes) FROM stdin;
\.


--
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rol (id, nombre, descripcion) FROM stdin;
1	admin	Administrador del sistema
2	junta	Miembro de la junta vecinal
3	vecino	Residente del barrio
\.


--
-- Data for Name: tipo_alerta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tipo_alerta (id, nombre, descripcion, prioridad) FROM stdin;
1	nuevo_incidente	Alerta generada por un nuevo incidente en la zona	1
2	recomendacion	Recomendacion de seguridad para la comunidad	2
\.


--
-- Data for Name: tipo_incidente; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tipo_incidente (id, nombre, nivel_riesgo_default, icono, color, activo, descripcion) FROM stdin;
1	robo	alto	fa-solid fa-mask	#dc3545	t	\N
2	asalto	alto	fa-solid fa-skull	#dc3545	t	\N
3	vandalismo	medio	fa-solid fa-bomb	#fd7e14	t	\N
4	sospechoso	bajo	fa-solid fa-eye	#ffc107	t	\N
5	ruido	bajo	fa-solid fa-volume-up	#6c757d	t	\N
6	alumbrado	bajo	fa-solid fa-lightbulb	#6c757d	t	\N
10	otro	bajo	fa-solid fa-circle	#6c757d	t	\N
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_sessions (id, user_id, token, ip_address, user_agent, created_at, last_activity) FROM stdin;
10	1	aa9e5361048dcae7574abe34a627ad5bf3afb83966f08a9bbf8e8c2bd23af2b1	127.0.0.1	\N	2026-05-31 19:08:47.189862-04	2026-05-31 20:27:13.912336-04
15	5	5410fead1460226b583f17381d1fd3e8daa87bcb5c9aac74c7701f9ace69cf15	127.0.0.1	\N	2026-06-02 16:46:34.559472-04	2026-06-02 16:56:07.390334-04
16	1	3ecb4a1d3960c03bb1761628d7eb19658466ac0efd7a72effb2e544e068ccf78	127.0.0.1	\N	2026-06-02 16:56:29.863686-04	2026-06-02 16:56:31.423139-04
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuarios (id, email, password_hash, nombre, rol_id, activo, telefono, fecha_registro, barrio_id, foto_url, email_verified, verification_token) FROM stdin;
2	vecino1@email.com	scrypt:32768:8:1$7qqVblkViA9x3y96$747e84e1507bf1f00da9c56b1a04bdde9b3c27bd0b45de567081cc1d5c18ae9f7f807eaf53685306547a4c6b61531038f28f9b3d2cf7a6d9cb4b173f5773e573	Juan Pérez	3	t	555-0002	2026-05-22 15:33:55.221988-04	\N	\N	t	\N
3	vecino2@email.com	scrypt:32768:8:1$YVk1Fyrl7IrfhtTS$bcb5ac2dc5687a7c0017a2a135966d781d1437438d00e1652f3a47cc48d750c12a17c10f93b45341ae42a011ce54e479563c161f74d0453369b36f19c917bd36	María García	3	t	555-0003	2026-05-22 15:33:55.317558-04	\N	\N	t	\N
4	junta@sisvec.com	scrypt:32768:8:1$0vUd5YC81qWYNk1h$83d58ea52556eb8c45e292ad1c38d40270e65a4d520eb8483e1291bfaa8000e164a20938e990e4efda89c86b295f99bceccb203f841e1501d69aea307d8210a6	Junta Vecinal Centro	2	t	555-0004	2026-05-22 15:33:55.408574-04	\N	\N	t	\N
1	admin@sisvec.com	scrypt:32768:8:1$zzuusLPlOeAblVhk$8ec1e59a63e44ac3df704ea8f7de319cb0140b46f174d6568c3e43de6eff3f164f7dd0905e7d21e792dc21eed9f99f0448233019263d1cd87397e944f07cba26	Administrador	1	t	555-0001	2026-05-22 15:33:55.106287-04	4	\N	t	\N
5	leoncarballojhery8@gmail.com	scrypt:32768:8:1$fqsjWshVY2d5Xj5w$afa0a6ef792d63fde5967df2fd202ea80e4ad8586181bf2c9d6b58db19e4db377d247e7bf55c181ccfd73a611f0c7bc8602b189a0dbab7f9f73cea9a65849d12	Jhery Leon	3	t	67731820	2026-06-02 16:45:38.762384-04	1	\N	t	\N
\.


--
-- Data for Name: validacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.validacion (id, incidente_id, validador_id, fecha, estado, observacion) FROM stdin;
\.


--
-- Name: alertas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.alertas_id_seq', 35, true);


--
-- Name: auditoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auditoria_id_seq', 1, false);


--
-- Name: barrio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.barrio_id_seq', 5, true);


--
-- Name: comentario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.comentario_id_seq', 1, false);


--
-- Name: evidencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.evidencia_id_seq', 1, false);


--
-- Name: incidentes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.incidentes_id_seq', 110, true);


--
-- Name: predicciones_riesgo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.predicciones_riesgo_id_seq', 480, true);


--
-- Name: reporte_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reporte_id_seq', 1, false);


--
-- Name: rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rol_id_seq', 3, true);


--
-- Name: tipo_alerta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tipo_alerta_id_seq', 2, true);


--
-- Name: tipo_incidente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tipo_incidente_id_seq', 10, true);


--
-- Name: user_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_sessions_id_seq', 16, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 5, true);


--
-- Name: validacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.validacion_id_seq', 1, false);


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

\unrestrict b4yvZHYhMzZ6iz24ZGnNVCv7XGSgVZbTlNX0GFkq6vlUcZAmSiP5Q77u74i54eK

