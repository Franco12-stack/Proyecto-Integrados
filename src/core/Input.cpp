#include "Input.h"
#include "../config/Pins.h"

namespace {
const uint8_t PINS[5] = {
    PIN_BTN_UP, PIN_BTN_DOWN, PIN_BTN_LEFT, PIN_BTN_RIGHT, PIN_BTN_OK
};
const Button BTNS[5] = {
    Button::UP, Button::DOWN, Button::LEFT, Button::RIGHT, Button::OK
};
}  // namespace

void Input::begin() {
    pinMode(PIN_BTN_UP,    INPUT_PULLUP);
    pinMode(PIN_BTN_DOWN,  INPUT_PULLUP);
    // 34/35/36 son input-only: pull-up debe ser externo
    pinMode(PIN_BTN_LEFT,  INPUT);
    pinMode(PIN_BTN_RIGHT, INPUT);
    pinMode(PIN_BTN_OK,    INPUT);
}

bool Input::readPin(uint8_t pin) const {
    return digitalRead(pin);
}

Button Input::poll() {
    const uint32_t now = millis();
    for (uint8_t i = 0; i < 5; ++i) {
        const uint8_t cur = readPin(PINS[i]);
        if (cur != lastState[i] && (now - lastChange[i]) > DEBOUNCE_MS) {
            lastChange[i] = now;
            lastState[i]  = cur;
            if (cur == LOW) return BTNS[i];  // flanco de bajada = pulsación
        }
    }
    return Button::NONE;
}
