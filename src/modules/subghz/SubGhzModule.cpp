#include "SubGhzModule.h"

namespace subghz_module {

void info(Display& d, Input& in) {
    d.clear();
    d.header("SubGHz");
    d.log("CC1101 - STUB");
    d.log("Frecuencias 433/868");
    d.log("/915 MHz reguladas");
    d.log("por pais. Solo TX en");
    d.log("bandas permitidas.");
    d.log("OK para salir.");
    while (in.poll() != Button::OK) delay(10);
}

}  // namespace subghz_module
