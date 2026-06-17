#include "Display.h"
#include "../config/Pins.h"

void Display::begin() {
    pinMode(PIN_LED, OUTPUT);
    digitalWrite(PIN_LED, LOW);
    _tft.init();
    _tft.setRotation(0);
    _tft.fillScreen(TFT_BLACK);
    _tft.setTextColor(TFT_WHITE, TFT_BLACK);
    _tft.setTextSize(2);
}

void Display::clear(uint16_t color) {
    _tft.fillScreen(color);
    _logY = 30;
}

void Display::header(const char* title) {
    _tft.fillRect(0, 0, 240, 20, TFT_DARKGREEN);
    _tft.setTextColor(TFT_WHITE, TFT_DARKGREEN);
    _tft.setTextSize(2);
    _tft.setCursor(4, 2);
    _tft.print(title);
}

void Display::footer(const char* hint) {
    _tft.fillRect(0, 220, 240, 20, TFT_NAVY);
    _tft.setTextColor(TFT_WHITE, TFT_NAVY);
    _tft.setTextSize(1);
    _tft.setCursor(4, 226);
    _tft.print(hint);
}

void Display::drawMenu(const char* const items[], uint8_t count, uint8_t selected) {
    clear();
    header("MULTITOOL");
    _tft.setTextSize(2);
    for (uint8_t i = 0; i < count; ++i) {
        const int16_t y = 30 + i * 22;
        if (i == selected) {
            _tft.fillRect(0, y - 2, 240, 22, TFT_DARKGREEN);
            _tft.setTextColor(TFT_WHITE, TFT_DARKGREEN);
        } else {
            _tft.setTextColor(TFT_WHITE, TFT_BLACK);
        }
        _tft.setCursor(8, y);
        _tft.print(items[i]);
    }
    footer("UP/DOWN  OK=Enter");
}

void Display::log(const char* line) {
    if (_logY > 200) {
        clear();
        header("LOG");
        _logY = 30;
    }
    _tft.setTextSize(1);
    _tft.setTextColor(TFT_GREEN, TFT_BLACK);
    _tft.setCursor(4, _logY);
    _tft.print(line);
    _logY += 10;
}
