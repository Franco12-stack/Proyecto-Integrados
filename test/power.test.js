import { test } from 'node:test';
import assert from 'node:assert/strict';
import { cpuWatts, gpuWatts, estimateWatts, recommendedPsu, parsePsuWatts } from '../src/core/power.js';
import { selection } from './helpers.js';

test('cpuWatts by family; "K" Core Ultra parts draw more', () => {
  assert.equal(cpuWatts('AMD Ryzen 9 7950X'), 125);
  assert.equal(cpuWatts('Intel Core i7-14700K'), 105);
  assert.equal(cpuWatts('AMD Ryzen 5 5600'), 65);
  assert.equal(cpuWatts('Intel Core i3-10100'), 58);
  assert.equal(cpuWatts('Intel Core Ultra 5 245K'), 125);
  assert.equal(cpuWatts('Intel Core Ultra 5 225'), 65);
});

test('gpuWatts picks the most specific model ("4070 Ti" before "4070")', () => {
  assert.equal(gpuWatts('GeForce RTX 4070 Ti'), 285);
  assert.equal(gpuWatts('GeForce RTX 4070 Super'), 200);
  assert.equal(gpuWatts('Radeon RX 7900 XTX'), 355);
  assert.equal(gpuWatts('Mystery card'), 150); // unknown -> conservative default
});

test('estimateWatts adds the components plus the system base; empty build is 0', () => {
  assert.equal(estimateWatts({}), 0);

  const build = selection({
    cpu: 'cpu-r5-7600', // 65
    motherboard: 'mb-b650m-ds3h', // 50
    ram: [['ram-d5-32', 1]], // 7 * 2 modules
    storage: [['ssd-sn580-1tb', 1]], // 7
    gpu: 'gpu-rtx4060', // 115
    case: 'case-h510', // 15
  });
  assert.equal(estimateWatts(build), 65 + 50 + 14 + 7 + 115 + 15 + 20);
});

test('recommendedPsu leaves 30% headroom and rounds up to a real PSU size', () => {
  assert.equal(recommendedPsu(300), 450); // 390 -> 450
  assert.equal(recommendedPsu(400), 550); // 520 -> 550
  assert.equal(recommendedPsu(600), 850); // 780 -> 850
  assert.equal(recommendedPsu(5000), 1200); // caps at the biggest size
});

test('parsePsuWatts reads the wattage from the product name', () => {
  assert.equal(parsePsuWatts('Corsair RM750e 750W 80+ Gold'), 750);
  assert.equal(parsePsuWatts('Seasonic Focus GX-850 850W 80+ Gold'), 850);
  assert.equal(parsePsuWatts('Mystery PSU'), 0);
});
