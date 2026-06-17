# Hardware: M5Stack Cardputer

## Specs (de fábrica, todo ya armado)

| Componente | Detalle |
|---|---|
| SoC | ESP32-S3FN8, dual-core Xtensa LX7 @ 240MHz |
| Flash | 8 MB |
| Pantalla | ST7789V2 1.14", 240×135, IPS |
| Teclado | 56 teclas (4×14) |
| Micrófono | SPM1423 MEMS, I2S |
| Altavoz | amplificador NS4150B |
| IR | 1 emisor (NO tiene receptor de fábrica) |
| IMU | BM1270 (no se usa en este proyecto) |
| Batería | 1750 mAh con carga integrada |
| Expansión | conectores HY2.0-4P y EXT2.54-14P |

No hace falta soldar nada para WiFi, BLE, IR (emisor), pantalla,
teclado o batería — viene completo.

## Pines confirmados (fijos de fábrica)

No se pueden modificar — están soldados así en la placa. Documentados
en [`src/config/Pins.h`](../src/config/Pins.h).

| Función | GPIO |
|---|---|
| IR TX | 44 |
| Mic BCK / WS / DATA | 41 / 43 / 46 |
| Speaker BCK / WS / DATA | 41 / 43 / 42 |
| Display BL/RST/DC/MOSI/SCK/CS | 38/33/34/35/36/37 (manejado por M5GFX) |

## Lo que NO trae y cómo agregarlo

### Receptor IR (para "aprender" controles remotos)
Necesitás un **TSOP1838** externo conectado a un GPIO libre del
puerto de expansión (EXT2.54-14P). Una vez cableado, definí
`PIN_IR_RX` en `Pins.h` con ese GPIO.

### RFID/NFC (RC522 o PN532)
Se conecta por el puerto de expansión: RC522 por SPI, PN532 por I2C.
Activá `FEATURE_RFID` en `Pins.h` y ajustá los pines en
`PIN_EXT_1`/`PIN_EXT_2` según cómo lo cables.

### SubGHz (CC1101)
También por el puerto de expansión, SPI. Activá `FEATURE_SUBGHZ`.

## Librería de software

El proyecto usa la librería oficial `M5Cardputer` (que internamente
usa `M5Unified` + `M5GFX`), no `TFT_eSPI` ni GPIO crudo para
botones — la matriz de teclado y el driver de pantalla ya vienen
resueltos por M5Stack, no hace falta reinventarlos.

## Convención de teclas para navegar el menú

| Tecla | Función |
|---|---|
| `;` | Arriba |
| `.` | Abajo |
| `,` | Izquierda |
| `/` | Derecha |
| Enter | OK / Confirmar |
| `` ` `` | Atrás |
| Espacio (mantener) | Hablar con el asistente de IA |

Es la misma convención que usa el firmware Bruce, así que si después
probás otro firmware en el mismo dispositivo, ya conocés los controles.
