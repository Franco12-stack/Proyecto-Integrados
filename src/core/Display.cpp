#include "Display.h"

void Display::begin() {
    auto& d = M5Cardputer.Display;
    d.setRotation(1);
    d.setTextSize(1);
    d.fillScreen(TFT_BLACK);
    d.setTextColor(TFT_WHITE, TFT_BLACK);
}

void Display::clear(uint32_t color) {
    M5Cardputer.Display.fillScreen(color);
    _logY = 30;
}

void Display::header(const char* title) {
    auto& d = M5Cardputer.Display;
    d.fillRect(0, 0, d.width(), 18, TFT_DARKGREEN);
    d.setTextColor(TFT_WHITE, TFT_DARKGREEN);
    d.setTextSize(1);
    d.setCursor(4, 4);
    d.print(title);
}

void Display::footer(const char* hint) {
    auto& d = M5Cardputer.Display;
    const int16_t y = d.height() - 14;
    d.fillRect(0, y, d.width(), 14, TFT_NAVY);
    d.setTextColor(TFT_WHITE, TFT_NAVY);
    d.setTextSize(1);
    d.setCursor(4, y + 2);
    d.print(hint);
}

void Display::drawMenu(const char* const items[], uint8_t count, uint8_t selected) {
    clear();
    header("MULTITOOL");
    auto& d = M5Cardputer.Display;
    d.setTextSize(1);
    for (uint8_t i = 0; i < count; ++i) {
        const int16_t y = 22 + i * 14;
        if (i == selected) {
            d.fillRect(0, y - 1, d.width(), 14, TFT_DARKGREEN);
            d.setTextColor(TFT_WHITE, TFT_DARKGREEN);
        } else {
            d.setTextColor(TFT_WHITE, TFT_BLACK);
        }
        d.setCursor(6, y);
        d.print(items[i]);
    }
    footer(", / mover  Enter=OK  `=Atras");
}

void Display::log(const char* line) {
    auto& d = M5Cardputer.Display;
    if (_logY > d.height() - 20) {
        clear();
        header("LOG");
        _logY = 22;
    }
    d.setTextSize(1);
    d.setTextColor(TFT_GREEN, TFT_BLACK);
    d.setCursor(4, _logY);
    d.print(line);
    _logY += 10;
}
