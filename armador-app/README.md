# Armador App — backend

App privada de Tienda Nube para el "Armá tu PC": muestra precios de la lista de Odoo y
cierra el pedido en Tienda Nube (queda pendiente de pago) para que la integración
Tienda Nube ↔ Odoo ya existente lo sincronice.

## 1. Crear la app en Tienda Nube Partners

1. Entrá a https://partners.tiendanube.com → Mis apps → Crear app.
2. Tipo: **App privada** (uso interno, no se publica en el store de apps).
3. Redirect URI: `https://TU-DOMINIO/auth/callback`
4. Alcances (scopes) necesarios:
   - `write_orders` (crear pedidos)
   - `read_products` (leer variant_id, stock, etc. del catálogo)
5. Guardá el `Client ID` y `Client Secret` → van en `.env`.
6. Instalá la app en la tienda integradosargentinos: te va a pedir autorizar y
   redirigir a `/auth/callback`, que guarda el token en la base local (SQLite).

## 2. Configurar variables de entorno

```bash
cp .env.example .env
# completar TN_CLIENT_ID, TN_CLIENT_SECRET, TN_APP_URL
# completar ODOO_PG_* con el usuario de solo lectura
# completar ODOO_PRICELIST_ID con el id de la lista de precios a usar
```

> El query en `src/services/odooPrices.js` asume el esquema estándar de Odoo
> (`product_pricelist_item` + `product_template.default_code` como SKU). Si la
> lista de precios usa otra tabla/lógica (por ejemplo reglas por categoría en vez
> de precio fijo por producto), hay que ajustar ese archivo — pasame el nombre
> real de la lista en Odoo y reviso el query.

## 3. Instalar y correr

```bash
npm install
npm start        # producción
npm run dev       # con auto-reload
```

Recomendado correrlo con `pm2` o como servicio systemd en el VPS, detrás de Nginx
con HTTPS (Tienda Nube exige que el redirect URI sea https).

## 4. Endpoints

- `GET /auth/callback` — usado por Tienda Nube en la instalación (OAuth).
- `GET /api/prices?skus=SKU1,SKU2&store_id=...` — precios de Odoo para esos SKUs.
- `POST /api/orders` — crea el pedido en Tienda Nube con precio custom por línea:
  ```json
  {
    "store_id": "123456",
    "customer": { "name": "...", "email": "..." },
    "items": [
      { "variant_id": 111, "quantity": 1, "price": 250000, "name": "Ryzen 5 5600" }
    ],
    "note": "Armado desde /arma-tu-pc/"
  }
  ```
  Responde `{ "checkoutUrl": "...", "orderId": ... }` — ese link es el que se le
  muestra al cliente para que complete datos, envío y quede pendiente de pago.

## Pendiente / a definir con el cliente

- Conectar el frontend del armador (`/arma-tu-pc/`) para que llame a `/api/prices`
  en vez de mostrar el precio de catálogo, y a `/api/orders` al finalizar.
- Confirmar el esquema real de `ODOO_PRICELIST_ID` en Postgres.
- Definir si el `customer` se pide dentro del armador o si Tienda Nube ya lo pide
  en su propio checkout (recomendado: dejar que Tienda Nube pida los datos en el
  checkout nativo, así no se duplica lógica).
