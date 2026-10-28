import { test } from 'node:test';
import assert from 'node:assert/strict';
import { detectSocket, detectRamType, isCompatible, issues, requiredRam } from '../src/core/compat.js';
import { byId, selection } from './helpers.js';

test('socket detection: attribute, name, "Core Ultra", chipset', () => {
  assert.equal(detectSocket(byId('cpu-r5-5600')), 'AM4'); // attribute
  assert.equal(detectSocket(byId('cpu-r7-5700x')), 'AM4'); // written in the name
  assert.equal(detectSocket(byId('cpu-ultra5-245k')), 'LGA1851'); // Core Ultra family
  assert.equal(detectSocket(byId('mb-b450m-pro')), 'AM4'); // chipset only
  assert.equal(detectSocket(byId('mb-x670e-pro')), 'AM5'); // chipset only
  assert.equal(detectSocket(byId('mb-z890-elite')), 'LGA1851'); // chipset only
  assert.equal(detectSocket(byId('gpu-rtx4060')), null); // unknown never blocks
});

test('memory type detection: attribute or name', () => {
  assert.equal(detectRamType(byId('ram-d4-16')), 'DDR4'); // attribute
  assert.equal(detectRamType(byId('ram-d5-32')), 'DDR5'); // name
  assert.equal(detectRamType(byId('mb-z890-elite')), 'DDR5'); // name
});

test('picking a CPU filters motherboards by socket (and vice versa)', () => {
  const am5 = selection({ cpu: 'cpu-r5-7600' });
  assert.equal(isCompatible(byId('mb-b650m-ds3h'), 'motherboard', am5), true);
  assert.equal(isCompatible(byId('mb-b550m-a'), 'motherboard', am5), false);

  const board = selection({ motherboard: 'mb-b550m-a' });
  assert.equal(isCompatible(byId('cpu-r5-5600'), 'cpu', board), true);
  assert.equal(isCompatible(byId('cpu-r5-7600'), 'cpu', board), false);
});

test('memory follows the socket: AM5 needs DDR5, AM4 needs DDR4', () => {
  assert.equal(requiredRam(selection({ cpu: 'cpu-r5-7600' })), 'DDR5');
  assert.equal(isCompatible(byId('ram-d4-16'), 'ram', selection({ cpu: 'cpu-r5-7600' })), false);
  assert.equal(isCompatible(byId('ram-d4-16'), 'ram', selection({ cpu: 'cpu-r5-5600' })), true);
});

test('LGA1700 is the special case: the motherboard decides DDR4 vs DDR5', () => {
  const cpuOnly = selection({ cpu: 'cpu-i5-12400f' });
  assert.equal(requiredRam(cpuOnly), null); // undecided: show everything
  assert.equal(isCompatible(byId('ram-d4-16'), 'ram', cpuOnly), true);
  assert.equal(isCompatible(byId('ram-d5-16'), 'ram', cpuOnly), true);

  const withD4Board = selection({ cpu: 'cpu-i5-12400f', motherboard: 'mb-b760m-d4' });
  assert.equal(isCompatible(byId('ram-d4-16'), 'ram', withD4Board), true);
  assert.equal(isCompatible(byId('ram-d5-16'), 'ram', withD4Board), false);

  const withD5Board = selection({ cpu: 'cpu-i5-12400f', motherboard: 'mb-b760m-d5' });
  assert.equal(isCompatible(byId('ram-d5-16'), 'ram', withD5Board), true);
});

test('issues() reports conflicts in a built selection, and stays quiet for a valid one', () => {
  assert.deepEqual(issues(selection({ cpu: 'cpu-r5-7600', motherboard: 'mb-b650m-ds3h', ram: [['ram-d5-32', 1]] })), []);

  const wrongBoard = issues(selection({ cpu: 'cpu-r5-7600', motherboard: 'mb-b550m-a' }));
  assert.match(wrongBoard[0], /AM5.*AM4/);

  const wrongRam = issues(selection({ cpu: 'cpu-r5-7600', motherboard: 'mb-b650m-ds3h', ram: [['ram-d4-16', 1]] }));
  assert.match(wrongRam[0], /DDR4.*DDR5/);
});

test('missing data never creates a false conflict', () => {
  assert.equal(isCompatible(byId('gpu-rtx4060'), 'gpu', selection({ cpu: 'cpu-r5-7600' })), true);
  assert.deepEqual(issues({}), []);
});
