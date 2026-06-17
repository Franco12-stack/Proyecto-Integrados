#include "WifiModule.h"

#include <WiFi.h>
#include <esp_wifi.h>

namespace wifi_module {

static void waitOk(Input& in) {
    while (in.poll() != Button::OK) delay(10);
}

void scan(Display& d, Input& in) {
    d.clear();
    d.header("WiFi Scan");
    d.footer("OK=salir");

    WiFi.mode(WIFI_STA);
    WiFi.disconnect();
    delay(100);

    d.log("Escaneando...");
    const int16_t n = WiFi.scanNetworks(false /*async*/, true /*hidden*/);
    d.clear();
    d.header("WiFi Scan");
    d.footer("OK=salir");

    if (n <= 0) {
        d.log("Sin redes encontradas");
    } else {
        char buf[48];
        snprintf(buf, sizeof(buf), "%d redes:", n);
        d.log(buf);
        const int16_t maxShow = (n > 16) ? 16 : n;
        for (int16_t i = 0; i < maxShow; ++i) {
            snprintf(buf, sizeof(buf), "%2d %ddBm %s",
                     WiFi.channel(i), WiFi.RSSI(i),
                     WiFi.SSID(i).c_str());
            buf[39] = '\0';
            d.log(buf);
        }
    }
    WiFi.scanDelete();
    waitOk(in);
}

// ------------- Deauth detector -------------
static volatile uint32_t deauth_count = 0;

static void IRAM_ATTR snifferCb(void* buf, wifi_promiscuous_pkt_type_t type) {
    if (type != WIFI_PKT_MGMT) return;
    const wifi_promiscuous_pkt_t* pkt = (wifi_promiscuous_pkt_t*)buf;
    const uint8_t* payload = pkt->payload;
    const uint8_t subtype = (payload[0] & 0xF0) >> 4;
    // 0xC = Deauthentication, 0xA = Disassociation
    if (subtype == 0xC || subtype == 0xA) deauth_count++;
}

void deauthDetector(Display& d, Input& in) {
    d.clear();
    d.header("Deauth Detect");
    d.footer("OK=salir");
    d.log("Modo monitor ON");
    d.log("Solo escucha.");

    deauth_count = 0;
    WiFi.disconnect();
    WiFi.mode(WIFI_MODE_NULL);
    esp_wifi_set_promiscuous(true);
    esp_wifi_set_promiscuous_rx_cb(&snifferCb);
    esp_wifi_set_channel(1, WIFI_SECOND_CHAN_NONE);

    uint32_t lastSwitch = millis();
    uint8_t ch = 1;
    uint32_t lastReport = 0;

    while (in.poll() != Button::OK) {
        const uint32_t now = millis();
        if (now - lastSwitch > 500) {
            ch = (ch % 13) + 1;
            esp_wifi_set_channel(ch, WIFI_SECOND_CHAN_NONE);
            lastSwitch = now;
        }
        if (now - lastReport > 1000) {
            char buf[40];
            snprintf(buf, sizeof(buf), "ch=%2d  deauth=%u",
                     ch, (unsigned)deauth_count);
            d.log(buf);
            lastReport = now;
        }
        delay(5);
    }

    esp_wifi_set_promiscuous(false);
}

void captivePortalDemo(Display& d, Input& in) {
    d.clear();
    d.header("Captive Demo");
    d.log("Demo educativa.");
    d.log("Levanta un AP local");
    d.log("SSID: TEST-PORTAL");
    d.log("NO captura datos.");
    d.log("OK para salir.");
    // TODO: levantar AP + DNSServer + WebServer que sirva pagina inocua.
    // Mantener sin captura de credenciales para no convertirlo en herramienta
    // de phishing. Si lo añades, requiere consentimiento explicito por sesion.
    waitOk(in);
}

void evilTwinStub(Display& d, Input& in) {
    d.clear();
    d.header("Evil Twin");
    d.log("STUB - sin implementar");
    d.log("Solo legal con");
    d.log("autorizacion escrita.");
    d.log("Ver docs/ETHICS.md");
    waitOk(in);
}

}  // namespace wifi_module
