/**
 * Component compatibility engine.
 *
 * Product metadata in real catalogs is patchy, so detection is layered:
 * explicit attribute first, then the socket/memory type written in the name,
 * then inference from the chipset. Unknown data never blocks a product — we
 * only hide or warn when we are sure of a conflict.
 *
 * A selection is `{ [category]: [{ product, qty }] }`.
 */

const SOCKETS = ['AM5', 'AM4', 'LGA1851', 'LGA1700', 'LGA1200'];

// The optional trailing letter is the board size/variant ("B450M", "H610I"), glued to the chipset.
const CHIPSET_TO_SOCKET = [
  [/\b(Z890|B860|H810|W880)[A-Z]?\b/i, 'LGA1851'],
  [/\b(Z790|B760|H770|H610|Z690|B660|H670)[A-Z]?\b/i, 'LGA1700'],
  [/\b(Z590|B560|H570|H510|Z490|B460|H470)[A-Z]?\b/i, 'LGA1200'],
  [/\b(X670E?|B650E?|A620)[A-Z]?\b/i, 'AM5'],
  [/\b(X570|B550|A520|B450|X470|B350|A320)[A-Z]?\b/i, 'AM4'],
];

/** Memory generation each socket forces. LGA1700 boards exist in both flavours. */
export const RAM_BY_SOCKET = {
  AM4: 'DDR4',
  AM5: 'DDR5',
  LGA1200: 'DDR4',
  LGA1851: 'DDR5',
  LGA1700: null,
};

const textOf = (p) => `${p.name} ${p.description ?? ''}`;
const firstOf = (selection, category) => selection[category]?.[0]?.product ?? null;

export function detectSocket(product) {
  if (product.attributes?.socket) return product.attributes.socket;
  const text = textOf(product);
  for (const socket of SOCKETS) if (text.includes(socket)) return socket;
  if (/Core\s*Ultra/i.test(text)) return 'LGA1851';
  for (const [pattern, socket] of CHIPSET_TO_SOCKET) if (pattern.test(text)) return socket;
  return null;
}

export function detectRamType(product) {
  if (product.attributes?.ramType) return product.attributes.ramType;
  const match = textOf(product).match(/DDR[345]/i);
  return match ? match[0].toUpperCase() : null;
}

/**
 * The memory generation the current build requires, or null if undecided.
 * The board has the final say (it covers LGA1700 DDR4-vs-DDR5 boards);
 * otherwise the CPU socket decides.
 */
export function requiredRam(selection) {
  const board = firstOf(selection, 'motherboard');
  const boardRam = board && detectRamType(board);
  if (boardRam) return boardRam;
  const cpu = firstOf(selection, 'cpu');
  const socket = cpu && detectSocket(cpu);
  return (socket && RAM_BY_SOCKET[socket]) || null;
}

const sameSocket = (a, b) => {
  const sa = detectSocket(a);
  const sb = detectSocket(b);
  return !sa || !sb || sa === sb;
};

/** Can `candidate` be added to `selection` without a known conflict? */
export function isCompatible(candidate, category, selection) {
  if (category === 'motherboard') {
    const cpu = firstOf(selection, 'cpu');
    return !cpu || sameSocket(cpu, candidate);
  }
  if (category === 'cpu') {
    const board = firstOf(selection, 'motherboard');
    return !board || sameSocket(board, candidate);
  }
  if (category === 'ram') {
    const need = requiredRam(selection);
    const type = detectRamType(candidate);
    return !need || !type || need === type;
  }
  return true;
}

/** Human-readable conflicts in the current selection. */
export function issues(selection) {
  const found = [];
  const cpu = firstOf(selection, 'cpu');
  const board = firstOf(selection, 'motherboard');

  if (cpu && board) {
    const a = detectSocket(cpu);
    const b = detectSocket(board);
    if (a && b && a !== b) found.push(`CPU socket (${a}) does not match motherboard socket (${b})`);
  }

  const need = requiredRam(selection);
  for (const { product } of selection.ram ?? []) {
    const type = detectRamType(product);
    if (need && type && type !== need) {
      found.push(`${type} memory is incompatible: this platform requires ${need}`);
      break;
    }
  }
  return found;
}
