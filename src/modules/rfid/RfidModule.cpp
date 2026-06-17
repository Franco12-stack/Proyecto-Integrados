#include "RfidModule.h"
#include "../../config/Pins.h"

#include <SPI.h>
#include <MFRC522.h>

namespace rfid_module {

static void waitOk(Input& in) {
    while (in.poll() != Button::OK) delay(10);
}

static SPIClass hspi(HSPI);

void readUid(Display& d, Input& in) {
    d.clear();
    d.header("RFID Read");
    d.footer("OK=salir");
    d.log("Acerca tarjeta...");

    hspi.begin(PIN_HSPI_SCK, PIN_HSPI_MISO, PIN_HSPI_MOSI, PIN_RC522_CS);
    MFRC522 reader(PIN_RC522_CS, PIN_RC522_RST);
    reader.PCD_Init();

    char buf[48];
    while (in.poll() != Button::OK) {
        if (reader.PICC_IsNewCardPresent() && reader.PICC_ReadCardSerial()) {
            char* p = buf;
            p += snprintf(p, sizeof(buf), "UID:");
            for (byte i = 0; i < reader.uid.size; ++i) {
                p += snprintf(p, buf + sizeof(buf) - p,
                              " %02X", reader.uid.uidByte[i]);
            }
            d.log(buf);
            const MFRC522::PICC_Type type =
                reader.PICC_GetType(reader.uid.sak);
            snprintf(buf, sizeof(buf), "Tipo:%s",
                     reader.PICC_GetTypeName(type));
            buf[39] = '\0';
            d.log(buf);
            reader.PICC_HaltA();
            delay(800);  // anti-rebote de lectura
        }
        delay(20);
    }
}

void cloneStub(Display& d, Input& in) {
    d.clear();
    d.header("RFID Clone");
    d.log("STUB - no impl.");
    d.log("Solo legal con");
    d.log("tarjetas propias.");
    waitOk(in);
}

}  // namespace rfid_module
