// Uso: node scripts/set-token.js <store_id> <access_token>
// Para "Aplicaciones a medida" (creadas desde el admin de la tienda) el token
// es fijo y se genera una sola vez — no hace falta el flujo OAuth de auth.js.
require('dotenv').config();
const { saveToken } = require('../src/db/tokens');

const [storeId, accessToken] = process.argv.slice(2);

if (!storeId || !accessToken) {
  console.error('Uso: node scripts/set-token.js <store_id> <access_token>');
  process.exit(1);
}

saveToken(storeId, accessToken, 'write_orders,read_products');
console.log(`Token guardado para la tienda ${storeId}.`);
