const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.ODOO_PG_HOST,
  port: Number(process.env.ODOO_PG_PORT || 5432),
  database: process.env.ODOO_PG_DATABASE,
  user: process.env.ODOO_PG_USER,
  password: process.env.ODOO_PG_PASSWORD,
  max: 5,
});

/**
 * Devuelve el precio de la lista configurada (ODOO_PRICELIST_ID) para un conjunto de SKUs.
 * Ajustar el JOIN/columnas según el esquema real de Odoo (product_pricelist_item, product_product, product_template).
 */
async function getPricesForSkus(skus) {
  if (!skus?.length) return {};

  const pricelistId = process.env.ODOO_PRICELIST_ID;

  const { rows } = await pool.query(
    `
    SELECT pt.default_code AS sku, pli.fixed_price AS price
    FROM product_pricelist_item pli
    JOIN product_template pt ON pt.id = pli.product_tmpl_id
    WHERE pli.pricelist_id = $1
      AND pt.default_code = ANY($2)
    `,
    [pricelistId, skus]
  );

  const result = {};
  for (const row of rows) {
    result[row.sku] = Number(row.price);
  }
  return result;
}

module.exports = { getPricesForSkus };
