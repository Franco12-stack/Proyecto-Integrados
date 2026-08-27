{# Carrusel de categorías — card grande PC + grilla 2×4 con paginación #}
<section class="section-home section-categorias-grid py-5">
  <div class="container">

    <div class="catg-header">
      <h2 class="catg-title">Explorá nuestras <strong>categorías</strong></h2>
      <div class="catg-arrows">
        <button class="catg-arrow" id="catg-prev" aria-label="Anterior">&#8249;</button>
        <button class="catg-arrow" id="catg-next" aria-label="Siguiente">&#8250;</button>
      </div>
    </div>

    {# Páginas de categorías — cada página: 1 grande + 8 pequeñas #}
    <div class="catg-pages-wrapper">

      {# PÁGINA 1 #}
      <div class="catg-page catg-page-active">
        <div class="catg-page-inner">

          {# Card grande #}
          <a href="/pc2/" class="catg-card catg-card-featured">
            <img src="{{ 'cat-pc-escritorios.jpg' | static_url }}" alt="PC de Escritorio" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
            <div class="catg-placeholder catg-placeholder-featured" style="display:none">
              <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.3"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
            </div>
            <div class="catg-overlay"><span class="catg-label-featured">PC DE ESCRITORIO</span></div>
          </a>

          {# Grilla 2×4 #}
          <div class="catg-small-grid">

            <a href="/monitores/" class="catg-card catg-card-small">
              <img src="{{ 'cat-monitores.jpg' | static_url }}" alt="Monitores" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">MONITORES</span></div>
            </a>

            <a href="/notebooks/" class="catg-card catg-card-small">
              <img src="{{ 'cat-notebooks.jpg' | static_url }}" alt="Notebooks" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><rect x="2" y="4" width="20" height="14" rx="2"/><line x1="2" y1="22" x2="22" y2="22"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">NOTEBOOKS</span></div>
            </a>

            <a href="/memorias-ram/" class="catg-card catg-card-small">
              <img src="{{ 'cat-memoria-ram.jpg' | static_url }}" alt="Memorias RAM" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><rect x="1" y="8" width="22" height="8" rx="1"/><line x1="6" y1="8" x2="6" y2="16"/><line x1="10" y1="8" x2="10" y2="16"/><line x1="14" y1="8" x2="14" y2="16"/><line x1="18" y1="8" x2="18" y2="16"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">MEMORIAS RAM</span></div>
            </a>

            <a href="/mothers/" class="catg-card catg-card-small">
              <img src="{{ 'cat-mother.jpg' | static_url }}" alt="Mothers" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><rect x="2" y="2" width="20" height="20" rx="2"/><rect x="8" y="8" width="8" height="8"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">MOTHERS</span></div>
            </a>

            <a href="/fuentes/" class="catg-card catg-card-small">
              <img src="{{ 'cat-fuentes.jpg' | static_url }}" alt="Fuentes" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">FUENTES</span></div>
            </a>

            <a href="/otros/sillas-y-escritorios/" class="catg-card catg-card-small">
              <img src="{{ 'cat-sillas.jpg' | static_url }}" alt="Sillas Gamers" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><path d="M12 2C6 2 4 7 4 12v4h16v-4c0-5-2-10-8-10z"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">SILLAS GAMERS</span></div>
            </a>

            <a href="/perifericos/" class="catg-card catg-card-small">
              <img src="{{ 'cat-perifericos.jpg' | static_url }}" alt="Periféricos" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><rect x="5" y="2" width="14" height="20" rx="2"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">PERIFÉRICOS</span></div>
            </a>

            <a href="/almacenamiento/" class="catg-card catg-card-small">
              <img src="{{ 'cat-almacenamiento.jpg' | static_url }}" alt="Almacenamiento" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">ALMACENAMIENTO</span></div>
            </a>

          </div>{# fin grilla #}
        </div>
      </div>{# fin página 1 #}

      {# PÁGINA 2 #}
      <div class="catg-page">
        <div class="catg-page-inner">

          <a href="/procesadores/" class="catg-card catg-card-featured">
            <img src="{{ 'cat-procesadores.jpg' | static_url }}" alt="Procesadores" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
            <div class="catg-placeholder catg-placeholder-featured" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.3"><rect x="4" y="4" width="16" height="16" rx="1"/><rect x="9" y="9" width="6" height="6"/></svg></div>
            <div class="catg-overlay"><span class="catg-label-featured">PROCESADORES</span></div>
          </a>

          <div class="catg-small-grid">

            <a href="/placas-de-video/" class="catg-card catg-card-small">
              <img src="{{ 'cat-placas-video.jpg' | static_url }}" alt="Placas de Video" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><rect x="1" y="6" width="22" height="12" rx="2"/><circle cx="8" cy="12" r="2"/><circle cx="16" cy="12" r="2"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">PLACAS DE VIDEO</span></div>
            </a>

            <a href="/gabinetes/" class="catg-card catg-card-small">
              <img src="{{ 'cat-gabinete.jpg' | static_url }}" alt="Gabinetes" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><rect x="3" y="2" width="12" height="20" rx="2"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">GABINETES</span></div>
            </a>

            <a href="/impresoras/" class="catg-card catg-card-small">
              <img src="{{ 'cat-impresora.jpg' | static_url }}" alt="Impresoras" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">IMPRESORAS</span></div>
            </a>

            <a href="/conectividad-y-redes/" class="catg-card catg-card-small">
              <img src="{{ 'cat-conectividad.jpg' | static_url }}" alt="Conectividad" class="catg-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
              <div class="catg-placeholder" style="display:none"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><path d="M5 12.55a11 11 0 0 1 14.08 0"/><path d="M1.42 9a16 16 0 0 1 21.16 0"/><path d="M8.53 16.11a6 6 0 0 1 6.95 0"/><circle cx="12" cy="20" r="1" fill="#fff"/></svg></div>
              <div class="catg-overlay"><span class="catg-label">CONECTIVIDAD</span></div>
            </a>

            {# 4 celdas vacías para completar la grilla si hacen falta #}
            <div class="catg-card-empty"></div>
            <div class="catg-card-empty"></div>
            <div class="catg-card-empty"></div>
            <div class="catg-card-empty"></div>

          </div>
        </div>
      </div>{# fin página 2 #}

    </div>{# fin pages-wrapper #}

    {# Dots #}
    <div class="catg-dots">
      <span class="catg-dot catg-dot-active" data-page="0"></span>
      <span class="catg-dot" data-page="1"></span>
    </div>

  </div>
</section>

<style>
.section-categorias-grid { background: #f5f7fa; }

.catg-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1.2rem;
}
.catg-title {
  font-size: 1.4rem;
  font-weight: 400;
  color: #111;
  margin: 0;
}
.catg-title strong { font-weight: 800; }

.catg-arrows { display: flex; gap: 6px; }
.catg-arrow {
  width: 36px; height: 36px;
  border: 2px solid #1565c0;
  border-radius: 8px;
  background: #fff;
  color: #1565c0;
  font-size: 1.4rem;
  line-height: 1;
  cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  transition: background 0.15s, color 0.15s;
}
.catg-arrow:hover { background: #1565c0; color: #fff; }

/* Páginas */
.catg-pages-wrapper { overflow: hidden; }
.catg-page { display: none; }
.catg-page.catg-page-active { display: block; }

.catg-page-inner {
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: 5px;
}
@media (max-width: 600px) {
  .catg-page-inner { grid-template-columns: 1fr; }
}

/* Card grande */
.catg-card-featured {
  display: block;
  border-radius: 10px;
  overflow: hidden;
  text-decoration: none;
  position: relative;
  aspect-ratio: 3/4;
}
@media (max-width: 600px) { .catg-card-featured { aspect-ratio: 16/9; } }

/* Grilla pequeña */
.catg-small-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-template-rows: repeat(2, 1fr);
  gap: 5px;
  align-content: stretch;
}
@media (max-width: 767px) { .catg-small-grid { grid-template-columns: repeat(2, 1fr); grid-template-rows: auto; } }

/* Card pequeña */
.catg-card-small {
  display: block;
  border-radius: 8px;
  overflow: hidden;
  text-decoration: none;
  position: relative;
  aspect-ratio: unset;
  min-height: 0;
}
.catg-card-empty {
  border-radius: 8px;
  background: transparent;
}

/* Imagen compartida */
.catg-img {
  width: 100%; height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.3s;
}
.catg-card-featured:hover .catg-img,
.catg-card-small:hover .catg-img { transform: scale(1.05); }

.catg-placeholder {
  position: absolute; inset: 0;
  display: flex; align-items: center; justify-content: center;
  background: #1a237e;
}
.catg-placeholder-featured { background: linear-gradient(135deg,#0d47a1,#1976d2); }

/* Overlay con label */
.catg-overlay {
  position: absolute; bottom: 0; left: 0; right: 0;
  background: linear-gradient(0deg, rgba(0,0,0,0.82) 0%, rgba(0,0,0,0.2) 70%, transparent 100%);
  padding: 28px 12px 10px;
}
.catg-card-small .catg-overlay { padding: 20px 10px 8px; }

.catg-label-featured {
  display: block;
  color: #fff;
  font-size: 1.05rem;
  font-weight: 800;
  letter-spacing: 0.05em;
  text-transform: uppercase;
}
.catg-label {
  display: block;
  color: #fff;
  font-size: 0.68rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

/* Dots */
.catg-dots {
  display: flex; justify-content: center; gap: 7px;
  margin-top: 14px;
}
.catg-dot {
  width: 8px; height: 8px;
  border-radius: 50%;
  background: #c5cae9;
  cursor: pointer;
  transition: background 0.2s;
}
.catg-dot.catg-dot-active { background: #1565c0; }
</style>

<script>
(function() {
  var pages = document.querySelectorAll('.catg-page');
  var dots  = document.querySelectorAll('.catg-dot');
  var cur   = 0;

  function goTo(n) {
    pages[cur].classList.remove('catg-page-active');
    dots[cur].classList.remove('catg-dot-active');
    cur = (n + pages.length) % pages.length;
    pages[cur].classList.add('catg-page-active');
    dots[cur].classList.add('catg-dot-active');
  }

  document.getElementById('catg-prev').addEventListener('click', function() { goTo(cur - 1); });
  document.getElementById('catg-next').addEventListener('click', function() { goTo(cur + 1); });
  dots.forEach(function(dot) {
    dot.addEventListener('click', function() { goTo(parseInt(dot.getAttribute('data-page'))); });
  });
})();
</script>
