# ESP32 Multitool — Proyecto Integrados

Multitool tipo "Flipper Zero" con asistente de voz por IA, basado en
**M5Stack Cardputer** (ESP32-S3). Proyecto educativo de
hardware/seguridad. **Solo para uso ético** — ver
[`docs/ETHICS.md`](docs/ETHICS.md).

## Funcionalidades

| Módulo  | Feature                  | Estado                     |
|---------|--------------------------|----------------------------|
| WiFi    | Scan de redes 2.4GHz     | ✅ Funcional               |
| WiFi    | Detector de deauth       | ✅ Funcional (defensivo)   |
| WiFi    | Captive portal demo      | 🟡 Demo educativa          |
| WiFi    | Evil twin                | ⛔ Stub (uso restringido)  |
| BLE     | Scan de dispositivos     | ✅ Funcional               |
| BLE     | BadBT / spam             | ⛔ Stub                    |
| IR      | TV-B-Gone (emisor)       | ✅ Funcional               |
| IR      | Receive                  | ⚠️ Requiere TSOP externo   |
| RFID    | Read UID / Clone         | ⚠️ Requiere RC522 externo  |
| SubGHz  | CC1101                   | ⚠️ Requiere módulo externo |
| **Voz** | **Asistente con IA**     | ✅ **Funcional**           |

## Asistente de voz

Mantené apretada la barra espaciadora, hablá ("escaneá las redes
wifi"), soltá — el dispositivo manda el audio a un backend propio
que transcribe con Whisper y usa **Claude** para entender el pedido
y ejecutar la acción. Solo puede disparar acciones seguras y
predefinidas; nunca funciones ofensivas. Ver
[`docs/VOICE_ASSISTANT.md`](docs/VOICE_ASSISTANT.md).

## Hardware

**M5Stack Cardputer** (ESP32-S3FN8) — viene armado de fábrica con
pantalla, teclado de 56 teclas, emisor IR, micrófono, altavoz y
batería. No hace falta soldar nada para las funciones básicas.

Detalle de pines y cómo sumar RFID/SubGHz/receptor IR por el puerto
de expansión en [`docs/HARDWARE.md`](docs/HARDWARE.md).

## Build del firmware

Requiere [PlatformIO](https://platformio.org/) (extensión de VSCode o CLI):

```bash
cp src/config/Secrets.h.example src/config/Secrets.h
# completar WiFi + URL del backend + token en Secrets.h

pio run                     # compila
pio run --target upload     # flasheo por USB
pio device monitor          # consola serie
```

## Backend del asistente de voz

Necesario solo si vas a usar el asistente de IA. Ver
[`server/README.md`](server/README.md) para instalarlo local o en
un VPS.

## Estructura

```
src/
├── main.cpp              # menu loop
├── config/
│   ├── Pins.h             # pinout central + feature flags
│   └── Secrets.h.example  # plantilla de credenciales
├── core/                  # Display, Input, Menu
└── modules/
    ├── wifi/              # scan, deauth detector, ...
    ├── ble/                # scan
    ├── ir/                 # TV-B-Gone (emisor)
    ├── rfid/               # UID read (requiere RC522 externo)
    ├── subghz/             # CC1101 (requiere módulo externo)
    └── voice/              # asistente de voz con IA
server/
├── main.py                # backend FastAPI: Whisper + Claude
└── README.md               # como desplegarlo
docs/
├── HARDWARE.md
├── VOICE_ASSISTANT.md
└── ETHICS.md
```

## Activar/desactivar módulos

Edita `src/config/Pins.h`:

```cpp
#define FEATURE_WIFI    1
#define FEATURE_VOICE   0   // desactivar el asistente de IA
```

## Licencia y uso

Proyecto educativo. **No** lo uses para acceder a sistemas o redes que
no sean tuyas o para los que no tengas autorización escrita.
Ver [`docs/ETHICS.md`](docs/ETHICS.md).
