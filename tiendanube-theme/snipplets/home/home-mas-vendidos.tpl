{# Sección "Más Vendidos" con tabs por categoría y carrusel #}
{% if sections.primary is defined and sections.primary.products is defined and sections.primary.products is not empty %}
<section class="section-home section-mas-vendidos-home py-4">
  <div class="container position-relative">

    <h2 class="js-products-featured-title h4 mb-3">Más Vendidos</h2>

    {# Tabs de categorías #}
    <div class="mv-tabs-wrapper mb-3">
      <div class="mv-tabs" role="tablist">
        <button class="mv-tab mv-tab-active" data-tab="todos" role="tab" aria-selected="true">Todos</button>
        <button class="mv-tab" data-tab="perifericos" role="tab" aria-selected="false">Periféricos</button>
        <button class="mv-tab" data-tab="notebooks" role="tab" aria-selected="false">Notebooks</button>
        <button class="mv-tab" data-tab="pcs" role="tab" aria-selected="false">PCs Armadas</button>
        <button class="mv-tab" data-tab="placas" role="tab" aria-selected="false">Placas de Video</button>
        <button class="mv-tab" data-tab="sillas" role="tab" aria-selected="false">Sillas Gamers</button>
        <button class="mv-tab" data-tab="monitores" role="tab" aria-selected="false">Monitores</button>
        <button class="mv-tab" data-tab="conectividad" role="tab" aria-selected="false">Conectividad</button>
      </div>
    </div>

    {# Carrusel Swiper con tarjetas nativas del tema #}
    <div class="js-swiper-mas-vendidos swiper-container">
      <div class="js-mv-grid swiper-wrapper flex-nowrap" id="mv-swiper-wrapper">
        {% for product in sections.primary.products %}
          {% set mv_first_cat = product.categories | first %}
          <div class="js-item-slide swiper-slide mv-slide" data-cat="{{ mv_first_cat ? (mv_first_cat.name | lower) : '' }}">
            {% include 'snipplets/product-item.tpl' with {'slide_item': true, 'section_name': 'primary'} %}
          </div>
        {% endfor %}
      </div>
    </div>

    {# Flechas de navegación #}
    <div class="js-swiper-mas-vendidos-prev swiper-button-prev svg-icon-text swiper-button-outside d-none d-md-block">
      <svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
    </div>
    <div class="js-swiper-mas-vendidos-next swiper-button-next svg-icon-text swiper-button-outside d-none d-md-block">
      <svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
    </div>

  </div>
</section>

<style>
.section-mas-vendidos-home { background: var(--main-background, #fff); }

.mv-tabs-wrapper {
  overflow-x: auto;
  scrollbar-width: none;
  border-bottom: 2px solid var(--main-foreground-opacity-10, #e0e0e0);
}
.mv-tabs-wrapper::-webkit-scrollbar { display: none; }

.mv-tabs {
  display: flex;
  gap: 0;
  min-width: max-content;
}

.mv-tab {
  background: none;
  border: none;
  border-bottom: 3px solid transparent;
  margin-bottom: -2px;
  padding: 8px 20px;
  font-family: var(--body-font, inherit);
  font-size: var(--font-small, 0.88rem);
  font-weight: 600;
  color: var(--main-foreground-opacity-60, #666);
  cursor: pointer;
  white-space: nowrap;
  transition: color 0.15s, border-color 0.15s;
}
.mv-tab:hover { color: var(--accent-color, #1565c0); }
.mv-tab.mv-tab-active {
  color: var(--accent-color, #1565c0);
  border-bottom-color: var(--accent-color, #1565c0);
}

.mv-slide { width: 220px; flex-shrink: 0; }
@media (max-width: 767px) { .mv-slide { width: 180px; } }

.mv-slide.mv-hidden { display: none !important; }
</style>

<script>
(function() {
  function initMVSwiper() {
    if (typeof Swiper === 'undefined') { setTimeout(initMVSwiper, 300); return; }
    new Swiper('.js-swiper-mas-vendidos', {
      slidesPerView: 'auto',
      spaceBetween: 12,
      freeMode: true,
      navigation: {
        nextEl: '.js-swiper-mas-vendidos-next',
        prevEl: '.js-swiper-mas-vendidos-prev',
      },
    });
  }
  initMVSwiper();

  /* Detectar categoría desde el título del producto (evita problemas de scope en Twig) */
  /* Mapea el nombre de categoría real de Tienda Nube al tab correspondiente */
  function mapCat(cat) {
    cat = (cat || '').toLowerCase();
    if (/placa|nvidia|geforce|radeon/.test(cat)) return 'placas';
    if (/notebook|laptop/.test(cat)) return 'notebooks';
    if (/mouse|teclado|auricular|headset|periferi|joystick|gamepad|micrófono|microfono|kit de teclado/.test(cat)) return 'perifericos';
    if (/pc armada|computadora|desktop|torre/.test(cat)) return 'pcs';
    if (/silla/.test(cat)) return 'sillas';
    if (/monitor/.test(cat)) return 'monitores';
    if (/conectividad|router|wifi/.test(cat)) return 'conectividad';
    return '';
  }

  var slides = document.querySelectorAll('.mv-slide');
  slides.forEach(function(slide) {
    slide.setAttribute('data-cat', mapCat(slide.getAttribute('data-cat')));
  });

  var tabs = document.querySelectorAll('.mv-tab');
  tabs.forEach(function(tab) {
    tab.addEventListener('click', function() {
      tabs.forEach(function(t) { t.classList.remove('mv-tab-active'); t.setAttribute('aria-selected', 'false'); });
      tab.classList.add('mv-tab-active');
      tab.setAttribute('aria-selected', 'true');
      var filter = tab.getAttribute('data-tab');
      slides.forEach(function(slide) {
        if (filter === 'todos' || slide.getAttribute('data-cat') === filter) {
          slide.classList.remove('mv-hidden');
        } else {
          slide.classList.add('mv-hidden');
        }
      });
    });
  });
})();
</script>
{% endif %}
