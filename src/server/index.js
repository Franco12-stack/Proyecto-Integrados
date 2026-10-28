import { createApp } from './app.js';

const port = Number(process.env.PORT ?? 3000);
const rate = process.env.NATIVE_TRANSFER_RATE;

createApp({ rateOverride: rate === undefined ? undefined : Number(rate) }).listen(port, () => {
  console.log(`PCForge demo running on http://localhost:${port}`);
});
