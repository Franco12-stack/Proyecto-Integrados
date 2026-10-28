/**
 * Product illustrations. The demo has no photo library, so every product gets a
 * generated SVG: a drawing of the part, tinted with its brand colour, with the
 * brand and model printed on it. Returned as a data URI so it works as <img src>
 * with no extra files or network requests.
 */

const BRANDS = [
  [/amd|ryzen|radeon/i, '#e4572e'],
  [/intel|core ultra|core i\d/i, '#1f7ae0'],
  [/nvidia|geforce|rtx|gtx/i, '#6fb61a'],
  [/corsair/i, '#e0b400'],
  [/kingston/i, '#d3202f'],
  [/asus|rog/i, '#2c6bed'],
  [/msi/i, '#d6252b'],
  [/gigabyte|aorus/i, '#e8761a'],
  [/asrock/i, '#2aa4a4'],
  [/seasonic|evga/i, '#2d8f6f'],
  [/nzxt|lian li/i, '#7a5cff'],
  [/cooler master|arctic|noctua/i, '#8b6a3d'],
  [/logitech|razer|redragon/i, '#18a999'],
  [/samsung|lg |dell|wd|seagate/i, '#3b6fb6'],
  [/microsoft|windows/i, '#1b9be0'],
  [/ubuntu/i, '#e95420'],
  [/tp-link/i, '#2f9e8f'],
];

function accentFor(name) {
  for (const [pattern, color] of BRANDS) if (pattern.test(name)) return color;
  let hash = 0;
  for (const ch of name) hash = (hash * 31 + ch.charCodeAt(0)) >>> 0;
  return `hsl(${hash % 360} 60% 45%)`;
}

const esc = (s) => String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);

function labels(product) {
  const words = product.name.replace(/\(.*?\)/g, '').split(/\s+/);
  const brand = words.slice(0, /^(core|geforce|radeon|ryzen)$/i.test(words[0]) ? 1 : 1).join(' ');
  const model = product.name.match(/(RTX|GTX|RX)\s?\d{3,4}(\s?(Ti|Super|XT))?|Ryzen \d \w+|i\d-\d{4,5}\w*|Ultra \d \w+|\b[A-Z]\d{3}M?\b|\d{2,4}\s?(GB|TB|W|mm)\b|\d{2} inch/i)?.[0] ?? words[1] ?? '';
  return { brand: brand.toUpperCase().slice(0, 14), model: model.slice(0, 16) };
}

