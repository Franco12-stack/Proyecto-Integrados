{# Banner "Armá tu PC" - estilo banner con foto de fondo #}
<section class="section-home section-armador-pc py-4">
  <div class="container">
    <a href="/arma-tu-pc/" class="armador-pc-banner" aria-label="Armá tu PC">
      {# Imagen de fondo — subí "banner-armador-pc.jpg" al FTP en /static/ #}
      <img src="{{ 'banner-armador-pc.jpg' | static_url }}" alt="" class="armador-pc-bg" onerror="this.style.display='none'">
      <div class="armador-pc-overlay"></div>
      <div class="armador-pc-content">
        <div class="armador-pc-text">
          <p class="armador-pc-sup">Configurá tu equipo ideal</p>
          <h3 class="armador-pc-title">Armá tu PC</h3>
          <p class="armador-pc-subtitle">Elegí cada componente y creá la PC perfecta para vos</p>
        </div>
        <div class="armador-pc-cta">
          <span class="armador-pc-btn">Empezar ahora
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
          </span>
        </div>
      </div>
    </a>
  </div>
</section>

<style>
.section-armador-pc { background: #fff; }

.armador-pc-banner {
  display: block;
  position: relative;
  border-radius: 18px;
  overflow: hidden;
  min-height: 260px;
  text-decoration: none;
  color: #fff;
  transition: box-shadow 0.25s, transform 0.25s;
  background: linear-gradient(135deg, #0a2472 0%, #0d47a1 50%, #1565c0 100%);
}
@media (max-width: 767px) { .armador-pc-banner { min-height: 180px; } }

.armador-pc-banner:hover {
  box-shadow: 0 10px 40px rgba(13,71,161,0.4);
  transform: translateY(-2px);
  color: #fff;
}

/* Imagen de fondo */
.armador-pc-bg {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  display: block;
  transition: transform 0.4s;
  pointer-events: none;
}
.armador-pc-banner:hover .armador-pc-bg { transform: scale(1.03); }

/* Overlay oscuro sobre la foto */
.armador-pc-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg, rgba(5,20,80,0.82) 0%, rgba(5,20,80,0.55) 55%, rgba(5,20,80,0.2) 100%);
  pointer-events: none;
}

/* Contenido */
.armador-pc-content {
  position: relative;
  z-index: 2;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding: 48px 52px;
}
@media (max-width: 767px) {
  .armador-pc-content { padding: 32px 24px; flex-direction: column; align-items: flex-start; gap: 20px; }
}

.armador-pc-text { flex: 1; }

.armador-pc-sup {
  font-size: 0.82rem;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  opacity: 0.75;
  margin: 0 0 8px;
}

.armador-pc-title {
  font-size: 2.6rem;
  font-weight: 900;
  margin: 0 0 10px;
  line-height: 1.1;
  letter-spacing: -0.01em;
}
@media (max-width: 767px) { .armador-pc-title { font-size: 1.8rem; } }

.armador-pc-subtitle {
  font-size: 1rem;
  margin: 0;
  opacity: 0.82;
  max-width: 420px;
}

.armador-pc-cta { flex-shrink: 0; }

.armador-pc-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: #fff;
  color: #0d47a1;
  font-weight: 800;
  font-size: 0.97rem;
  padding: 14px 28px;
  border-radius: 10px;
  white-space: nowrap;
  letter-spacing: 0.01em;
  transition: background 0.18s, color 0.18s;
}
.armador-pc-banner:hover .armador-pc-btn {
  background: #1565c0;
  color: #fff;
}
</style>
