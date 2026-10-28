import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const dataDir = join(dirname(fileURLToPath(import.meta.url)), '..', 'src', 'server', 'data');
const read = (name) => JSON.parse(readFileSync(join(dataDir, `${name}.json`), 'utf8'));

export const products = read('products');
export const priceList = read('pricelist');
export const config = read('config');

export const byId = (id) => {
  const product = products.find((p) => p.id === id);
  if (!product) throw new Error(`fixture product not found: ${id}`);
  return product;
};

/** selection({ cpu: 'cpu-r5-7600', ram: [['ram-d5-16', 2]] }) -> compat/power selection shape */
export function selection(spec) {
  return Object.fromEntries(
    Object.entries(spec).map(([category, value]) => [
      category,
      (Array.isArray(value) ? value : [[value, 1]]).map(([id, qty = 1]) => ({ product: byId(id), qty })),
    ]),
  );
}

/** Small deterministic PRNG so property tests are reproducible. */
export function mulberry32(seed) {
  let a = seed;
  return () => {
    a |= 0; a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
