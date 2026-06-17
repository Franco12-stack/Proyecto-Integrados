#include <Arduino.h>

#include "config/Pins.h"
#include "core/Display.h"
#include "core/Input.h"
#include "core/Menu.h"

#if FEATURE_WIFI
#include "modules/wifi/WifiModule.h"
#endif
#if FEATURE_BLE
#include "modules/ble/BleModule.h"
#endif
#if FEATURE_IR
#include "modules/ir/IrModule.h"
#endif
#if FEATURE_RFID
#include "modules/rfid/RfidModule.h"
#endif
#if FEATURE_SUBGHZ
#include "modules/subghz/SubGhzModule.h"
#endif

static Display display;
static Input   input;
static Menu    menu(display, input);

// ---------- Submenus por categoria ----------

#if FEATURE_WIFI
static void wifiMenu() {
    const char* const items[] = {
        "Scan",
        "Deauth detector",
        "Captive demo",
        "Evil Twin (stub)",
        "<- Atras",
    };
    while (true) {
        const uint8_t sel = menu.run("WiFi", items, 5);
        switch (sel) {
            case 0: wifi_module::scan(display, input); break;
            case 1: wifi_module::deauthDetector(display, input); break;
            case 2: wifi_module::captivePortalDemo(display, input); break;
            case 3: wifi_module::evilTwinStub(display, input); break;
            case 4: return;
        }
    }
}
#endif

#if FEATURE_BLE
static void bleMenu() {
    const char* const items[] = { "Scan", "Spam (stub)", "<- Atras" };
    while (true) {
        const uint8_t sel = menu.run("BLE", items, 3);
        switch (sel) {
            case 0: ble_module::scan(display, input); break;
            case 1: ble_module::spamStub(display, input); break;
            case 2: return;
        }
    }
}
#endif

#if FEATURE_IR
static void irMenu() {
    const char* const items[] = { "Receive", "TV-B-Gone", "<- Atras" };
    while (true) {
        const uint8_t sel = menu.run("IR", items, 3);
        switch (sel) {
            case 0: ir_module::receive(display, input); break;
            case 1: ir_module::tvBGone(display, input); break;
            case 2: return;
        }
    }
}
#endif

#if FEATURE_RFID
static void rfidMenu() {
    const char* const items[] = { "Read UID", "Clone (stub)", "<- Atras" };
    while (true) {
        const uint8_t sel = menu.run("RFID", items, 3);
        switch (sel) {
            case 0: rfid_module::readUid(display, input); break;
            case 1: rfid_module::cloneStub(display, input); break;
            case 2: return;
        }
    }
}
#endif

// ---------- Menu principal ----------

static void mainMenu() {
    const char* const items[] = {
        "WiFi", "Bluetooth", "Infrarrojos", "RFID/NFC", "SubGHz", "Acerca",
    };
    const uint8_t sel = menu.run("MULTITOOL", items, 6);
    switch (sel) {
#if FEATURE_WIFI
        case 0: wifiMenu(); break;
#endif
#if FEATURE_BLE
        case 1: bleMenu(); break;
#endif
#if FEATURE_IR
        case 2: irMenu(); break;
#endif
#if FEATURE_RFID
        case 3: rfidMenu(); break;
#endif
#if FEATURE_SUBGHZ
        case 4: subghz_module::info(display, input); break;
#endif
        case 5: {
            display.clear();
            display.header("Acerca");
            display.log("ESP32 Multitool");
            display.log("Proyecto Integrados");
            display.log("v0.1.0");
            display.log("Uso etico unicamente.");
            display.log("OK para salir.");
            while (input.poll() != Button::OK) delay(10);
            break;
        }
        default: break;
    }
}

void setup() {
    Serial.begin(115200);
    delay(200);
    Serial.println("[Multitool] boot");
    display.begin();
    input.begin();

    display.clear();
    display.header("MULTITOOL");
    display.log("Iniciando...");
    display.log("Uso etico:");
    display.log("ver docs/ETHICS.md");
    delay(1500);
}

void loop() {
    mainMenu();
}
