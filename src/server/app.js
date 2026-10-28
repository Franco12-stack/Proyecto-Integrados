import { readFileSync } from 'node:fs';
import { randomUUID } from 'node:crypto';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import express from 'express';
import { buildOrder, OrderError, httpStatus } from '../core/orders.js';

const here = dirname(fileURLToPath(import.meta.url));
const readJson = (dir, name) => JSON.parse(readFileSync(join(dir, `${name}.json`), 'utf8'));

/**
 * The HTTP app. The catalog plays the e-commerce platform and the price list
 * plays the ERP; swapping them for real clients is the only change needed to
 * point this at live systems.
 */
export function createApp({ dataDir = join(here, 'data'), rateOverride } = {}) {
  const products = readJson(dataDir, 'products');
  const priceList = readJson(dataDir, 'pricelist');
  const config = readJson(dataDir, 'config');
  if (rateOverride !== undefined) config.nativeTransferRate = rateOverride;

  const orders = new Map();
  const app = express();
  app.use(express.json({ limit: '50kb' }));

  app.get('/api/health', (_req, res) => res.json({ ok: true, mode: 'server' }));

  // Single source of truth for the rate, so the UI can never drift from what is charged.
  app.get('/api/config', (_req, res) => res.json(config));

  // "Admin API" view: includes products hidden from the public storefront.
  // `?publishedOnly=1` shows what a storefront visitor would see.
  app.get('/api/products', (req, res) => {
    const { category, publishedOnly } = req.query;
    res.json(products.filter((p) => (!category || p.category === category) && (!publishedOnly || p.published)));
  });

  app.get('/api/prices', (req, res) => {
    const skus = String(req.query.skus ?? '').split(',').filter(Boolean);
    res.json({ prices: Object.fromEntries(skus.filter((s) => s in priceList).map((s) => [s, priceList[s]])) });
  });

  app.post('/api/orders', (req, res, next) => {
    try {
      const { items, expectedTransferTotal } = req.body ?? {};
      const order = { id: randomUUID().slice(0, 8), createdAt: new Date().toISOString(), ...buildOrder({ items, products, priceList, config, expectedTransferTotal }) };
      orders.set(order.id, order);
      res.status(201).json(order);
    } catch (err) {
      next(err);
    }
  });

  app.get('/api/orders/:id', (req, res, next) => {
    const order = orders.get(req.params.id);
    if (!order) return next(new OrderError('NOT_FOUND', 'Order not found'));
    return res.json(order);
  });

  app.use('/core', express.static(join(here, '..', 'core')));
  app.use('/data', express.static(dataDir));
  app.use(express.static(join(here, '..', 'web')));

  // eslint-disable-next-line no-unused-vars
  app.use((err, _req, res, _next) => {
    if (err instanceof OrderError) {
      return res.status(httpStatus(err.code)).json({ error: { code: err.code, message: err.message, details: err.details } });
    }
    if (err.type === 'entity.parse.failed') return res.status(400).json({ error: { code: 'INVALID_JSON', message: 'Malformed JSON body' } });
    console.error(err);
    return res.status(500).json({ error: { code: 'INTERNAL', message: 'Unexpected error' } });
  });

  return app;
}
