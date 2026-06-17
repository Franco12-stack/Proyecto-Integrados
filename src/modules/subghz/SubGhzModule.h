#pragma once

#include "../../core/Display.h"
#include "../../core/Input.h"

namespace subghz_module {

// Stub: la integracion con CC1101 requiere libreria especifica + antena legal.
// Las frecuencias 433/868/915MHz tienen regulacion estricta por pais.
void info(Display& d, Input& in);

}  // namespace subghz_module
