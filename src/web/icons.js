/** Line icons for the category tabs and the empty summary rows (24x24, stroke = currentColor). */
const P = {
  cpu: '<rect x="7" y="7" width="10" height="10" rx="1.5"/><rect x="10" y="10" width="4" height="4"/><path d="M9 7V4M12 7V4M15 7V4M9 20v-3M12 20v-3M15 20v-3M7 9H4M7 12H4M7 15H4M20 9h-3M20 12h-3M20 15h-3"/>',
  motherboard: '<rect x="3" y="3" width="18" height="18" rx="2"/><rect x="6" y="6" width="6" height="6" rx="1"/><path d="M15 6v7M18 6v7M6 16h12M6 19h8"/>',
  ram: '<rect x="2" y="9" width="20" height="8" rx="1.5"/><path d="M6 9V6M10 9V6M14 9V6M18 9V6M7 17v2M12 17v2M17 17v2"/>',
  storage: '<rect x="4" y="3" width="16" height="18" rx="2"/><circle cx="12" cy="12" r="4"/><circle cx="12" cy="12" r="1"/><path d="M15 9l3-3"/>',
  gpu: '<rect x="2" y="7" width="20" height="10" rx="2"/><circle cx="8" cy="12" r="3"/><circle cx="16" cy="12" r="3"/><path d="M6 17v3M10 17v3M14 17v3"/>',
  cooling: '<circle cx="12" cy="12" r="9"/><path d="M12 12c0-4 3-6 5-5M12 12c3 3 1 6-1 6.5M12 12c-4-1-5-4-4-5.5"/><circle cx="12" cy="12" r="1.2"/>',
  case: '<rect x="6" y="2" width="12" height="20" rx="2"/><circle cx="12" cy="7" r="2"/><path d="M9 13h6M9 16h6M9 19h6"/>',
  psu: '<rect x="2" y="6" width="20" height="12" rx="2"/><circle cx="9" cy="12" r="3.5"/><path d="M15 9h5M15 12h5M15 15h5"/>',
  os: '<rect x="3" y="4" width="18" height="13" rx="2"/><path d="M8 21h8M12 17v4"/><path d="M7.5 8h4v3h-4zM12.5 8h4v3h-4z"/>',
  connectivity: '<path d="M3 9a14 14 0 0 1 18 0M6 12.5a9 9 0 0 1 12 0M9 16a4.5 4.5 0 0 1 6 0"/><circle cx="12" cy="19.5" r="1" fill="currentColor"/>',
  monitor: '<rect x="2" y="4" width="20" height="13" rx="1.5"/><path d="M8 21h8M12 17v4"/>',
  peripherals: '<rect x="2" y="9" width="14" height="8" rx="1.5"/><path d="M5 12h.01M8 12h.01M11 12h.01M5 15h6"/><rect x="18" y="8" width="4" height="9" rx="2"/>',
};

export const icon = (key, size = 18) =>
  `<svg viewBox="0 0 24 24" width="${size}" height="${size}" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${P[key] ?? ''}</svg>`;
