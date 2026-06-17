#include "IrModule.h"
#include "../../config/Pins.h"

#include <IRrecv.h>
#include <IRsend.h>
#include <IRutils.h>

namespace ir_module {

static void waitOk(Input& in) {
    while (in.poll() != Button::OK) delay(10);
}

void receive(Display& d, Input& in) {
    d.clear();
    d.header("IR Receive");
    d.footer("OK=salir");
    d.log("Apunta el mando");
    d.log("al receptor IR.");

    IRrecv recv(PIN_IR_RX, 1024 /*buffer*/, 50 /*timeout ms*/, true);
    recv.enableIRIn();
    decode_results res;
    char buf[48];

    while (in.poll() != Button::OK) {
        if (recv.decode(&res)) {
            snprintf(buf, sizeof(buf), "%s 0x%llX",
                     typeToString(res.decode_type).c_str(),
                     (unsigned long long)res.value);
            buf[39] = '\0';
            d.log(buf);
            recv.resume();
        }
        delay(20);
    }
    recv.disableIRIn();
}

void tvBGone(Display& d, Input& in) {
    d.clear();
    d.header("TV-B-Gone");
    d.log("Enviando POWER...");
    IRsend sender(PIN_IR_TX);
    sender.begin();

    // Codigos POWER mas comunes (Sony, Samsung, LG, Panasonic, Philips).
    // Tabla minima para validar HW. Amplia con codigos reales si lo necesitas.
    const uint32_t SONY_PWR    = 0xA90;
    const uint32_t SAMSUNG_PWR = 0xE0E040BF;
    const uint32_t LG_PWR      = 0x20DF10EF;
    const uint32_t NEC_PWR     = 0x00FFA25D;

    sender.sendSony(SONY_PWR, 12);          delay(40);
    sender.sendSamsung(SAMSUNG_PWR, 32);    delay(40);
    sender.sendLG(LG_PWR, 32);              delay(40);
    sender.sendNEC(NEC_PWR, 32);            delay(40);

    d.log("Hecho.");
    d.log("OK para salir.");
    waitOk(in);
}

}  // namespace ir_module
