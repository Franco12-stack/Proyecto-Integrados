const axios = require('axios');

/**
 * Reemplaza al proxy Vercel "tn-proxy" (GET /api/products?category_id=...) que ya
 * usaba el armador en producción — mismo contrato de entrada/salida, para no tener
 * que tocar el JS del frontend más de lo necesario.
 */
async function getProductsByCategory({ storeId, accessToken, categoryId, perPage = 200 }) {
  const { data } = await axios.get(
    `https://api.tiendanube.com/2025-03/${storeId}/products`,
    {
      params: { category_id: categoryId, per_page: perPage },
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'User-Agent': 'ArmadorApp (contacto@integradosargentinos.com)',
      },
    }
  );
  return data;
}

module.exports = { getProductsByCategory };
