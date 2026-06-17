#pragma once

#include "../../core/Display.h"
#include "../../core/Input.h"

namespace voice_module {

// Inicializa el microfono. Llamar una vez en setup().
void begin();

// Push-to-talk: mientras se mantiene ESPACIO, graba audio.
// Al soltar, lo manda al backend (Whisper + Claude) y ejecuta
// la accion que la IA decida, dentro del set de acciones seguras
// permitidas (ver server/main.py).
void pushToTalk(Display& d, Input& in);

}  // namespace voice_module
