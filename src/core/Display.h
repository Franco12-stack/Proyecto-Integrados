#pragma once

#include <M5Cardputer.h>
#include <M5GFX.h>

class Display {
public:
    void begin();
    void clear(uint32_t color = TFT_BLACK);
    void header(const char* title);
    void footer(const char* hint);
    void drawMenu(const char* const items[], uint8_t count, uint8_t selected);
    void log(const char* line);
    M5GFX& gfx() { return M5Cardputer.Display; }
private:
    uint16_t _logY = 30;
};
