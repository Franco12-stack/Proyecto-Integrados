#pragma once

#include "../../core/Display.h"
#include "../../core/Input.h"

namespace ble_module {

// Escaneo pasivo de dispositivos BLE cercanos.
void scan(Display& d, Input& in);

// BadBT/BLE spam: STUB. Es disruptivo y puede ser ilegal en muchos paises.
// Solo implementar para investigacion en hardware propio.
void spamStub(Display& d, Input& in);

}  // namespace ble_module
