export const CATEGORIES = [
  { key: 'cpu', label: 'Processor', required: true },
  { key: 'motherboard', label: 'Motherboard', required: true },
  { key: 'ram', label: 'Memory', required: true, multi: true },
  { key: 'storage', label: 'Storage', required: true, multi: true },
  { key: 'gpu', label: 'Graphics card' },
  { key: 'cooling', label: 'Cooling' },
  { key: 'case', label: 'Case' },
  { key: 'psu', label: 'Power supply' },
  { key: 'os', label: 'Operating system' },
  { key: 'connectivity', label: 'Connectivity' },
  { key: 'monitor', label: 'Monitor', multi: true },
  { key: 'peripherals', label: 'Peripherals', multi: true },
];

export const MAX_QTY = 4;
