# Asistente de voz con IA

## Cómo funciona

```
[Vos hablás]
     |  mantenés ESPACIO apretado en el Cardputer
     v
[Microfono I2S onboard] -- grava PCM 16kHz mono mientras mantenes la tecla
     |
     v
[ESP32-S3] -- arma un WAV en memoria (PSRAM) y lo manda por HTTPS
     |
     v
[Tu backend en un VPS] (server/main.py)
     |-- 1. Transcribe el audio con Whisper API (OpenAI)
     |-- 2. Le pasa el texto a Claude (Anthropic) con una lista FIJA
     |      de acciones permitidas
     v
[Claude elige UNA accion de la lista + una respuesta corta]
     |
     v
[Backend devuelve JSON] {"action": "wifi_scan", "reply": "Escaneando..."}
     |
     v
[ESP32-S3] muestra el "reply" en pantalla y ejecuta la accion
           correspondiente del menu (la misma funcion que se usa
           si la elegis a mano con el teclado)
```

## Por qué no hay reconocimiento 100% local

El ESP32-S3 no tiene potencia para correr un modelo de lenguaje, y la
transcripción de voz libre tampoco es viable en este chip con buena
precisión. Por eso el "cerebro" (Whisper + Claude) vive en un servidor
aparte. El microcontrolador solo grava audio, lo manda, y ejecuta la
respuesta — igual que si usaras el teclado.

## Por qué "Hey Flipper" no es un wake word real (todavía)

Las palabras de activación que escuchan todo el tiempo sin botón
("wake words") necesitan un modelo entrenado específico para esa
frase exacta. Espressif (el fabricante del chip) ofrece algunas
palabras de fábrica ya entrenadas (ej. "Hi ESP"), pero una frase
personalizada como "Hey Flipper" requiere pedirles un entrenamiento
custom (proceso de Espressif, no es solo código).

**Por eso esta versión usa push-to-talk** (mantener ESPACIO) — es
100% confiable y no depende de ese proceso externo. Si más adelante
querés el wake word:

1. Revisar [ESP-SR](https://github.com/espressif/esp-sr) (librería de
   reconocimiento de voz de Espressif).
2. Pedir el entrenamiento custom de wake word, o usar uno de los que
   ya vienen entrenados de fábrica.
3. Integrar ESP-SR al proyecto (requiere componentes de ESP-IDF, más
   complejo de mezclar con Arduino que el resto del firmware).

## Seguridad y límites del diseño

- **Claude solo puede elegir entre un set fijo de acciones seguras**
  (`wifi_scan`, `wifi_deauth_detector`, `ble_scan`, `ir_tvbgone`,
  `about`, `none`). Las funciones ofensivas (evil twin, BLE spam,
  clonado RFID) ni siquiera están en esa lista — es imposible que la
  IA las active por voz, sin importar lo que le pidas.
- Si le pedís algo fuera de ese alcance o algo no ético, Claude
  responde `none` con una explicación breve, no ejecuta nada.
- El audio se manda a tu propio servidor (no a un tercero
  desconocido), pero igual viaja por Whisper (OpenAI) y Claude
  (Anthropic) para procesarse — no es 100% privado/offline.
- Grabaciones limitadas a 8 segundos como máximo (configurable en
  `VoiceModule.cpp`, constante `MAX_SECONDS`).

## Configuración necesaria

1. `src/config/Secrets.h` (copiar de `Secrets.h.example`): WiFi +
   URL del backend + token compartido.
2. `server/.env` (copiar de `.env.example`): claves de Anthropic y
   OpenAI + el mismo token compartido.
3. Desplegar `server/` en un VPS con HTTPS — ver
   [`server/README.md`](../server/README.md).
