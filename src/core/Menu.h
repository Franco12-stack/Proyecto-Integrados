#pragma once

#include "Display.h"
#include "Input.h"

class Menu {
public:
    Menu(Display& d, Input& in) : _d(d), _in(in) {}
    // Bloquea hasta que el usuario elija un item. Devuelve el índice.
    uint8_t run(const char* title, const char* const items[], uint8_t count);
private:
    Display& _d;
    Input&   _in;
};
