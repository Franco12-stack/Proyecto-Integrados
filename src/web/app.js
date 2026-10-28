import { CATEGORIES, MAX_QTY } from './core/categories.js';
import { unitPrices, couponFor, settle } from './core/pricing.js';
import { isCompatible, issues, detectSocket, detectRamType } from './core/compat.js';
import { estimateWatts, recommendedPsu, parsePsuWatts } from './core/power.js';
import { createApi } from './api.js';

const $ = (selector) => document.querySelector(selector);
const esc = (value) =>
  String(value).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);

const state = {
  api: null,
  config: null,
  products: [],
  prices: {}, // sku -> wholesale price (only SKUs that have one)
  selection: {}, // { [category]: [{ product, qty }] }
  tab: CATEGORIES[0].key,
  query: '',
  hideIncompatible: true,
  includeHidden: true,
};

const formatters = {};
function fmt(amount, digits = 0) {
  formatters[digits] ??= new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: state.config.currency,
    minimumFractionDigits: digits,
    maximumFractionDigits: digits,
  });
  return formatters[digits].format(amount);
}

const categoryOf = (key) => CATEGORIES.find((c) => c.key === key);
const unit = (product) => unitPrices(product.price, state.prices[product.sku], state.config.nativeTransferRate);
const chosen = () => Object.values(state.selection).flat();
const qtyOf = (product) => state.selection[product.category]?.find((e) => e.product.id === product.id)?.qty ?? 0;

function totals() {
  return chosen().reduce(
    (sum, { product, qty }) => {
      const u = unit(product);
      return { transfer: sum.transfer + u.transfer * qty, card: sum.card + u.card * qty };
    },
    { transfer: 0, card: 0 },
  );
}

// ---- state changes -------------------------------------------------------

function pick(productId) {
  const product = state.products.find((p) => p.id === productId);
  const entries = state.selection[product.category] ?? [];
  const existing = entries.find((e) => e.product.id === product.id);

  if (categoryOf(product.category).multi) {
    if (existing) existing.qty = Math.min(existing.qty + 1, MAX_QTY, product.stock);
    else entries.push({ product, qty: 1 });
    state.selection[product.category] = entries;
  } else if (existing) {
    delete state.selection[product.category];
  } else {
    state.selection[product.category] = [{ product, qty: 1 }];
  }
  render();
}

function changeQty(cat, id, delta) {
  const entries = state.selection[cat] ?? [];
  const entry = entries.find((e) => e.product.id === id);
  if (!entry) return;
  entry.qty = Math.min(entry.qty + delta, MAX_QTY, entry.product.stock);
  if (entry.qty < 1) entries.splice(entries.indexOf(entry), 1);
  if (entries.length === 0) delete state.selection[cat];
  render();
}

function remove(cat, id) {
  state.selection[cat] = (state.selection[cat] ?? []).filter((e) => e.product.id !== id);
  if (state.selection[cat].length === 0) delete state.selection[cat];
  render();
}

// ---- rendering -----------------------------------------------------------

function renderTabs() {
  $('#tabs').innerHTML = CATEGORIES.map((c) => {
    const done = state.selection[c.key]?.length;
    return `<button class="tab ${c.key === state.tab ? 'active' : ''} ${done ? 'done' : ''}" data-tab="${c.key}">
      ${esc(c.label)}${c.required ? '<span class="req" title="required">*</span>' : ''}${done ? ' ✓' : ''}</button>`;
  }).join('');
}

function tagsFor(product, u) {
  const tags = [];
  if (product.category === 'cpu' || product.category === 'motherboard') tags.push(detectSocket(product));
  if (product.category === 'ram' || product.category === 'motherboard') tags.push(detectRamType(product));
  if (product.category === 'psu') tags.push(parsePsuWatts(product.name) ? `${parsePsuWatts(product.name)}W` : null);
  const html = tags.filter(Boolean).map((t) => `<span class="tag">${esc(t)}</span>`);
  if (!product.published) html.push('<span class="tag hidden" title="Not visible on the public storefront">hidden in storefront</span>');
  if (product.stock === 0) html.push('<span class="tag out">out of stock</span>');
  if (!u.special) html.push('<span class="tag" title="No price-list entry: sold at normal list price">list price</span>');
  return html.join('');
}

