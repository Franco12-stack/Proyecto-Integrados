#pragma once

#include "../../core/Display.h"
#include "../../core/Input.h"

namespace rfid_module {

// Lee el UID de tarjetas MIFARE 13.56MHz con RC522.
void readUid(Display& d, Input& in);

// Clonado de tarjetas: STUB.
// Legal solo si la tarjeta es tuya o tienes autorizacion.
void cloneStub(Display& d, Input& in);

}  // namespace rfid_module
