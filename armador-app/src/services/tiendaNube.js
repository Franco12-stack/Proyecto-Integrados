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
 * Crea un "draft order" (Orden preliminar) en Tienda Nube y devuelve su checkout_url.
 *
 * Importante: el endpoint POST /draft_orders NO acepta precio custom por línea
 * (solo variant_id, quantity, properties) — el precio de cada línea sale del
 * catálogo de Tienda Nube. Para que el total coincida con el precio de Odoo,
 * calculamos la diferencia (catálogo - Odoo) y la mandamos como `discount`
 * (monto absoluto) a nivel de todo el pedido.
 *
 * items: [{ variant_id, quantity, catalogPrice, odooPrice }]
 * customer: { name, lastname, email, phone? }
 */
async function createDraftOrder({ storeId, accessToken, customer, items, note }) {
  const tn = client(storeId, accessToken);

  const catalogSubtotal = items.reduce(
    (acc, item) => acc + item.catalogPrice * item.quantity,
    0
  );
  const odooSubtotal = items.reduce(
    (acc, item) => acc + item.odooPrice * item.quantity,
    0
  );
  const discount = Math.max(0, catalogSubtotal - odooSubtotal);

  const payload = {
    contact_name: customer.name,
    contact_lastname: customer.lastname,
    contact_email: customer.email,
    contact_phone: customer.phone,
    payment_status: 'unpaid',
    products: items.map((item) => ({
      variant_id: item.variant_id,
      quantity: item.quantity,
    })),
    discount: discount.toFixed(2),
    discount_type: 'absolute',
    note,
  };

  const { data } = await tn.post('/draft_orders', payload);

  return {
    draftOrder: data,
    checkoutUrl: data.checkout_url,
  };
}

module.exports = { createDraftOrder };
