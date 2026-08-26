{# Banner "Armá tu PC" - redirige al armador de PC #}
<section class="section-home section-armador-pc py-4">
  <div class="container">
    <a href="/armador-de-pc" class="armador-pc-banner" aria-label="Armá tu PC">
      <div class="armador-pc-content">
        <div class="armador-pc-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
            <line x1="8" y1="21" x2="16" y2="21"></line>
            <line x1="12" y1="17" x2="12" y2="21"></line>
            <circle cx="12" cy="10" r="2"></circle>
            <path d="M12 8V6M12 12v2M10 10H8M16 10h-2"></path>
          </svg>
        </div>
        <div class="armador-pc-text">
          <h3 class="armador-pc-title">Armá tu PC</h3>
          <p class="armador-pc-subtitle">Elegí los componentes ideales y creá tu equipo a medida</p>
        </div>
        <div class="armador-pc-cta">
          <span class="armador-pc-btn">Empezar ahora</span>
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="armador-pc-arrow">
            <line x1="5" y1="12" x2="19" y2="12"></line>
            <polyline points="12 5 19 12 12 19"></polyline>
          </svg>
        </div>
      </div>
    </a>
  </div>
</section>

<style>
.section-armador-pc { background: #fff; }
.armador-pc-banner {
  display: block;
  background: linear-gradient(135deg, #0d47a1 0%, #1565c0 50%, #1976d2 100%);
  border-radius: 16px;
  padding: 32px 40px;
  text-decoration: none;
  color: #fff;
  transition: box-shadow 0.25s, transform 0.25s;
  overflow: hidden;
  position: relative;
}
.armador-pc-banner::before {
  content: '';
  position: absolute;
  top: -40px; right: -40px;
  width: 180px; height: 180px;
  background: rgba(255,255,255,0.06);
  border-radius: 50%;
}
.armador-pc-banner::after {
  content: '';
  position: absolute;
  bottom: -60px; left: -20px;
  width: 220px; height: 220px;
  background: rgba(255,255,255,0.04);
  border-radius: 50%;
}
.armador-pc-banner:hover {
  box-shadow: 0 8px 32px rgba(21,101,192,0.35);
  transform: translateY(-2px);
  color: #fff;
}
.armador-pc-content {
  display: flex;
  align-items: center;
  gap: 24px;
  position: relative;
  z-index: 1;
}
.armador-pc-icon {
  flex-shrink: 0;
  background: rgba(255,255,255,0.15);
  border-radius: 12px;
  padding: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.armador-pc-text { flex: 1; }
.armador-pc-title {
  font-size: 1.7rem;
  font-weight: 800;
  margin: 0 0 4px;
  line-height: 1.2;
}
.armador-pc-subtitle {
  font-size: 0.97rem;
  margin: 0;
  opacity: 0.85;
}
.armador-pc-cta {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}
.armador-pc-btn {
  background: #fff;
  color: #1565c0;
  font-weight: 700;
  font-size: 0.95rem;
  padding: 10px 22px;
  border-radius: 8px;
  white-space: nowrap;
}
.armador-pc-arrow { opacity: 0.85; }
@media (max-width: 767px) {
  .armador-pc-banner { padding: 24px 20px; }
  .armador-pc-content { flex-wrap: wrap; gap: 16px; }
  .armador-pc-title { font-size: 1.3rem; }
  .armador-pc-icon { padding: 10px; }
  .armador-pc-cta { width: 100%; justify-content: flex-start; }
}
</style>
