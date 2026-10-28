/**
 * Pricing engine.
 *
 * Context (the constraint this module exists to work around)
 * ----------------------------------------------------------
 * The e-commerce platform's draft-order API only accepts `variant + quantity`
 * per line, plus ONE order-level discount. There is no per-line price override,
 * so a wholesale price list can only be applied by computing a coupon.
 *
 * On top of that, the platform applies its own "bank transfer" discount
 * (NATIVE_TRANSFER_RATE) automatically at checkout, on the subtotal AFTER the
 * coupon. A coupon computed as `catalog - wholesale` therefore discounts twice
 * and undercharges the customer by exactly `rate * wholesale`.
 *
 * The fix is to size the coupon so that the platform's own discount lands the
 * transfer total exactly on the wholesale price:
 *
 *     (catalog - coupon) * (1 - rate) = wholesale
 *     coupon = catalog - wholesale / (1 - rate)
 *
 * Bonus invariant: paying by card (no native discount) then costs
 * `wholesale / (1 - rate)`, which is exactly the card price shown in the UI.
 */

export const NATIVE_TRANSFER_RATE = 0.25;

const toCents = (n) => Math.round(n * 100) / 100;

/**
 * Display prices for one unit. Rounding is always UP so rounding can never
 * make us charge less than the price list says.
 *
 * - With a wholesale price: transfer = wholesale, card = transfer / (1 - rate).
 *   The card price derives from the already-rounded transfer price, which is the
 *   number the order is built on, so what is shown is never below what is charged.
 * - Without one: the product is sold at its normal list price, i.e. card = list
 *   price and transfer = list price minus the platform's transfer discount.
 */
export function unitPrices(catalogPrice, wholesalePrice, rate = NATIVE_TRANSFER_RATE) {
  if (Number.isFinite(wholesalePrice)) {
    const transfer = Math.ceil(wholesalePrice);
    return { special: true, transfer, card: Math.ceil(transfer / (1 - rate)) };
  }
  return { special: false, transfer: Math.ceil(catalogPrice * (1 - rate)), card: catalogPrice };
}

/**
 * Order-level coupon for a set of lines.
 * Each line: { catalogPrice, wholesalePrice, quantity } where `wholesalePrice`
 * is the target transfer price of one unit.
 *
 * strategy 'compensated' (default): accounts for the platform's own discount.
 * strategy 'naive': the buggy `catalog - wholesale`, kept to demonstrate it.
 */
export function couponFor(lines, { rate = NATIVE_TRANSFER_RATE, strategy = 'compensated' } = {}) {
  const catalog = lines.reduce((sum, l) => sum + l.catalogPrice * l.quantity, 0);
  const wholesale = lines.reduce((sum, l) => sum + l.wholesalePrice * l.quantity, 0);
  const target = strategy === 'naive' ? wholesale : wholesale / (1 - rate);
  const raw = catalog - target;
  return {
    catalog: toCents(catalog),
    wholesale: toCents(wholesale),
    target: toCents(target),
    coupon: toCents(Math.max(0, raw)),
    // The list price is already below the target: no coupon can fix that.
    clamped: raw < 0,
  };
}

/** What the platform's checkout does with a subtotal, a coupon and a payment method. */
export function settle({ subtotal, coupon, payment, rate = NATIVE_TRANSFER_RATE }) {
  const afterCoupon = subtotal - coupon;
  const nativeDiscount = payment === 'transfer' ? afterCoupon * rate : 0;
  return {
    subtotal: toCents(subtotal),
    coupon: toCents(coupon),
    nativeDiscount: toCents(nativeDiscount),
    total: toCents(afterCoupon - nativeDiscount),
  };
}
