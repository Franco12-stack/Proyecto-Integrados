# Armador App — backend

App a medida de Tienda Nube para el "Armá tu PC": muestra precios de la lista de Odoo
y genera un pedido preliminar (Draft Order) en Tienda Nube — el cliente termina la
compra en el checkout nativo (mismos medios de pago y analizador de fraude de
siempre) y queda pendiente de pago. La integración Tienda Nube ↔ Odoo ya existente
sincroniza el pedido apenas se confirma.

## 1. Token de la app (Aplicaciones a medida)

Se creó desde el admin de la tienda (Configuración → Aplicaciones a medida →
Crear), no requiere OAuth. Permisos tildados:

- **Productos**: Lectura
- **Pedidos**: Lectura y escritura
- **Pedidos manuales** (Draft Orders): Lectura y escritura

Al crearla te da un **Access Token** una sola vez — guardalo, no se puede volver a ver.

## 2. Configurar variables de entorno

```bash
cp .env.example .env
# completar ODOO_PG_* con el usuario de solo lectura
# completar ODOO_PRICELIST_ID con el id de la lista de precios a usar
```

> El query en `src/services/odooPrices.js` asume el esquema estándar de Odoo
> (`product_pricelist_item` + `product_template.default_code` como SKU). Si la
> lista de precios usa otra tabla/lógica, hay que ajustar ese archivo.

## 3. Instalar, cargar el token y correr

```bash
npm install
node scripts/set-token.js 6990490 EL_ACCESS_TOKEN_QUE_TE_DIO_TIENDA_NUBE
npm start        # producción
npm run dev       # con auto-reload
```

Recomendado correrlo con `pm2` o como servicio systemd en el VPS, detrás de Nginx
con HTTPS.

## 4. Endpoints

- `GET /api/prices?skus=SKU1,SKU2&store_id=6990490` — precios de Odoo para esos SKUs.
- `POST /api/orders` — crea el Draft Order en Tienda Nube:
  ```json
  {
    "store_id": "6990490",
    "customer": { "name": "Juan", "lastname": "Pérez", "email": "juan@mail.com", "phone": "3411234567" },
    "items": [
      { "variant_id": 111, "quantity": 1, "catalogPrice": 300000, "odooPrice": 250000 }
    ],
    "note": "Armado desde /arma-tu-pc/"
  }
  ```
  Responde `{ "checkoutUrl": "...", "draftOrderId": ... }`. Ese link se le muestra
  al cliente para completar envío/pago en el checkout nativo de Tienda Nube.

  **Importante**: la API de Draft Orders no acepta precio custom por línea, solo
  `variant_id`/`quantity`. Por eso el backend calcula la diferencia entre el precio
  de catálogo (`catalogPrice`) y el de Odoo (`odooPrice`) por cada ítem, y la manda
  como `discount` (monto fijo) a nivel de todo el pedido — así el total final
  coincide con el precio de Odoo.

## Pendiente / a definir con el cliente

- Conectar el frontend del armador (`/arma-tu-pc/`) para que llame a `/api/prices`
  (mostrando `odooPrice`) y a `/api/orders` al finalizar, mandando también el
  `catalogPrice` de cada producto (lo trae la API de Productos de Tienda Nube).
- Confirmar el esquema real de `ODOO_PRICELIST_ID` en Postgres.
- Definir dónde se piden nombre/apellido/email del cliente antes de crear el Draft
  Order (son obligatorios para crearlo) — puede ser un mini-form al final del
  armador, antes de mandarlo al checkout.
