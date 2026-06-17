#include "BleModule.h"

#include <BLEDevice.h>
#include <BLEScan.h>
#include <BLEAdvertisedDevice.h>

namespace ble_module {

static void waitOk(Input& in) {
    while (in.poll() != Button::OK) delay(10);
}

void scan(Display& d, Input& in) {
    d.clear();
    d.header("BLE Scan");
    d.footer("OK=salir");
    d.log("Escaneando 5s...");

    BLEDevice::init("");
    BLEScan* s = BLEDevice::getScan();
    s->setActiveScan(true);
    s->setInterval(100);
    s->setWindow(99);
    BLEScanResults* results = s->start(5, false);

    d.clear();
    d.header("BLE Scan");
    d.footer("OK=salir");
    char buf[48];
    snprintf(buf, sizeof(buf), "%d dispositivos:", results->getCount());
    d.log(buf);

    const int max_show = (results->getCount() > 14) ? 14 : results->getCount();
    for (int i = 0; i < max_show; ++i) {
        BLEAdvertisedDevice dev = results->getDevice(i);
        const char* name = dev.haveName() ? dev.getName().c_str() : "(sin nombre)";
        snprintf(buf, sizeof(buf), "%d %s",
                 dev.getRSSI(), name);
        buf[39] = '\0';
        d.log(buf);
    }
    s->clearResults();
    waitOk(in);
}

void spamStub(Display& d, Input& in) {
    d.clear();
    d.header("BLE Spam");
    d.log("STUB - no impl.");
    d.log("Disruptivo y posible-");
    d.log("mente ilegal. Solo");
    d.log("para investigacion");
    d.log("en HW propio.");
    waitOk(in);
}

}  // namespace ble_module
