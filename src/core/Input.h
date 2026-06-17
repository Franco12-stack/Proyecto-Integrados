#pragma once

#include <M5Cardputer.h>

enum class Button : uint8_t {
    NONE  = 0,
    UP,     // tecla ;
    DOWN,   // tecla .
    LEFT,   // tecla ,
    RIGHT,  // tecla /
    OK,     // Enter
    BACK,   // tecla `
    TALK,   // barra espaciadora (push-to-talk asistente de voz)
};

class Input {
public:
    void begin();
    // Llama a M5Cardputer.update() y devuelve la tecla relevante pulsada
    // en este ciclo (transicion), o NONE. Hace debounce con isChange().
    Button poll();
    // Para push-to-talk: true mientras la tecla se mantiene apretada.
    bool isTalkHeld();
};
