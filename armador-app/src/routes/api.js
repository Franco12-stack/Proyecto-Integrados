const express = require('express');
const { getPricesForSkus } = require('../services/odooPrices');
const { createDraftOrder } = require('../services/tiendaNube');
const { getProductsByCategory } = require('../services/tiendaNubeProducts');
const { getToken } = require('../db/tokens');

const router = express.Router();

// GET /api/products?category_id=123&store_id=6990490&per_page=200
// Reemplaza al viejo proxy de Vercel (tn-proxy-sandy.vercel.app) que usaba el armador.
router.get('/products', async (req, res) => {
  const { category_id, store_id, per_page } = req.query;

  if (!category_id || !store_id) {
    return res.status(400).json({ error: 'Faltan category_id o store_id' });
  }

  const tokenRow = getToken(store_id);
  if (!tokenRow) {
    return res.status(401).json({ error: 'La tienda no tiene la app instalada/autorizada' });
  }

  try {
    const products = await getProductsByCategory({
      storeId: store_id,
      accessToken: tokenRow.access_token,
      categoryId: category_id,
      perPage: per_page,
    });
    res.json(products);
  } catch (err) {
    console.error('Error consultando productos en Tienda Nube:', err.response?.data || err.message);
    res.status(500).json({ error: 'No se pudieron obtener los productos' });
  }
});

// GET /api/prices?skus=SKU1,SKU2,SKU3&store_id=123
router.get('/prices', async (req, res) => {
  try {
    const skus = String(req.query.skus || '').split(',').filter(Boolean);
    const prices = await getPricesForSkus(skus);
    res.json({ prices });
  } catch (err) {
    console.error('Error consultando precios en Odoo:', err.message);
    res.status(500).json({ error: 'No se pudieron obtener los precios' });
  }
});

// POST /api/orders  { store_id, customer: {name, lastname, email, phone}, items: [{variant_id, quantity, catalogPrice, odooPrice}], note }
router.post('/orders', async (req, res) => {
  const { store_id, customer, items, note } = req.body;

  if (!store_id || !items?.length) {
    return res.status(400).json({ error: 'Faltan store_id o items' });
  }
  if (!customer?.name || !customer?.lastname || !customer?.email) {
    return res.status(400).json({ error: 'Faltan datos del cliente (nombre, apellido, email)' });
  }

  const tokenRow = getToken(store_id);
  if (!tokenRow) {
    return res.status(401).json({ error: 'La tienda no tiene la app instalada/autorizada' });
  }

  try {
    const { checkoutUrl, draftOrder } = await createDraftOrder({
      storeId: store_id,
      accessToken: tokenRow.access_token,
      customer,
      items,
      note,
    });
    res.json({ checkoutUrl, draftOrderId: draftOrder.id });
  } catch (err) {
    console.error('Error creando pedido en Tienda Nube:', err.response?.data || err.message);
    res.status(500).json({ error: 'No se pudo crear el pedido' });
  }
});

module.exports = router;
