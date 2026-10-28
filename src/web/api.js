/**
 * Data access for the UI. Two interchangeable implementations:
 *
 *  - server mode: talks to the Express API (`npm start`).
 *  - browser mode: no backend at all. Loads the same JSON data and runs the very
 *    same `buildOrder` from /core in the page, keeping orders in localStorage.
 *    This is what powers the static GitHub Pages demo.
 *
 * Paths are relative on purpose so the app works under a sub-path
 * (https://user.github.io/repo/).
 */
import { buildOrder } from './core/orders.js';

async function parse(response) {
  const body = await response.json().catch(() => ({}));
  if (!response.ok) {
    const error = new Error(body.error?.message ?? response.statusText);
    error.code = body.error?.code;
    throw error;
  }
  return body;
}

function serverApi() {
  return {
    mode: 'server',
    config: () => fetch('api/config').then(parse),
    products: () => fetch('api/products').then(parse),
    prices: (skus) => fetch(`api/prices?skus=${encodeURIComponent(skus.join(','))}`).then(parse).then((d) => d.prices),
    createOrder: (payload) =>
      fetch('api/orders', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(payload) }).then(parse),
    getOrder: (id) => fetch(`api/orders/${encodeURIComponent(id)}`).then(parse),
  };
}

async function browserApi() {
  const [config, products, priceList] = await Promise.all(
    ['config', 'products', 'pricelist'].map((name) => fetch(`data/${name}.json`).then(parse)),
  );
  const STORAGE_KEY = 'pcforge:orders';
  // localStorage can be unavailable (private mode, sandboxed frames): orders then live in memory only.
  const memory = {};
  const stored = () => {
    try { return { ...JSON.parse(localStorage.getItem(STORAGE_KEY) ?? '{}'), ...memory }; } catch { return { ...memory }; }
  };

  return {
    mode: 'browser',
    config: async () => config,
    products: async () => products,
    prices: async (skus) => Object.fromEntries(skus.filter((sku) => sku in priceList).map((sku) => [sku, priceList[sku]])),
    createOrder: async (payload) => {
      const order = {
        id: crypto.randomUUID().slice(0, 8),
        createdAt: new Date().toISOString(),
        ...buildOrder({ ...payload, products, priceList, config }),
      };
      memory[order.id] = order;
      try { localStorage.setItem(STORAGE_KEY, JSON.stringify(stored())); } catch { /* memory only */ }
      return order;
    },
    getOrder: async (id) => {
      const order = stored()[id];
      if (!order) throw Object.assign(new Error('Order not found'), { code: 'NOT_FOUND' });
      return order;
    },
  };
}

export async function createApi() {
  // The static build tags its pages, so it never probes for a backend that is not there.
  const isStaticBuild = document.querySelector('meta[name="pcforge-mode"]')?.content === 'static';
  if (!isStaticBuild) {
    try {
      const response = await fetch('api/health', { cache: 'no-store' });
      if (response.ok && (await response.json()).ok) return serverApi();
    } catch {
      // no backend reachable: fall through to browser mode
    }
  }
  return browserApi();
}
