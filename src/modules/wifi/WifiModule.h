#pragma once

#include "../../core/Display.h"
#include "../../core/Input.h"

namespace wifi_module {

// Escaneo pasivo de redes 2.4GHz. Defensivo, seguro.
void scan(Display& d, Input& in);

// Detector de tramas deauth (modo monitor). Defensivo: NO emite.
void deauthDetector(Display& d, Input& in);

// Portal cautivo educativo (DEMO local, sin captura real de credenciales).
// IMPORTANTE: Solo demo. No usar para suplantar redes reales.
void captivePortalDemo(Display& d, Input& in);

// Evil Twin: STUB. No implementado por defecto.
// Es legalmente sensible — solo úsalo con autorización escrita.
void evilTwinStub(Display& d, Input& in);

}  // namespace wifi_module
