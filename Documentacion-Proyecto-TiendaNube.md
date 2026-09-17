# Proyecto Tienda Nube — Integrados Argentinos

> Documentación completa del rediseño de la home y del proyecto "Armador de PC 2.0".
> Repo: `Franco12-stack/Proyecto-Integrados`, rama `claude/tienda-nube-t18so6`.

---

## 1. Resumen general

Este proyecto tiene dos partes bien separadas:

1. **Rediseño de la home** (tema Brasilia, editado con archivos `.tpl` subidos por FTP).
2. **"Armador de PC 2.0"** — un backend propio que conecta el armador (`/arma-tu-pc/`)
   con precios especiales de Odoo y crea pedidos reales en Tienda Nube.

---

## 2. Rediseño de la Home

### 2.1 Cómo se sube el tema

- **Acceso**: FTP a `ftp.tiendanube.com`, usuario `integradosargentinos` (la contraseña
  puede vencer — si FileZilla da `530 Authentication failed`, hay que resetearla desde
  el admin de Tienda Nube).
- **Cliente usado**: FileZilla.
- Los archivos del tema viven en carpetas como:
  - `templates/` → páginas completas (`home.tpl`, `page.tpl`, `product.tpl`, etc.)
  - `snipplets/` → componentes reutilizables, organizados en subcarpetas (`home/`, `cart/`, etc.)
  - `static/` → imágenes, CSS y JS sueltos
- **Importante**: subir un archivo `.tpl` roto (o subir `home.tpl` antes que los
  snippets que incluye) puede tirar un error 500 en todo el sitio. Siempre subir
  primero los snippets nuevos, después el archivo que los incluye.
- Después de subir, probar en **ventana de incógnito** — el sitio y el navegador
  cachean agresivamente.

### 2.2 Estructura de la Home (`templates/home.tpl`)

El home renderiza, en este orden:

1. Slider principal (nativo de Tienda Nube)
2. **Ofertas con temporizador** (bloque nativo de TN) — solo si está en "Mostrar"
   en el panel de Diseño (se verifica recorriendo `home_order_position_1..18`)
3. Bloques custom, en este orden fijo:
   - `snipplets/home/home-mas-vendidos.tpl`
   - `snipplets/home/home-armador-pc.tpl`
   - `snipplets/home/home-categorias-grid.tpl`
4. El resto de las secciones configurables desde el panel de Diseño (loop normal),
   excluyendo `slider`, `products` y `timer_offers` para no duplicarlas.

### 2.3 Bloque "Más Vendidos" (`snipplets/home/home-mas-vendidos.tpl`)

- Carrusel Swiper (ya cargado por el tema) con productos de `sections.primary.products`.
- **Categorías por producto**: se detectan 100% en Twig, leyendo `product.name` con
  strings (`'placa de video' in _n`, etc.) — nunca usar `{% for %}` anidados para esto,
  las variables `{% set %}` de un loop interno no se propagan afuera (lección aprendida
  a las malas).
- **Tabs dinámicos**: el JS lee los `data-cat` de cada slide y genera un botón de tab
  solo para las categorías que realmente tienen productos (no se muestran categorías vacías).

### 2.4 Banner "Armá tu PC" (`snipplets/home/home-armador-pc.tpl`)

- Banner alto con foto de fondo (`banner-armador-pc.jpg` en `/static/`), enlaza a `/arma-tu-pc/`.
- El overlay es un degradado **negro** sutil (NO azul — se probó con azul fuerte y quedaba
  mal, se corrigió a `rgba(0,0,0,...)` con menos opacidad).
- Usa `<span>` en vez de `<button>` para el CTA (un `<button>` dentro de un `<a>` es HTML inválido
  y rompe el click). La imagen y el overlay llevan `pointer-events: none` para no tapar el click.

### 2.5 Grilla de categorías (`snipplets/home/home-categorias-grid.tpl`)

- Card grande fija ("PC de Escritorio") + grilla de categorías chicas, paginada en 2 páginas.
- **La card grande NO pagina** — está fuera del sistema de páginas, y toma la altura
  exacta de la grilla de chicas automáticamente (usando imágenes con `position:absolute`
  para evitar un problema de "altura circular" en CSS Grid).
