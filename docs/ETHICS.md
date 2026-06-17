# Uso ético y legal

Este proyecto es **educativo**. Hardware y firmware multitool tipo
Flipper son herramientas de **doble uso** — pueden investigar y
proteger, o causar daño y violar la ley. Antes de usar cualquier
módulo, lee esto.

## Asistente de voz con IA

El asistente de voz (ver [`VOICE_ASSISTANT.md`](VOICE_ASSISTANT.md))
solo puede disparar un set fijo de acciones seguras y pasivas
(`wifi_scan`, `wifi_deauth_detector`, `ble_scan`, `ir_tvbgone`,
`about`). Las funciones ofensivas no están en esa lista, así que ni
pidiéndolo por voz se pueden activar. Si pedís algo fuera de ese
alcance, la IA responde que no y no ejecuta nada.

## Reglas

1. **Solo opera en hardware/redes propias o con autorización escrita.**
   Un permiso verbal no es suficiente si las cosas se complican.
2. **Las funciones ofensivas (evil twin, BLE spam, RFID clone) están
   como STUB intencionalmente.** Implementarlas y usarlas contra
   terceros sin autorización es delito en la mayoría de países.
3. **SubGHz (433/868/915 MHz) está regulado.** Transmitir fuera de la
   banda ISM permitida en tu país o por encima de la potencia legal
   puede acarrear sanciones administrativas.
4. **Infrarrojos:** apagar una TV ajena en público no es "una broma" —
   es interferencia con propiedad ajena.
5. **WiFi scan / deauth detector / BLE scan** son **pasivos** y
   generalmente legales — escuchan, no emiten.

## Legislación de referencia (España/UE)

- **LO 10/1995 (Código Penal) art. 197**: descubrimiento y revelación
  de secretos — interceptar comunicaciones ajenas.
- **LO 10/1995 art. 264**: daños informáticos.
- **RGPD**: cualquier captura de datos personales (incluido un MAC o
  un SSID si se cruza con identificación) requiere base legal.
- **Ley General de Telecomunicaciones 11/2022**: uso del espectro
  radioeléctrico.

Si vives fuera de la UE, consulta tu marco local (en US: CFAA, FCC
Part 15 para RF; en LATAM hay variación por país).

## Buenas prácticas

- Para CTF / lab personal: usa una red separada (AP propio sin
  internet), o un Faraday cage para SubGHz.
- Para pentest profesional: necesitas un **scope written agreement**
  firmado antes de tocar nada.
- Si encuentras una vulnerabilidad en infraestructura ajena que NO te
  pertenece, repórtala (responsible disclosure), no la explotes.

## Si dudas, no lo hagas

Si tienes que preguntar "¿esto es legal?", la respuesta segura es
**no lo hagas hasta tener claridad legal**.
