#pragma once

#include <Arduino.h>

enum class Button : uint8_t {
    NONE  = 0,
    UP,
    DOWN,
    LEFT,
    RIGHT,
    OK,
};

class Input {
public:
    void begin();
    // Devuelve el botón que se acaba de pulsar (transición LOW), o NONE.
    Button poll();
private:
    static constexpr uint8_t DEBOUNCE_MS = 30;
    uint8_t lastState[5] = {1, 1, 1, 1, 1};
    uint32_t lastChange[5] = {0, 0, 0, 0, 0};
    bool readPin(uint8_t pin) const;
};