- Las cards chicas usan `aspect-ratio: 1/1` en desktop (cuadradas) y `4/3` en mobile.
- **Orden actual** (2 páginas de 8):
  - Página 1: Fuentes, Mothers, Memorias RAM, Procesadores, Almacenamiento, Placas de
    Video, Refrigeración, Monitores
  - Página 2: Gabinetes, Periféricos, Conectividad, Sillas, Notebooks, Impresoras,
    Tablets, Simuladores
- Fotos nuevas van a `/static/` con nombre `cat-<categoria>.jpg` (ej: `cat-tablets.jpg`).
  Si falta la foto, se ve un ícono SVG de placeholder automáticamente.

### 2.6 Bugs de CSS que costó encontrar (para no repetirlos)

- **Cascada por orden, no por especificidad**: si dos reglas CSS tienen la misma
  especificidad, gana la que está escrita **después** en el archivo, sin importar el
  orden de las clases en el HTML. Pasó con `.catg-no-featured` siendo pisada por
  `.catg-page-inner` porque esta última estaba más abajo en el `<style>`.
- **Altura "circular" en CSS Grid**: si una imagen usa `width/height: 100%` (flujo normal)
  dentro de un contenedor cuya altura depende del contenido, y ese contenido es la
  imagen misma, el navegador no puede resolverlo y cae a `height: auto` (usa el tamaño
  natural de la imagen). Se soluciona con `position: absolute; inset: 0` en la imagen.

---

## 3. Armador de PC 2.0

### 3.1 Qué problema resuelve

El armador (`/arma-tu-pc/`) permite elegir componentes y armar una PC. El pedido:

1. Puede incluir productos **ocultos** de la tienda (siempre que tengan stock).
2. Muestra precio de una **lista especial de Odoo** (Gremio 3/4), no el de catálogo de TN.
3. Al finalizar, crea un pedido real en Tienda Nube y manda al cliente al checkout nativo
   (mismos medios de pago, mismo antifraude) para que pague — **no hay checkout propio**.

### 3.2 Arquitectura

```
Cliente (navegador) → page.tpl (armador, JS)
        │
        │  fetch
        ▼
Backend propio (armador-app) — VPS Hostinger, Docker + Traefik + HTTPS
        │                              │
        │ Tienda Nube API              │ Postgres (Odoo, solo lectura)
        ▼                              ▼
  Draft Orders / Products      readonly_dashboards @ Postgres Odoo
```

- **Backend**: Node.js + Express, carpeta `armador-app/` del repo.
- **Hosting**: VPS de Hostinger (`srv1513138.hstgr.cloud`), ya tenía otros servicios
  corriendo en Docker con **Traefik** como reverse proxy (WhatsApp bots, OpenClaw, etc.)
- **HTTPS**: `https://armador.integradosargentinos.com` — subdominio DNS tipo A apuntando
  a la IP del VPS, con certificado Let's Encrypt automático vía Traefik (label
  `certresolver=letsencrypt`, ya configurado en el Traefik existente).
- El backend corre en un contenedor Docker (`--restart unless-stopped`), NO con pm2
  (se probó con pm2 primero, pero como el puerto 80/443 ya lo usaba Traefik en modo
  `--network=host`, la forma correcta de integrarse fue meter el backend en Docker
  con labels de Traefik, no instalar Nginx aparte).

### 3.3 Endpoints del backend (`armador-app/src/routes/api.js`)

| Endpoint | Qué hace |
|---|---|
| `GET /api/products?category_id=X&store_id=6990490` | Trae productos de una categoría desde la API de Tienda Nube (reemplaza al viejo proxy en Vercel `tn-proxy-sandy.vercel.app`, que el propio Franco había armado en mayo). Como usa el token de la app (no la storefront pública), **trae también productos ocultos**. |
| `GET /api/prices?skus=SKU1,SKU2&store_id=6990490` | Consulta el precio de esos SKUs en la lista de precios de Odoo (Postgres). |
| `POST /api/orders` | Crea el pedido (Draft Order) en Tienda Nube con el precio de Odoo aplicado como descuento, devuelve `checkoutUrl`. |

### 3.4 La cuenta de Tienda Nube (permisos)

Se creó una **Aplicación a medida** desde el propio admin de la tienda
(Configuración → Aplicaciones a medida), NO una app de Partners con OAuth —
esto da un **Access Token fijo** directo, sin flujo de autorización.

Permisos tildados (mínimos necesarios):

- **Productos**: Lectura
- **Pedidos**: Lectura y escritura (SIN "Gestionar/Leer análisis de riesgo" — eso
  es para apps de antifraude, no lo necesitamos, el checkout nativo ya lo hace solo)
