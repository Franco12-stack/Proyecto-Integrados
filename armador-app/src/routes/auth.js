const express = require('express');
const axios = require('axios');
const { saveToken } = require('../db/tokens');

const router = express.Router();

// Tienda Nube redirige acá después de que el comerciante instala/autoriza la app
router.get('/callback', async (req, res) => {
  const { code } = req.query;
  if (!code) return res.status(400).send('Falta el parámetro "code"');

  try {
    const { data } = await axios.post('https://www.tiendanube.com/apps/authorize/token', {
      client_id: process.env.TN_CLIENT_ID,
      client_secret: process.env.TN_CLIENT_SECRET,
      grant_type: 'authorization_code',
      code,
    });

    // data: { access_token, token_type, scope, user_id: store_id }
    saveToken(data.user_id, data.access_token, data.scope);

    res.send('App instalada correctamente. Ya podés cerrar esta ventana.');
  } catch (err) {
    console.error('Error en OAuth callback:', err.response?.data || err.message);
    res.status(500).send('Error autorizando la app');
  }
});

module.exports = router;
