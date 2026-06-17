#pragma once

// ============================================================
// PIN CONFIGURATION - M5Stack Cardputer (ESP32-S3FN8)
// ============================================================
// Estos pines son fijos de fábrica (no se pueden cambiar, son
// los que M5Stack soldó en la placa). Display y teclado los
// maneja la libreria oficial M5Cardputer/M5GFX, no se tocan
// directamente.
// ============================================================

// ---------- DISPLAY (manejado por M5GFX, solo referencia) ----------
// ST7789V2 240x135 SPI: BL=38 RST=33 RS/DC=34 MOSI=35 SCK=36 CS=37

// ---------- TECLADO (manejado por M5Cardputer::Keyboard) ----------
// Matriz 56 teclas. Convencion de navegacion usada en este proyecto
// (igual a la de Bruce y otros launchers de Cardputer):
//   ;  = UP     .  = DOWN    ,  = LEFT    /  = RIGHT
//   Enter = OK            Esc (`) = BACK

// ---------- MICROFONO (I2S, SPM1423) ----------
#define PIN_MIC_BCK     41
#define PIN_MIC_WS      43
#define PIN_MIC_DATA    46

// ---------- ALTAVOZ (I2S, comparte BCK/WS con el mic) ----------
#define PIN_SPK_BCK     41
#define PIN_SPK_WS      43
#define PIN_SPK_DATA    42

// ---------- INFRARROJOS ----------
// Solo TRANSMISOR de fabrica. No hay receptor IR onboard:
// para "aprender" codigos de un control remoto hace falta
// un receptor TSOP1838 externo cableado a un GPIO libre del
// puerto de expansion (HY2.0-4P / EXT2.54-14P).
#define PIN_IR_TX       44
#define PIN_IR_RX       -1   // -1 = no disponible sin HW externo

// ---------- PUERTO DE EXPANSION (Grove HY2.0-4P / EXT2.54-14P) ----------
// El puerto Grove de 4 pines trae solo 2 GPIOs libres (G1, G2) + 5V/GND:
// alcanza para I2C (PN532) pero NO para SPI (RC522/CC1101 necesitan
// 4 lineas: SCK/MISO/MOSI/CS). Para SPI hace falta usar el header
// EXT2.54-14P de abajo de la placa.
//
// IMPORTANTE: estos valores son PLACEHOLDERS. Verificá el pinout fisico
// de tu unidad (puede variar segun la revision de hardware) antes de
// cablear nada, y ajustalos a los GPIOs que realmente uses.
#define PIN_EXT_SCK     1
#define PIN_EXT_MISO    2
#define PIN_EXT_MOSI    3   // TODO: confirmar GPIO libre real en tu EXT header
#define PIN_EXT_I2C_SDA 1
#define PIN_EXT_I2C_SCL 2

// ---------- RC522 RFID 13.56MHz (SPI por puerto EXT) ----------
#define PIN_HSPI_SCK    PIN_EXT_SCK
#define PIN_HSPI_MISO   PIN_EXT_MISO
#define PIN_HSPI_MOSI   PIN_EXT_MOSI
#define PIN_RC522_CS    3   // TODO: ajustar a tu cableado
#define PIN_RC522_RST   -1  // -1 = no usar reset por HW

// ---------- CC1101 SubGHz 433/868/915 MHz (SPI por puerto EXT) ----------
#define PIN_CC1101_CS   4   // TODO: ajustar a tu cableado
#define PIN_CC1101_GDO0 5   // TODO: ajustar a tu cableado
#define PIN_CC1101_GDO2 -1

// ============================================================
// FEATURE FLAGS - activa/desactiva módulos en build
// ============================================================
#define FEATURE_WIFI    1
#define FEATURE_BLE     1
#define FEATURE_IR      1
#define FEATURE_RFID    0   // requiere RC522 externo en puerto EXT
#define FEATURE_SUBGHZ  0   // requiere CC1101 externo en puerto EXT
#define FEATURE_VOICE   1   // asistente de voz con IA (push-to-talk)