- **Pedidos manuales** (Draft Orders): Lectura y escritura ← el permiso clave, porque
  permite crear pedidos con precio custom (aplicando un descuento)

El token se carga en la base local del backend con:

```bash
node scripts/set-token.js 6990490 EL_ACCESS_TOKEN
```

### 3.5 Cómo funciona el precio de Odoo → Draft Order (la parte más delicada)

**Limitación de la API de Tienda Nube**: `POST /draft_orders` NO acepta un precio
custom por línea (solo `variant_id` y `quantity` — el precio sale del catálogo).
La única forma de bajar el precio es aplicar un **descuento** (`discount`) a nivel
de todo el pedido.

**Problema real que apareció en producción**: la tienda tiene configurado en
Tienda Nube (Configuración → Medios de pago) un **descuento automático del 25%**
por "Transferencia/Depósito", que se aplica solo con elegir ese medio de pago —
totalmente aparte de cualquier cupón. Si calculábamos el cupón como
`catálogo − precio_odoo` directo, ese 25% se restaba **dos veces** (nuestro cupón +
el automático de la tienda), y el cliente terminaba pagando de menos.

**Fórmula correcta** (en `armador-app/src/services/tiendaNube.js`):

```js
NATIVE_TRANSFER_DISCOUNT_RATE = 0.25  // configurable por env var

targetSubtotalBeforeNativeDiscount = odooSubtotal / (1 - NATIVE_TRANSFER_DISCOUNT_RATE)
discount = catalogSubtotal - targetSubtotalBeforeNativeDiscount
```

Así, después de que la tienda aplique su 25% automático sobre lo que queda tras
nuestro cupón, el resultado da **exacto** el precio de Odoo.

**Precio mostrado en pantalla mientras se arma la PC** (`page.tpl`, funciones
`price()` / `transferPrice()`):

- Si el producto tiene precio de Odoo cargado (`p._odooPrice`):
  - **Transferencia** = precio de Odoo, tal cual (redondeado **siempre hacia
    arriba**, `Math.ceil`, nunca para abajo).
  - **Tarjeta** = precio de Odoo `/ 0.75` (se le suma el recargo, no se le resta).
- Si no hay precio de Odoo para ese SKU: cae al precio de catálogo normal de Tienda Nube.

**Importante**: el precio que se manda a crear el pedido es el que **ya se le mostró
al cliente en pantalla** (`item.product._odooPrice`), no uno que se vuelve a consultar
en el momento de finalizar — hubo un bug real donde esa segunda consulta fallaba para
un SKU puntual y ese producto quedaba sin descuento, descuadrando el total.

### 3.6 Flujo completo del armador (`templates/page.tpl`)

> ⚠️ Ojo: `page.tpl` es el archivo de **todo el sitio** (layout general), no solo del
> armador. El código del armador vive adentro de un bloque
> `{% if template == 'page.arma-tu-pc' %}`. Al editarlo, tocar solo esa sección.

1. `fetchCat()` pide productos por categoría a `CFG.proxyUrl` (nuestro backend),
   filtra por stock, y llama a `attachOdooPrices()` para pegarle a cada producto
   su precio de Odoo (`p._odooPrice`) de una sola consulta batch por categoría.
2. El cliente va eligiendo un producto por categoría (Procesador, Placa Madre, RAM, etc.)
3. Al hacer clic en "Agregar todo al carrito" (`APC.addAll`):
   - Arma la lista de `items` (variant_id, sku, catalogPrice, odooPrice — este último
     tomado directo de `p._odooPrice`, sin volver a consultar)
   - Llama a `createOrderViaBackend()` → `POST /api/orders` de nuestro backend
   - El backend crea el Draft Order en Tienda Nube y devuelve `checkoutUrl`
   - El navegador redirige directo a ese link (checkout nativo de Tienda Nube)
4. **No se piden datos del cliente con popups** — Tienda Nube ya los pide en su
   propio checkout. Se usan valores placeholder obligatorios para crear el Draft
   Order (`Cliente Armador`, email `armador+<timestamp>@integradosargentinos.com`)
   que el cliente corrige con sus datos reales al pagar.

### 3.7 Configuración de Odoo (Postgres)

- Usuario de solo lectura: `readonly_dashboards`, con `SELECT` sobre todas las
  tablas del schema `public`.
