#pragma once

#include "../../core/Display.h"
#include "../../core/Input.h"

namespace ir_module {

// Receptor IR: muestra protocolo y codigo del mando que apuntes.
void receive(Display& d, Input& in);

// TV-B-Gone: barrido de codigos POWER de muchas marcas.
// STUB inicialmente - la base la dejo lista pero hay que llenar la tabla.
void tvBGone(Display& d, Input& in);

}  // namespace ir_module
