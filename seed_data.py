from datetime import datetime, timedelta, timezone
from app import create_app, db
app = create_app()
with app.app_context():
    from app.models import Rol, Barrio, Usuario, TipoIncidente, Incidente, TipoAlerta, Validacion, Prediccion

    db.drop_all()
    db.create_all()

    roles = [
        Rol(nombre='admin', descripcion='Administrador del sistema'),
        Rol(nombre='junta', descripcion='Miembro de la junta vecinal'),
        Rol(nombre='vecino', descripcion='Residente del barrio'),
    ]
    db.session.add_all(roles); db.session.flush()
    r_admin, r_junta, r_vecino = roles[0].id, roles[1].id, roles[2].id

    bcentro = Barrio(nombre='Centro', ciudad='Santa Cruz', lat_centro=-17.7833, lng_centro=-63.1825)
    bnorte  = Barrio(nombre='Norte',  ciudad='Santa Cruz', lat_centro=-17.7700, lng_centro=-63.1800)
    bsur    = Barrio(nombre='Sur',    ciudad='Santa Cruz', lat_centro=-17.8000, lng_centro=-63.1850)
    beste   = Barrio(nombre='Este',   ciudad='Santa Cruz', lat_centro=-17.7833, lng_centro=-63.1600)
    boeste  = Barrio(nombre='Oeste',  ciudad='Santa Cruz', lat_centro=-17.7833, lng_centro=-63.2000)
    barrios = [bcentro, bnorte, bsur, beste, boeste]
    db.session.add_all(barrios); db.session.flush()

    admin = Usuario(email='admin@sisvec.com', nombre='Administrador', rol_id=r_admin, barrio_id=bcentro.id, activo=True, telefono='555-0001')
    admin.set_password('admin123'); db.session.add(admin)
    v1 = Usuario(email='vecino1@gmail.com', nombre='Juan Perez', rol_id=r_vecino, barrio_id=bnorte.id, activo=True, telefono='555-0002')
    v1.set_password('vecino123'); db.session.add(v1)
    v2 = Usuario(email='vecino2@email.com', nombre='Maria Garcia', rol_id=r_vecino, barrio_id=bcentro.id, activo=True, telefono='555-0003')
    v2.set_password('vecino123'); db.session.add(v2)
    junta = Usuario(email='junta@sisvec.com', nombre='Junta Vecinal Centro', rol_id=r_junta, barrio_id=bcentro.id, activo=True, telefono='555-0004')
    junta.set_password('junta123'); db.session.add(junta)
    db.session.flush()

    tipos_id = {}
    for n, nivel, icono, color in [
        ('robo','alto','theft','#dc3545'),
        ('violencia','alto','violence','#dc3545'),
        ('drogas','alto','drug','#6f42c1'),
        ('vandalismo','medio','hammer','#ffc107'),
        ('sospechoso','bajo','question-mark','#0dcaf0'),
        ('ruido','bajo','volume-high','#6c757d'),
        ('alumbrado','bajo','lightbulb','#198754'),
        ('asalto','alto','person-fill','#dc3545'),
        ('otro','bajo','circle-exclamation','#6c757d'),
    ]:
        t = TipoIncidente(nombre=n, nivel_riesgo_default=nivel, icono=icono, color=color, activo=True)
        db.session.add(t); db.session.flush()
        tipos_id[n] = t.id

    for n, d, p in [('nuevo_incidente','Notificacion',1),('riesgo_alto','Zona alto riesgo',1),('recordatorio','Recordatorio',3),('general','Info general',4)]:
        db.session.add(TipoAlerta(nombre=n, descripcion=d, prioridad=p))
    db.session.flush(); db.session.commit()

    ahora = datetime.now(timezone.utc)

    rows = [
        (tipos_id['robo'], bcentro.id, v2.id, 'Robo a mano armada en comercio de la calle Bolivar', ahora - timedelta(hours=2), -17.7840, -63.1810, 'alto', True, True),
        (tipos_id['sospechoso'], bnorte.id, v1.id, 'Camioneta blanca sin placas estacionada hace 3 horas frente a la plaza', ahora - timedelta(hours=5), -17.7710, -63.1795, 'bajo', False, False),
        (tipos_id['ruido'], bcentro.id, None, 'Fiesta en edificio calle Sucre con musica alto volumen', ahora - timedelta(hours=8), -17.7825, -63.1835, 'bajo', True, False),
        (tipos_id['asalto'], bcentro.id, v2.id, 'Asalto con cuchillo en parada de micro Av. Principal', ahora - timedelta(hours=3), -17.7842, -63.1825, 'alto', True, True),
        (tipos_id['robo'], bsur.id, v2.id, 'Motocicleta robada en Av. San Martin', ahora - timedelta(hours=26), -17.8010, -63.1840, 'alto', True, True),
        (tipos_id['violencia'], bcentro.id, v1.id, 'Pelea entre dos grupos en salida del boliche', ahora - timedelta(hours=28), -17.7838, -63.1820, 'alto', True, True),
        (tipos_id['alumbrado'], bnorte.id, None, 'Lampara fundida en esquina calle 4 y Av. 2 de Mayo', ahora - timedelta(hours=30), -17.7695, -63.1805, 'bajo', False, False),
        (tipos_id['drogas'], bcentro.id, v2.id, 'Consumo y venta en parque infantil calle Junin', ahora - timedelta(hours=52), -17.7845, -63.1815, 'alto', False, True),
        (tipos_id['robo'], beste.id, v1.id, 'Robo de cartera en parada del micro', ahora - timedelta(hours=54), -17.7830, -63.1580, 'alto', True, True),
        (tipos_id['vandalismo'], boeste.id, None, 'Grafiti en fachada de iglesia barrio Oeste', ahora - timedelta(hours=56), -17.7840, -63.2010, 'medio', True, False),
        (tipos_id['robo'], bcentro.id, v2.id, 'Sustraccion de mercancia en tienda electrodomesticos', ahora - timedelta(hours=76), -17.7850, -63.1828, 'alto', True, True),
        (tipos_id['sospechoso'], bsur.id, v1.id, 'Individuo merodeando autos en Av. Iraizos', ahora - timedelta(hours=78), -17.7990, -63.1860, 'bajo', False, False),
        (tipos_id['ruido'], boeste.id, None, 'Musica alto volumen en taller mecanico despues 10pm', ahora - timedelta(hours=80), -17.7825, -63.1990, 'bajo', True, False),
        (tipos_id['asalto'], bnorte.id, v1.id, 'Sujeto armado robó celular a transeúnte en calle 4', ahora - timedelta(hours=48), -17.7712, -63.1798, 'alto', True, True),
        (tipos_id['robo'], bcentro.id, v2.id, 'Auto con vidrio roto y radio robada calle 24 Septiembre', ahora - timedelta(hours=100), -17.7835, -63.1830, 'alto', True, True),
        (tipos_id['violencia'], bnorte.id, v1.id, 'Intento de agresion en cancha barrio Norte', ahora - timedelta(hours=102), -17.7705, -63.1802, 'alto', True, True),
        (tipos_id['alumbrado'], bsur.id, None, 'Poste de luz caido sobre vereda calle 7', ahora - timedelta(hours=104), -17.8015, -63.1845, 'bajo', False, False),
        (tipos_id['drogas'], beste.id, v2.id, 'Olor a marihuana persistente en pasillo edificio', ahora - timedelta(hours=126), -17.7820, -63.1590, 'alto', False, True),
        (tipos_id['robo'], bcentro.id, v1.id, 'Carterista en mercado central', ahora - timedelta(hours=128), -17.7848, -63.1822, 'alto', True, True),
        (tipos_id['vandalismo'], bnorte.id, None, 'Contenedor basura quemado en plaza barrio Norte', ahora - timedelta(hours=130), -17.7700, -63.1808, 'medio', True, False),
        (tipos_id['sospechoso'], bcentro.id, v2.id, 'Persona merodeando casas calle Arenales', ahora - timedelta(hours=150), -17.7842, -63.1818, 'bajo', False, False),
        (tipos_id['robo'], boeste.id, v1.id, 'Bicicleta robada de garaje barrio Oeste', ahora - timedelta(hours=152), -17.7838, -63.2005, 'alto', True, True),
        (tipos_id['ruido'], bcentro.id, None, 'Perro ladrando toda la noche calle Libertad', ahora - timedelta(hours=154), -17.7828, -63.1840, 'bajo', False, False),
        (tipos_id['robo'], bsur.id, v2.id, 'Robo a tienda barrio por dos encapuchados', ahora - timedelta(hours=176), -17.8005, -63.1865, 'alto', True, True),
        (tipos_id['violencia'], bcentro.id, v1.id, 'Acoso callejero a vecina en parada de micro', ahora - timedelta(hours=178), -17.7830, -63.1832, 'alto', True, True),
        (tipos_id['alumbrado'], beste.id, None, 'Cuadra completamente oscura calle 8 barrio Este', ahora - timedelta(hours=180), -17.7840, -63.1570, 'bajo', False, False),
        (tipos_id['drogas'], bcentro.id, v2.id, 'Posible punto de venta esquina Sucre y Bolivar', ahora - timedelta(hours=200), -17.7846, -63.1826, 'alto', False, True),
        (tipos_id['robo'], bnorte.id, v1.id, 'Sustraccion herramientas de construccion barrio Norte', ahora - timedelta(hours=202), -17.7710, -63.1790, 'alto', True, True),
        (tipos_id['vandalismo'], bsur.id, None, 'Banco de plaza rayado con insultos', ahora - timedelta(hours=204), -17.8012, -63.1855, 'medio', True, False),
        (tipos_id['robo'], bcentro.id, v2.id, 'Camioneta blanca robada frente al hospital', ahora - timedelta(hours=226), -17.7852, -63.1812, 'alto', True, True),
        (tipos_id['sospechoso'], boeste.id, v1.id, 'Dos personas mirando casas calle 5 actitud sospechosa', ahora - timedelta(hours=228), -17.7835, -63.2015, 'bajo', False, False),
        (tipos_id['ruido'], bcentro.id, None, 'Taller mecanico ruidoso desde 7am calle Junin', ahora - timedelta(hours=230), -17.7855, -63.1838, 'bajo', True, False),
        (tipos_id['robo'], beste.id, v2.id, 'Robo de cableado electrico en obra construccion', ahora - timedelta(hours=250), -17.7825, -63.1585, 'alto', True, True),
        (tipos_id['violencia'], bcentro.id, v1.id, 'Discusion violenta entre padres en puerta colegio', ahora - timedelta(hours=252), -17.7836, -63.1836, 'alto', True, True),
        (tipos_id['alumbrado'], bnorte.id, None, 'Lampara parque infantil fundida hace una semana', ahora - timedelta(hours=254), -17.7708, -63.1798, 'bajo', False, False),
        (tipos_id['drogas'], bcentro.id, v2.id, 'Consumo drogas en bano centro comercial', ahora - timedelta(hours=290), -17.7844, -63.1824, 'alto', False, True),
        (tipos_id['robo'], bsur.id, v1.id, 'Robo de cartera en micro linea 12', ahora - timedelta(hours=294), -17.8008, -63.1858, 'alto', True, True),
        (tipos_id['vandalismo'], bcentro.id, None, 'Piedrazo a ventana local comercial Av. Principal', ahora - timedelta(hours=296), -17.7832, -63.1822, 'medio', True, False),
        (tipos_id['robo'], bcentro.id, v2.id, 'Puerta forzada en estacionamiento supermercado', ahora - timedelta(hours=340), -17.7849, -63.1819, 'alto', True, True),
        (tipos_id['sospechoso'], bnorte.id, v1.id, 'Camioneta negra dando vueltas desde hace una hora', ahora - timedelta(hours=344), -17.7702, -63.1806, 'bajo', False, False),
        (tipos_id['robo'], bcentro.id, v2.id, 'Robo en farmacia calle Bolivar se llevaron medicamentos', ahora - timedelta(hours=388), -17.7847, -63.1817, 'alto', True, True),
        (tipos_id['violencia'], beste.id, v1.id, 'Amenazas entre vecinos por limite propiedad', ahora - timedelta(hours=392), -17.7833, -63.1595, 'alto', True, True),
        (tipos_id['alumbrado'], boeste.id, None, 'Toda la calle 10 barrio Oeste sin luz', ahora - timedelta(hours=394), -17.7840, -63.2000, 'bajo', False, False),
        (tipos_id['drogas'], bcentro.id, v2.id, 'Jeringas y restos consumo en callejon Sucre', ahora - timedelta(hours=436), -17.7851, -63.1831, 'alto', False, True),
        (tipos_id['robo'], bnorte.id, v1.id, 'Robo de bicicleta del patio casa barrio Norte', ahora - timedelta(hours=440), -17.7715, -63.1792, 'alto', True, True),
        (tipos_id['robo'], bcentro.id, v2.id, 'Motocicleta sustraida estacionamiento edificio', ahora - timedelta(hours=506), -17.7841, -63.1821, 'alto', True, True),
        (tipos_id['vandalismo'], bsur.id, None, 'Cartel senalizacion derribado Av. San Martin', ahora - timedelta(hours=510), -17.8018, -63.1862, 'medio', True, False),
        (tipos_id['robo'], bcentro.id, v2.id, 'Hurto de cartera en mercado publico', ahora - timedelta(hours=580), -17.7843, -63.1823, 'alto', True, True),
        (tipos_id['sospechoso'], boeste.id, v1.id, 'Sonidos cristales rotos calle 8 barrio Oeste', ahora - timedelta(hours=584), -17.7836, -63.2012, 'bajo', False, False),
        (tipos_id['ruido'], bcentro.id, None, 'Construccion ruidosa antes de 8am calle Libertad', ahora - timedelta(hours=586), -17.7839, -63.1842, 'bajo', True, False),
        (tipos_id['robo'], bcentro.id, v2.id, 'Camioneta con cerradura forzada estacionada', ahora - timedelta(hours=652), -17.7853, -63.1815, 'alto', True, True),
        (tipos_id['violencia'], bnorte.id, v1.id, 'Pelea en fila del banco barrio Norte', ahora - timedelta(hours=656), -17.7706, -63.1804, 'alto', True, True),
        (tipos_id['alumbrado'], bcentro.id, None, 'Lampara fundida esquina Bolivar y Sucre', ahora - timedelta(hours=658), -17.7844, -63.1827, 'bajo', False, False),
        (tipos_id['drogas'], bsur.id, v2.id, 'Olor a marihuana en pasillo colegio barrio Sur', ahora - timedelta(hours=700), -17.8020, -63.1868, 'alto', False, True),
        (tipos_id['robo'], bcentro.id, v1.id, 'Robo cartera en parada micro Av. Principal', ahora - timedelta(hours=704), -17.7834, -63.1829, 'alto', True, True),
    ]
    for d in rows:
        inc = Incidente(tipo_incidente_id=d[0], barrio_id=d[1], reportado_por=d[2], descripcion=d[3], fecha_hora=d[4], latitud=d[5], longitud=d[6], riesgo_nivel=d[7], verificado=d[8], reportado_anonimamente=d[9], direccion='')
        db.session.add(inc); db.session.flush()
        if inc.verificado:
            db.session.add(Validacion(incidente_id=inc.id, validador_id=junta.id, estado='verificado'))
    db.session.commit()

    for b, pa, pm, pb, nl, uh in [
        (bcentro, 0.35, 0.40, 0.25, 'medio', 3), (bnorte, 0.15, 0.35, 0.50, 'bajo', 1),
        (bsur, 0.25, 0.40, 0.35, 'medio', 2), (beste, 0.20, 0.35, 0.45, 'bajo', 1), (boeste, 0.10, 0.30, 0.60, 'bajo', 0),
    ]:
        db.session.add(Prediccion(barrio_id=b.id, lat_centro=b.lat_centro, lng_centro=b.lng_centro, lat_min=b.lat_centro-0.015, lat_max=b.lat_centro+0.015, lng_min=b.lng_centro-0.015, lng_max=b.lng_centro+0.015, probabilidad_alto=pa, probabilidad_medio=pm, probabilidad_bajo=pb, nivel_predominante=nl, fecha_prediccion=ahora-timedelta(hours=2), modelo_version='v1.0', incidentes_ultima_hora=uh, activa=True))
    db.session.commit()

    # --- Generar alertas ---
    from app.utils.alerts import crear_alerta
    alertas_creadas = 0
    for inc in Incidente.query.all():
        inc.tipo_incidente  # eager load
        tipo_nombre = inc.tipo_incidente.nombre if inc.tipo_incidente else 'otro'
        barrio_nombre = inc.barrio_obj.nombre if inc.barrio_obj else 'tu barrio'

        # Alerta para quien reportó
        if inc.reportado_por:
            crear_alerta(
                usuario_id=inc.reportado_por,
                tipo_nombre='nuevo_incidente',
                mensaje="Reportaste un incidente: %s (riesgo %s). Recibirás notificaciones si hay novedades." % (tipo_nombre, inc.riesgo_nivel),
                incidente_id=inc.id,
                nivel_riesgo=inc.riesgo_nivel,
            )
            alertas_creadas += 1

        # Alerta para vecinos del mismo barrio
        vecinos = Usuario.query.filter(
            Usuario.barrio_id == inc.barrio_id,
            Usuario.id != inc.reportado_por,
            Usuario.activo == True,
        ).all()
        emoji = "🔴" if inc.riesgo_nivel == "alto" else "🟡" if inc.riesgo_nivel == "medio" else "🟢"
        for v in vecinos:
            crear_alerta(
                usuario_id=v.id,
                tipo_nombre='nuevo_incidente',
                mensaje="%s Incidente reportado en tu barrio: %s. Nivel de riesgo: %s. Toma precauciones." % (emoji, tipo_nombre, inc.riesgo_nivel),
                incidente_id=inc.id,
                zona=barrio_nombre,
                nivel_riesgo=inc.riesgo_nivel,
            )
            alertas_creadas += 1

        # Alertas críticas para tipos específicos con riesgo alto
        if inc.riesgo_nivel == 'alto' and tipo_nombre in ('violencia', 'robo', 'drogas'):
            criticos = Usuario.query.filter(
                Usuario.activo == True,
                Usuario.id != inc.reportado_por,
                Usuario.telefono.isnot(None),
                Usuario.telefono != '',
            ).all()
            for v in criticos:
                desc = (" Descripción: " + inc.descripcion[:100]) if inc.descripcion else ""
                crear_alerta(
                    usuario_id=v.id,
                    tipo_nombre='nuevo_incidente',
                    mensaje="⚠️ Incidente reportado en tu barrio: %s. Toma precauciones.%s" % (tipo_nombre, desc),
                    incidente_id=inc.id,
                    nivel_riesgo=inc.riesgo_nivel,
                )
                alertas_creadas += 1

    db.session.commit()

    total = Incidente.query.count()
    print('%d incidentes creados (orden cronologico, riesgo real por tipo)' % total)
    print('%d alertas generadas' % alertas_creadas)
    print('%d validaciones, %d predicciones, %d usuarios' % (Validacion.query.count(), Prediccion.query.count(), Usuario.query.count()))
    for u in Usuario.query.all():
        p = 'admin123' if 'admin' in u.email else 'junta123' if 'junta' in u.email else 'vecino123'
        print('  %s / %s (pass: %s)' % (u.email, u.rol, p))
    print('5 mas recientes:')
    for i in Incidente.query.order_by(Incidente.fecha_hora.desc()).limit(5).all():
        print('  [%s] %s %s | %s' % (i.fecha_hora.strftime('%Y-%m-%d %H:%M'), i.tipo, i.riesgo_nivel, i.descripcion[:45]))
    print('OK!')