- Variables de entorno (`armador-app/.env`, **no se sube a git**):
  ```
  ODOO_PG_HOST=181.104.13.48
  ODOO_PG_PORT=30432
  ODOO_PG_DATABASE=odoo
  ODOO_PG_USER=readonly_dashboards
  ODOO_PG_PASSWORD=***
  ODOO_PRICELIST_ID=45   # Gremio 3/4
  NATIVE_TRANSFER_DISCOUNT_RATE=0.25
  ```
- Query usado (`armador-app/src/services/odooPrices.js`): busca en
  `product_pricelist_item` + `product_template.default_code` (= SKU de Tienda Nube)
  para la lista de precios `ODOO_PRICELIST_ID`.
- ⚠️ **Pendiente de seguridad**: hoy ese Postgres acepta conexiones desde
  cualquier IP (`0.0.0.0/0`). Falta restringirlo solo a la IP del VPS.

### 3.8 Cómo desplegar cambios del backend (VPS)

Consola web de Hostinger → VPS → "Consola web" (o SSH: `root@181.215.135.99`).

```bash
cd /opt/Proyecto-Integrados
git pull
cd armador-app
docker build -t armador-app .
docker stop armador-app
docker rm armador-app
docker run -d \
  --name armador-app \
  --restart unless-stopped \
  --env-file .env \
  -v $(pwd)/data:/app/data \
  --label "traefik.enable=true" \
  --label "traefik.http.routers.armador.rule=Host(\`armador.integradosargentinos.com\`)" \
  --label "traefik.http.routers.armador.entrypoints=websecure" \
  --label "traefik.http.routers.armador.tls.certresolver=letsencrypt" \
  --label "traefik.http.services.armador.loadbalancer.server.port=3000" \
  armador-app
```

Verificar:
```bash
docker ps --filter name=armador-app
docker logs armador-app --tail 50
```

### 3.9 Pendientes conocidos

- [ ] Confirmar con una prueba real que el fix del doble descuento (25%) quedó bien aplicado.
- [ ] Revisar pedidos hechos con el armador **antes** de ese fix, por si algún cliente pagó de menos.
- [ ] Restringir el Postgres de Odoo a la IP del VPS.
- [ ] Rotar el token viejo de Tienda Nube que quedó expuesto en el frontend, en una
      versión vieja del armador (`página.arma-tu-pc.tpl`, no la que está en uso).
- [ ] Borrar del FTP las versiones huérfanas del armador que no se usan
      (`página.arma-tu-pc.tpl`, `page.arma-tu-pc.tpl` sin tilde, `pc-builder.js` +
      `snipplets/armador-pc.tpl`) — quedaron de pruebas anteriores, no están conectadas
      a nada, pero una de ellas tiene el token expuesto.
- [ ] Reemplazar los datos placeholder del cliente por algo más prolijo si Tienda Nube
      llegase a exigir datos reales para crear el Draft Order en el futuro.

---

## 4. Accesos y datos de referencia

| Qué | Dato |
|---|---|
| Repo | `github.com/Franco12-stack/Proyecto-Integrados`, rama `claude/tienda-nube-t18so6` |
| Tienda | `integradosargentinos.com` — ID de tienda `6990490` |
| VPS | Hostinger, `srv1513138.hstgr.cloud` — IP `181.215.135.99` |
| Backend armador | `https://armador.integradosargentinos.com` |
| Carpeta del backend en el VPS | `/opt/Proyecto-Integrados/armador-app` |
| Postgres Odoo | `181.104.13.48:30432`, DB `odoo`, usuario `readonly_dashboards` |
| Lista de precios Odoo usada | ID `45` (Gremio 3/4) |
| Descuento nativo transferencia | 25% (Config. → Medios de pago en TN) |

---

## 5. Glosario rápido

- **Draft Order (Orden preliminar)**: pedido creado por API, no por el cliente en la
  tienda. Al crearlo devuelve un `checkout_url` para que el cliente termine de pagar
  en el checkout normal de Tienda Nube.
- **Aplicación a medida**: tipo de app de Tienda Nube creada directo desde el admin
  de la tienda (sin OAuth), da un token de acceso fijo con los permisos que se elijan.
- **Traefik**: reverse proxy que ya corría en el VPS (para otros servicios), maneja
  HTTPS automático vía Docker labels — no hizo falta instalar Nginx aparte.
