/**
 * Power estimate and PSU recommendation. Figures are rough public TDP values:
 * good enough to warn about an undersized PSU, not a substitute for a datasheet.
 * Keep GPU entries ordered most-specific first ("4070 ti" before "4070").
 */

const GPU_WATTS = [
  [/4090/, 450], [/4080/, 320], [/4070 ti/i, 285], [/4070/, 200], [/4060 ti/i, 160], [/4060/, 115],
  [/3090/, 350], [/3080/, 320], [/3070/, 220], [/3060 ti/i, 200], [/3060/, 170], [/3050/, 100],
  [/7900 xtx/i, 355], [/7900/, 300], [/7800 xt/i, 263], [/7700 xt/i, 245], [/7600 xt/i, 190], [/7600/, 165],
  [/6800/, 250], [/6700/, 175], [/6600/, 132],
  [/1660/, 120], [/1650/, 75],
];

const PSU_SIZES = [450, 550, 650, 750, 850, 1000, 1200];
const SYSTEM_BASE_WATTS = 20;
const HEADROOM = 1.3;

export function cpuWatts(name) {
  if (/core ultra/i.test(name)) return /\d{3}K\b/i.test(name) ? 125 : 65;
  if (/ryzen 9|core i9/i.test(name)) return 125;
  if (/ryzen 7|core i7/i.test(name)) return 105;
  if (/ryzen 5|core i5/i.test(name)) return 65;
  if (/ryzen 3|core i3/i.test(name)) return 58;
  return 65;
}

export function gpuWatts(name) {
  for (const [pattern, watts] of GPU_WATTS) if (pattern.test(name)) return watts;
  return 150;
}

function storageWatts(product) {
  const kind = product.attributes?.kind ?? (/nvme|m\.2/i.test(product.name) ? 'nvme' : /ssd/i.test(product.name) ? 'ssd' : 'hdd');
  return { nvme: 7, ssd: 4, hdd: 10 }[kind];
}

const coolingWatts = (name) => (/aio|liquid|\b(240|280|360)\s?mm\b/i.test(name) ? 18 : 8);

/** Estimated draw in watts for a selection; 0 for an empty one. */
export function estimateWatts(selection) {
  let total = 0;
  for (const [category, entries] of Object.entries(selection)) {
    for (const { product, qty } of entries) {
      switch (category) {
        case 'cpu': total += cpuWatts(product.name); break;
        case 'gpu': total += gpuWatts(product.name); break;
        case 'ram': total += (/DDR5/i.test(product.name) ? 7 : 5) * (product.attributes?.modules ?? 1) * qty; break;
        case 'storage': total += storageWatts(product) * qty; break;
        case 'motherboard': total += 50; break;
        case 'case': total += 15; break;
        case 'cooling': total += coolingWatts(product.name); break;
        default: break;
      }
    }
  }
  return total === 0 ? 0 : total + SYSTEM_BASE_WATTS;
}

export function recommendedPsu(watts) {
  const needed = Math.ceil(watts * HEADROOM);
  return PSU_SIZES.find((size) => size >= needed) ?? PSU_SIZES.at(-1);
}

export function parsePsuWatts(name) {
  const match = name.match(/(\d{3,4})\s*W\b/i);
  return match ? Number(match[1]) : 0;
}
