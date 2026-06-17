#include "Menu.h"

uint8_t Menu::run(const char* /*title*/, const char* const items[], uint8_t count) {
    uint8_t sel = 0;
    _d.drawMenu(items, count, sel);
    for (;;) {
        const Button b = _in.poll();
        switch (b) {
            case Button::UP:
                sel = (sel == 0) ? count - 1 : sel - 1;
                _d.drawMenu(items, count, sel);
                break;
            case Button::DOWN:
                sel = (sel + 1) % count;
                _d.drawMenu(items, count, sel);
                break;
            case Button::OK:
                return sel;
            default:
                break;
        }
        delay(10);
    }
}
