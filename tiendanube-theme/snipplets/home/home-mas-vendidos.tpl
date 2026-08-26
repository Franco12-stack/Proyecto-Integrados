{# Sección "Más Vendidos" con tabs por categoría #}
{% if sections.primary.products %}
<section class="section-home section-mas-vendidos-home py-5">
  <div class="container">

    <h2 class="mas-vendidos-title">Más Vendidos</h2>

    {# Tabs de categorías #}
    <div class="mv-tabs-wrapper">
      <div class="mv-tabs" role="tablist">
        <button class="mv-tab mv-tab-active" data-tab="todos" role="tab" aria-selected="true">Todos</button>
        <button class="mv-tab" data-tab="perifericos" role="tab" aria-selected="false">Periféricos</button>
        <button class="mv-tab" data-tab="notebooks" role="tab" aria-selected="false">Notebooks</button>
        <button class="mv-tab" data-tab="procesadores" role="tab" aria-selected="false">Procesadores</button>
        <button class="mv-tab" data-tab="conectividad" role="tab" aria-selected="false">Conectividad</button>
        <button class="mv-tab" data-tab="sillas" role="tab" aria-selected="false">Sillas Gamers</button>
      </div>
    </div>

    {# Grid de productos #}
    <div class="mv-products-grid" id="mv-grid">
      {% for product in sections.primary.products %}
        {% set cat_slug = '' %}
        {% for cat in product.categories %}
          {% set cat_name_lower = cat.name | lower %}
          {% if 'periferico' in cat_name_lower or 'teclado' in cat_name_lower or 'mouse' in cat_name_lower or 'auricular' in cat_name_lower or 'headset' in cat_name_lower %}
            {% set cat_slug = 'perifericos' %}
          {% elseif 'notebook' in cat_name_lower or 'laptop' in cat_name_lower %}
            {% set cat_slug = 'notebooks' %}
          {% elseif 'procesador' in cat_name_lower or 'cpu' in cat_name_lower or 'ryzen' in cat_name_lower or 'intel' in cat_name_lower %}
            {% set cat_slug = 'procesadores' %}
          {% elseif 'conectividad' in cat_name_lower or 'red' in cat_name_lower or 'router' in cat_name_lower or 'switch' in cat_name_lower %}
            {% set cat_slug = 'conectividad' %}
          {% elseif 'silla' in cat_name_lower or 'gamer' in cat_name_lower %}
            {% set cat_slug = 'sillas' %}
          {% endif %}
        {% endfor %}

        <div class="mv-product-card" data-cat="{{ cat_slug }}">
          <a href="{{ product.url }}" class="mv-product-link">
            <div class="mv-product-image-wrap">
              {% if product.featured_image %}
                <img
                  src="{{ product.featured_image | product_image_url('300x300') }}"
                  alt="{{ product.name }}"
                  class="mv-product-img"
                  loading="lazy"
                />
              {% else %}
                <div class="mv-product-img-placeholder"></div>
              {% endif %}
            </div>
            <div class="mv-product-info">
              <p class="mv-product-name">{{ product.name }}</p>
              <p class="mv-product-price">
                {% if product.compare_at_price and product.compare_at_price > product.price %}
                  <span class="mv-price-old">{{ product.compare_at_price | money }}</span>
                {% endif %}
                <span class="mv-price-main">{{ product.price | money }}</span>
              </p>
            </div>
          </a>
        </div>
      {% endfor %}
    </div>

  </div>
</section>

<style>
.section-mas-vendidos-home { background: #fff; }
.mas-vendidos-title {
  font-size: 1.6rem;
  font-weight: 700;
  color: #111;
  margin-bottom: 1.2rem;
  text-align: center;
}
.mv-tabs-wrapper { overflow-x: auto; padding-bottom: 4px; margin-bottom: 1.5rem; }
.mv-tabs {
  display: flex;
  gap: 8px;
  min-width: max-content;
  border-bottom: 2px solid #e0e0e0;
  padding-bottom: 0;
}
.mv-tab {
  background: none;
  border: none;
  border-bottom: 3px solid transparent;
  margin-bottom: -2px;
  padding: 8px 18px;
  font-size: 0.97rem;
  font-weight: 600;
  color: #555;
  cursor: pointer;
  border-radius: 4px 4px 0 0;
  transition: color 0.2s, border-color 0.2s;
  white-space: nowrap;
}
.mv-tab:hover { color: #1565c0; }
.mv-tab.mv-tab-active { color: #1565c0; border-bottom-color: #1565c0; }
.mv-products-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}
@media (max-width: 991px) { .mv-products-grid { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 600px) { .mv-products-grid { grid-template-columns: repeat(2, 1fr); } }
.mv-product-card { display: block; transition: opacity 0.2s; }
.mv-product-card.mv-hidden { display: none; }
.mv-product-link {
  display: block;
  border: 1px solid #e8e8e8;
  border-radius: 10px;
  overflow: hidden;
  text-decoration: none;
  color: inherit;
  transition: box-shadow 0.2s, transform 0.2s;
  background: #fafafa;
}
.mv-product-link:hover { box-shadow: 0 4px 16px rgba(21,101,192,0.12); transform: translateY(-2px); }
.mv-product-image-wrap {
  width: 100%;
  aspect-ratio: 1/1;
  overflow: hidden;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
}
.mv-product-img { width: 100%; height: 100%; object-fit: contain; }
.mv-product-img-placeholder { width: 100%; height: 100%; background: #f0f0f0; }
.mv-product-info { padding: 10px 12px 14px; }
.mv-product-name {
  font-size: 0.88rem;
  color: #222;
  margin-bottom: 6px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.mv-product-price { display: flex; flex-direction: column; gap: 2px; }
.mv-price-old { font-size: 0.78rem; color: #999; text-decoration: line-through; }
.mv-price-main { font-size: 1.05rem; font-weight: 700; color: #1565c0; }
</style>

<script>
(function() {
  var tabs = document.querySelectorAll('.mv-tab');
  var cards = document.querySelectorAll('.mv-product-card');
  tabs.forEach(function(tab) {
    tab.addEventListener('click', function() {
      tabs.forEach(function(t) { t.classList.remove('mv-tab-active'); t.setAttribute('aria-selected','false'); });
      tab.classList.add('mv-tab-active');
      tab.setAttribute('aria-selected','true');
      var filter = tab.getAttribute('data-tab');
      cards.forEach(function(card) {
        if (filter === 'todos' || card.getAttribute('data-cat') === filter) {
          card.classList.remove('mv-hidden');
        } else {
          card.classList.add('mv-hidden');
        }
      });
    });
  });
})();
</script>
{% endif %}
