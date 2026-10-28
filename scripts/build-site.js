// Assembles a fully static copy of the demo in ./site (used for GitHub Pages).
// The pages are tagged so the front-end uses its in-browser API instead of probing for a backend.
import { cpSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const site = join(root, 'site');

rmSync(site, { recursive: true, force: true });
mkdirSync(site, { recursive: true });
cpSync(join(root, 'src', 'web'), site, { recursive: true });
cpSync(join(root, 'src', 'core'), join(site, 'core'), { recursive: true });
cpSync(join(root, 'src', 'server', 'data'), join(site, 'data'), { recursive: true });
writeFileSync(join(site, '.nojekyll'), '');

for (const page of ['index.html', 'checkout.html']) {
  const file = join(site, page);
  const html = readFileSync(file, 'utf8');
  if (!html.includes('<meta charset="utf-8">')) throw new Error(`${page}: expected charset meta to anchor the mode tag`);
  writeFileSync(file, html.replace('<meta charset="utf-8">', '<meta charset="utf-8">\n  <meta name="pcforge-mode" content="static">'));
}

console.log(`Static site written to ${site}`);
