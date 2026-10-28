import { MAX_QTY } from './categories.js';
import { unitPrices, couponFor, settle } from './pricing.js';

export class OrderError extends Error {
  constructor(code, message, details = {}) {
    super(message);
    this.code = code;
    this.details = details;
  }
}

const HTTP_STATUS = { INVALID_ITEMS: 400, UNKNOWN_PRODUCT: 422, OUT_OF_STOCK: 422, PRICE_CHANGED: 409, NOT_FOUND: 404 };
export const httpStatus = (code) => HTTP_STATUS[code] ?? 400;

const quotesFor = (subtotal, coupon, rate) => ({
  transfer: settle({ subtotal, coupon, payment: 'transfer', rate }),
  card: settle({ subtotal, coupon, payment: 'card', rate }),
});

/**
 * Build a draft order the way the platform would accept it: lines carry only a
 * product reference and a quantity, and the price list is applied through a
 * single order-level coupon. Pure function, shared by the server and by the
 * in-browser demo mode.
 *
 * Prices are always resolved here, never trusted from the client. If the client
 * sends the total it was shown (`expectedTransferTotal`) and prices moved in the
 * meantime, the order is rejected so nobody pays a price they did not see.
 */
export function buildOrder({ items, products, priceList, config, expectedTransferTotal }) {
  if (!Array.isArray(items) || items.length === 0) {
    throw new OrderError('INVALID_ITEMS', 'items must be a non-empty array');
  }

  const rate = config.nativeTransferRate;
  const byId = new Map(products.map((p) => [p.id, p]));

  const lines = items.map((item) => {
    const quantity = Number(item?.quantity);
    if (typeof item?.id !== 'string' || !Number.isInteger(quantity) || quantity < 1 || quantity > MAX_QTY) {
      throw new OrderError('INVALID_ITEMS', `each item needs a string id and a quantity between 1 and ${MAX_QTY}`);
    }
    // Hidden (unpublished) products are intentionally allowed: this is the admin side.
    const product = byId.get(item.id);
    if (!product) throw new OrderError('UNKNOWN_PRODUCT', `Unknown product ${item.id}`, { id: item.id });
    if (product.stock < quantity) {
      throw new OrderError('OUT_OF_STOCK', `${product.name}: only ${product.stock} in stock`, { id: product.id, stock: product.stock });
    }
    const price = unitPrices(product.price, priceList[product.sku], rate);
    return {
      id: product.id,
      sku: product.sku,
      name: product.name,
      quantity,
      published: product.published,
      catalogPrice: product.price,
      wholesalePrice: price.transfer,
      cardPrice: price.card,
      specialPrice: price.special,
    };
  });

  const compensated = couponFor(lines, { rate });
  const naive = couponFor(lines, { rate, strategy: 'naive' });
  const expectedTransfer = lines.reduce((sum, l) => sum + l.wholesalePrice * l.quantity, 0);

  if (expectedTransferTotal !== undefined && Math.abs(Number(expectedTransferTotal) - expectedTransfer) > 0.01) {
    throw new OrderError('PRICE_CHANGED', 'Prices changed since you built this configuration', {
      expected: Number(expectedTransferTotal),
      actual: expectedTransfer,
    });
  }

  return {
    currency: config.currency,
    nativeTransferRate: rate,
    lines,
    subtotal: compensated.catalog,
    coupon: compensated.coupon,
    clamped: compensated.clamped,
    expectedTransfer,
    quotes: quotesFor(compensated.catalog, compensated.coupon, rate),
    naive: { coupon: naive.coupon, quotes: quotesFor(naive.catalog, naive.coupon, rate) },
  };
}
