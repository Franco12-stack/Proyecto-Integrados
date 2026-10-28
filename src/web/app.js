import { CATEGORIES, MAX_QTY } from './core/categories.js';
import { unitPrices, couponFor, settle } from './core/pricing.js';
import { isCompatible, issues, detectSocket, detectRamType, requiredRam } from './core/compat.js';
import { estimateWatts, recommendedPsu, parsePsuWatts } from './core/power.js';
import { createApi } from './api.js';
import { productArt } from './art.js';
import { icon } from './icons.js';

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
  showIncompatible: false,
  includeHidden: true,
  loading: false,
  ordering: false,
  error: '',
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
const plural = (n, word) => `${n} ${word}${n === 1 ? '' : 's'}`;

function totals() {
  return chosen().reduce(
    (sum, { product, qty }) => {
      const u = unit(product);
      return { transfer: sum.transfer + u.transfer * qty, card: sum.card + u.card * qty };
    },
    { transfer: 0, card: 0 },
  );
}

// ---- feedback ------------------------------------------------------------

let toastTimer;
function toast(message) {
  const el = $('#toast');
  el.textContent = message;
  el.hidden = false;
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => { el.hidden = true; }, 2200);
}

function openModal(html, small = false) {
  $('#modalBody').className = `apc-modal${small ? ' small' : ''}`;
  $('#modalBody').innerHTML = html;
  $('#modal').classList.add('show');
}
const closeModal = () => $('#modal').classList.remove('show');

// ---- state changes -------------------------------------------------------

function go(key) {
  state.tab = key;
  state.query = '';
  $('#search').value = '';
  render();
  $('#tabs .active')?.scrollIntoView({ inline: 'center', block: 'nearest' });
  $('#grid').scrollTop = 0;
}

function goNext() {
  const index = CATEGORIES.findIndex((c) => c.key === state.tab);
  if (index < CATEGORIES.length - 1) go(CATEGORIES[index + 1].key);
}

