{# Sección "Más Vendidos" con tabs dinámicos por categoría y carrusel #}
{% if sections.primary is defined and sections.primary.products is defined and sections.primary.products is not empty %}
<section class="section-home section-mas-vendidos-home py-4">
  <div class="container position-relative">

    <h2 class="js-products-featured-title h4 mb-3">Más Vendidos</h2>

    {# Solo el tab "Todos" — el JS agrega los demás dinámicamente #}
    <div class="mv-tabs-wrapper mb-3">
      <div class="mv-tabs" id="mv-tabs-list" role="tablist">
        <button class="mv-tab mv-tab-active" data-tab="todos" role="tab" aria-selected="true">Todos</button>
      </div>
    </div>

    {# Carrusel Swiper con tarjetas nativas del tema #}
    <div class="js-swiper-mas-vendidos swiper-container">
      <div class="js-mv-grid swiper-wrapper flex-nowrap" id="mv-swiper-wrapper">
        {% for product in sections.primary.products %}
          {%- set _n = product.name | lower -%}
          {%- if 'placa de video' in _n or 'rtx' in _n or 'radeon rx' in _n or 'geforce' in _n or ' rx ' in _n -%}
            {%- set _cat = 'placas' -%}
          {%- elseif 'notebook' in _n or 'laptop' in _n -%}
            {%- set _cat = 'notebooks' -%}
          {%- elseif 'silla' in _n -%}
            {%- set _cat = 'sillas' -%}
          {%- elseif 'monitor' in _n -%}
            {%- set _cat = 'monitores' -%}
          {%- elseif 'mouse' in _n or 'teclado' in _n or 'auricular' in _n or 'headset' in _n or 'micr' in _n or 'webcam' in _n or 'joystick' in _n or 'gamepad' in _n -%}
            {%- set _cat = 'perifericos' -%}
          {%- elseif 'pc amd' in _n or 'pc intel' in _n or 'pc gamer' in _n or 'pc ryzen' in _n or 'computadora' in _n or 'desktop' in _n -%}
            {%- set _cat = 'pcs' -%}
          {%- elseif 'procesador' in _n or 'ryzen' in _n or 'core i' in _n or 'intel core' in _n -%}
            {%- set _cat = 'procesadores' -%}
          {%- elseif 'mother' in _n or 'placa madre' in _n or 'motherboard' in _n -%}
            {%- set _cat = 'motherboards' -%}
          {%- elseif 'almacenamiento' in _n or ' ssd' in _n or ' hdd' in _n or 'disco' in _n or 'pendrive' in _n -%}
            {%- set _cat = 'almacenamiento' -%}
          {%- elseif 'fuente' in _n or 'psu' in _n -%}
            {%- set _cat = 'fuentes' -%}
          {%- elseif 'memoria ram' in _n or ' ram ' in _n -%}
            {%- set _cat = 'memorias' -%}
          {%- elseif 'router' in _n or 'wifi' in _n or 'conectividad' in _n -%}
            {%- set _cat = 'conectividad' -%}
          {%- else -%}
            {%- set _cat = '' -%}
          {%- endif -%}
          <div class="js-item-slide swiper-slide mv-slide" data-cat="{{ _cat }}">
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

  /* Etiquetas legibles por clave de categoría */
  var catLabels = {
    'placas':        'Placas de Video',
    'notebooks':     'Notebooks',
    'sillas':        'Sillas Gamers',
    'monitores':     'Monitores',
    'perifericos':   'Periféricos',
    'pcs':           'PCs Armadas',
    'procesadores':  'Procesadores',
    'motherboards':  'Motherboards',
    'almacenamiento':'Almacenamiento',
    'fuentes':       'Fuentes',
    'memorias':      'Memorias RAM',
    'conectividad':  'Conectividad'
  };

  /* Orden preferido de los tabs */
  var catOrder = ['pcs','procesadores','placas','notebooks','memorias','motherboards','almacenamiento','fuentes','monitores','perifericos','sillas','conectividad'];

  var slides = document.querySelectorAll('.mv-slide');
  var tabsList = document.getElementById('mv-tabs-list');

  /* Detectar categorías presentes */
  var usedCats = {};
  slides.forEach(function(s) {
    var c = s.getAttribute('data-cat');
    if (c) usedCats[c] = true;
  });

  /* Generar tabs en el orden definido */
  catOrder.forEach(function(cat) {
    if (!usedCats[cat]) return;
    var btn = document.createElement('button');
    btn.className = 'mv-tab';
    btn.setAttribute('data-tab', cat);
    btn.setAttribute('role', 'tab');
    btn.setAttribute('aria-selected', 'false');
    btn.textContent = catLabels[cat] || cat;
    tabsList.appendChild(btn);
  });

  /* Agregar cualquier categoría no contemplada en catOrder */
  Object.keys(usedCats).forEach(function(cat) {
    if (catOrder.indexOf(cat) === -1) {
      var btn = document.createElement('button');
      btn.className = 'mv-tab';
      btn.setAttribute('data-tab', cat);
      btn.setAttribute('role', 'tab');
      btn.setAttribute('aria-selected', 'false');
      btn.textContent = catLabels[cat] || cat;
      tabsList.appendChild(btn);
    }
  });

  /* Lógica de filtrado */
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
