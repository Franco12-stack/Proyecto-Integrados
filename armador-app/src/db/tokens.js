const Database = require('better-sqlite3');
const path = require('path');
const fs = require('fs');

const file = process.env.DATABASE_FILE || './data/store_tokens.sqlite';
fs.mkdirSync(path.dirname(file), { recursive: true });

const db = new Database(file);
db.exec(`
  CREATE TABLE IF NOT EXISTS store_tokens (
    store_id TEXT PRIMARY KEY,
    access_token TEXT NOT NULL,
    scope TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
  )
`);

function saveToken(storeId, accessToken, scope) {
  db.prepare(`
    INSERT INTO store_tokens (store_id, access_token, scope)
    VALUES (?, ?, ?)
    ON CONFLICT(store_id) DO UPDATE SET access_token = excluded.access_token, scope = excluded.scope
  `).run(String(storeId), accessToken, scope);
}

function getToken(storeId) {
  return db.prepare('SELECT * FROM store_tokens WHERE store_id = ?').get(String(storeId));
}

module.exports = { saveToken, getToken };
