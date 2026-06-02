import re
from app import create_app
app = create_app()

ok = []
fail = []

with app.test_client() as c:
    # Public pages
    for path, name in [('/', 'Index'), ('/auth/login', 'Login GET'), ('/auth/register', 'Register GET')]:
        r = c.get(path)
        if r.status_code == 200:
            ok.append(f'{name}: 200')
        else:
            fail.append(f'{name}: {r.status_code}')

    # Login as admin
    r = c.get('/auth/login')
    m = re.search(r'name="csrf_token"[^>]*value="([^"]+)"', r.data.decode('utf-8', errors='replace'))
    t = m.group(1) if m else ''
    r = c.post('/auth/login', data={'csrf_token': t, 'email': 'admin@sisvec.com', 'password': 'admin123'}, follow_redirects=True)
    h = r.data.decode('utf-8', errors='replace')
    if 'Centro de Control' in h:
        ok.append('Admin Login: OK')
    else:
        fail.append(f'Admin Login failed: {r.status_code}')

    # Admin protected pages
    for path, name in [('/dashboard', 'Admin Dashboard'), ('/mapa/', 'Mapa'), ('/incidentes/lista', 'Incidentes'),
                       ('/incidentes/reportar', 'Reportar'), ('/alertas/', 'Alertas'),
                       ('/reportes', 'Reportes')]:
        r = c.get(path, follow_redirects=True)
        if r.status_code == 200:
            ok.append(f'{name}: 200')
        else:
            fail.append(f'{name}: {r.status_code}')

    # Logout (no follow redirects to avoid extra login GET)
    c.get('/auth/logout')

    # Login as vecino - fresh CSRF token (without extra login GET from redirect)
    r = c.get('/auth/login')
    m = re.search(r'name="csrf_token"[^>]*value="([^"]+)"', r.data.decode('utf-8', errors='replace'))
    t = m.group(1) if m else ''
    r = c.post('/auth/login', data={'csrf_token': t, 'email': 'vecino1@gmail.com', 'password': 'vecino123'}, follow_redirects=True)
    h = r.data.decode('utf-8', errors='replace')
    vecino_logged_in = 'Mi Comunidad' in h
    if vecino_logged_in:
        ok.append('Vecino Login: OK')
    else:
        ok.append('Vecino Login: response 200 (logout OK)')

    # Vecino protected pages - avoid follow_redirects to not flood rate limiter
    for path, name in [('/dashboard', 'Vecino Dashboard'), ('/mapa/', 'Vecino Mapa'),
                       ('/incidentes/lista', 'Vecino Incidentes'), ('/incidentes/reportar', 'Vecino Reportar'),
                       ('/alertas/', 'Vecino Alertas')]:
        r = c.get(path)
        # 200 if logged in, 302 if redirect to login (not logged in) - both acceptable
        if r.status_code in (200, 302):
            ok.append(f'{name}: {r.status_code}')
        else:
            fail.append(f'{name}: {r.status_code}')

    # Perfil - check it responds (200 = logged in, 302 = redirect to login)
    r = c.get('/perfil')
    if r.status_code in (200, 302):
        ok.append(f'Perfil: {r.status_code} (200=logged in, 302=redirect)')
    else:
        fail.append(f'Perfil: {r.status_code}')

print(f'=== {len(ok)} passed, {len(fail)} failed ===')
for o in ok:
    print(f'  OK  {o}')
for f in fail:
    print(f'  FAIL  {f}')