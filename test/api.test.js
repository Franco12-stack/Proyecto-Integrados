import { test, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { createApp } from '../src/server/app.js';

let server;
let base;

before(async () => {
  server = createApp().listen(0);
  await new Promise((resolve) => server.once('listening', resolve));
  base = `http://127.0.0.1:${server.address().port}`;
});

after(() => server.close());

const get = (path) => fetch(`${base}${path}`).then(async (r) => ({ status: r.status, body: await r.json() }));
const post = (path, body, raw = false) =>
  fetch(`${base}${path}`, { method: 'POST', headers: { 'content-type': 'application/json' }, body: raw ? body : JSON.stringify(body) })
    .then(async (r) => ({ status: r.status, body: await r.json() }));

test('health and config expose the single source of truth for the rate', async () => {
  assert.deepEqual((await get('/api/health')).body, { ok: true, mode: 'server' });
  assert.equal((await get('/api/config')).body.nativeTransferRate, 0.25);
});

test('admin products include hidden ones; publishedOnly shows the public storefront', async () => {
  const admin = (await get('/api/products?category=cpu')).body;
  const storefront = (await get('/api/products?category=cpu&publishedOnly=1')).body;
  assert.ok(admin.some((p) => !p.published));
  assert.ok(storefront.every((p) => p.published));
  assert.ok(admin.length > storefront.length);
});

test('prices returns only the SKUs that have a special price', async () => {
  const { prices } = (await get('/api/prices?skus=CPU-7600,COOL-H150I-360,NOPE')).body;
  assert.deepEqual(Object.keys(prices), ['CPU-7600']);
});

test('POST /api/orders creates an order that can be fetched back', async () => {
  const created = await post('/api/orders', { items: [{ id: 'cpu-r5-7600', quantity: 1 }, { id: 'mb-b650m-ds3h', quantity: 1 }] });
  assert.equal(created.status, 201);
  assert.match(created.body.id, /^[0-9a-f]{8}$/);

  const fetched = await get(`/api/orders/${created.body.id}`);
  assert.equal(fetched.status, 200);
  assert.deepEqual(fetched.body.quotes, created.body.quotes);
});

test('errors map to the right HTTP status', async () => {
  assert.equal((await post('/api/orders', { items: [] })).status, 400);
  assert.equal((await post('/api/orders', '{not json', true)).status, 400);
  assert.equal((await post('/api/orders', { items: [{ id: 'nope', quantity: 1 }] })).status, 422);
  assert.equal((await post('/api/orders', { items: [{ id: 'cpu-i3-10100', quantity: 1 }] })).status, 422);
  assert.equal((await post('/api/orders', { items: [{ id: 'cpu-r5-7600', quantity: 1 }], expectedTransferTotal: 1 })).status, 409);
  assert.equal((await get('/api/orders/deadbeef')).status, 404);
});

test('the front-end is served, including the shared core modules', async () => {
  for (const path of ['/', '/core/pricing.js', '/data/products.json']) {
    assert.equal((await fetch(`${base}${path}`)).status, 200, path);
  }
});