function pick(productId) {
  const product = state.products.find((p) => p.id === productId);
  if (!product || product.stock === 0) return;
  const cfg = categoryOf(product.category);
  const entries = state.selection[product.category] ?? [];
  const existing = entries.find((e) => e.product.id === product.id);

  if (cfg.multi) {
    if (existing) existing.qty = Math.min(existing.qty + 1, MAX_QTY, product.stock);
    else entries.push({ product, qty: 1 });
    state.selection[product.category] = entries;
    toast(`✓ ${product.name} added`);
    render();
  } else if (existing) {
    delete state.selection[product.category];
    render();
  } else {
    state.selection[product.category] = [{ product, qty: 1 }];
    toast(`✓ ${product.name}`);
    render();
    setTimeout(() => { if (state.tab === product.category) goNext(); }, 350);
  }
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

async function loadCatalog() {
  state.products = await state.api.products();
  state.prices = await state.api.prices(state.products.map((p) => p.sku));
  // Keep the selected products pointing at fresh data (price, stock) after a reload.
  for (const entries of Object.values(state.selection)) {
    for (const entry of entries) entry.product = state.products.find((p) => p.id === entry.product.id) ?? entry.product;
  }
}

async function refresh() {
  state.loading = true;
  renderGrid();
  try {
    await Promise.all([loadCatalog(), new Promise((resolve) => setTimeout(resolve, 350))]);
    toast('Products and prices reloaded');
  } catch (error) {
    toast(`Could not reload: ${error.message}`);
  }
  state.loading = false;
  render();
}

function reset() {
  state.selection = {};
  state.error = '';
  go(CATEGORIES[0].key);
  toast('Build cleared');
}

// ---- rendering: tabs & panel ---------------------------------------------

function renderTabs() {
  $('#tabs').innerHTML = CATEGORIES.map((c) => {
    const done = state.selection[c.key]?.length;
    return `<button class="apc-tab ${c.key === state.tab ? 'active' : ''} ${done ? 'done' : ''}" data-act="tab" data-tab="${c.key}">
      ${icon(c.key, 15)} ${esc(c.label)}<span class="apc-tab-check">✓</span></button>`;
  }).join('');
}

function renderHeader() {
  const cfg = categoryOf(state.tab);
  $('#title').innerHTML = `${icon(cfg.key, 18)} ${esc(cfg.label)}${cfg.required ? '' : ' <span class="apc-badge-opt">Optional</span>'}${cfg.multi ? ' <span class="apc-badge-multi">You can pick several</span>' : ''}`;
  $('#skip').hidden = cfg.required;
  $('#search').placeholder = `Search ${cfg.label.toLowerCase()}…`;
}

function tagsFor(product, u) {
  const tags = [];
  const add = (text, cls = '') => tags.push(`<span class="apc-tag ${cls}">${esc(text)}</span>`);
  if (product.category === 'cpu' || product.category === 'motherboard') {
    const socket = detectSocket(product);
    if (socket) add(socket, socket === 'AM4' ? 'tag-am4' : socket === 'AM5' ? 'tag-am5' : 'tag-lga');
  }
  if (product.category === 'ram' || product.category === 'motherboard') {
    const ram = detectRamType(product);
    if (ram) add(ram, ram === 'DDR5' ? 'tag-ddr5' : 'tag-ddr4');
  }
  if (product.category === 'psu') {
    const watts = parsePsuWatts(product.name);
    if (watts) add(`${watts}W`, 'tag-watts');
  }
  if (!product.published) tags.push('<span class="apc-tag tag-hidden" title="Not visible on the public storefront">hidden in storefront</span>');
  if (product.stock === 0) add('out of stock', 'tag-out');
  if (!u.special) tags.push('<span class="apc-tag" title="No price-list entry: sold at the normal list price">list price</span>');
  return tags.join('');
}

function visibleProducts() {
  const query = state.query.trim().toLowerCase();
  return state.products
    .filter((p) => p.category === state.tab)
    .filter((p) => state.includeHidden || p.published)
    .filter((p) => !query || p.name.toLowerCase().includes(query))
    .map((product) => ({ product, compatible: isCompatible(product, product.category, state.selection) }))
    .filter(({ compatible }) => compatible || state.showIncompatible)
    .sort((a, b) => unit(a.product).transfer - unit(b.product).transfer);
}

function noticeHtml() {
  const { cpu, motherboard } = state.selection;
  if (state.tab === 'motherboard' && cpu) {
    const socket = detectSocket(cpu[0].product);
    return socket ? `<div class="apc-compat-notice">🔌 Showing motherboards compatible with socket ${esc(socket)}</div>` : '';
  }
  if (state.tab === 'ram' && (cpu || motherboard)) {
    const need = requiredRam(state.selection);
    return need ? `<div class="apc-compat-notice">💾 Your build needs ${esc(need)} memory</div>` : '';
  }
  return '';
}

function cardHtml({ product, compatible }, cfg) {
  const u = unit(product);
  const qty = qtyOf(product);
  const out = product.stock === 0;
  const cls = ['apc-card', cfg.multi && qty ? 'apc-multi-sel' : '', !cfg.multi && qty ? 'apc-selected' : '', compatible ? '' : 'apc-incompat', out ? 'apc-oos' : '']
    .filter(Boolean).join(' ');
  return `<article class="${cls}" data-act="pick" data-id="${esc(product.id)}" ${compatible && !out ? '' : 'aria-disabled="true"'}>
    ${cfg.multi && qty ? `<div class="apc-qty-badge">${qty}</div>` : ''}
    ${compatible ? '' : '<div class="apc-incompat-badge">Incompatible</div>'}
    <div class="apc-card-img-wrap"><img class="apc-card-img" src="${productArt(product)}" alt="" loading="lazy"></div>
    <div class="apc-card-body">
      <div class="apc-card-name">${esc(product.name)}</div>
      <div class="apc-tags">${tagsFor(product, u)}</div>
      <div class="apc-prices">
        <div class="apc-price-transfer"><div class="apc-price-amount">${fmt(u.transfer)}</div><div class="apc-price-sub">bank transfer or deposit</div></div>
        <div class="apc-price-card"><div class="apc-price-card-amount">${fmt(u.card)}</div><div class="apc-price-card-label">credit card</div></div>
      </div>
    </div>
    ${cfg.multi && qty ? `<div class="apc-qty-ctrl">
      <button class="apc-qty-btn" data-act="qty" data-cat="${product.category}" data-id="${esc(product.id)}" data-delta="1" aria-label="One more">+</button>
      <span class="apc-qty-num">×${qty}</span>
      <button class="apc-qty-btn" data-act="qty" data-cat="${product.category}" data-id="${esc(product.id)}" data-delta="-1" aria-label="One less">−</button>
    </div>` : ''}
  </article>`;
}

function renderGrid() {
  const cfg = categoryOf(state.tab);
  const grid = $('#grid');
  if (state.loading) {
    grid.innerHTML = '<div class="apc-state"><div class="apc-spinner"></div><span>Loading products…</span></div>';
    $('#filterCount').textContent = '';
    return;
  }
  const items = visibleProducts();
  $('#filterCount').textContent = plural(items.length, 'product');
  $('#notice').innerHTML = noticeHtml();
  grid.innerHTML = items.length
    ? items.map((item) => cardHtml(item, cfg)).join('')
    : `<div class="apc-state"><span style="opacity:.35">${icon(cfg.key, 52)}</span><span>${state.query ? `No results for "${esc(state.query)}"` : 'No compatible products in this category'}</span></div>`;

  if (cfg.multi) {
    const any = state.selection[cfg.key]?.length;
    $('#nextWrap').innerHTML = `<div class="apc-next-wrap"><button class="apc-next-btn" data-act="next">${any ? 'Continue →' : 'Skip this step →'}</button></div>`;
  } else {
    $('#nextWrap').innerHTML = '';
  }
}

// ---- rendering: summary --------------------------------------------------

function breakdownTable(entries) {
  const rate = state.config.nativeTransferRate;
  const lines = entries.map(({ product, qty }) => ({ catalogPrice: product.price, wholesalePrice: unit(product).transfer, quantity: qty }));
  const target = totals();
  const row = (label, strategy) => {
    const c = couponFor(lines, { rate, strategy });
    const pay = (payment) => settle({ subtotal: c.catalog, coupon: c.coupon, payment, rate }).total;
    return { label, coupon: c.coupon, transfer: pay('transfer'), card: pay('card'), catalog: c.catalog };
  };
  const good = row('Compensated (used)', 'compensated');
  const naive = row('Naive', 'naive');
  const cell = (value, expected) => `<td class="${Math.abs(value - expected) < 1.5 ? 'ok' : 'bad'}">${fmt(value, 2)}</td>`;
  return `<details class="how">
    <summary>How the discount is built</summary>
    <p class="sum-hint">List-price subtotal ${fmt(good.catalog, 2)}. The platform adds its own ${Math.round(rate * 100)}% bank-transfer discount after the coupon, so a naive coupon discounts twice.</p>
    <table>
      <tr><th></th><th>Coupon</th><th>Transfer</th><th>Card</th></tr>
      <tr><td>${good.label}</td><td>${fmt(good.coupon, 2)}</td>${cell(good.transfer, target.transfer)}${cell(good.card, target.card)}</tr>
      <tr><td>${naive.label}</td><td>${fmt(naive.coupon, 2)}</td>${cell(naive.transfer, target.transfer)}${cell(naive.card, target.card)}</tr>
      <tr><td>Price list says</td><td></td><td>${fmt(target.transfer, 2)}</td><td>${fmt(target.card, 2)}</td></tr>
    </table>
  </details>`;
}

function summaryHtml() {
  const { transfer, card } = totals();
  const count = chosen().length;
  const missing = CATEGORIES.filter((c) => c.required && !state.selection[c.key]);
  const problems = issues(state.selection);

  const rows = CATEGORIES.map((cfg) => {
    const entries = state.selection[cfg.key] ?? [];
    if (!entries.length) {
      return `<div class="sum-item item-empty"><div class="sum-thumb">${icon(cfg.key, 18)}</div>
        <div class="sum-info"><div class="sum-cat">${esc(cfg.label)}${cfg.required ? ' *' : ''}</div><div class="sum-name">Not selected</div></div></div>`;
    }
    return entries.map(({ product, qty }) => `<div class="sum-item">
      <div class="sum-thumb"><img src="${productArt(product)}" alt=""></div>
      <div class="sum-info"><div class="sum-cat">${esc(cfg.label)}${qty > 1 ? ` ×${qty}` : ''}</div><div class="sum-name" title="${esc(product.name)}">${esc(product.name)}</div></div>
      <div class="sum-price">${fmt(unit(product).transfer * qty)}</div>
      <button class="sum-del" data-act="remove" data-cat="${cfg.key}" data-id="${esc(product.id)}" title="Remove" aria-label="Remove ${esc(product.name)}">×</button>
    </div>`).join('');
  }).join('');

  const watts = estimateWatts(state.selection);
  let power = '';
  if (watts > 0) {
    const need = recommendedPsu(watts);
    const psu = state.selection.psu?.[0]?.product;
    const have = psu ? parsePsuWatts(psu.name) : 0;
    const verdict = !psu ? '' : have >= need ? ` <span class="psu-ok">✔ ${have}W is enough</span>` : ` <span class="psu-bad">⚠ ${have}W is too small</span>`;
    power = `<div class="power-banner">⚡ Estimated draw <strong>~${watts}W</strong> · recommended PSU <strong>${need}W</strong>${verdict}</div>`;
  }

  const compat = problems.length
    ? `<div class="compat-err">⚠️ ${problems.map(esc).join('<br>⚠️ ')}</div>`
    : count >= 2 ? '<div class="compat-ok">✅ Compatible components</div>' : '';

  const disabled = missing.length || problems.length || count === 0 || state.ordering;
  const entries = Object.values(state.selection).flat();
  return `<div class="sum-head"><span class="sum-head-dot"></span><span>Your build</span><span class="sum-count">${plural(count, 'component')}</span></div>
    <div class="sum-items">${rows}</div>
    <div class="sum-footer">
      ${power}${compat}
      <div class="dual-totals">
        <div class="total-block total-transfer"><div class="total-lbl">Bank transfer</div><div class="total-amt js-total-transfer">${fmt(transfer)}</div></div>
        <div class="total-block total-card"><div class="total-lbl">Card · installments</div><div class="total-amt js-total-card">${fmt(card)}</div></div>
      </div>
      <button class="btn-cart" data-act="checkout" ${disabled ? 'disabled' : ''}>${state.ordering ? '<span class="apc-spinner" style="width:16px;height:16px;border-width:2px;border-color:rgba(255,255,255,.4);border-top-color:#fff"></span> Creating order…' : '🛒 Create order &amp; checkout'}</button>
      <button class="btn-presupuesto" data-act="quote" ${count === 0 ? 'disabled' : ''}>📄 View quote</button>
      <button class="btn-reset" data-act="reset" ${count === 0 ? 'disabled' : ''}>Start over</button>
      <p class="sum-hint">${missing.length ? `Still needed: ${missing.map((c) => esc(c.label)).join(', ')}` : 'Prices come from the price list; the platform checkout handles payment.'}</p>
      ${state.error ? `<p class="sum-error" role="alert">${esc(state.error)}</p>` : ''}
      ${entries.length ? breakdownTable(entries) : ''}
    </div>`;
}

function renderSummary() {
  const html = summaryHtml();
  $('#summary').innerHTML = html;
  $('#mobileCount').textContent = plural(chosen().length, 'component');
  $('#mobileTotal').textContent = fmt(totals().transfer);
  if ($('#drawer').classList.contains('open')) $('#drawer').innerHTML = `<div class="sum-card">${html}</div>`;
}

function render() {
  renderTabs();
  renderHeader();
  renderGrid();
  renderSummary();
}

// ---- quote ---------------------------------------------------------------

const QUOTE_CSS = `body{font-family:Arial,sans-serif;color:#333;max-width:820px;margin:24px auto;padding:0 16px}
.q-head{display:flex;justify-content:space-between;border-bottom:3px solid #1ba9e2;padding-bottom:12px;margin-bottom:14px}
.q-head b{font-size:20px}.q-meta{text-align:right;font-size:12px;color:#666;line-height:1.7}
table{width:100%;border-collapse:collapse;margin-bottom:14px;font-size:13px}th{background:#1a1a1a;color:#fff;padding:7px 9px;text-align:left;font-size:11px}
td{padding:7px 9px;border-bottom:1px solid #eee;vertical-align:middle}.r{text-align:right;white-space:nowrap}
img{width:44px;height:33px;object-fit:contain;display:block}.q-cat{font-size:10px;font-weight:700;text-transform:uppercase;color:#999}
.q-totals{display:flex;gap:12px;justify-content:flex-end;margin-bottom:12px}.tb{padding:10px 14px;border-radius:10px;min-width:170px;border:1.5px solid #e8e8e8}
.tb.t{background:linear-gradient(135deg,#1ba9e2,#34b7ec);color:#fff;border:none}.tb small{display:block;font-size:9px;text-transform:uppercase;letter-spacing:.5px;opacity:.85}
.tb b{font-size:18px}.q-note{font-size:11px;color:#999;border-top:1px solid #eee;padding-top:10px}`;

function quoteBody() {
  const date = (d) => d.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
  const today = new Date();
  const valid = new Date(today.getTime() + 24 * 3600 * 1000);
  const { transfer, card } = totals();
  const rows = CATEGORIES.flatMap((cfg) => (state.selection[cfg.key] ?? []).map(({ product, qty }) => {
    const u = unit(product);
    return `<tr><td><img src="${productArt(product)}" alt=""></td>
      <td><div class="q-cat">${esc(cfg.label)}${qty > 1 ? ` ×${qty}` : ''}</div>${esc(product.name)}</td>
      <td class="r"><b>${fmt(u.transfer * qty)}</b></td><td class="r" style="color:#999">${fmt(u.card * qty)}</td></tr>`;
  })).join('');
  return `<div class="q-head"><div><b>PCForge</b><div style="font-size:12px;color:#888">Quote · fictional demo data</div></div>
      <div class="q-meta"><b>Quote</b><br>Date: ${date(today)}<br>Valid until: ${date(valid)}</div></div>
    <table><thead><tr><th></th><th>Component</th><th class="r">Bank transfer</th><th class="r">Card</th></tr></thead><tbody>${rows}</tbody></table>
    <div class="q-totals"><div class="tb t"><small>Bank transfer</small><b>${fmt(transfer)}</b></div><div class="tb"><small>Credit card</small><b>${fmt(card)}</b></div></div>
    <p class="q-note">Prices are valid for 24 hours and subject to stock. This is a demo: nothing here is a real offer.</p>`;
}

function openQuote() {
  openModal(`<style>${QUOTE_CSS.replace(/(^|\})([^{}@]+)\{/g, (m, a, sel) => `${a}.qv ${sel.trim().replace(/,/g, ', .qv ')}{`).replace('.qv body', '.qv')}.qv{margin:0;padding:0}</style>
    <div class="qv">${quoteBody()}</div>
    <div class="apc-modal-btns" style="margin-top:14px"><button class="primary" data-act="download-quote">Download quote (.html)</button><button data-act="close-modal">Close</button></div>`);
}

function downloadQuote() {
  const html = `<!doctype html><html lang="en"><meta charset="utf-8"><title>PCForge quote</title><style>${QUOTE_CSS}</style><body>${quoteBody()}</body></html>`;
  const link = document.createElement('a');
  link.href = URL.createObjectURL(new Blob([html], { type: 'text/html' }));
  link.download = 'pcforge-quote.html';
  link.click();
  setTimeout(() => URL.revokeObjectURL(link.href), 1000);
}

// ---- checkout ------------------------------------------------------------

async function checkout() {
  state.ordering = true;
  state.error = '';
  renderSummary();
  try {
    const items = chosen().map(({ product, qty }) => ({ id: product.id, quantity: qty }));
    const order = await state.api.createOrder({ items, expectedTransferTotal: totals().transfer });
    state.ordering = false;
    closeDrawer();
    location.hash = `order-${order.id}`;
  } catch (error) {
    state.ordering = false;
    state.error = error.code === 'PRICE_CHANGED' ? 'Prices changed. Reload the products and review your build.' : error.message;
    renderSummary();
  }
}

function openDrawer() {
  $('#drawer').classList.add('open');
  $('#drawerOverlay').classList.add('open');
  $('#drawer').innerHTML = `<div class="sum-card">${summaryHtml()}</div>`;
}
function closeDrawer() {
  $('#drawer').classList.remove('open');
  $('#drawerOverlay').classList.remove('open');
}

async function route() {
  const id = location.hash.startsWith('#order-') ? decodeURIComponent(location.hash.slice(7)) : null;
  $('#builder').hidden = Boolean(id);
  $('#mobileBar').hidden = Boolean(id);
  $('#page').hidden = !id;
  if (id) {
    $('#toast').hidden = true;
    $('#page').innerHTML = '<div class="apc-state"><div class="apc-spinner"></div><span>Loading order…</span></div>';
    const { show } = await import('./checkout.js');
    await show(id, $('#page'), state.api);
    window.scrollTo(0, 0);
  }
}

// ---- wiring --------------------------------------------------------------

document.addEventListener('click', (event) => {
  const el = event.target.closest('[data-act]');
  if (!el) return;
  const { act } = el.dataset;
  if (el.id === 'modal' && event.target !== el) return; // clicks inside the dialog keep it open
  if (act === 'tab') go(el.dataset.tab);
  else if (act === 'pick') {
    if (el.getAttribute('aria-disabled') !== 'true') pick(el.dataset.id);
  } else if (act === 'qty') changeQty(el.dataset.cat, el.dataset.id, Number(el.dataset.delta));
  else if (act === 'remove') remove(el.dataset.cat, el.dataset.id);
  else if (act === 'next' || act === 'skip') goNext();
  else if (act === 'refresh') refresh();
  else if (act === 'checkout') checkout();
  else if (act === 'quote') { closeDrawer(); openQuote(); }
  else if (act === 'download-quote') downloadQuote();
  else if (act === 'reset') {
    closeDrawer();
    openModal(`<h2>Start over?</h2><p>The current selection will be cleared.</p>
      <div class="apc-modal-btns"><button data-act="close-modal">Cancel</button><button class="danger" data-act="confirm-reset">Clear build</button></div>`, true);
  } else if (act === 'confirm-reset') { closeModal(); reset(); }
  else if (act === 'close-modal') closeModal();
  else if (act === 'open-drawer') openDrawer();
  else if (act === 'close-drawer') closeDrawer();
});

document.addEventListener('keydown', (event) => { if (event.key === 'Escape') { closeModal(); closeDrawer(); } });
$('#search').addEventListener('input', (e) => { state.query = e.target.value; renderGrid(); });
$('#showIncompatible').addEventListener('change', (e) => { state.showIncompatible = e.target.checked; renderGrid(); });
$('#includeHidden').addEventListener('change', (e) => { state.includeHidden = e.target.checked; renderGrid(); });
addEventListener('hashchange', route);

async function init() {
  state.loading = true;
  renderTabs();
  renderHeader();
  renderGrid();
  try {
    state.api = await createApi();
    state.config = await state.api.config();
    await loadCatalog();
  } catch (error) {
    $('#grid').innerHTML = `<div class="apc-state"><span class="error">Could not load the catalog: ${esc(error.message)}</span></div>`;
    return;
  }
  $('#mode').textContent = state.api.mode === 'server' ? '· server API' : '· in-browser mock';
  state.loading = false;
  render();
  route();
}

init();
