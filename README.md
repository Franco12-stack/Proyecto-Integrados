# ESP32 Multitool — Proyecto Integrados

Multitool tipo "Flipper Zero" basado en ESP32 DevKit. Pensado como
proyecto educativo de hardware/seguridad. **Solo para uso ético** —
ver [`docs/ETHICS.md`](docs/ETHICS.md).

## Funcionalidades

| Módulo  | Feature                  | Estado                     |
|---------|--------------------------|----------------------------|
| WiFi    | Scan de redes 2.4GHz     | ✅ Funcional               |
| WiFi    | Detector de deauth       | ✅ Funcional (defensivo)   |
| WiFi    | Captive portal demo      | 🟡 Demo educativa          |
| WiFi    | Evil twin                | ⛔ Stub (uso restringido)  |
| BLE     | Scan de dispositivos     | ✅ Funcional               |
| BLE     | BadBT / spam             | ⛔ Stub                    |
| IR      | Receive                  | ✅ Funcional               |
| IR      | TV-B-Gone                | 🟡 Base, falta tabla       |
| RFID    | Read UID (MIFARE)        | ✅ Funcional               |
| RFID    | Clone                    | ⛔ Stub                    |
| SubGHz  | CC1101                   | 🟡 Info + stub             |

## Hardware

- **MCU:** ESP32 DevKit V1 (38 pines)
- **Display:** ST7789 240×240 SPI
- **Input:** 5 botones (UP/DOWN/LEFT/RIGHT/OK)
- **RFID:** RC522 (HSPI)
- **NFC:** PN532 (I2C, opcional)
- **SubGHz:** CC1101 (HSPI, opcional)
- **IR:** LED IR + TSOP1838

Diagrama de conexionado en [`docs/HARDWARE.md`](docs/HARDWARE.md).

## Build

Requiere [PlatformIO](https://platformio.org/) (extensión de VSCode o CLI):

```bash
pio run                     # compila
pio run --target upload     # flasheo por USB
pio device monitor          # consola serie
```

## Estructura

```
src/
├── main.cpp              # menu loop
├── config/Pins.h         # pinout central
├── core/                 # Display, Input, Menu
└── modules/
    ├── wifi/             # scan, deauth detector, ...
    ├── ble/              # scan
    ├── ir/               # receive, TV-B-Gone
    ├── rfid/             # UID read
    └── subghz/           # CC1101 stub
```

## Activar/desactivar módulos

Edita `src/config/Pins.h`:

```cpp
#define FEATURE_WIFI    1
#define FEATURE_BLE     0   // desactivar
```

## Licencia y uso

Proyecto educativo. **No** lo uses para acceder a sistemas o redes que
no sean tuyas o para los que no tengas autorización escrita.
Ver [`docs/ETHICS.md`](docs/ETHICS.md).
