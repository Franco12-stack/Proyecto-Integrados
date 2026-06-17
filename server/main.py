"""
Backend del asistente de voz del ESP32 Multitool.

Flujo: el dispositivo manda un WAV -> este servidor lo transcribe
(Whisper) -> le pasa el texto a Claude, que elige UNA accion dentro
de un set fijo y seguro -> se devuelve esa accion en JSON.

Por diseno, Claude solo puede elegir entre las acciones definidas en
ALLOWED_ACTIONS (todas defensivas/pasivas). Nunca puede activar
funciones ofensivas (evil twin, BLE spam, clonado RFID) porque esas
ni siquiera estan en la lista de opciones que se le ofrecen.
"""

import os

import anthropic
import requests
from dotenv import load_dotenv
from fastapi import FastAPI, Header, HTTPException, Request
from fastapi.responses import JSONResponse

load_dotenv()

ANTHROPIC_API_KEY = os.environ["ANTHROPIC_API_KEY"]
OPENAI_API_KEY = os.environ["OPENAI_API_KEY"]
DEVICE_TOKEN = os.environ["DEVICE_TOKEN"]
CLAUDE_MODEL = os.environ.get("CLAUDE_MODEL", "claude-sonnet-4-6")

MAX_BODY_BYTES = 5 * 1024 * 1024  # ~5MB, de sobra para 8s de audio 16kHz/16bit

ALLOWED_ACTIONS = [
    "wifi_scan",
    "wifi_deauth_detector",
    "ble_scan",
    "ir_tvbgone",
    "about",
    "none",
]

SYSTEM_PROMPT = """Sos el asistente de voz de un dispositivo ESP32 tipo \
"multitool" (similar a un Flipper Zero) usado con fines educativos.

El usuario te habla en espanol y vos elegis UNA accion de la lista \
permitida que mejor corresponda a lo que pidio, y escribis una \
respuesta corta (1 frase) en espanol para mostrarle en pantalla.

Acciones disponibles:
- wifi_scan: escanear redes WiFi cercanas (pasivo, solo escucha)
- wifi_deauth_detector: detectar ataques de deauth en el aire (pasivo)
- ble_scan: escanear dispositivos Bluetooth cercanos (pasivo)
- ir_tvbgone: enviar codigos de apagado por infrarrojos
- about: mostrar info del dispositivo
- none: si el pedido no corresponde a ninguna accion de la lista, o \
si pide algo ofensivo/ilegal (atacar redes ajenas, clonar tarjetas \
ajenas, suplantar redes, espiar a terceros, etc.)

Si el pedido es ambiguo o esta fuera de lo que el dispositivo puede \
hacer eticamente, elegi "none" y explicaselo brevemente en la \
respuesta, sin sermonear.
"""

app = FastAPI()


def transcribe(wav_bytes: bytes) -> str:
    resp = requests.post(
        "https://api.openai.com/v1/audio/transcriptions",
        headers={"Authorization": f"Bearer {OPENAI_API_KEY}"},
        files={"file": ("audio.wav", wav_bytes, "audio/wav")},
        data={"model": "whisper-1", "language": "es"},
        timeout=30,
    )
    resp.raise_for_status()
    return resp.json()["text"].strip()


def decide_action(transcript: str) -> dict:
    client = anthropic.Anthropic(api_key=ANTHROPIC_API_KEY)
    tools = [
        {
            "name": "execute_action",
            "description": "Ejecuta una accion en el dispositivo multitool.",
            "input_schema": {
                "type": "object",
                "properties": {
                    "action": {
                        "type": "string",
                        "enum": ALLOWED_ACTIONS,
                    },
                    "reply": {
                        "type": "string",
                        "description": "Respuesta corta en espanol para "
                        "mostrar en pantalla (maximo ~60 caracteres).",
                    },
                },
                "required": ["action", "reply"],
            },
        }
    ]
    message = client.messages.create(
        model=CLAUDE_MODEL,
        max_tokens=300,
        system=SYSTEM_PROMPT,
        tools=tools,
        tool_choice={"type": "tool", "name": "execute_action"},
        messages=[{"role": "user", "content": transcript}],
    )
    tool_use = next(b for b in message.content if b.type == "tool_use")
    action = tool_use.input.get("action", "none")
    reply = tool_use.input.get("reply", "")
    if action not in ALLOWED_ACTIONS:
        action = "none"
    return {"action": action, "reply": reply}


@app.post("/command")
async def command(request: Request, x_device_token: str = Header(default="")):
    if x_device_token != DEVICE_TOKEN:
        raise HTTPException(status_code=401, detail="token invalido")

    wav_bytes = await request.body()
    if len(wav_bytes) > MAX_BODY_BYTES:
        raise HTTPException(status_code=413, detail="audio demasiado grande")
    if len(wav_bytes) < 44:  # mas chico que un header WAV valido
        raise HTTPException(status_code=400, detail="audio invalido")

    try:
        transcript = transcribe(wav_bytes)
    except requests.RequestException:
        return JSONResponse(
            {"action": "none", "reply": "Error transcribiendo audio."},
            status_code=200,
        )

    if not transcript:
        return {"action": "none", "reply": "No te escuche bien."}

    try:
        result = decide_action(transcript)
    except Exception:
        return JSONResponse(
            {"action": "none", "reply": "Error consultando la IA."},
            status_code=200,
        )

    return result
