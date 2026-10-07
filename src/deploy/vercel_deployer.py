#!/usr/bin/env python3
"""
Script automatizado para desplegar la Landing Page de Induvallas en Vercel
utilizando la API REST oficial de Vercel v13.
"""

import os
import json
import urllib.request
import urllib.error

def load_env():
    env_vars = {}
    env_path = os.path.join(os.path.dirname(__file__), '../../.env')
    if os.path.exists(env_path):
        with open(env_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    k, v = line.split('=', 1)
                    env_vars[k.strip()] = v.strip().strip('"').strip("'")
    return env_vars

def deploy():
    env = load_env()
    token = env.get('VERCEL_TOKEN')
    supabase_url = env.get('SUPABASE_URL', '')
    supabase_anon_key = env.get('SUPABASE_ANON_KEY', '')

    if not token:
        print("[ERROR] No se encontró VERCEL_TOKEN en el archivo .env")
        print("Por favor coloca tu token de Vercel en .env para continuar.")
        return None

    landing_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../landing'))
    
    # Leer archivos de la landing
    files_to_deploy = []
    
    for filename in ['index.html', 'styles.css', 'app.js']:
        filepath = os.path.join(landing_dir, filename)
        if os.path.exists(filepath):
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Inyectar credenciales reales de Supabase en index.html o app.js si están configuradas
            if filename == 'index.html' and supabase_url and supabase_anon_key:
                injection = f"""<script>
  window.__SUPABASE_URL__ = "{supabase_url}";
  window.__SUPABASE_ANON_KEY__ = "{supabase_anon_key}";
</script>
</head>"""
                content = content.replace('</head>', injection)

            files_to_deploy.append({
                "file": filename,
                "data": content,
                "encoding": "utf-8"
            })

    payload = {
        "name": "induvallas-mofu-filter",
        "files": files_to_deploy,
        "projectSettings": {
            "framework": None
        }
    }

    url = "https://api.vercel.com/v13/deployments"
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode('utf-8'),
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
    )

    print("[INFO] Subiendo archivos y desplegando en Vercel...")
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = json.loads(resp.read().decode('utf-8'))
            deployment_url = f"https://{data.get('url')}"
            print("[EXITO] Despliegue completado.")
            print(f"URL de Producción: {deployment_url}")
            return deployment_url
    except urllib.error.HTTPError as e:
        error_msg = e.read().decode('utf-8')
        print(f"[ERROR VERCEL API {e.code}]: {error_msg}")
        return None
    except Exception as e:
        print(f"[ERROR]: {e}")
        return None

if __name__ == '__main__':
    deploy()
