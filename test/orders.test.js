import { test } from 'node:test';
import assert from 'node:assert/strict';
import { buildOrder, OrderError } from '../src/core/orders.js';
import { products, priceList, config, byId } from './helpers.js';

const build = (items, extra = {}) => buildOrder({ items, products, priceList, config, ...extra });
const near = (a, b, tol = 0.011) => assert.ok(Math.abs(a - b) <= tol, `${a} not within ${tol} of ${b}`);
const rejects = (fn, code) => assert.throws(fn, (err) => err instanceof OrderError && err.code === code);

const A_BUILD = [
  { id: 'cpu-r5-7600', quantity: 1 },
  { id: 'mb-b650m-ds3h', quantity: 1 },
  { id: 'ram-d5-32', quantity: 2 },
  { id: 'ssd-sn580-1tb', quantity: 1 },
  { id: 'gpu-rtx4060', quantity: 1 },
  { id: 'psu-rm750e', quantity: 1 },
];

test('a full build lands on the price list for transfer and on wholesale / 0.75 for card', () => {
  const order = build(A_BUILD);
  const wholesale = order.lines.reduce((s, l) => s + l.wholesalePrice * l.quantity, 0);
  const shownCard = order.lines.reduce((s, l) => s + l.cardPrice * l.quantity, 0);

  assert.equal(order.expectedTransfer, wholesale);
  near(order.quotes.transfer.total, wholesale);
  near(order.quotes.card.total, wholesale / 0.75, order.lines.length);
  // Rounding policy: what is shown for card is never below what is charged, and within $1 per line.
  assert.ok(shownCard >= order.quotes.card.total - 0.01);
  assert.ok(shownCard - order.quotes.card.total < order.lines.length);
  assert.equal(order.clamped, false);
});

test('the naive strategy undercharges the same build by exactly rate * wholesale', () => {
  const order = build(A_BUILD);
  const wholesale = order.expectedTransfer;
  near(order.naive.quotes.transfer.total, wholesale * 0.75, 0.02);
  assert.ok(order.naive.coupon > order.coupon);
});

test('hidden (unpublished) products can be ordered when they are in stock', () => {
  const order = build([{ id: 'cpu-i7-14700k', quantity: 1 }]);
  assert.equal(order.lines[0].published, false);
});

test('out-of-stock products are rejected, including partial availability', () => {
  rejects(() => build([{ id: 'cpu-i3-10100', quantity: 1 }]), 'OUT_OF_STOCK'); // stock 0
  rejects(() => build([{ id: 'mb-z890-elite', quantity: 4 }]), 'OUT_OF_STOCK'); // stock 3, asked for 4
  assert.doesNotThrow(() => build([{ id: 'mb-z890-elite', quantity: 3 }]));
});

test('invalid input is rejected', () => {
  rejects(() => build([]), 'INVALID_ITEMS');
  rejects(() => build('nope'), 'INVALID_ITEMS');
  rejects(() => build([{ id: 'cpu-r5-7600', quantity: 0 }]), 'INVALID_ITEMS');
  rejects(() => build([{ id: 'cpu-r5-7600', quantity: 99 }]), 'INVALID_ITEMS');
  rejects(() => build([{ id: 'does-not-exist', quantity: 1 }]), 'UNKNOWN_PRODUCT');
});

test('prices are resolved server-side: a stale total from the client is rejected', () => {
  const fresh = build(A_BUILD).expectedTransfer;
  assert.doesNotThrow(() => build(A_BUILD, { expectedTransferTotal: fresh }));
  rejects(() => build(A_BUILD, { expectedTransferTotal: fresh - 25 }), 'PRICE_CHANGED');
});

test('REGRESSION: a product with no special price keeps its normal transfer price (list * 0.75)', () => {
  const noSpecial = byId('cool-h150i-360');
  assert.equal(priceList[noSpecial.sku], undefined);

  // Mixed cart: one product with a price-list entry, one without.
  const order = build([{ id: 'cpu-r5-7600', quantity: 1 }, { id: noSpecial.id, quantity: 1 }]);
  const line = order.lines.find((l) => l.id === noSpecial.id);

  assert.equal(line.specialPrice, false);
  assert.equal(line.wholesalePrice, Math.ceil(noSpecial.price * 0.75));
  // Treating "no price" as wholesale = list price would charge this line the FULL list price on transfer.
  assert.ok(line.wholesalePrice < noSpecial.price);
  near(order.quotes.transfer.total, order.expectedTransfer, order.lines.length);
});

test('a quote exists for both payment methods and the coupon is never negative', () => {
  const order = build([{ id: 'ssd-nv2-500', quantity: 1 }]);
  assert.ok(order.coupon >= 0);
  assert.ok(order.quotes.transfer.total < order.quotes.card.total);
});
