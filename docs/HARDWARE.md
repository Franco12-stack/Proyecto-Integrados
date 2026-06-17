# Hardware y conexionado

## Lista de materiales (BOM)

| Componente              | Función               | Precio aprox. | Esencial |
|-------------------------|-----------------------|---------------|----------|
| ESP32 DevKit V1 (38p)   | MCU                   | 5-8 €         | Sí       |
| Display ST7789 240x240  | UI                    | 6-10 €        | Sí       |
| 5x botones tactiles 6mm | Input                 | 1 €           | Sí       |
| 5x resistencias 10kΩ    | Pull-ups (3 de 5 btn) | <1 €          | Sí       |
| LED IR + TSOP1838       | Infrarrojos           | 1-2 €         | IR       |
| Modulo RC522            | RFID 13.56MHz         | 2-3 €         | RFID     |
| Modulo CC1101 (433MHz)  | SubGHz                | 3-5 €         | SubGHz   |
| PN532                   | NFC avanzado          | 5-8 €         | Opc.     |
| Bateria LiPo 1S + TP4056| Portabilidad          | 5 €           | Opc.     |
| Protoboard 830 puntos   | Prototipado           | 3 €           | Sí       |

## Asignación de pines (`src/config/Pins.h`)

### Display ST7789 (VSPI)
```
ESP32     ST7789
GPIO23 -> MOSI / SDA
GPIO18 -> SCK / SCL
GPIO 5 -> CS
GPIO 2 -> DC
GPIO 4 -> RST
GPIO15 -> BLK (backlight)
3V3    -> VCC
GND    -> GND
```

### Botones
| Botón | GPIO | Pull-up         |
|-------|------|-----------------|
| UP    | 32   | Interno         |
| DOWN  | 33   | Interno         |
| LEFT  | 35   | **Externo 10k** |
| RIGHT | 34   | **Externo 10k** |
| OK    | 36   | **Externo 10k** |

Conexión: pin GPIO ↔ botón ↔ GND. La pull-up va de GPIO a 3V3 (10kΩ).
GPIO 32/33 usan pull-up interno (`INPUT_PULLUP`).

### HSPI compartido (RC522 + CC1101)
```
GPIO14 -> SCK
GPIO12 -> MISO
GPIO13 -> MOSI
GPIO27 -> CS RC522
GPIO25 -> CS CC1101
GPIO26 -> GDO0 CC1101
```

### I2C (PN532)
```
GPIO21 -> SDA
GPIO22 -> SCL
```

### IR
```
GPIO17 -> LED IR (con transistor NPN + R 220Ω en serie)
GPIO16 -> Out del TSOP1838
```

## Notas de montaje

- **GPIO 6-11** están reservados para la flash SPI interna del ESP32:
  **no los uses jamás**.
- **GPIO 34-39** son input-only y NO tienen pull-up interno.
- Si compartes el bus HSPI entre RC522 y CC1101, asegúrate de que
  los CS están **siempre** en estado HIGH cuando no se usan.
- Para el LED IR conviene usar transistor de switch (2N2222 o BC547)
  con la base alimentada desde el GPIO; el GPIO solo no da corriente.

## Modificar el pinout

Todo está en `src/config/Pins.h` y en el bloque `build_flags` de
`platformio.ini` (este último para `TFT_eSPI`).
