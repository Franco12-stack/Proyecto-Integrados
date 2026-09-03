const axios = require('axios');

function client(storeId, accessToken) {
  return axios.create({
    baseURL: `https://api.tiendanube.com/2025-03/${storeId}`,
    headers: {
      Authorization: `Bearer ${accessToken}`,
      'User-Agent': 'ArmadorApp (contacto@integradosargentinos.com)',
      'Content-Type': 'application/json; charset=utf-8',
    },
  });
}

/**
 * Crea un pedido en Tienda Nube con precios custom por línea (el precio de Odoo, no el de catálogo).
 * El pedido queda "open"/pendiente de pago; el checkout_url se le pasa al cliente para
 * que complete datos y método de envío/pago. La integración Tienda Nube↔Odoo ya existente
 * se encarga de sincronizarlo una vez creado.
 *
 * items: [{ variant_id, quantity, price, name }]
 */
async function createDraftOrder({ storeId, accessToken, customer, items, note }) {
  const tn = client(storeId, accessToken);

  const payload = {
    customer,
    products: items.map((item) => ({
      variant_id: item.variant_id,
      quantity: item.quantity,
      price: item.price, // precio custom (de Odoo), pisa el precio de catálogo
      name: item.name,
    })),
    note,
    status: 'open',
    payment_status: 'pending',
    gateway: 'other',
  };

  const { data } = await tn.post('/orders', payload);

  // Tienda Nube expone la URL de checkout del pedido para que el cliente termine la compra
  return {
    order: data,
    checkoutUrl: data.checkout_url || `https://www.tiendanube.com/checkout/order/${data.id}`,
  };
}

module.exports = { createDraftOrder };
