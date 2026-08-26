{# Grid de categorías con imagen - redirige a cada categoría #}
<section class="section-home section-categorias-grid py-5">
  <div class="container">

    <h2 class="categorias-grid-title">Categorías</h2>

    <div class="categorias-grid">

      <a href="/notebooks" class="categoria-card">
        <div class="categoria-card-img-wrap">
          <img src="{{ 'cat-notebooks.jpg' | static_url }}" alt="Notebooks" class="categoria-card-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
          <div class="categoria-card-placeholder" style="display:none">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#1565c0" stroke-width="1.5"><rect x="2" y="4" width="20" height="14" rx="2"/><line x1="2" y1="22" x2="22" y2="22"/></svg>
          </div>
        </div>
        <div class="categoria-card-label">Notebooks</div>
      </a>

      <a href="/perifericos" class="categoria-card">
        <div class="categoria-card-img-wrap">
          <img src="{{ 'cat-perifericos.jpg' | static_url }}" alt="Periféricos" class="categoria-card-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
          <div class="categoria-card-placeholder" style="display:none">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#1565c0" stroke-width="1.5"><rect x="5" y="2" width="14" height="20" rx="2"/><line x1="12" y1="18" x2="12" y2="18" stroke-width="2" stroke-linecap="round"/></svg>
          </div>
        </div>
        <div class="categoria-card-label">Periféricos</div>
      </a>

      <a href="/procesadores" class="categoria-card">
        <div class="categoria-card-img-wrap">
          <img src="{{ 'cat-procesadores.jpg' | static_url }}" alt="Procesadores" class="categoria-card-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
          <div class="categoria-card-placeholder" style="display:none">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#1565c0" stroke-width="1.5"><rect x="4" y="4" width="16" height="16" rx="1"/><rect x="9" y="9" width="6" height="6"/><line x1="9" y1="1" x2="9" y2="4"/><line x1="15" y1="1" x2="15" y2="4"/><line x1="9" y1="20" x2="9" y2="23"/><line x1="15" y1="20" x2="15" y2="23"/><line x1="20" y1="9" x2="23" y2="9"/><line x1="20" y1="14" x2="23" y2="14"/><line x1="1" y1="9" x2="4" y2="9"/><line x1="1" y1="14" x2="4" y2="14"/></svg>
          </div>
        </div>
        <div class="categoria-card-label">Procesadores</div>
      </a>

      <a href="/placas-de-video" class="categoria-card">
        <div class="categoria-card-img-wrap">
          <img src="{{ 'cat-placas-video.jpg' | static_url }}" alt="Placas de Video" class="categoria-card-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
          <div class="categoria-card-placeholder" style="display:none">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#1565c0" stroke-width="1.5"><rect x="1" y="6" width="22" height="12" rx="2"/><circle cx="8" cy="12" r="2"/><circle cx="16" cy="12" r="2"/></svg>
          </div>
        </div>
        <div class="categoria-card-label">Placas de Video</div>
      </a>

      <a href="/monitores" class="categoria-card">
        <div class="categoria-card-img-wrap">
          <img src="{{ 'cat-monitores.jpg' | static_url }}" alt="Monitores" class="categoria-card-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
          <div class="categoria-card-placeholder" style="display:none">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#1565c0" stroke-width="1.5"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
          </div>
        </div>
        <div class="categoria-card-label">Monitores</div>
      </a>

      <a href="/sillas-gamer" class="categoria-card">
        <div class="categoria-card-img-wrap">
          <img src="{{ 'cat-sillas.jpg' | static_url }}" alt="Sillas Gamer" class="categoria-card-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
          <div class="categoria-card-placeholder" style="display:none">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#1565c0" stroke-width="1.5"><path d="M12 2C6 2 4 7 4 12v4h16v-4c0-5-2-10-8-10z"/><line x1="8" y1="22" x2="8" y2="16"/><line x1="16" y1="22" x2="16" y2="16"/></svg>
          </div>
        </div>
        <div class="categoria-card-label">Sillas Gamer</div>
      </a>

      <a href="/conectividad" class="categoria-card">
        <div class="categoria-card-img-wrap">
          <img src="{{ 'cat-conectividad.jpg' | static_url }}" alt="Conectividad" class="categoria-card-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
          <div class="categoria-card-placeholder" style="display:none">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#1565c0" stroke-width="1.5"><path d="M5 12.55a11 11 0 0 1 14.08 0"/><path d="M1.42 9a16 16 0 0 1 21.16 0"/><path d="M8.53 16.11a6 6 0 0 1 6.95 0"/><circle cx="12" cy="20" r="1" fill="#1565c0"/></svg>
          </div>
        </div>
        <div class="categoria-card-label">Conectividad</div>
      </a>

      <a href="/almacenamiento" class="categoria-card">
        <div class="categoria-card-img-wrap">
          <img src="{{ 'cat-almacenamiento.jpg' | static_url }}" alt="Almacenamiento" class="categoria-card-img" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
          <div class="categoria-card-placeholder" style="display:none">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#1565c0" stroke-width="1.5"><ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/></svg>
          </div>
        </div>
        <div class="categoria-card-label">Almacenamiento</div>
      </a>

    </div>
  </div>
</section>

<style>
.section-categorias-grid { background: #f5f7fa; }
.categorias-grid-title {
  font-size: 1.6rem;
  font-weight: 700;
  color: #111;
  margin-bottom: 1.5rem;
  text-align: center;
}
.categorias-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}
@media (max-width: 991px) { .categorias-grid { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 550px) { .categorias-grid { grid-template-columns: repeat(2, 1fr); } }
.categoria-card {
  display: block;
  border-radius: 12px;
  overflow: hidden;
  background: #fff;
  text-decoration: none;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
  transition: box-shadow 0.22s, transform 0.22s;
}
.categoria-card:hover {
  box-shadow: 0 6px 20px rgba(21,101,192,0.15);
  transform: translateY(-3px);
}
.categoria-card-img-wrap {
  width: 100%;
  aspect-ratio: 1/1;
  overflow: hidden;
  background: #eef2fb;
  display: flex;
  align-items: center;
  justify-content: center;
}
.categoria-card-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.3s;
}
.categoria-card:hover .categoria-card-img { transform: scale(1.05); }
.categoria-card-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #eef2fb;
}
.categoria-card-label {
  text-align: center;
  padding: 12px 8px;
  font-weight: 700;
  font-size: 0.93rem;
  color: #1565c0;
  background: #fff;
}
</style>
