# Backend del asistente de voz

Recibe audio del ESP32 Multitool, lo transcribe con Whisper (OpenAI) y
le pide a Claude (Anthropic) que decida qué acción ejecutar, dentro de
un set fijo de acciones seguras. Ver el flujo completo en
[`docs/VOICE_ASSISTANT.md`](../docs/VOICE_ASSISTANT.md).

## Instalación local (probar antes de desplegar)

```bash
cd server
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Editar .env con tus claves de API y un DEVICE_TOKEN propio
uvicorn main:app --host 0.0.0.0 --port 8000
```

Probar con un WAV de ejemplo:

```bash
curl -X POST http://localhost:8000/command \
  -H "Content-Type: audio/wav" \
  -H "X-Device-Token: tu-token" \
  --data-binary @prueba.wav
```

## Desplegar en un VPS

1. **Servidor mínimo:** cualquier VPS con 512MB+ RAM (DigitalOcean,
   Hetzner, etc.) alcanza — el procesamiento pesado lo hacen las APIs
   externas, no este servidor.
2. **Clona el repo y repite la instalación local** en el VPS.
3. **Corré el servicio con systemd** para que sobreviva reinicios:

```ini
# /etc/systemd/system/multitool-voice.service
[Unit]
Description=Multitool voice backend
After=network.target

[Service]
WorkingDirectory=/home/TU_USUARIO/Proyecto-Integrados/server
ExecStart=/home/TU_USUARIO/Proyecto-Integrados/server/venv/bin/uvicorn main:app --host 127.0.0.1 --port 8000
Restart=always
User=TU_USUARIO
EnvironmentFile=/home/TU_USUARIO/Proyecto-Integrados/server/.env

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable --now multitool-voice
```

4. **Pon HTTPS delante con Nginx + Let's Encrypt** (el ESP32 necesita
   HTTPS):

```nginx
server {
    listen 443 ssl;
    server_name tu-dominio.example.com;
    ssl_certificate     /etc/letsencrypt/live/tu-dominio.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tu-dominio.example.com/privkey.pem;

    location /command {
        proxy_pass http://127.0.0.1:8000;
        client_max_body_size 5M;
    }
}
```

```bash
sudo certbot --nginx -d tu-dominio.example.com
```

5. **Poné esa URL en `src/config/Secrets.h`** como `BACKEND_URL`.

## Seguridad

- `DEVICE_TOKEN` evita que cualquiera en internet use tu backend (y
  tu cuenta de OpenAI/Anthropic) sin permiso. Generá uno largo y
  random, ej: `openssl rand -hex 32`.
- El firmware usa `setInsecure()` en TLS por simplicidad (cifra pero
  no valida el certificado). Para más seguridad, fijá el CA cert de
  Let's Encrypt en el firmware con `WiFiClientSecure::setCACert()`.
- Nunca commitees `.env` ni `Secrets.h` — ya están en `.gitignore`.
