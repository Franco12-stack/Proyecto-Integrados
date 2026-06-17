#include "VoiceModule.h"
#include "../../config/Pins.h"
#include "../wifi/WifiModule.h"
#include "../ble/BleModule.h"
#include "../ir/IrModule.h"

#include <M5Cardputer.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <esp_heap_caps.h>
#include <cstring>

#if __has_include("../../config/Secrets.h")
#include "../../config/Secrets.h"
#else
#warning "Falta src/config/Secrets.h - copia Secrets.h.example y completa tus credenciales"
#define WIFI_SSID     ""
#define WIFI_PASSWORD ""
#define BACKEND_URL   ""
#define DEVICE_TOKEN  ""
#endif

namespace voice_module {

namespace {

constexpr uint32_t SAMPLE_RATE = 16000;
constexpr uint32_t MAX_SECONDS = 8;
constexpr size_t MAX_SAMPLES = SAMPLE_RATE * MAX_SECONDS;

int16_t* g_audioBuf = nullptr;

bool ensureWifi(Display& d) {
    if (WiFi.status() == WL_CONNECTED) return true;
    d.log("Conectando WiFi...");
    WiFi.mode(WIFI_STA);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    const uint32_t start = millis();
    while (WiFi.status() != WL_CONNECTED) {
        if (millis() - start > 10000) {
            d.log("WiFi: timeout");
            return false;
        }
        delay(200);
    }
    d.log("WiFi OK");
    return true;
}

// Construye un WAV PCM16 mono y devuelve el tamano total escrito.
size_t buildWav(uint8_t* out, const int16_t* samples, size_t numSamples) {
    const uint32_t byteRate  = SAMPLE_RATE * 2;
    const uint32_t dataSize  = numSamples * 2;
    const uint32_t chunkSize = 36 + dataSize;

    size_t p = 0;
    auto put = [&](const void* src, size_t n) {
        memcpy(out + p, src, n);
        p += n;
    };
    uint16_t u16;
    uint32_t u32;

    put("RIFF", 4);
    put(&chunkSize, 4);
    put("WAVE", 4);
    put("fmt ", 4);
    u32 = 16; put(&u32, 4);
    u16 = 1;  put(&u16, 2);   // PCM
    u16 = 1;  put(&u16, 2);   // mono
    u32 = SAMPLE_RATE; put(&u32, 4);
    put(&byteRate, 4);
    u16 = 2;  put(&u16, 2);   // block align
    u16 = 16; put(&u16, 2);  // bits/sample
    put("data", 4);
    put(&dataSize, 4);
    put(samples, dataSize);
    return p;
}

const char* jsonStr(JsonDocument& doc, const char* key, const char* def) {
    JsonVariant v = doc[key];
    if (v.isNull()) return def;
    return v.as<const char*>();
}

}  // namespace

void begin() {
    if (!g_audioBuf) {
        g_audioBuf = static_cast<int16_t*>(
            heap_caps_malloc(MAX_SAMPLES * sizeof(int16_t), MALLOC_CAP_SPIRAM));
    }
}

void pushToTalk(Display& d, Input& in) {
    d.clear();
    d.header("Asistente IA");

    if (!g_audioBuf) {
        d.log("Error: sin PSRAM.");
        return;
    }
    if (!ensureWifi(d)) return;

    d.log("Mantene ESPACIO y habla");
    while (!in.isTalkHeld()) {
        in.poll();
        delay(10);
    }

    d.log("Escuchando...");
    M5Cardputer.Mic.begin();
    size_t recorded = 0;
    constexpr uint32_t CHUNK = 256;
    while (in.isTalkHeld() && recorded + CHUNK < MAX_SAMPLES) {
        M5Cardputer.Mic.record(g_audioBuf + recorded, CHUNK, SAMPLE_RATE);
        recorded += CHUNK;
    }
    M5Cardputer.Mic.end();

    char buf[48];
    snprintf(buf, sizeof(buf), "Grabado: %.1fs", (float)recorded / SAMPLE_RATE);
    d.log(buf);

    if (recorded < SAMPLE_RATE / 2) {
        d.log("Muy corto, cancelado.");
        return;
    }

    const size_t wavSize = 44 + recorded * sizeof(int16_t);
    uint8_t* wav = static_cast<uint8_t*>(
        heap_caps_malloc(wavSize, MALLOC_CAP_SPIRAM));
    if (!wav) {
        d.log("Sin memoria para WAV.");
        return;
    }
    buildWav(wav, g_audioBuf, recorded);

    d.log("Enviando al servidor...");
    WiFiClientSecure client;
    // Validacion de certificado simplificada para uso personal/hobby.
    // Ver docs/VOICE_ASSISTANT.md para usar setCACert() en produccion.
    client.setInsecure();

    HTTPClient http;
    http.begin(client, BACKEND_URL);
    http.addHeader("Content-Type", "audio/wav");
    http.addHeader("X-Device-Token", DEVICE_TOKEN);
    http.setTimeout(20000);

    const int code = http.POST(wav, wavSize);
    heap_caps_free(wav);

    if (code != 200) {
        snprintf(buf, sizeof(buf), "Error servidor: %d", code);
        d.log(buf);
        http.end();
        return;
    }

    const String body = http.getString();
    http.end();

    JsonDocument doc;
    if (deserializeJson(doc, body) != DeserializationError::Ok) {
        d.log("Respuesta invalida.");
        return;
    }

    const char* action = jsonStr(doc, "action", "none");
    const char* reply  = jsonStr(doc, "reply", "");

    d.log(reply);
    delay(1200);

    if (strcmp(action, "wifi_scan") == 0) {
        wifi_module::scan(d, in);
    } else if (strcmp(action, "wifi_deauth_detector") == 0) {
        wifi_module::deauthDetector(d, in);
    } else if (strcmp(action, "ble_scan") == 0) {
        ble_module::scan(d, in);
    } else if (strcmp(action, "ir_tvbgone") == 0) {
        ir_module::tvBGone(d, in);
    }
    // "about" y "none" no disparan ninguna accion adicional: solo
    // muestran el "reply" de texto que ya se mostro arriba.
}

}  // namespace voice_module
