const esc = (value) =>
  String(value).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);

function money(order, amount, digits = 2) {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: order.currency, minimumFractionDigits: digits, maximumFractionDigits: digits }).format(amount);
}

function linesPanel(order) {
  const rows = order.lines.map((l) => `<tr>
      <td>${esc(l.name)} ${l.published ? '' : '<span class="apc-tag tag-hidden">hidden in storefront</span>'}</td>
      <td>${l.quantity}</td>
      <td>${money(order, l.catalogPrice * l.quantity, 0)}</td>
      <td>${money(order, l.wholesalePrice * l.quantity, 0)}</td>
    </tr>`).join('');
  return `<section class="panel"><h2>Order #${esc(order.id)}</h2>
    <div class="tbl-wrap"><table><tr><th>Item</th><th>Qty</th><th>List price</th><th>Price-list (transfer)</th></tr>${rows}</table></div></section>`;
}

function totalsPanel(order, payment) {
  const q = order.quotes[payment];
  return `<section class="panel"><h2>Payment</h2>
    <div class="pay">
      <label><input type="radio" name="pay" value="transfer" ${payment === 'transfer' ? 'checked' : ''}> Bank transfer</label>
      <label><input type="radio" name="pay" value="card" ${payment === 'card' ? 'checked' : ''}> Credit card</label>
    </div>
    <div class="row"><span>Subtotal (list prices)</span><span>${money(order, q.subtotal)}</span></div>
    <div class="row"><span>Coupon <code>DRAFT-${esc(order.id).toUpperCase()}</code></span><span>−${money(order, q.coupon)}</span></div>
    ${payment === 'transfer'
      ? `<div class="row"><span>Bank-transfer discount (${Math.round(order.nativeTransferRate * 100)}%, applied by the platform)</span><span>−${money(order, q.nativeDiscount)}</span></div>`
      : ''}
    <div class="row total"><span>Total</span><span id="grand-total">${money(order, q.total)}</span></div>
    <p class="hint">Demo only — no payment is processed.</p></section>`;
}

function explanationPanel(order) {
  const target = order.expectedTransfer;
  const pct = Math.round(order.nativeTransferRate * 100);
  const diff = target - order.naive.quotes.transfer.total;
  return `<section class="panel"><h2>Why two discounts?</h2>
    <div class="note">The platform's draft-order API accepts one order-level coupon and no per-line prices, and its checkout then applies its own
    ${pct}% bank-transfer discount <i>after</i> the coupon. The coupon is therefore sized so that this discount lands the transfer total on the price list:
    <code>coupon = list − priceList / (1 − ${order.nativeTransferRate})</code>.</div>
    <table>
      <tr><th>Coupon strategy</th><th>Coupon</th><th>Customer pays (transfer)</th><th>Price list says</th></tr>
      <tr><td>Compensated (used)</td><td>${money(order, order.coupon)}</td><td class="ok">${money(order, order.quotes.transfer.total)}</td><td>${money(order, target)}</td></tr>
      <tr><td>Naive <small>(list − priceList)</small></td><td>${money(order, order.naive.coupon)}</td><td class="bad">${money(order, order.naive.quotes.transfer.total)}</td><td>${money(order, target)}</td></tr>
    </table>
    <p class="hint">The naive coupon undercharges by ${money(order, diff)} (= ${pct}% of the price-list total): the discount is applied twice.</p>
    ${order.clamped ? '<p class="warn">Some list prices are below the target, so the coupon was clamped at 0 for this order.</p>' : ''}</section>`;
}

const BACK = '<a class="co-back" href="#build">← Back to the configurator</a>';

function render(page, order, payment) {
  page.innerHTML = `${BACK}${linesPanel(order)}${totalsPanel(order, payment)}${explanationPanel(order)}`;
  page.querySelectorAll('input[name="pay"]').forEach((input) => input.addEventListener('change', () => render(page, order, input.value)));
}

/** Render the simulated platform checkout for an order into `page`. */
export async function show(id, page, api) {
  try {
    render(page, await api.getOrder(id), 'transfer');
  } catch (error) {
    page.innerHTML = `${BACK}<p class="error">${esc(error.message)}</p>`;
  }
}
