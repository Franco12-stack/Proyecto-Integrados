#pragma once

// ============================================================
// PIN CONFIGURATION - ESP32 DevKit V1 (38-pin)
// ============================================================
// Cambia los pines aquí si tu hardware es distinto.
// Ver docs/HARDWARE.md para el diagrama de conexionado.
// ============================================================

// ---------- DISPLAY ST7789 240x240 (VSPI) ----------
// Definidos en platformio.ini vía TFT_eSPI (TFT_MOSI=23, TFT_SCLK=18,
// TFT_CS=5, TFT_DC=2, TFT_RST=4, TFT_BL=15). No los redefinas aquí.

// ---------- BOTONES (5 direcciones + OK) ----------
// 32/33 soportan INPUT_PULLUP interno.
// 34/35/36 son input-only: requieren resistencia externa 10kΩ a 3V3.
#define PIN_BTN_UP      32
#define PIN_BTN_DOWN    33
#define PIN_BTN_LEFT    35   // input-only, pull-up externo
#define PIN_BTN_RIGHT   34   // input-only, pull-up externo
#define PIN_BTN_OK      36   // input-only, pull-up externo

// ---------- HSPI BUS (compartido: RC522 + CC1101) ----------
#define PIN_HSPI_SCK    14
#define PIN_HSPI_MISO   12
#define PIN_HSPI_MOSI   13

// ---------- RC522 RFID 13.56MHz (HSPI) ----------
#define PIN_RC522_CS    27
#define PIN_RC522_RST   -1   // opcional, -1 = no usar reset HW

// ---------- CC1101 SubGHz 433/868/915 MHz (HSPI) ----------
#define PIN_CC1101_CS   25
#define PIN_CC1101_GDO0 26
#define PIN_CC1101_GDO2 -1   // opcional

// ---------- PN532 NFC (I2C) ----------
#define PIN_I2C_SDA     21
#define PIN_I2C_SCL     22

// ---------- INFRARROJOS ----------
#define PIN_IR_TX       17
#define PIN_IR_RX       16

// ---------- LED de estado / Buzzer ----------
#define PIN_LED         19
#define PIN_BUZZER      -1   // opcional

// ============================================================
// FEATURE FLAGS - activa/desactiva módulos en build
// ============================================================
#define FEATURE_WIFI    1
#define FEATURE_BLE     1
#define FEATURE_IR      1
#define FEATURE_RFID    1
#define FEATURE_SUBGHZ  1
