#pragma once

#include <TFT_eSPI.h>

class Display {
public:
    void begin();
    void clear(uint16_t color = TFT_BLACK);
    void header(const char* title);
    void footer(const char* hint);
    void drawMenu(const char* const items[], uint8_t count, uint8_t selected);
    void log(const char* line);
    TFT_eSPI& tft() { return _tft; }
private:
    TFT_eSPI _tft;
    uint16_t _logY = 30;
};
