import { test } from 'node:test';
import assert from 'node:assert/strict';
import { unitPrices, couponFor, settle } from '../src/core/pricing.js';
import { mulberry32 } from './helpers.js';

const near = (actual, expected, tolerance = 0.011) =>
  assert.ok(Math.abs(actual - expected) <= tolerance, `expected ${actual} to be within ${tolerance} of ${expected}`);

test('unitPrices: transfer is the wholesale price, card adds the surcharge, both round UP', () => {
  assert.deepEqual(unitPrices(400, 205.51), { special: true, transfer: 206, card: 275 }); // 205.51 / 0.75 = 274.01
  assert.deepEqual(unitPrices(400, 300), { special: true, transfer: 300, card: 400 });
});

test('unitPrices: without a special price the product keeps its normal prices', () => {
  assert.deepEqual(unitPrices(400, undefined), { special: false, transfer: 300, card: 400 });
  assert.deepEqual(unitPrices(399, undefined), { special: false, transfer: 300, card: 399 }); // 299.25 -> 300
});

test('REGRESSION: naive coupon applies the transfer discount twice and undercharges by rate * wholesale', () => {
  const lines = [{ catalogPrice: 1000, wholesalePrice: 700, quantity: 1 }];
  const naive = couponFor(lines, { strategy: 'naive' });
  assert.equal(naive.coupon, 300);

  const total = settle({ subtotal: naive.catalog, coupon: naive.coupon, payment: 'transfer' }).total;
  assert.equal(total, 525); // should have been 700
  assert.equal(700 - total, 0.25 * 700);
});

test('compensated coupon lands the transfer total exactly on the wholesale price', () => {
  const lines = [{ catalogPrice: 1000, wholesalePrice: 700, quantity: 1 }];
  const { coupon, catalog } = couponFor(lines);
  near(coupon, 66.67);
  near(settle({ subtotal: catalog, coupon, payment: 'transfer' }).total, 700);
});

test('compensated coupon makes the card total equal wholesale / (1 - rate)', () => {
  const lines = [{ catalogPrice: 1000, wholesalePrice: 700, quantity: 1 }];
  const { coupon, catalog } = couponFor(lines);
  near(settle({ subtotal: catalog, coupon, payment: 'card' }).total, 700 / 0.75);
});

test('coupon is clamped at zero (and flagged) when the list price is already below target', () => {
  const result = couponFor([{ catalogPrice: 100, wholesalePrice: 90, quantity: 1 }]);
  assert.equal(result.coupon, 0);
  assert.equal(result.clamped, true);
});

test('the rate is configurable', () => {
  const lines = [{ catalogPrice: 1000, wholesalePrice: 600, quantity: 1 }];
  const { coupon, catalog } = couponFor(lines, { rate: 0.4 });
  near(settle({ subtotal: catalog, coupon, payment: 'transfer', rate: 0.4 }).total, 600);
});

test('PROPERTY: for any cart, transfer == sum of wholesale and card == sum of wholesale / 0.75', () => {
  const rand = mulberry32(2026);
  for (let run = 0; run < 500; run += 1) {
    const lines = Array.from({ length: 1 + Math.floor(rand() * 8) }, () => {
      const catalogPrice = Math.round(50 + rand() * 2000);
      return {
        catalogPrice,
        wholesalePrice: Math.ceil(catalogPrice * (0.4 + rand() * 0.34)), // stays below catalog * 0.75
        quantity: 1 + Math.floor(rand() * 4),
      };
    });
    const wholesale = lines.reduce((s, l) => s + l.wholesalePrice * l.quantity, 0);
    const { coupon, catalog, clamped } = couponFor(lines);
    assert.equal(clamped, false);
    near(settle({ subtotal: catalog, coupon, payment: 'transfer' }).total, wholesale);
    near(settle({ subtotal: catalog, coupon, payment: 'card' }).total, wholesale / 0.75, 0.02);
  }
});