function visibleProducts() {
  const query = state.query.trim().toLowerCase();
  return state.products
    .filter((p) => p.category === state.tab)
    .filter((p) => state.includeHidden || p.published)
    .filter((p) => !query || p.name.toLowerCase().includes(query))
    .map((product) => ({ product, compatible: isCompatible(product, product.category, state.selection) }))
    .filter(({ compatible }) => compatible || !state.hideIncompatible)
    .sort((a, b) => unit(a.product).transfer - unit(b.product).transfer);
}

function renderGrid() {
  const cfg = categoryOf(state.tab);
  const items = visibleProducts();
  $('#grid').innerHTML = items.length
    ? items.map(({ product, compatible }) => {
        const u = unit(product);
        const qty = qtyOf(product);
        const label = qty ? (cfg.multi ? `Add another (${qty} selected)` : 'Remove') : 'Select';
        const disabled = product.stock === 0 || !compatible;
        return `<article class="card ${qty ? 'selected' : ''} ${compatible ? '' : 'incompatible'}" data-id="${esc(product.id)}">
          <div class="name">${esc(product.name)}</div>
          <div class="tags">${tagsFor(product, u)}</div>
          <div class="prices">
            <div class="price transfer"><b>${fmt(u.transfer)}</b><small>bank transfer</small></div>
            <div class="price card-price"><b>${fmt(u.card)}</b><small>credit card</small></div>
          </div>
          <button class="pick" data-act="pick" ${disabled ? 'disabled' : ''}>${compatible ? label : 'Incompatible'}</button>
        </article>`;
      }).join('')
    : '<div class="empty">No products match.</div>';
}

function breakdownTable(entries) {
  const rate = state.config.nativeTransferRate;
  const lines = entries.map(({ product, qty }) => ({
    catalogPrice: product.price,
    wholesalePrice: unit(product).transfer,
    quantity: qty,
  }));
  const row = (label, strategy) => {
    const c = couponFor(lines, { rate, strategy });
    const pay = (payment) => settle({ subtotal: c.catalog, coupon: c.coupon, payment, rate }).total;
    return { label, coupon: c.coupon, transfer: pay('transfer'), card: pay('card'), catalog: c.catalog };
  };
  const good = row('Compensated (used)', 'compensated');
  const naive = row('Naive', 'naive');
  const target = totals().transfer;
  const cell = (value, expected) => `<td class="${Math.abs(value - expected) < 1.5 ? 'ok' : 'bad'}">${fmt(value, 2)}</td>`;
  return `<details>
    <summary>How the discount is built</summary>
    <p class="hint">List-price subtotal ${fmt(good.catalog, 2)}. The platform adds its own ${Math.round(rate * 100)}% bank-transfer discount after the coupon, so a naive coupon discounts twice.</p>
    <table>
      <tr><th></th><th>Coupon</th><th>Transfer</th><th>Card</th></tr>
      <tr><td>${good.label}</td><td>${fmt(good.coupon, 2)}</td>${cell(good.transfer, target)}${cell(good.card, totals().card)}</tr>
      <tr><td>${naive.label}</td><td>${fmt(naive.coupon, 2)}</td>${cell(naive.transfer, target)}${cell(naive.card, totals().card)}</tr>
      <tr><td>Price list says</td><td></td><td>${fmt(target, 2)}</td><td>${fmt(totals().card, 2)}</td></tr>
    </table>
  </details>`;
}