// Each drawing is 200x150. `a` is the accent colour, `d` a dark neutral, `l` a light neutral.
const DRAW = {
  cpu: (a, t) => `
    <g stroke="#9aa3ad" stroke-width="2">${Array.from({ length: 9 }, (_, i) => `<line x1="${68 + i * 8}" y1="30" x2="${68 + i * 8}" y2="38"/><line x1="${68 + i * 8}" y1="112" x2="${68 + i * 8}" y2="120"/><line x1="58" y1="${40 + i * 9}" x2="66" y2="${40 + i * 9}"/><line x1="134" y1="${40 + i * 9}" x2="142" y2="${40 + i * 9}"/>`).join('')}</g>
    <rect x="62" y="34" width="76" height="82" rx="8" fill="#2b323b"/>
    <rect x="70" y="42" width="60" height="66" rx="5" fill="url(#metal)"/>
    <path d="M62 34h14l-14 14z" fill="${a}"/>
    <text x="100" y="72" text-anchor="middle" font-size="11" font-weight="800" fill="#1f252c">${t.brand}</text>
    <text x="100" y="88" text-anchor="middle" font-size="9" fill="#3d4650">${esc(t.model)}</text>`,
  motherboard: (a) => `
    <rect x="46" y="16" width="108" height="118" rx="6" fill="#1f2a36"/>
    <rect x="58" y="28" width="34" height="34" rx="3" fill="#323f4d"/><rect x="64" y="34" width="22" height="22" rx="2" fill="url(#metal)"/>
    ${[0, 1, 2, 3].map((i) => `<rect x="${108 + i * 9}" y="24" width="5" height="46" rx="1" fill="${i % 2 ? '#52627a' : a}"/>`).join('')}
    <rect x="58" y="78" width="88" height="7" rx="2" fill="#52627a"/><rect x="58" y="92" width="88" height="7" rx="2" fill="#52627a"/><rect x="58" y="106" width="60" height="7" rx="2" fill="#52627a"/>
    <rect x="122" y="104" width="22" height="18" rx="2" fill="${a}"/>
    <rect x="46" y="28" width="10" height="38" fill="#323f4d"/>
    ${[0, 1, 2, 3, 4, 5].map((i) => `<circle cx="${64 + i * 14}" cy="125" r="1.8" fill="#c9d3de"/>`).join('')}`,
  ram: (a, t) => [0, 1].map((i) => `
    <g transform="translate(0 ${i * 34})">
      <rect x="22" y="30" width="156" height="26" rx="3" fill="#202830"/>
      ${[0, 1, 2, 3, 4, 5].map((k) => `<rect x="${32 + k * 24}" y="35" width="16" height="12" rx="1.5" fill="#39434f"/>`).join('')}
      <rect x="22" y="30" width="156" height="4" fill="${a}"/>
      <rect x="22" y="56" width="156" height="5" fill="#d4af37"/>
      ${i === 0 ? `<text x="100" y="53" text-anchor="middle" font-size="7" font-weight="700" fill="#cdd5de">${t.brand} ${esc(t.model)}</text>` : ''}
    </g>`).join(''),
  storage: (a, t, p) => {
    if (/hdd|barracuda|7200/i.test(p.name)) return `<rect x="46" y="22" width="108" height="106" rx="8" fill="#9aa3ad"/><rect x="52" y="28" width="96" height="94" rx="5" fill="#cfd5dc"/><circle cx="96" cy="72" r="32" fill="#2b323b"/><circle cx="96" cy="72" r="8" fill="#9aa3ad"/><path d="M118 38l26 20" stroke="#2b323b" stroke-width="4" stroke-linecap="round"/><rect x="58" y="108" width="40" height="8" rx="2" fill="${a}"/>`;
    if (/sata|2\.5/i.test(p.name)) return `<rect x="40" y="30" width="120" height="86" rx="8" fill="#2b323b"/><rect x="40" y="30" width="120" height="14" rx="8" fill="${a}"/><text x="100" y="82" text-anchor="middle" font-size="13" font-weight="800" fill="#e6ebf0">${t.brand}</text><text x="100" y="98" text-anchor="middle" font-size="10" fill="#9aa3ad">${esc(t.model)}</text><rect x="48" y="104" width="30" height="6" rx="1.5" fill="#d4af37"/>`;
    return `<rect x="20" y="52" width="160" height="46" rx="5" fill="#243b35"/><rect x="34" y="60" width="30" height="30" rx="3" fill="#1b1f24"/><rect x="72" y="60" width="26" height="30" rx="3" fill="#1b1f24"/><rect x="106" y="60" width="26" height="30" rx="3" fill="#1b1f24"/><rect x="138" y="58" width="32" height="34" rx="2" fill="${a}" opacity=".9"/><text x="154" y="79" text-anchor="middle" font-size="7" font-weight="800" fill="#fff">M.2</text><rect x="20" y="52" width="9" height="46" fill="#d4af37"/>`;
  },
  gpu: (a, t) => `
    <rect x="18" y="38" width="164" height="68" rx="9" fill="#232a33"/>
    <rect x="18" y="38" width="164" height="7" rx="3" fill="${a}"/>
    ${[56, 120].map((x) => `<circle cx="${x}" cy="76" r="25" fill="#10151a"/><g transform="translate(${x} 76)">${[0, 60, 120, 180, 240, 300].map((r) => `<path d="M0 0 C6 -8 8 -17 0 -23 C-8 -17 -6 -8 0 0" fill="#4a5663" transform="rotate(${r})"/>`).join('')}<circle r="4" fill="${a}"/></g>`).join('')}
    <text x="168" y="72" text-anchor="end" font-size="8" font-weight="800" fill="#cdd5de" transform="rotate(0)">${t.brand}</text>
    <rect x="12" y="38" width="6" height="74" fill="#9aa3ad"/>
    <rect x="42" y="106" width="96" height="8" rx="1" fill="#d4af37"/>`,
  cooling: (a, t, p) => /aio|liquid|\b(240|280|360)\s?mm/i.test(p.name)
    ? `<rect x="22" y="38" width="112" height="64" rx="6" fill="#262e37"/>${[48, 78, 108].map((x) => `<circle cx="${x}" cy="70" r="13" fill="#10151a"/><circle cx="${x}" cy="70" r="4" fill="${a}"/>`).join('')}<path d="M134 56c20 0 18 -14 34 -14M134 84c20 0 18 14 34 14" stroke="#1b1f24" stroke-width="5" fill="none"/><rect x="154" y="62" width="30" height="26" rx="6" fill="#2b323b"/><circle cx="169" cy="75" r="8" fill="${a}"/>`
    : `<rect x="56" y="20" width="88" height="82" rx="4" fill="#cfd5dc"/>${Array.from({ length: 11 }, (_, i) => `<rect x="${58 + i * 8}" y="22" width="4" height="78" fill="${i % 2 ? '#aab3bd' : '#e3e8ed'}"/>`).join('')}<rect x="66" y="102" width="68" height="14" rx="3" fill="#2b323b"/><circle cx="100" cy="62" r="26" fill="#10151a" opacity=".92"/><circle cx="100" cy="62" r="5" fill="${a}"/>${[0, 72, 144, 216, 288].map((r) => `<path d="M100 62 C108 52 110 40 100 36 C92 44 94 54 100 62" fill="#4a5663" transform="rotate(${r} 100 62)"/>`).join('')}`,
  case: (a) => `
    <rect x="58" y="12" width="84" height="126" rx="8" fill="#232a33"/>
    <rect x="66" y="20" width="56" height="106" rx="4" fill="#0f141a"/>
    <rect x="68" y="22" width="52" height="102" rx="3" fill="url(#glass)"/>
    ${[36, 62, 88].map((y) => `<circle cx="94" cy="${y}" r="9" fill="none" stroke="${a}" stroke-width="2"/><circle cx="94" cy="${y}" r="2.5" fill="${a}"/>`).join('')}
    <rect x="126" y="24" width="10" height="3" rx="1" fill="#52627a"/><rect x="126" y="31" width="10" height="3" rx="1" fill="#52627a"/>
    <circle cx="131" cy="118" r="4" fill="${a}"/>
    <rect x="64" y="136" width="10" height="5" rx="1" fill="#10151a"/><rect x="126" y="136" width="10" height="5" rx="1" fill="#10151a"/>`,
  psu: (a, t) => `
    <rect x="34" y="34" width="132" height="84" rx="8" fill="#2b323b"/>
    <circle cx="86" cy="76" r="30" fill="#10151a"/>${[0, 72, 144, 216, 288].map((r) => `<path d="M86 76 C95 65 97 52 86 47 C77 56 79 67 86 76" fill="#4a5663" transform="rotate(${r} 86 76)"/>`).join('')}<circle cx="86" cy="76" r="5" fill="${a}"/>
    <rect x="128" y="46" width="30" height="46" rx="3" fill="#1b1f24"/><text x="143" y="66" text-anchor="middle" font-size="11" font-weight="800" fill="${a}">${esc((t.model.match(/\d{3,4}/) ?? [''])[0])}</text><text x="143" y="79" text-anchor="middle" font-size="7" fill="#9aa3ad">WATTS</text>
    <rect x="128" y="98" width="30" height="10" rx="2" fill="#1b1f24"/>`,
  os: (a, t, p) => `
    <rect x="52" y="14" width="96" height="122" rx="6" fill="#f3f5f8" stroke="#cdd5de" stroke-width="2"/>
    <rect x="52" y="14" width="96" height="30" rx="6" fill="${a}"/>
    ${/ubuntu|linux/i.test(p.name)
      ? `<circle cx="100" cy="86" r="26" fill="none" stroke="${a}" stroke-width="6"/><circle cx="100" cy="60" r="6" fill="${a}"/><circle cx="78" cy="98" r="6" fill="${a}"/><circle cx="122" cy="98" r="6" fill="${a}"/>`
      : `<g fill="${a}"><rect x="76" y="62" width="22" height="22" rx="2"/><rect x="102" y="62" width="22" height="22" rx="2"/><rect x="76" y="88" width="22" height="22" rx="2"/><rect x="102" y="88" width="22" height="22" rx="2"/></g>`}
    <text x="100" y="33" text-anchor="middle" font-size="9" font-weight="800" fill="#fff">${/pro/i.test(p.name) ? 'PRO' : /ubuntu/i.test(p.name) ? 'UBUNTU' : 'HOME'}</text>
    <text x="100" y="126" text-anchor="middle" font-size="8" fill="#6a7683">64-bit · OEM</text>`,
  connectivity: (a, t, p) => /usb/i.test(p.name)
    ? `<rect x="40" y="58" width="92" height="34" rx="6" fill="#2b323b"/><rect x="132" y="64" width="30" height="22" rx="2" fill="#9aa3ad"/><rect x="140" y="70" width="14" height="4" fill="#52627a"/><circle cx="62" cy="75" r="6" fill="${a}"/><path d="M82 66l10 9-10 9" stroke="${a}" stroke-width="3" fill="none"/>`
    : `<rect x="26" y="62" width="104" height="52" rx="4" fill="#1f2a36"/><rect x="40" y="74" width="30" height="26" rx="3" fill="#323f4d"/><rect x="78" y="74" width="26" height="26" rx="3" fill="${a}" opacity=".85"/><rect x="26" y="114" width="70" height="7" fill="#d4af37"/>${[150, 170].map((x) => `<rect x="${x}" y="20" width="6" height="64" rx="3" fill="#2b323b"/><rect x="${x - 2}" y="82" width="10" height="8" rx="2" fill="#52627a"/>`).join('')}<path d="M138 44a26 26 0 0 1 0 -22M130 50a40 40 0 0 1 0 -34" stroke="${a}" stroke-width="3" fill="none" stroke-linecap="round" transform="translate(-14 16)"/>`,
  monitor: (a) => `
    <rect x="20" y="20" width="160" height="92" rx="7" fill="#1b2128"/>
    <rect x="25" y="25" width="150" height="80" rx="3" fill="url(#screen)"/>
    <circle cx="70" cy="62" r="20" fill="${a}" opacity=".35"/><path d="M25 95 L70 60 L102 84 L132 56 L175 92 V105 H25z" fill="#10151a" opacity=".55"/>
    <rect x="92" y="112" width="16" height="16" fill="#2b323b"/><rect x="66" y="128" width="68" height="7" rx="3" fill="#39434f"/>`,
  peripherals: (a, t, p) => /mouse pad|pad/i.test(p.name)
    ? `<rect x="22" y="36" width="156" height="84" rx="12" fill="#1b2128"/><path d="M22 100q40 -24 80 -4t76 -4v28a12 12 0 0 1 -12 12H34a12 12 0 0 1 -12 -12z" fill="${a}" opacity=".55"/><rect x="22" y="36" width="156" height="84" rx="12" fill="none" stroke="${a}" stroke-width="2.5"/>`
    : /headset|headphone/i.test(p.name)
      ? `<path d="M52 92V76a48 48 0 0 1 96 0v16" stroke="#2b323b" stroke-width="9" fill="none" stroke-linecap="round"/><rect x="40" y="82" width="24" height="42" rx="10" fill="#2b323b"/><rect x="136" y="82" width="24" height="42" rx="10" fill="#2b323b"/><rect x="44" y="90" width="9" height="26" rx="4" fill="${a}"/><path d="M60 116q16 18 38 14" stroke="#2b323b" stroke-width="4" fill="none" stroke-linecap="round"/>`
      : /webcam|c920/i.test(p.name)
        ? `<rect x="60" y="26" width="80" height="60" rx="22" fill="#2b323b"/><circle cx="100" cy="56" r="22" fill="#10151a"/><circle cx="100" cy="56" r="11" fill="${a}" opacity=".7"/><circle cx="94" cy="50" r="3" fill="#fff" opacity=".7"/><rect x="88" y="86" width="24" height="12" fill="#39434f"/><rect x="66" y="98" width="68" height="9" rx="4" fill="#39434f"/>`
        : /mouse/i.test(p.name)
          ? `<path d="M100 22c26 0 40 20 40 46v26c0 20 -14 34 -40 34s-40 -14 -40 -34V68c0 -26 14 -46 40 -46z" fill="#2b323b"/><path d="M100 22v44M60 66h80" stroke="#10151a" stroke-width="2"/><rect x="95" y="38" width="10" height="18" rx="5" fill="${a}"/>`
          : `<rect x="20" y="42" width="160" height="66" rx="8" fill="#2b323b"/>${Array.from({ length: 3 }, (_, r) => Array.from({ length: 12 - (r === 2 ? 4 : 0) }, (_, c) => `<rect x="${(r === 2 ? 52 : 28) + c * 12.2}" y="${50 + r * 17}" width="9.5" height="12" rx="2" fill="${r === 0 && c < 2 ? a : '#4a5663'}"/>`).join('')).join('')}<rect x="60" y="50" width="0" height="0"/>`,
};

const DEFS = `<defs>
  <linearGradient id="metal" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#eef1f4"/><stop offset="1" stop-color="#aeb7c1"/></linearGradient>
  <linearGradient id="glass" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#2a3541"/><stop offset="1" stop-color="#0f141a"/></linearGradient>
  <linearGradient id="screen" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#274b7a"/><stop offset="1" stop-color="#101b2e"/></linearGradient>
</defs>`;

const cache = new Map();

/** Data-URI SVG for a product. Deterministic, cached per product id. */
export function productArt(product) {
  if (cache.has(product.id)) return cache.get(product.id);
  const accent = accentFor(product.name);
  const draw = DRAW[product.category] ?? DRAW.peripherals;
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 150" font-family="Rubik,Arial,sans-serif">${DEFS}
    <rect width="200" height="150" fill="#f4f6f9"/><circle cx="100" cy="75" r="62" fill="${accent}" opacity=".10"/>
    ${draw(accent, labels(product), product)}</svg>`;
  const uri = `data:image/svg+xml;charset=utf-8,${encodeURIComponent(svg)}`;
  cache.set(product.id, uri);
  return uri;
}
