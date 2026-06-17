#include "Input.h"

void Input::begin() {
    // M5Cardputer.begin() ya inicializa el teclado en main.cpp.
}

Button Input::poll() {
    M5Cardputer.update();
    if (!M5Cardputer.Keyboard.isChange()) return Button::NONE;
    if (!M5Cardputer.Keyboard.isPressed()) return Button::NONE;

    if (M5Cardputer.Keyboard.isKeyPressed(';')) return Button::UP;
    if (M5Cardputer.Keyboard.isKeyPressed('.')) return Button::DOWN;
    if (M5Cardputer.Keyboard.isKeyPressed(',')) return Button::LEFT;
    if (M5Cardputer.Keyboard.isKeyPressed('/')) return Button::RIGHT;
    if (M5Cardputer.Keyboard.isKeyPressed('`')) return Button::BACK;

    const auto status = M5Cardputer.Keyboard.keysState();
    if (status.enter) return Button::OK;
    if (M5Cardputer.Keyboard.isKeyPressed(' ')) return Button::TALK;

    return Button::NONE;
}

bool Input::isTalkHeld() {
    M5Cardputer.update();
    return M5Cardputer.Keyboard.isKeyPressed(' ');
}