function renderSummary() {
  const entries = Object.entries(state.selection).flatMap(([cat, list]) => list.map((e) => ({ ...e, cat })));
  const { transfer, card } = totals();
  const watts = estimateWatts(state.selection);
  const psu = state.selection.psu?.[0]?.product;
  const missing = CATEGORIES.filter((c) => c.required && !state.selection[c.key]);
  const problems = issues(state.selection);

  const lines = entries.length
    ? entries.map(({ cat, product, qty }) => `<div class="line">
        <div class="nm">${esc(product.name)}</div><div class="amt">${fmt(unit(product).transfer * qty)}</div>
        <div class="sub">${esc(categoryOf(cat).label)}</div>
        <div class="amt qty">${categoryOf(cat).multi
          ? `<button data-act="qty" data-cat="${cat}" data-id="${esc(product.id)}" data-delta="-1" aria-label="less">−</button>${qty}<button data-act="qty" data-cat="${cat}" data-id="${esc(product.id)}" data-delta="1" aria-label="more">+</button>`
          : ''}<button data-act="remove" data-cat="${cat}" data-id="${esc(product.id)}" aria-label="remove">✕</button></div>
      </div>`).join('')
    : '<p class="hint">Pick a component to start. Items marked * are required.</p>';

  let power = '';
  if (watts > 0) {
    const need = recommendedPsu(watts);
    const have = psu ? parsePsuWatts(psu.name) : 0;
    const verdict = !psu ? '' : have >= need ? `<span class="ok"> ✔ ${have}W is enough</span>` : `<span class="bad"> ⚠ ${have}W is too small</span>`;
    power = `<div class="meter">⚡ ~<b>${watts}W</b> estimated · recommended PSU <b>${need}W</b>${verdict}</div>`;
  }

  $('#summary').innerHTML = `
    ${lines}
    <div class="totals">
      <div class="price transfer"><b id="total-transfer">${fmt(transfer)}</b><small>bank transfer</small></div>
      <div class="price card-price"><b id="total-card">${fmt(card)}</b><small>credit card</small></div>
    </div>
    ${power}
    ${problems.length ? `<ul class="issues">${problems.map((p) => `<li>${esc(p)}</li>`).join('')}</ul>` : ''}
    <button id="checkout" class="cta" ${missing.length || problems.length ? 'disabled' : ''}>Create order &amp; go to checkout</button>
    <p class="hint">${missing.length ? `Still needed: ${missing.map((c) => esc(c.label)).join(', ')}` : 'Prices come from the price list; the platform checkout handles payment.'}</p>
    <p id="error" class="error" role="alert"></p>
    ${entries.length ? breakdownTable(entries) : ''}`;
}

function render() {
  renderTabs();
  renderGrid();
  renderSummary();
}

// ---- actions & wiring ----------------------------------------------------

async function checkout() {
  const button = $('#checkout');
  button.disabled = true;
  button.textContent = 'Creating order…';
  try {
    const items = chosen().map(({ product, qty }) => ({ id: product.id, quantity: qty }));
    const order = await state.api.createOrder({ items, expectedTransferTotal: totals().transfer });
    location.href = `checkout.html?id=${encodeURIComponent(order.id)}`;
  } catch (error) {
    renderSummary();
    $('#error').textContent = error.code === 'PRICE_CHANGED' ? 'Prices changed. Please review your build.' : error.message;
  }
}

document.addEventListener('click', (event) => {
  const el = event.target.closest('[data-tab], [data-act], #checkout');
  if (!el) return;
  if (el.dataset.tab) {
    state.tab = el.dataset.tab;
    render();
  } else if (el.id === 'checkout') {
    checkout();
  } else if (el.dataset.act === 'pick') {
    pick(el.closest('.card').dataset.id);
  } else if (el.dataset.act === 'qty') {
    changeQty(el.dataset.cat, el.dataset.id, Number(el.dataset.delta));
  } else if (el.dataset.act === 'remove') {
    remove(el.dataset.cat, el.dataset.id);
  }
});

$('#search').addEventListener('input', (e) => { state.query = e.target.value; renderGrid(); });
$('#hideIncompatible').addEventListener('change', (e) => { state.hideIncompatible = e.target.checked; renderGrid(); });
$('#includeHidden').addEventListener('change', (e) => { state.includeHidden = e.target.checked; renderGrid(); });

async function init() {
  state.api = await createApi();
  state.config = await state.api.config();
  state.products = await state.api.products();
  state.prices = await state.api.prices(state.products.map((p) => p.sku));
  $('#mode').textContent = state.api.mode === 'server' ? 'Mode: server API' : 'Mode: in-browser mock (static demo)';
  render();
}

init();
