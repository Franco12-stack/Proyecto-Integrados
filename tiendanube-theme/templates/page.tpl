{% if template == 'page.arma-tu-pc' %}
<style>
  #apcGenericPage { display: none !important; }
  #apcBuilderWrapper { display: block !important; }
  .page-header, .page-title, nav.breadcrumbs { display: none !important; }
  #main-content, .main-content, [id*='content'], [class*='page-content'] { padding: 0 !important; margin: 0 !important; max-width: 100% !important; }
  @media (min-width: 641px) {
    body { overflow: hidden !important; }
  }
</style>
{% endif %}

<div id="apcGenericPage">
  <h1 class="page-header">{{ page.name }}</h1>
  {{ page.content }}
</div>

<div id="apcBuilderWrapper" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; z-index:9999; overflow:hidden;">
<!-- ============================================================
     ARMADOR DE PC - integradosargentinos.com
     Diseño renovado — productos inline (sin modal)
     ============================================================ -->
<script>
/* Si el armador se abre como archivo standalone (no dentro de Tiendanube),
   elimina márgenes y scroll del body para que el builder llene la pantalla */
(function(){
  function applyStandaloneReset(){
    if(!document.getElementById('apcGenericPage')){
      var mobile = window.innerWidth <= 640;
      document.documentElement.style.cssText='margin:0;padding:0;height:100%;overflow:'+(mobile?'auto':'hidden');
      document.body.style.cssText='margin:0;padding:0;height:100%;overflow:'+(mobile?'auto':'hidden');
    }
  }
  if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',applyStandaloneReset);
  else applyStandaloneReset();
})();
</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

<style>
/* ============================================================
   VARIABLES Y RESET
   ============================================================ */
#armador-pc {
  --cyan:       #1BA9E2;
  --cyan-dk:    #1590c5;
  --cyan-grad:  linear-gradient(135deg, #1BA9E2, #34b7ec);
  --header-bg:  #1a1a1a;
  --body-bg:    #f5f5f5;
  --white:      #ffffff;
  --text:       #3F3D38;
  --text-muted: #888;
  --text-light: #bbb;
  --border:     #e8e8e8;
  --green:      #2ecc71;
  --red:        #e74c3c;
  --orange:     #f97316;
  --shadow-sm:  0 1px 4px rgba(0,0,0,.07);
  --shadow:     0 4px 16px rgba(0,0,0,.10);
  --radius:     10px;
  --radius-sm:  8px;
  --radius-pill:20px;

  font-family: 'Rubik', -apple-system, BlinkMacSystemFont, sans-serif;
  color: var(--text);
  background: var(--body-bg);
  display: flex;
  flex-direction: column;
  overflow: hidden;          /* no scroll externo */
  height: 100vh;             /* llena toda la pantalla */
}
#armador-pc *, #armador-pc *::before, #armador-pc *::after {
  box-sizing: border-box; margin: 0; padding: 0;
}

/* ============================================================
   HEADER — compacto
   ============================================================ */
#armador-pc .apc-header {
  background: var(--header-bg);
  color: var(--white);
  padding: 8px 24px 7px;
  text-align: center;
  border-bottom: 3px solid var(--cyan);
  flex-shrink: 0;
}
#armador-pc .apc-header h1 {
  font-size: clamp(15px, 2vw, 20px);
  font-weight: 900;
  letter-spacing: -0.5px;
  margin-bottom: 1px;
}
#armador-pc .apc-header h1 span { color: var(--cyan); }
#armador-pc .apc-header p { font-size: 11px; color: var(--text-light); }

/* ============================================================
   LAYOUT PRINCIPAL
   ============================================================ */
#armador-pc .apc-body {
  display: flex;
  gap: 16px;
  width: 100%;
  padding: 8px 14px 8px;
  align-items: stretch;
  flex: 1;
  min-height: 0;
  overflow: hidden;
}
#armador-pc .apc-main {
  flex: 1; min-width: 0;
  display: flex; flex-direction: column; min-height: 0;
  overflow: hidden;
}
#armador-pc .apc-sidebar {
  width: 310px; flex-shrink: 0;
  display: flex; flex-direction: column;
  min-height: 0; overflow: hidden;
}

/* ============================================================
   RESPONSIVE — TABLET (≤900px)
   ============================================================ */
@media (max-width: 900px) {
  #armador-pc .apc-body { flex-direction: column; padding: 8px 10px; gap: 10px; }
  #armador-pc .apc-sidebar { width: 100%; min-height: 0; }
}

/* ============================================================
   RESPONSIVE — MOBILE (≤640px)
   ============================================================ */
@media (max-width: 640px) {
  /* El wrapper deja de ser fixed en mobile — permite scroll natural */
  #apcBuilderWrapper {
    position: static !important;
    height: auto !important;
    overflow: auto !important;
  }

  /* El builder scrollea naturalmente en mobile */
  #armador-pc { height: auto; min-height: 100svh; overflow: visible; }

  /* Header compacto */
  #armador-pc .apc-header { padding: 6px 14px 5px; }
  #armador-pc .apc-header h1 { font-size: 16px; }
  #armador-pc .apc-header p { display: none; }

  /* Body sin restricción de altura — display:block evita el colapso de flex */
  #armador-pc .apc-body {
    display: block !important;
    padding: 6px 8px;
    overflow: visible !important;
    min-height: 0;
  }
  #armador-pc .apc-main {
    display: block !important;
    overflow: visible !important;
    min-height: 0;
    width: 100%;
  }

  /* Sidebar oculto en mobile — reemplazado por barra flotante */
  #armador-pc .apc-sidebar { display: none; }

  /* Quitar overflow:hidden y flex:1 en mobile (causaban colapso a altura 0) */
  #armador-pc,
  #armador-pc .apc-body,
  #armador-pc .apc-main,
  #armador-pc .apc-panel,
  #armador-pc .apc-sidebar,
  #armador-pc .sum-card,
  #armador-pc .sum-items { overflow: visible !important; }

  /* Panel: display block en lugar de flex, height auto */
  #armador-pc .apc-panel {
    display: block !important;
    flex: none !important;
    min-height: 0;
    height: auto !important;
  }

  /* Grid: 1 columna, sin límite de altura (scroll de página) */
  #armador-pc .apc-grid {
    grid-template-columns: 1fr !important;
    max-height: none !important;
    overflow-y: visible !important;
    padding: 8px;
    gap: 8px;
  }

  /* Cards más compactas en mobile */
  #armador-pc .apc-card { min-height: 110px; }
  #armador-pc .apc-card-img-wrap { width: 90px; min-width: 90px; padding: 6px; }
  #armador-pc .apc-card-body { padding: 8px 10px; gap: 4px; }
  #armador-pc .apc-card-name { font-size: 12px; height: calc(12px * 1.35 * 3); }
  #armador-pc .apc-price-amount { font-size: 13px; }
  #armador-pc .apc-price-sub { font-size: 7px; }
  #armador-pc .apc-price-card-amount { font-size: 12px; }

  /* Barra flotante inferior visible en mobile */
  #armador-pc .apc-mobile-bar {
    display: flex !important;
  }

  /* Espacio extra al final para que no tape la barra flotante */
  #armador-pc .apc-panel { padding-bottom: 70px; }
}

/* Elementos mobile — OCULTOS por defecto */
#armador-pc .apc-mobile-bar,
#armador-pc .apc-mobile-drawer,
#armador-pc .apc-mobile-overlay {
  display: none;
}

/* Cuando se abren con clase .open (controlado desde JS), se muestran */
#armador-pc .apc-mobile-drawer.open {
  display: flex !important;
  position: fixed !important; bottom: 0 !important; left: 0 !important; right: 0 !important;
  height: 85vh !important;
  background: white !important;
  border-radius: 20px 20px 0 0 !important;
  box-shadow: 0 -8px 30px rgba(0,0,0,.2) !important;
  flex-direction: column !important;
  z-index: 100001 !important;
  animation: apcDrawerUp .3s ease !important;
}
@keyframes apcDrawerUp { from { transform: translateY(100%); } to { transform: translateY(0); } }

#armador-pc .apc-mobile-overlay.open {
  display: block !important;
  position: fixed !important; inset: 0 !important;
  background: rgba(0,0,0,.5) !important;
  z-index: 100000 !important;
}

#armador-pc .apc-mobile-drawer-handle {
  width: 40px; height: 4px; background: #ddd; border-radius: 2px;
  margin: 12px auto 8px; flex-shrink: 0;
}

#armador-pc .apc-mobile-bar {
  position: fixed; bottom: 0; left: 0; right: 0;
  background: white;
  border-top: 1.5px solid var(--border);
  box-shadow: 0 -4px 20px rgba(0,0,0,.12);
  padding: 10px 14px;
  align-items: center; gap: 10px;
  z-index: 9999;
}
#armador-pc .apc-mobile-bar-info {
  flex: 1; min-width: 0;
  display: flex; flex-direction: column;
}
#armador-pc .apc-mobile-bar-count {
  font-size: 11px; color: var(--text-muted); font-weight: 600;
}
#armador-pc .apc-mobile-bar-total {
  font-size: 16px; font-weight: 900; color: var(--cyan); letter-spacing: -.5px;
}
#armador-pc .apc-mobile-bar-btn {
  padding: 10px 16px; border-radius: var(--radius-pill);
  background: var(--cyan-grad); color: white;
  border: none; font-family: 'Rubik', sans-serif;
  font-size: 13px; font-weight: 700; cursor: pointer;
  white-space: nowrap;
}

/* ============================================================
   TABS DE CATEGORÍAS (pastillas)
   ============================================================ */
#armador-pc .apc-tabs {
  display: flex;
  gap: 5px;
  flex-wrap: nowrap;        /* una sola fila siempre */
  overflow-x: auto;         /* scroll horizontal si no entran */
  margin-bottom: 10px;
  flex-shrink: 0;
  scrollbar-width: none;    /* ocultar scrollbar en Firefox */
  -ms-overflow-style: none; /* ocultar scrollbar en IE */
}
#armador-pc .apc-tabs::-webkit-scrollbar { display: none; } /* ocultar scrollbar en Chrome */
#armador-pc .apc-tab {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 7px 13px;
  border-radius: 100px;
  border: 2px solid var(--border);
  background: var(--white);
  cursor: pointer;
  font-size: 12px;
  font-weight: 600;
  white-space: nowrap;
  transition: all .18s;
  color: var(--text-muted);
  font-family: 'Rubik', sans-serif;
}
#armador-pc .apc-tab:hover  { border-color: var(--cyan); color: var(--cyan); }
#armador-pc .apc-tab.active { background: var(--cyan); border-color: var(--cyan); color: #fff; }
#armador-pc .apc-tab.done   { border-color: var(--green); color: var(--green); background: #f0fdf4; }
#armador-pc .apc-tab.done.active { background: var(--green); border-color: var(--green); color: #fff; }
#armador-pc .apc-tab-check  { display: none; font-size: 11px; }
#armador-pc .apc-tab.done .apc-tab-check { display: inline; }
#armador-pc .apc-tab svg    { width: 15px; height: 15px; }

/* ============================================================
   PANEL DE PRODUCTOS
   ============================================================ */
#armador-pc .apc-panel {
  background: var(--white);
  border: 1.5px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  flex: 1; min-height: 0;     /* expande para llenar el espacio */
  display: flex; flex-direction: column;
}
#armador-pc .apc-panel-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 16px;
  border-bottom: 1px solid var(--border);
  background: var(--header-bg);
  flex-shrink: 0;
}
#armador-pc .apc-panel-title {
  font-size: 16px;
  font-weight: 800;
  color: white;
  display: flex;
  align-items: center;
  gap: 8px;
}
#armador-pc .apc-panel-title svg { width: 18px; height: 18px; }
#armador-pc .apc-badge-opt {
  font-size: 10px; font-weight: 600;
  background: rgba(255,255,255,.15); color: rgba(255,255,255,.85);
  padding: 2px 8px; border-radius: 100px;
}
#armador-pc .apc-badge-multi {
  font-size: 10px; font-weight: 600;
  background: rgba(27,169,226,.25); color: #90deff;
  padding: 2px 8px; border-radius: 100px;
}
#armador-pc .apc-skip-btn {
  font-size: 12px; color: rgba(255,255,255,.6);
  background: rgba(255,255,255,.08);
  border: 1px solid rgba(255,255,255,.15);
  padding: 5px 13px; border-radius: 100px;
  cursor: pointer; transition: all .18s;
  font-family: 'Rubik', sans-serif;
}
#armador-pc .apc-skip-btn:hover { background: rgba(255,255,255,.15); color: white; }
#armador-pc .apc-refresh-btn {
  font-size: 16px; color: rgba(255,255,255,.5);
  background: none; border: none; cursor: pointer;
  padding: 2px 4px; line-height: 1;
  transition: color .18s, transform .3s;
}
#armador-pc .apc-refresh-btn:hover { color: var(--cyan); transform: rotate(180deg); }

/* Barra de búsqueda */
#armador-pc .apc-search-wrap {
  padding: 6px 14px;
  border-bottom: 1px solid var(--border);
  display: flex; align-items: center; gap: 10px;
  background: #fafafa;
  flex-shrink: 0;
}
#armador-pc .apc-search {
  flex: 1; padding: 6px 12px;
  border: 1.5px solid var(--border); border-radius: 22px;
  font-size: 13px; font-family: 'Rubik', sans-serif;
  outline: none; background: white;
  transition: border-color .15s;
}
#armador-pc .apc-search:focus { border-color: var(--cyan); }
#armador-pc .apc-filter-count {
  font-size: 12px; color: var(--text-muted); font-weight: 600; white-space: nowrap;
}

/* Aviso de compatibilidad en panel */
#armador-pc #apcCompatNotice { flex-shrink: 0; }
#armador-pc .apc-compat-notice {
  margin: 8px 20px 0;
  background: rgba(27,169,226,.08);
  border: 1px solid rgba(27,169,226,.25);
  border-radius: var(--radius-sm);
  padding: 7px 12px; font-size: 12px; color: var(--cyan); font-weight: 500;
}

/* ============================================================
   GRID DE PRODUCTOS
   ============================================================ */
#armador-pc .apc-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 12px;
  padding: 14px 16px;
  overflow-y: auto;
  align-content: start;
  max-height: calc(100vh - 340px); /* fallback CSS; JS sobreescribe */
}
@media (max-width: 600px) {
  #armador-pc .apc-grid { grid-template-columns: 1fr; padding: 8px 10px; }
}

/* Tarjeta de producto — horizontal con imagen grande */
#armador-pc .apc-card {
  border: 1.5px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden; cursor: pointer;
  transition: border-color .15s, box-shadow .15s;
  display: flex; flex-direction: row;
  align-items: stretch;
  background: var(--white); position: relative;
  min-height: 200px;
}
#armador-pc .apc-card:hover {
  border-color: var(--cyan);
  box-shadow: 0 4px 20px rgba(27,169,226,.18);
  transform: translateY(-2px);
}
#armador-pc .apc-card.apc-selected {
  border-color: var(--green);
  box-shadow: 0 0 0 2px rgba(46,204,113,.18);
}
#armador-pc .apc-card.apc-selected::after {
  content: '✓';
  position: absolute; top: 5px; right: 6px;
  width: 18px; height: 18px;
  background: var(--green); color: white;
  border-radius: 50%; font-size: 10px; font-weight: 900;
  display: flex; align-items: center; justify-content: center; line-height: 1;
}
#armador-pc .apc-card.apc-multi-sel {
  border-color: var(--cyan);
  box-shadow: 0 0 0 2px rgba(27,169,226,.18);
}
#armador-pc .apc-card.apc-incompat { opacity: .38; filter: grayscale(50%); cursor: not-allowed; }
#armador-pc .apc-card.apc-incompat:hover { border-color: var(--border); transform: none; box-shadow: none; }

#armador-pc .apc-qty-badge {
  position: absolute; top: 8px; right: 8px;
  width: 22px; height: 22px;
  background: var(--cyan); color: white; border-radius: 50%;
  font-size: 11px; font-weight: 900;
  display: flex; align-items: center; justify-content: center; z-index: 2;
}
#armador-pc .apc-incompat-badge {
  position: absolute; top: 8px; left: 8px;
  background: var(--red); color: white;
  font-size: 9px; font-weight: 700; padding: 2px 6px;
  border-radius: 4px; z-index: 2;
}

/* Imagen de producto — columna izquierda fija */
#armador-pc .apc-card-img-wrap {
  width: 130px; min-width: 130px; height: auto;
  background: var(--body-bg);
  display: flex; align-items: center; justify-content: center;
  overflow: hidden; padding: 10px;
  border-right: 1px solid var(--border);
}
#armador-pc .apc-card-img {
  width: 100%; height: 100%; object-fit: contain;
  transition: transform .25s ease;
}
#armador-pc .apc-card:hover .apc-card-img { transform: scale(1.06); }
#armador-pc .apc-card-img-ph {
  display: flex; align-items: center; justify-content: center;
  width: 100%; height: 100%; opacity: .22;
}
#armador-pc .apc-card-img-ph svg { width: 52px; height: 52px; color: var(--text-muted); }

/* Cuerpo de la tarjeta */
#armador-pc .apc-card-body {
  padding: 12px 14px; flex: 1; min-width: 0;
  display: flex; flex-direction: column; justify-content: flex-start;
  gap: 6px;
  border-top: none;
}
#armador-pc .apc-card-name {
  font-size: 13px; font-weight: 700; color: var(--text);
  line-height: 1.35;
  height: calc(13px * 1.35 * 3); /* exactamente 3 líneas = 52.65px */
  overflow: hidden;
  flex-shrink: 0;
}
#armador-pc .apc-incompat-msg { font-size: 10px; color: var(--red); margin-bottom: 6px; font-style: italic; }

/* Tags */
#armador-pc .apc-tags { display: flex; flex-wrap: wrap; gap: 3px; flex-shrink: 0; }
#armador-pc .apc-tag {
  font-size: 9px; font-weight: 700; padding: 2px 5px; border-radius: 4px;
  background: rgba(27,169,226,.12); color: var(--cyan);
  text-transform: uppercase; letter-spacing: .3px;
}
#armador-pc .tag-ddr4  { background: #dbeafe; color: #1d4ed8; }
#armador-pc .tag-ddr5  { background: #dcfce7; color: #15803d; }
#armador-pc .tag-am4   { background: #fff3e0; color: #e65100; }
#armador-pc .tag-am5   { background: #fce4ec; color: #c62828; }
#armador-pc .tag-lga   { background: #e3f2fd; color: #0277bd; }
#armador-pc .tag-watts { background: #fff8e1; color: #f57f17; }

/* Precios — dos columnas en una fila */
#armador-pc .apc-prices { display: flex; flex-direction: column; gap: 5px; flex-shrink: 0; }
#armador-pc .apc-price-transfer {
  background: var(--cyan-grad); border-radius: 8px; padding: 6px 11px;
  display: flex; flex-direction: column;
  border: 2px solid rgba(0,0,0,.18);
  box-shadow: 0 2px 6px rgba(0,0,0,.18);
}
#armador-pc .apc-price-amount { font-size: 16px; font-weight: 900; color: white; letter-spacing: -.5px; line-height: 1.15; text-shadow: 0 1px 3px rgba(0,0,0,.35), 0 0 1px rgba(0,0,0,.25); }
#armador-pc .apc-price-sub { font-size: 9px; color: rgba(255,255,255,.85); font-weight: 600; margin-top: 2px; }
#armador-pc .apc-price-card { background: #f0f0f4; border-radius: 8px; padding: 6px 11px; display: flex; flex-direction: column; }
#armador-pc .apc-price-card-amount { font-size: 15px; font-weight: 700; color: var(--text); line-height: 1.15; }
#armador-pc .apc-price-card-label { font-size: 9px; color: var(--text-muted); font-weight: 500; margin-top: 2px; }

/* Controles qty (multi) */
#armador-pc .apc-qty-ctrl {
  display: flex; align-items: center; justify-content: center; gap: 8px;
  padding: 7px 12px; border-top: 1px solid var(--border);
  background: rgba(27,169,226,.05);
}
#armador-pc .apc-qty-btn {
  width: 26px; height: 26px; border-radius: 50%;
  border: 1.5px solid var(--cyan); background: transparent; color: var(--cyan);
  font-size: 14px; font-weight: 700; cursor: pointer;
  display: flex; align-items: center; justify-content: center; line-height: 1;
  transition: background .15s, color .15s;
}
#armador-pc .apc-qty-btn:hover { background: var(--cyan); color: white; }
#armador-pc .apc-qty-num { font-size: 13px; font-weight: 800; color: var(--cyan); min-width: 26px; text-align: center; }

/* Botón continuar (multi) */
#armador-pc .apc-next-wrap {
  padding: 12px 20px; border-top: 1px solid var(--border); background: #fafafa;
}
#armador-pc .apc-next-btn {
  width: 100%; padding: 12px;
  background: var(--cyan-grad); color: white;
  border: none; border-radius: var(--radius-pill);
  font-size: 14px; font-weight: 700; font-family: 'Rubik', sans-serif;
  cursor: pointer; transition: opacity .15s;
  display: flex; align-items: center; justify-content: center; gap: 6px;
}
#armador-pc .apc-next-btn:hover { opacity: .9; }

/* Loading / vacío */
#armador-pc .apc-state {
  display: flex; flex-direction: column; align-items: center;
  justify-content: center; padding: 50px 24px;
  color: var(--text-muted); text-align: center; gap: 12px;
  grid-column: 1 / -1;
}
#armador-pc .apc-spinner {
  width: 36px; height: 36px;
  border: 3px solid var(--border); border-top-color: var(--cyan);
  border-radius: 50%; animation: apcSpin .7s linear infinite;
}
@keyframes apcSpin { to { transform: rotate(360deg); } }

/* ============================================================
   SIDEBAR — RESUMEN
   ============================================================ */
#armador-pc .sum-card {
  background: var(--white);
  border: 1.5px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden; box-shadow: var(--shadow-sm);
  display: flex; flex-direction: column;
  flex: 1; min-height: 0;     /* ocupa toda la altura disponible */
}
#armador-pc .sum-head {
  background: var(--header-bg); color: white;
  padding: 14px 18px; font-weight: 700; font-size: 14px;
  display: flex; align-items: center; gap: 8px;
}
#armador-pc .sum-head-dot { width: 8px; height: 8px; border-radius: 50%; background: var(--cyan); flex-shrink: 0; }
#armador-pc .sum-count { margin-left: auto; font-size: 11px; font-weight: 400; opacity: .65; }

#armador-pc .sum-items { padding: 5px 0; flex: 1; min-height: 0; overflow-y: auto; }
#armador-pc .sum-item {
  display: flex; align-items: center; gap: 10px;
  padding: 7px 16px; border-bottom: 1px solid #f5f5f5;
}
#armador-pc .sum-item:last-child { border-bottom: none; }
#armador-pc .sum-thumb {
  width: 34px; height: 34px; border-radius: 6px;
  background: var(--body-bg); flex-shrink: 0; overflow: hidden;
  display: flex; align-items: center; justify-content: center;
}
#armador-pc .sum-thumb img { width: 100%; height: 100%; object-fit: contain; }
#armador-pc .sum-thumb svg { width: 18px; height: 18px; color: var(--text-muted); }
#armador-pc .sum-item.item-empty .sum-thumb { opacity: .25; }
#armador-pc .sum-info { flex: 1; min-width: 0; }
#armador-pc .sum-cat { font-size: 9px; font-weight: 700; text-transform: uppercase; letter-spacing: .6px; color: var(--text-muted); }
#armador-pc .sum-name { font-size: 11px; color: var(--text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-weight: 500; }
#armador-pc .sum-item.item-empty .sum-name { color: #ccc; font-style: italic; }
#armador-pc .sum-price { font-size: 11px; font-weight: 800; color: var(--cyan); flex-shrink: 0; white-space: nowrap; }
#armador-pc .sum-item.item-empty .sum-price { display: none; }
#armador-pc .sum-del {
  background: none; border: none; cursor: pointer;
  color: #ccc; font-size: 15px; line-height: 1; flex-shrink: 0;
  transition: color .15s; padding: 0 2px;
}
#armador-pc .sum-del:hover { color: var(--red); }

/* Footer del resumen */
#armador-pc .sum-footer { padding: 12px 16px; background: #fafafa; border-top: 1.5px solid var(--border); flex-shrink: 0; }

/* Consumo estimado */
#armador-pc .power-banner {
  display: flex; align-items: center; gap: 8px;
  font-size: 11px; color: var(--text-muted);
  background: #fff8f0; border: 1px solid #ffe0b2;
  border-radius: 8px; padding: 8px 10px; margin-bottom: 10px;
}
#armador-pc .power-banner strong { color: var(--orange); font-weight: 800; }

/* Compatibilidad */
#armador-pc .compat-ok  { font-size: 11px; background: #dcfce7; color: #166534; padding: 6px 10px; border-radius: 7px; margin-bottom: 10px; }
#armador-pc .compat-err { font-size: 11px; background: #fee2e2; color: #991b1b; padding: 6px 10px; border-radius: 7px; margin-bottom: 10px; }

/* Totales dobles */
#armador-pc .dual-totals { display: flex; gap: 8px; margin-bottom: 12px; }
#armador-pc .total-block { flex: 1; border-radius: var(--radius); padding: 10px 12px; min-width: 0; }
#armador-pc .total-transfer { background: var(--cyan-grad); }
#armador-pc .total-card     { background: white; border: 1.5px solid var(--border); }
#armador-pc .total-lbl {
  font-size: 9px; font-weight: 700; letter-spacing: .5px;
  text-transform: uppercase; margin-bottom: 2px;
}
#armador-pc .total-transfer .total-lbl { color: rgba(255,255,255,.80); }
#armador-pc .total-card     .total-lbl { color: var(--text-muted); }
#armador-pc .total-amt {
  font-size: clamp(0.8rem, 2.2vw, 1rem);
  font-weight: 900; letter-spacing: -0.5px;
  word-break: break-all; line-height: 1.1;
}
#armador-pc .total-transfer .total-amt { color: white; }
#armador-pc .total-card     .total-amt { color: var(--text); }

/* Botones CTA */
#armador-pc .btn-cart {
  width: 100%; padding: 14px; border-radius: var(--radius-pill);
  border: none; background: var(--cyan-grad); color: white;
  font-family: 'Rubik', sans-serif; font-size: 14px; font-weight: 800;
  cursor: pointer; transition: opacity .15s, transform .1s;
  box-shadow: 0 4px 20px rgba(27,169,226,.35);
  display: flex; align-items: center; justify-content: center; gap: 7px;
}
#armador-pc .btn-cart:hover:not(:disabled) { opacity: .92; transform: translateY(-1px); }
#armador-pc .btn-cart:disabled { background: #ddd; color: #aaa; cursor: not-allowed; box-shadow: none; transform: none; }
#armador-pc .btn-presupuesto {
  width: 100%; padding: 10px; border-radius: var(--radius-pill);
  border: 2px solid var(--cyan); background: transparent; color: var(--cyan);
  font-family: 'Rubik', sans-serif; font-size: 13px; font-weight: 700;
  cursor: pointer; margin-top: 8px;
  transition: background .15s, color .15s;
  display: flex; align-items: center; justify-content: center; gap: 6px;
}
#armador-pc .btn-presupuesto:hover:not(:disabled) { background: var(--cyan); color: white; }
#armador-pc .btn-presupuesto:disabled { border-color: #ddd; color: #bbb; cursor: not-allowed; }
#armador-pc .btn-reset {
  width: 100%; padding: 9px; border-radius: var(--radius-sm);
  border: 1.5px solid var(--border); background: transparent;
  color: var(--text-muted); font-family: 'Rubik', sans-serif;
  font-size: 12px; font-weight: 600; cursor: pointer; margin-top: 8px;
  transition: background .15s, color .15s, border-color .15s;
}
#armador-pc .btn-reset:hover { background: #f5f5f5; color: var(--red); border-color: var(--red); }

/* ============================================================
   TOAST
   ============================================================ */
.apc-toast {
  position: fixed; bottom: 28px; left: 50%;
  transform: translateX(-50%);
  background: #1a1a1a; color: white;
  padding: 11px 22px; border-radius: 30px;
  font-family: 'Rubik', sans-serif; font-size: 13px; font-weight: 600;
  z-index: 9999; animation: apcToastIn .2s ease;
  white-space: nowrap; pointer-events: none;
  box-shadow: 0 8px 40px rgba(0,0,0,.25); border-left: 3px solid #1BA9E2;
}
@keyframes apcToastIn {
  from { opacity: 0; transform: translateX(-50%) translateY(10px); }
  to   { opacity: 1; transform: translateX(-50%) translateY(0); }
}

/* ============================================================
   OVERLAY DE ÉXITO
   ============================================================ */
#armador-pc .apc-overlay {
  position: fixed; inset: 0; background: rgba(0,0,0,.55);
  display: none; align-items: center; justify-content: center; z-index: 9999;
}
#armador-pc .apc-overlay.show { display: flex; }
#armador-pc .apc-modal {
  background: white; border-radius: 16px; padding: 40px 32px;
  text-align: center; max-width: 360px; width: 90%;
  animation: apcUp .28s ease; font-family: 'Rubik', sans-serif;
}
@keyframes apcUp { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:translateY(0); } }
#armador-pc .apc-modal-ico { font-size: 3.5rem; margin-bottom: 12px; }
#armador-pc .apc-modal h2 { font-size: 1.4rem; font-weight: 800; color: #1a1a1a; margin-bottom: 8px; }
#armador-pc .apc-modal p  { color: #888; font-size: .9rem; margin-bottom: 24px; }
#armador-pc .apc-modal-btns { display: flex; flex-direction: column; gap: 10px; }
#armador-pc .apc-modal-btns a {
  display: block; padding: 13px;
  background: var(--cyan-grad); color: white;
  border-radius: 12px; font-weight: 700; font-size: .95rem; text-decoration: none;
}
#armador-pc .apc-modal-btns button {
  padding: 11px; background: none; border: 1.5px solid #e8e8e8;
  border-radius: 12px; cursor: pointer; font-size: .85rem;
  color: #888; font-family: 'Rubik', sans-serif;
}
#armador-pc .apc-modal-btns button:hover { border-color: #888; color: #3F3D38; }
</style>

<!-- ============================================================
     HTML
     ============================================================ -->
<div id="armador-pc">

  <div class="apc-header">
    <h1>Armá tu <span>PC</span></h1>
    <p>Elegí cada componente y los sumamos al carrito de una sola vez</p>
  </div>

  <div class="apc-body">

    <!-- Panel izquierdo: tabs + productos inline -->
    <div class="apc-main">
      <div class="apc-tabs" id="apcTabs"></div>

      <div class="apc-panel">
        <div class="apc-panel-head">
          <div class="apc-panel-title" id="apcTitle"></div>
          <div style="display:flex;align-items:center;gap:8px">
            <button class="apc-refresh-btn" onclick="APC.refresh()" title="Actualizar productos">↻</button>
            <button class="apc-skip-btn" id="apcSkip" onclick="APC.skip()">Omitir este paso</button>
          </div>
        </div>
        <div class="apc-search-wrap">
          <input id="apcSearch" class="apc-search" type="text"
                 placeholder="Buscar..." oninput="APC.search(this.value)">
          <span class="apc-filter-count" id="apcFilterCount"></span>
        </div>
        <div id="apcCompatNotice"></div>
        <div class="apc-grid" id="apcGrid"></div>
      </div>
    </div>

    <!-- Sidebar derecho: resumen -->
    <div class="apc-sidebar">
      <div class="sum-card">
        <div class="sum-head">
          <div class="sum-head-dot"></div>
          <span>Tu configuración</span>
          <span class="sum-count" id="apcSubtitle">0 componentes</span>
        </div>
        <div class="sum-items" id="apcSumBody"></div>
        <div class="sum-footer">
          <div class="power-banner" id="apcWattsWrap" style="display:none">
            ⚡ <span id="apcWattsText"></span><span id="apcWattsPsuAlert"></span>
          </div>
          <div id="apcCompat"></div>
          <div class="dual-totals">
            <div class="total-block total-transfer">
              <div class="total-lbl">Transferencia</div>
              <div class="total-amt" id="apcTotalTransfer">$0</div>
            </div>
            <div class="total-block total-card">
              <div class="total-lbl">Tarjeta · 6 cuotas sin interés</div>
              <div class="total-amt" id="apcTotalCard">$0</div>
            </div>
          </div>
          <button class="btn-cart" id="apcBtnCart" onclick="APC.addAll()" disabled>
            🛒 Agregar todo al carrito
          </button>
          <button class="btn-presupuesto" id="apcBtnPresupuesto" onclick="APC.descargarPresupuesto()" disabled>
            📄 Descargar presupuesto
          </button>
          <button class="btn-reset" onclick="APC.reset()">Empezar de nuevo</button>
        </div>
      </div>
    </div>

  </div><!-- /.apc-body -->

  <!-- Barra flotante mobile -->
  <div class="apc-mobile-bar" id="apcMobileBar">
    <div class="apc-mobile-bar-info">
      <span class="apc-mobile-bar-count" id="apcMobileCount">0 componentes</span>
      <span class="apc-mobile-bar-total" id="apcMobileTotal">$0</span>
    </div>
    <button class="apc-mobile-bar-btn" onclick="APC.openDrawer()">Ver configuración ›</button>
  </div>

  <!-- Overlay oscuro mobile -->
  <div class="apc-mobile-overlay" id="apcMobileOverlay" onclick="APC.closeDrawer()"></div>

  <!-- Drawer mobile (sidebar completo) -->
  <div class="apc-mobile-drawer" id="apcMobileDrawer">
    <div class="apc-mobile-drawer-handle"></div>
    <div class="sum-card" style="flex:1;border:none;border-radius:0;overflow:hidden;display:flex;flex-direction:column;">
      <div class="sum-head">
        <div class="sum-head-dot"></div>
        <span>Tu configuración</span>
        <span class="sum-count" id="apcMobileSubtitle">0 componentes</span>
      </div>
      <div class="sum-items" id="apcMobileSumBody" style="flex:1;overflow-y:auto;"></div>
      <div class="sum-footer">
        <div id="apcMobileWattsWrap" style="display:none" class="power-banner">
          ⚡ <span id="apcMobileWattsText"></span>
        </div>
        <div class="compat-ok" id="apcMobileCompatOk" style="display:none">✅ Componentes compatibles</div>
        <div class="compat-err" id="apcMobileCompatErr" style="display:none"></div>
        <div class="dual-totals">
          <div class="total-block total-transfer">
            <div class="total-lbl">Transferencia</div>
            <div class="total-amt" id="apcMobileTotalT">$0</div>
          </div>
          <div class="total-block total-card">
            <div class="total-lbl">Tarjeta · 6 cuotas</div>
            <div class="total-amt" id="apcMobileTotalC">$0</div>
          </div>
        </div>
        <button class="btn-cart" id="apcMobileBtnCart" onclick="APC.addAll()" disabled>🛒 Agregar al carrito</button>
        <button class="btn-presupuesto" id="apcMobileBtnPresupuesto" onclick="APC.descargarPresupuesto()" disabled style="margin-top:8px">📄 Descargar presupuesto</button>
        <button class="btn-reset" onclick="APC.reset();APC.closeDrawer()">Empezar de nuevo</button>
      </div>
    </div>
  </div>

  <!-- Overlay éxito -->
  <div class="apc-overlay" id="apcOverlay">
    <div class="apc-modal">
      <div class="apc-modal-ico">🎉</div>
      <h2>¡Todo listo!</h2>
      <p>Los componentes fueron agregados al carrito. Podés seguir comprando o ir al checkout.</p>
      <div class="apc-modal-btns">
        <a href="/checkout">Ir al carrito</a>
        <button onclick="APC.closeModal()">Seguir armando</button>
      </div>
    </div>
  </div>

</div><!-- /#armador-pc -->

<script>
(function () {
'use strict';

/* =====================================================
   CONFIGURACIÓN
   ===================================================== */
var CFG = {
  storeId:  '6990490',
  proxyUrl: 'https://parish-privacy-tracks-grand.trycloudflare.com',
  cats: {
    cpu:      { id: 36289644, name: 'Procesador',        icon: '⚙️',  req: true  },
    mother:   { id: 36289548, name: 'Placa Madre',        icon: '🔌',  req: true  },
    ram:      { id: 36289520, name: 'Memoria RAM',        icon: '💾',  req: true,  multi: true },
    storage:  { id: 36285772, name: 'Almacenamiento',     icon: '💿',  req: true,  multi: true },
    gpu:      { id: 36289624, name: 'Tarjeta de Video',   icon: '🎮',  req: false },
    cooling:  { id: 36289658, name: 'Refrigeración',      icon: '❄️',  req: false },
    case_:    { id: 36289440, name: 'Gabinete',           icon: '🖥️',  req: false },
    psu:      { id: 36289429, name: 'Fuente de Poder',    icon: '⚡',  req: false },
    os:       { id: 36289670, name: 'Sistema Operativo',  icon: '🪟',  req: false },
    connectivity: { id: 36285955, name: 'Conectividad WiFi', icon: '📶', req: false },
    monitor:  { id: 36289547, name: 'Monitor',            icon: '🖥️',  req: false, multi: true },
    periph:   { ids: [36289490, 36289556, 36289730, 36285942, 36289602], name: 'Periféricos', icon: '🎮', req: false, multi: true },
  },
  attrSocket: 'Socket',
  attrRam:    'Tipo de RAM',
  socketRules: {
    'AM4':    ['AM4'],
    'AM5':    ['AM5'],
    'LGA1700':['LGA1700'],
    'LGA1851':['LGA1851'],
    'LGA1200':['LGA1200'],
  },
  surcharge: 25,   /* descuento transferencia: card × (1 - 0.25) = card × 0.75 */
  ramSocket: {
    'AM4':    'DDR4',
    'AM5':    'DDR5',
    'LGA1200':'DDR4',
    'LGA1700': null,   /* soporta DDR4 o DDR5 según la placa — no filtrar */
    'LGA1851':'DDR5',
  },
};

/* =====================================================
   ICONOS SVG
   ===================================================== */
var ICONS = {
  cpu:     '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="14" height="14" rx="1.5"/><rect x="12" y="12" width="8" height="8" rx="0.5"/><line x1="12" y1="9" x2="12" y2="5"/><line x1="16" y1="9" x2="16" y2="5"/><line x1="20" y1="9" x2="20" y2="5"/><line x1="12" y1="23" x2="12" y2="27"/><line x1="16" y1="23" x2="16" y2="27"/><line x1="20" y1="23" x2="20" y2="27"/><line x1="9" y1="12" x2="5" y2="12"/><line x1="9" y1="16" x2="5" y2="16"/><line x1="9" y1="20" x2="5" y2="20"/><line x1="23" y1="12" x2="27" y2="12"/><line x1="23" y1="16" x2="27" y2="16"/><line x1="23" y1="20" x2="27" y2="20"/></svg>',
  mother:  '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="26" height="26" rx="2"/><rect x="6" y="6" width="8" height="8" rx="1"/><rect x="18" y="6" width="3" height="12" rx="0.5"/><rect x="23" y="6" width="3" height="12" rx="0.5"/><rect x="6" y="19" width="20" height="3" rx="0.5"/><rect x="6" y="24" width="20" height="2.5" rx="0.5"/></svg>',
  ram:     '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="14" width="26" height="9" rx="1"/><line x1="15" y1="14" x2="15" y2="18"/><rect x="5" y="10" width="3" height="4" rx="0.4"/><rect x="10" y="10" width="3" height="4" rx="0.4"/><rect x="15" y="10" width="3" height="4" rx="0.4"/><rect x="20" y="10" width="3" height="4" rx="0.4"/><rect x="25" y="10" width="2.5" height="4" rx="0.4"/></svg>',
  storage: '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="4" width="22" height="24" rx="2"/><circle cx="16" cy="16" r="6"/><circle cx="16" cy="16" r="2"/><line x1="20.5" y1="11.5" x2="23" y2="9"/><circle cx="23.5" cy="8.5" r="1"/></svg>',
  gpu:     '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="10" width="28" height="14" rx="2"/><circle cx="11" cy="17" r="4"/><circle cx="11" cy="17" r="1.5"/><circle cx="22" cy="17" r="4"/><circle cx="22" cy="17" r="1.5"/><rect x="2" y="8" width="5" height="3" rx="0.8"/><line x1="6" y1="24" x2="6" y2="27"/><line x1="10" y1="24" x2="10" y2="27"/><line x1="14" y1="24" x2="14" y2="27"/></svg>',
  psu:     '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="7" width="26" height="18" rx="2"/><circle cx="12" cy="16" r="5"/><circle cx="12" cy="16" r="2"/><line x1="12" y1="11" x2="12" y2="13"/><line x1="12" y1="19" x2="12" y2="21"/><line x1="7" y1="16" x2="9" y2="16"/><line x1="15" y1="16" x2="17" y2="16"/><line x1="20" y1="12" x2="28" y2="12"/><line x1="20" y1="16" x2="28" y2="16"/><line x1="20" y1="20" x2="28" y2="20"/></svg>',
  case_:   '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="2" width="14" height="28" rx="2"/><circle cx="16" cy="8" r="2"/><rect x="12" y="14" width="8" height="2" rx="0.4"/><rect x="12" y="18" width="8" height="2" rx="0.4"/><rect x="12" y="22" width="8" height="2" rx="0.4"/></svg>',
  cooling: '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="8" y="17" width="16" height="5" rx="1"/><line x1="11" y1="17" x2="11" y2="7"/><line x1="14" y1="17" x2="14" y2="7"/><line x1="17" y1="17" x2="17" y2="7"/><line x1="20" y1="17" x2="20" y2="7"/><line x1="8" y1="9" x2="24" y2="9"/><line x1="8" y1="7" x2="24" y2="7"/><circle cx="16" cy="27" r="4"/><circle cx="16" cy="27" r="1.5"/></svg>',
  os:      '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="5" width="24" height="17" rx="2"/><line x1="16" y1="22" x2="16" y2="26"/><line x1="11" y1="26" x2="21" y2="26"/><rect x="8" y="9" width="6" height="5" rx="0.6"/><rect x="16" y="9" width="6" height="5" rx="0.6"/><rect x="8" y="16" width="6" height="4" rx="0.6"/><rect x="16" y="16" width="6" height="4" rx="0.6"/></svg>',
  connectivity: '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M5 15a15 15 0 0 1 22 0"/><path d="M9 20a9 9 0 0 1 14 0"/><path d="M13 25a5 5 0 0 1 6 0"/><circle cx="16" cy="28" r="1.5" fill="currentColor" stroke="none"/></svg>',
  monitor: '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="26" height="17" rx="1.5"/><line x1="16" y1="22" x2="16" y2="27"/><line x1="10" y1="27" x2="22" y2="27"/><line x1="6" y1="8" x2="9" y2="8"/></svg>',
  periph:  '<svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="9" width="22" height="11" rx="1.5"/><circle cx="6" cy="13" r="0.7" fill="currentColor"/><circle cx="9" cy="13" r="0.7" fill="currentColor"/><circle cx="12" cy="13" r="0.7" fill="currentColor"/><circle cx="15" cy="13" r="0.7" fill="currentColor"/><circle cx="18" cy="13" r="0.7" fill="currentColor"/><line x1="7" y1="16.5" x2="19" y2="16.5"/><ellipse cx="26.5" cy="18" rx="3.5" ry="5"/><line x1="26.5" y1="13" x2="26.5" y2="17"/></svg>',
};
function ico(key, size) {
  var svg = ICONS[key] || ICONS['cpu'];
  return '<span style="display:inline-flex;align-items:center;justify-content:center;width:'+(size||18)+'px;height:'+(size||18)+'px">'+svg+'</span>';
}

/* =====================================================
   CONSUMO EN WATTS
   ===================================================== */
var WATTS = {
  cpu: function (p) {
    var n = nameStr(p).toLowerCase();
    /* Intel Core Ultra (Arrow Lake / Meteor Lake) — K = mayor TDP */
    if (/core ultra 9/.test(n))              return /\bk\b/.test(n) ? 125 : 65;
    if (/core ultra 7/.test(n))              return /\bk\b/.test(n) ? 125 : 65;
    if (/core ultra 5/.test(n))              return /\bk\b/.test(n) ? 125 : 65;
    /* AMD Ryzen / Intel Core clásicos */
    if (/ryzen 9|core i9|threadripper/.test(n)) return 125;
    if (/ryzen 7|core i7/.test(n))              return 105;
    if (/ryzen 5|core i5/.test(n))              return 65;
    if (/ryzen 3|core i3/.test(n))              return 58;
    /* Gama baja */
    if (/pentium|celeron/.test(n))              return 58;
    if (/athlon/.test(n))                       return 35;
    return 65;
  },
  gpu: function (p) {
    var n = nameStr(p).toLowerCase();
    /* RTX 5000 series */
    if (/5090/.test(n))                      return 575;
    if (/5080/.test(n))                      return 360;
    if (/5070 ti|5070ti/.test(n))            return 300;
    if (/5070/.test(n))                      return 250;
    if (/5060 ti|5060ti/.test(n))            return 180;
    if (/5060/.test(n))                      return 150;
    if (/5050/.test(n))                      return 130;
    /* RX 9000 series */
    if (/9070 xt|9070xt/.test(n))            return 304;
    if (/9070/.test(n))                      return 220;
    if (/9060 xt|9060xt/.test(n))            return 150;
    if (/9060/.test(n))                      return 130;
    /* RTX 4000 series */
    if (/4090/.test(n))                      return 450;
    if (/4080/.test(n))                      return 320;
    if (/4070 ti|4070ti/.test(n))            return 285;
    if (/4070/.test(n))                      return 200;
    if (/4060 ti|4060ti/.test(n))            return 160;
    if (/4060/.test(n))                      return 115;
    /* RTX 3000 series */
    if (/3090/.test(n))                      return 350;
    if (/3080/.test(n))                      return 320;
    if (/3070/.test(n))                      return 220;
    if (/3060 ti|3060ti/.test(n))            return 200;
    if (/3060/.test(n))                      return 170;
    if (/3050/.test(n))                      return 100;
    /* RX 7000 series */
    if (/7900 xtx|7900 xt/.test(n))          return 355;
    if (/7900/.test(n))                      return 300;
    if (/7800 xt/.test(n))                   return 263;
    if (/7700 xt/.test(n))                   return 245;
    if (/7600 xt/.test(n))                   return 190;
    if (/7600/.test(n))                      return 165;
    /* RX 6000 series */
    if (/6950 xt/.test(n))                   return 335;
    if (/6900 xt|6800 xt/.test(n))           return 300;
    if (/6800/.test(n))                      return 250;
    if (/6700 xt/.test(n))                   return 230;
    if (/6700/.test(n))                      return 175;
    if (/6600 xt/.test(n))                   return 160;
    if (/6600/.test(n))                      return 132;
    /* Gama baja / legacy */
    if (/1030|gt 1030/.test(n))              return 30;
    if (/1650/.test(n))                      return 75;
    if (/1660 ti|1660ti/.test(n))            return 120;
    if (/1660/.test(n))                      return 120;
    return 150;
  },
  ram:     function (p, qty) { var t=(attr(p,CFG.attrRam)||'').toLowerCase(); return (t.indexOf('ddr5')!==-1?7:5)*qty; },
  storage: function (p, qty) { var n=nameStr(p).toLowerCase(); if(/nvme|m\.2/.test(n))return 7*qty; if(/ssd/.test(n))return 4*qty; return 10*qty; },
  mother:  50,
  psu:     0,
  case_:   15,
  cooling: function (p) { var n=nameStr(p).toLowerCase(); if(/aio|líquid|liquid|kraken|corsair h|nzxt k|arctic liquid|240|280|360/.test(n))return 18; return 8; },
  os: 0,
};
function estimateWatts() {
  var t=20;
  Object.keys(CFG.cats).forEach(function(k){ selArr(k).forEach(function(item){ var fn=WATTS[k]; if(fn===undefined)return; t+=(typeof fn==='function')?fn(item.product,item.qty):fn; }); });
  return t;
}
function recommendedPSU(w) {
  var needed=Math.ceil(w*1.3), sizes=[450,550,650,750,850,1000,1200];
  for(var i=0;i<sizes.length;i++){if(sizes[i]>=needed)return sizes[i];}return 1200;
}
function parsePSUWatts(p) { var m=nameStr(p).match(/(\d{3,4})\s*[Ww]/); return m?parseInt(m[1]):0; }

function renderWatts() {
  var wrap=$('apcWattsWrap'), watts=estimateWatts();
  if(watts<=20){wrap.style.display='none';return;}
  wrap.style.display='';
  var rec=recommendedPSU(watts), psuSel=S.sel['psu'], psuW=psuSel?parsePSUWatts(psuSel):0;
  $('apcWattsText').innerHTML='~<strong>'+watts+'W</strong> estimado · Recomendada: <strong>'+rec+'W</strong>';
  var al=$('apcWattsPsuAlert');
  if(psuSel&&psuW>=rec) al.innerHTML=' <span style="color:#2ecc71;font-weight:700">✅ '+psuW+'W OK</span>';
  else if(psuSel&&psuW>0) al.innerHTML=' <span style="color:#e74c3c;font-weight:700">⚠️ '+psuW+'W insuf.</span>';
  else al.innerHTML='';
}

/* =====================================================
   ESTADO
   ===================================================== */
var S = { step: Object.keys(CFG.cats)[0], sel:{}, cache:{}, cacheTs:{}, query:'', busy:false, mode:'transfer' };
var CACHE_TTL = 5 * 60 * 1000; /* 5 minutos */

/* =====================================================
   HELPERS
   ===================================================== */
function $(id){return document.getElementById(id);}
function fmt(n){return '$'+parseFloat(n||0).toLocaleString('es-AR',{minimumFractionDigits:0,maximumFractionDigits:0});}
function nameStr(p){var n=p.name;if(!n)return '';if(typeof n==='object')return n.es||n.pt||Object.values(n)[0]||'';return n;}
/* precio de lista (tarjeta/cuotas) = precio de Odoo si está cargado, si no el de catálogo (variants[0].price) */
function price(p){
  if(p._odooPrice!=null) return p._odooPrice;
  var v0=p.variants&&p.variants[0]?p.variants[0]:null;
  if(!v0) return 0;
  return parseFloat(v0.price||0);
}
/* precio transferencia, calculado sobre el precio base de price() (Odoo o catálogo):
   - Si la API trae promotional_price válido (< card), ese ES el precio real
   - Si no: descuento exacto = card × (1 - surcharge/100)
     surcharge=25 → multiplica por 0.75 exacto (vs /1.33 que da 0.7519, error de ~$1000 en precios altos) */
function transferPrice(p){
  var v0=p.variants&&p.variants[0]?p.variants[0]:null;
  if(!v0) return 0;
  var card=price(p);
  var promo=parseFloat(v0.promotional_price||0);
  if(p._odooPrice==null && promo>0&&promo<card) return Math.round(promo);
  return Math.round(card*(1-CFG.surcharge/100));
}
function img(p){if(!p.images||!p.images.length)return null;var i=p.images[0];return i.src||i.url||(typeof i==='string'?i:null);}
function variant(p){return(p.variants&&p.variants[0])?p.variants[0].id:null;}
function attr(p,name){if(!p.attributes)return null;for(var i=0;i<p.attributes.length;i++){if((p.attributes[i].name||'').toLowerCase()===name.toLowerCase())return p.attributes[i].value||p.attributes[i].values||null;}return null;}
function descText(p){var d=p.description||'';if(typeof d==='object')d=d.es||d.pt||Object.values(d)[0]||'';return d.replace(/<[^>]*>/g,' ');}
function detectSocket(p){
  var s=attr(p,CFG.attrSocket);if(s)return typeof s==='string'?s:null;
  var text=nameStr(p)+' '+descText(p);
  /* 1. Nombre exacto del socket */
  var sockets=['AM5','AM4','LGA1851','LGA1700','LGA1200'];
  for(var i=0;i<sockets.length;i++){if(text.indexOf(sockets[i])!==-1)return sockets[i];}
  /* 2. Intel Ultra series → LGA1851 */
  if(/Core\s*Ultra/i.test(text))return 'LGA1851';
  /* 3. Chipset → socket */
  if(/\b(Z890|B860|H810|W880)\b/i.test(text))return 'LGA1851';
  if(/\b(Z790|B760|H770|H610|Z690|B660|H670)\b/i.test(text))return 'LGA1700';
  if(/\b(Z590|B560|H570|H510|Z490|B460|H470)\b/i.test(text))return 'LGA1200';
  if(/\b(Z390|Z370|B365|B360|H370|H310|Z270|B250|H270|H110)\b/i.test(text))return 'LGA1151';
  if(/\b(X670E?|B650E?|A620)\b/i.test(text))return 'AM5';
  if(/\b(X570|B550|A520|B450|X470|B350|A320)\b/i.test(text))return 'AM4';
  /* 4. Número de socket parcial entre paréntesis o solo */
  if(/\(1851\)|\b1851\b/.test(text))return 'LGA1851';
  if(/\(1700\)|\b1700\b/.test(text))return 'LGA1700';
  if(/\(1200\)|\b1200\b/.test(text))return 'LGA1200';
  if(/\(1151\)|\b1151\b/.test(text))return 'LGA1151';
  return null;
}
function detectRamType(p){var r=attr(p,CFG.attrRam);if(r)return typeof r==='string'?r:null;var text=nameStr(p)+' '+descText(p);if(/DDR5/i.test(text))return 'DDR5';if(/DDR4/i.test(text))return 'DDR4';if(/DDR3/i.test(text))return 'DDR3';return null;}
/* precio tarjeta = price de la API (ya es el precio con recargo) */
function cardPrice(p){return price(p);}
function isMulti(key){return !!CFG.cats[key].multi;}
function selArr(key){var v=S.sel[key];if(!v)return[];if(isMulti(key))return v;return[{product:v,qty:1}];}
function selQty(key,productId){if(!isMulti(key)||!S.sel[key])return 0;var found=S.sel[key].filter(function(i){return i.product.id===productId;})[0];return found?found.qty:0;}

function productTags(p, key) {
  var tags=[];
  if(key==='cpu'||key==='mother'){var s=detectSocket(p);if(s){var sc=s.indexOf('AM4')!==-1?'tag-am4':s.indexOf('AM5')!==-1?'tag-am5':'tag-lga';tags.push('<span class="apc-tag '+sc+'">'+s+'</span>');}}
  if(key==='ram'){var rt=detectRamType(p);if(rt){var rc=/DDR5/i.test(rt)?'tag-ddr5':'tag-ddr4';tags.push('<span class="apc-tag '+rc+'">'+rt+'</span>');}}
  if(key==='psu'){var w=parsePSUWatts(p);if(w)tags.push('<span class="apc-tag tag-watts">'+w+'W</span>');}
  return tags.join('');
}

function showToast(msg) {
  var old=document.querySelector('.apc-toast');if(old)old.remove();
  var t=document.createElement('div');t.className='apc-toast';t.textContent=msg;
  document.body.appendChild(t);
  setTimeout(function(){if(t.parentNode)t.remove();},2400);
}

/* =====================================================
   MODO DEMO
   ===================================================== */
var DEMO=(location.hostname==='localhost'||location.hostname==='127.0.0.1'||location.protocol==='file:');
var MOCK={
  cpu:[
    {id:1,name:'AMD Ryzen 5 5600X 6 Core 3.7GHz AM4',price:'89999',variants:[{id:101}],images:[],attributes:[{name:'Socket',value:'AM4'}]},
    {id:2,name:'AMD Ryzen 7 7700X 8 Core 4.5GHz AM5',price:'149999',variants:[{id:102}],images:[],attributes:[{name:'Socket',value:'AM5'}]},
    {id:3,name:'Intel Core i5-12400F 6 Core 2.5GHz LGA1700',price:'79999',variants:[{id:103}],images:[],attributes:[{name:'Socket',value:'LGA1700'}]},
    {id:4,name:'Intel Core i7-13700K 16 Core LGA1700',price:'189999',variants:[{id:104}],images:[],attributes:[{name:'Socket',value:'LGA1700'}]},
  ],
  mother:[
    {id:10,name:'ASUS PRIME B550M-A Wi-Fi — AMD AM4 DDR4',price:'69999',variants:[{id:110}],images:[],attributes:[{name:'Socket',value:'AM4'}]},
    {id:11,name:'MSI MAG B650 Tomahawk WiFi — AMD AM5 DDR5',price:'129999',variants:[{id:111}],images:[],attributes:[{name:'Socket',value:'AM5'}]},
    {id:12,name:'Gigabyte B660M DS3H AX — Intel LGA1700 DDR4',price:'64999',variants:[{id:112}],images:[],attributes:[{name:'Socket',value:'LGA1700'}]},
    {id:13,name:'ASUS ROG STRIX Z790-H Gaming — Intel LGA1700',price:'219999',variants:[{id:113}],images:[],attributes:[{name:'Socket',value:'LGA1700'}]},
  ],
  ram:[
    {id:20,name:'Kingston Fury Beast DDR4 16GB (2x8) 3200MHz',price:'29999',variants:[{id:120}],images:[],attributes:[{name:'Tipo de RAM',value:'DDR4'}]},
    {id:21,name:'Corsair Vengeance DDR4 32GB (2x16) 3600MHz',price:'54999',variants:[{id:121}],images:[],attributes:[{name:'Tipo de RAM',value:'DDR4'}]},
    {id:22,name:'G.Skill Trident Z5 DDR5 32GB (2x16) 6000MHz',price:'89999',variants:[{id:122}],images:[],attributes:[{name:'Tipo de RAM',value:'DDR5'}]},
    {id:23,name:'Kingston Fury Beast DDR5 16GB (2x8) 5200MHz',price:'49999',variants:[{id:123}],images:[],attributes:[{name:'Tipo de RAM',value:'DDR5'}]},
  ],
  storage:[
    {id:30,name:'SSD Samsung 870 EVO 500GB SATA',price:'34999',variants:[{id:130}],images:[]},
    {id:31,name:'SSD Kingston NV2 1TB NVMe M.2',price:'44999',variants:[{id:131}],images:[]},
    {id:32,name:'SSD WD Black SN850X 1TB NVMe Gen4',price:'89999',variants:[{id:132}],images:[]},
    {id:33,name:'HDD Seagate Barracuda 2TB 7200RPM SATA',price:'24999',variants:[{id:133}],images:[]},
  ],
  gpu:[
    {id:40,name:'NVIDIA GeForce RTX 4060 8GB GDDR6',price:'259999',variants:[{id:140}],images:[]},
    {id:41,name:'NVIDIA GeForce RTX 4070 12GB GDDR6X',price:'449999',variants:[{id:141}],images:[]},
    {id:42,name:'AMD Radeon RX 7600 8GB GDDR6',price:'209999',variants:[{id:142}],images:[]},
    {id:43,name:'AMD Radeon RX 7700 XT 12GB GDDR6',price:'319999',variants:[{id:143}],images:[]},
  ],
  psu:[
    {id:50,name:'Corsair CV550 550W 80+ Bronze',price:'34999',variants:[{id:150}],images:[]},
    {id:51,name:'EVGA SuperNOVA 650 G6 80+ Gold Modular',price:'64999',variants:[{id:151}],images:[]},
    {id:52,name:'Seasonic Focus GX-850 850W 80+ Gold',price:'99999',variants:[{id:152}],images:[]},
  ],
  case_:[
    {id:60,name:'Cooler Master MasterBox Q300L Micro ATX',price:'29999',variants:[{id:160}],images:[]},
    {id:61,name:'NZXT H510 Flow Mid Tower ATX',price:'69999',variants:[{id:161}],images:[]},
    {id:62,name:'Lian Li Lancool 216 RGB ATX',price:'89999',variants:[{id:162}],images:[]},
  ],
  cooling:[
    {id:70,name:'Cooler Master Hyper 212 Black Edition',price:'19999',variants:[{id:170}],images:[]},
    {id:71,name:'Noctua NH-D15 Dual Torre 140mm',price:'54999',variants:[{id:171}],images:[]},
    {id:72,name:'NZXT Kraken 240mm AIO Líquida RGB',price:'89999',variants:[{id:172}],images:[]},
  ],
  os:[
    {id:80,name:'Microsoft Windows 11 Home 64-bit OEM',price:'44999',variants:[{id:180}],images:[]},
    {id:81,name:'Microsoft Windows 11 Pro 64-bit OEM',price:'64999',variants:[{id:181}],images:[]},
    {id:82,name:'Ubuntu Desktop 24.04 LTS (Gratis)',price:'0',variants:[{id:182}],images:[]},
  ],
};

/* =====================================================
   FILTROS PERMANENTES (independientes del CPU)
   ===================================================== */
var DEAD_SOCKETS=['LGA1151','LGA1150','LGA1155','LGA1156','AM3','AM3+','FM2','FM2+'];
function isBlacklisted(p,key){
  if(key==='mother'){
    var sock=detectSocket(p);
    if(sock&&DEAD_SOCKETS.indexOf(sock)!==-1)return true;
  }
  if(key==='ram'){
    var rt=detectRamType(p);
    if(rt&&rt.indexOf('DDR4')===-1&&rt.indexOf('DDR5')===-1)return true; /* filtra DDR3 y similares */
  }
  return false;
}

/* =====================================================
   API
   ===================================================== */
function fetchCatByKey(key){
  var c=CFG.cats[key];
  if(c.ids&&c.ids.length){
    /* Categoría compuesta: trae varias y deduplica por ID */
    return Promise.all(c.ids.map(function(id){return fetchCat(id);}))
      .then(function(arrays){
        var seen={},out=[];
        arrays.forEach(function(arr){arr.forEach(function(p){if(!seen[p.id]){seen[p.id]=1;out.push(p);}});});
        return out;
      });
  }
  return fetchCat(c.id);
}

function fetchCat(catId) {
  if(DEMO){var key=Object.keys(CFG.cats).find(function(k){return CFG.cats[k].id===catId;});return Promise.resolve(MOCK[key]||[]);}

  /* per_page=200 trae todos los productos en una sola request.
     El proxy ignora el parámetro page, así que no paginamos. */
  var url=CFG.proxyUrl+'/api/products?category_id='+catId+'&per_page=200&store_id='+CFG.storeId;
  return fetch(url,{cache:'no-store'})
    .then(function(r){return r.ok?r.json():[];})
    .then(function(d){
      var prods=Array.isArray(d)?d:(d.products||d.results||[]);
      return prods.filter(function(p){
        if(!p.variants||!p.variants.length)return false;
        return p.variants.some(function(v){
          if(v.available===false||v.available==='false')return false;
          if(v.stock===null||v.stock===undefined||v.stock==='')return true;
          return parseInt(v.stock)>0;
        });
      });
    })
    .then(attachOdooPrices)
    .catch(function(){return[];});
}

/* Trae de una sola vez el precio de Odoo de todos los SKUs de la categoría,
   y lo deja guardado en p._odooPrice — de ahí en más price()/transferPrice()
   lo usan automáticamente en toda la UI (grilla, resumen, total). */
function attachOdooPrices(prods){
  var skus=prods.map(function(p){var v0=p.variants&&p.variants[0];return v0&&v0.sku;}).filter(Boolean);
  if(!skus.length) return prods;
  var url=CFG.proxyUrl+'/api/prices?store_id='+CFG.storeId+'&skus='+encodeURIComponent(skus.join(','));
  return fetch(url)
    .then(function(r){return r.ok?r.json():{prices:{}};})
    .then(function(d){
      var odooPrices=d.prices||{};
      prods.forEach(function(p){
        var v0=p.variants&&p.variants[0];
        var sku=v0&&v0.sku;
        if(sku && odooPrices[sku]!==undefined) p._odooPrice=parseFloat(odooPrices[sku]);
      });
      return prods;
    })
    .catch(function(){return prods;}); /* si falla, se sigue mostrando el precio de catálogo */
}

/* Arma el pedido con precio de Odoo vía el backend propio (Armador App) y
   devuelve la URL de checkout de Tienda Nube para completar la compra ahí. */
function createOrderViaBackend(items, customer){
  var skus=items.map(function(i){return i.sku;}).filter(Boolean);
  var pricesUrl=CFG.proxyUrl+'/api/prices?store_id='+CFG.storeId+'&skus='+encodeURIComponent(skus.join(','));

  return fetch(pricesUrl)
    .then(function(r){return r.json();})
    .then(function(d){
      var odooPrices=d.prices||{};
      var orderItems=items.map(function(i){
        return {
          variant_id: i.variantId,
          quantity: i.qty,
          catalogPrice: i.catalogPrice,
          /* si no hay precio especial cargado en Odoo para ese SKU, se cobra el de catálogo */
          odooPrice: (i.sku && odooPrices[i.sku] !== undefined) ? odooPrices[i.sku] : i.catalogPrice,
        };
      });
      return fetch(CFG.proxyUrl+'/api/orders',{
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify({
          store_id: CFG.storeId,
          customer: customer,
          items: orderItems,
          note: 'Armado desde /arma-tu-pc/',
        }),
      });
    })
    .then(function(r){return r.json();})
    .then(function(d){
      if(!d.checkoutUrl) throw new Error(d.error||'No se pudo crear el pedido');
      return d.checkoutUrl;
    });
}

/* =====================================================
   COMPATIBILIDAD
   ===================================================== */
var Compat = {
  cpuSocket:function(){var c=S.sel['cpu'];return c?detectSocket(c):null;},
  ok:function(product,key){
    var sock=Compat.cpuSocket();if(!sock)return true;
    if(key==='mother'){var ms=detectSocket(product);if(!ms)return true;return(CFG.socketRules[sock]||[]).some(function(s){return ms.toLowerCase().indexOf(s.toLowerCase())!==-1;});}
    if(key==='ram'){
      var req=CFG.ramSocket[sock];
      /* LGA1700 — depende de la placa madre seleccionada */
      if(sock==='LGA1700'){
        var mb=S.sel['mother'];
        if(mb){
          var mbRam=detectRamType(mb);
          if(mbRam){
            var rt=detectRamType(product);
            if(!rt)return true;
            return rt.toLowerCase().indexOf(mbRam.toLowerCase())!==-1;
          }
        }
        return true; /* sin placa seleccionada, no filtrar */
      }
      if(!req)return true;
      var rt=detectRamType(product);if(!rt)return true;
      return rt.toLowerCase().indexOf(req.toLowerCase())!==-1;
    }
    return true;
  },
  status:function(){
    var issues=[],cpu=S.sel['cpu'],mb=S.sel['mother'],ramFirst=selArr('ram')[0],ram=ramFirst?ramFirst.product:null;
    if(cpu&&mb){var cs=detectSocket(cpu),ms=detectSocket(mb);if(cs&&ms){var ok=(CFG.socketRules[cs]||[]).some(function(s){return ms.toLowerCase().indexOf(s.toLowerCase())!==-1;});if(!ok)issues.push('Socket CPU ('+cs+') ≠ Placa madre ('+ms+')');}}
    if(cpu&&ram){
      var cs2=detectSocket(cpu),req=CFG.ramSocket[cs2],rt=detectRamType(ram);
      /* LGA1700 — depende de la placa madre */
      if(cs2==='LGA1700'&&mb){var mbR=detectRamType(mb);if(mbR)req=mbR;}
      if(cs2&&req&&rt&&rt.toLowerCase().indexOf(req.toLowerCase())===-1)issues.push('RAM ('+rt+') incompatible — requiere '+req);
    }
    return issues;
  },
};

/* =====================================================
   RENDER
   ===================================================== */
var R = {
  all: function(){R.tabs();R.header();R.grid();R.summary();},

  tabs: function(){
    var keys=Object.keys(CFG.cats),html='';
    keys.forEach(function(k){
      var c=CFG.cats[k];
      var isDone=isMulti(k)?(S.sel[k]&&S.sel[k].length>0):!!S.sel[k];
      var cls='apc-tab'+(k===S.step?' active':'')+(isDone?' done':'');
      html+='<button class="'+cls+'" onclick="APC.go(\''+k+'\')">'
           +ico(k,15)+' '+c.name
           +'<span class="apc-tab-check"> ✓</span>'
           +'</button>';
    });
    $('apcTabs').innerHTML=html;
  },

  header: function(){
    var c=CFG.cats[S.step];
    var multiHint=isMulti(S.step)?' <span class="apc-badge-multi">Podés elegir varios</span>':'';
    $('apcTitle').innerHTML=ico(S.step,18)+' '+c.name+(!c.req?' <span class="apc-badge-opt">Opcional</span>':'')+multiHint;
    $('apcSkip').style.display=c.req?'none':'';
    $('apcSearch').placeholder='Buscar '+c.name.toLowerCase()+'...';
    $('apcSearch').value='';
    S.query='';
  },

  grid: function(){
    var g=$('apcGrid');
    if(S.busy){g.innerHTML='<div class="apc-state"><div class="apc-spinner"></div><span>Cargando productos...</span></div>';$('apcFilterCount').textContent='';return;}

    var prods=S.cache[S.step]||[];
    var q=S.query.toLowerCase();
    var filtered=q?prods.filter(function(p){return nameStr(p).toLowerCase().indexOf(q)!==-1;}):prods;

    $('apcFilterCount').textContent=filtered.length+' producto'+(filtered.length!==1?'s':'');

    /* Aviso compatibilidad */
    var cn=$('apcCompatNotice');
    if(S.step==='mother'&&S.sel['cpu']){var cs=detectSocket(S.sel['cpu']);cn.innerHTML=cs?'<div class="apc-compat-notice">🔌 Mostrando placas compatibles con socket '+cs+'</div>':'';}
    else if(S.step==='ram'&&S.sel['cpu']){
      var cs2=detectSocket(S.sel['cpu']),req=cs2?CFG.ramSocket[cs2]:null;
      /* LGA1700 — usar el tipo de la placa madre seleccionada */
      if(cs2==='LGA1700'&&S.sel['mother']){var mbRam=detectRamType(S.sel['mother']);if(mbRam)req=mbRam;}
      cn.innerHTML=req?'<div class="apc-compat-notice">💾 Tu placa requiere RAM '+req+'</div>':'';
    }
    else{cn.innerHTML='';}

    if(!filtered.length){
      var msg=q?'Sin resultados para "'+q+'"':'Sin productos en esta categoría';
      g.innerHTML='<div class="apc-state"><span style="font-size:2.5rem;opacity:.3">'+CFG.cats[S.step].icon+'</span><span>'+msg+'</span></div>';
      /* Botón continuar */
      var ne=document.getElementById('apcNextWrap');
      if(ne)ne.outerHTML='';
      return;
    }

    var multi=isMulti(S.step),sel=S.sel[S.step],html='';
    filtered.forEach(function(p){
      if(!Compat.ok(p,S.step))return;
      var qty=multi?selQty(S.step,p.id):0;
      var isSel=multi?(qty>0):(sel&&sel.id===p.id);
      var src=img(p);
      var click='onclick="APC.pick(\''+S.step+'\','+p.id+')"';
      var cls='apc-card'+(multi&&isSel?' apc-multi-sel':(!multi&&isSel?' apc-selected':''));

      html+='<div class="'+cls+'" '+click+'>';
      if(multi&&qty>0) html+='<div class="apc-qty-badge">'+qty+'</div>';

      html+='<div class="apc-card-img-wrap">';
      if(src) html+='<img class="apc-card-img" src="'+src+'" alt="">';
      else    html+='<div class="apc-card-img-ph">'+ico(S.step,52)+'</div>';
      html+='</div>';

      html+='<div class="apc-card-body">';
      html+='<div class="apc-card-name">'+nameStr(p)+'</div>';
      var tags=productTags(p,S.step);
      if(tags) html+='<div class="apc-tags">'+tags+'</div>';
      html+='<div class="apc-prices">'
           +'<div class="apc-price-transfer"><div class="apc-price-amount">'+fmt(transferPrice(p))+'</div><div class="apc-price-sub">con Transferencia o depósito</div></div>'
           +'<div class="apc-price-card"><div class="apc-price-card-amount">'+fmt(cardPrice(p))+'</div><div class="apc-price-card-label">6 cuotas sin interés</div></div>'
           +'</div>';
      html+='</div>';

      if(multi&&isSel){
        html+='<div class="apc-qty-ctrl" onclick="event.stopPropagation()">'
             +'<button class="apc-qty-btn" onclick="APC.decrement(\''+S.step+'\','+p.id+')">−</button>'
             +'<span class="apc-qty-num">×'+qty+'</span>'
             +'<button class="apc-qty-btn" onclick="APC.pick(\''+S.step+'\','+p.id+')">+</button>'
             +'</div>';
      }
      html+='</div>';
    });

    g.innerHTML=html;

    /* Botón continuar para multi */
    var existing=document.getElementById('apcNextWrap');
    if(existing)existing.outerHTML='';
    if(multi){
      var hasAny=S.sel[S.step]&&S.sel[S.step].length>0;
      var btnHtml='<div class="apc-next-wrap" id="apcNextWrap">'
        +'<button class="apc-next-btn" onclick="APC.next()">'
        +(hasAny?'Continuar →':'Omitir este paso →')
        +'</button></div>';
      g.insertAdjacentHTML('afterend',btnHtml);
    }
  },

  summary: function(){
    var keys=Object.keys(CFG.cats),totalTransfer=0,totalCard=0,count=0,html='';
    keys.forEach(function(k){
      var c=CFG.cats[k],items=selArr(k);
      if(items.length===0){
        html+='<div class="sum-item item-empty">'
             +'<div class="sum-thumb">'+ico(k,18)+'</div>'
             +'<div class="sum-info"><div class="sum-cat">'+c.name+'</div><div class="sum-name">No seleccionado</div></div>'
             +'</div>';
      } else {
        items.forEach(function(item){
          totalTransfer+=transferPrice(item.product)*item.qty;
          totalCard+=cardPrice(item.product)*item.qty;
          count++;
          var src=img(item.product),qtyLabel=item.qty>1?' ×'+item.qty:'';
          html+='<div class="sum-item">'
               +'<div class="sum-thumb">'+(src?'<img src="'+src+'" alt="">':ico(k,18))+'</div>'
               +'<div class="sum-info"><div class="sum-cat">'+c.name+qtyLabel+'</div><div class="sum-name">'+nameStr(item.product)+'</div></div>'
               +'<div class="sum-price">'+fmt(transferPrice(item.product)*item.qty)+'</div>'
               +'<button class="sum-del" onclick="APC.removeItem(\''+k+'\','+item.product.id+')" title="Quitar">×</button>'
               +'</div>';
        });
      }
    });
    $('apcSumBody').innerHTML=html;
    $('apcTotalTransfer').textContent=fmt(totalTransfer);
    $('apcTotalCard').textContent=fmt(totalCard);
    $('apcSubtitle').textContent=count+' componente'+(count!==1?'s':'');
    var allReq=keys.every(function(k){if(!CFG.cats[k].req)return true;return isMulti(k)?(S.sel[k]&&S.sel[k].length>0):!!S.sel[k];});
    $('apcBtnCart').disabled=!allReq||count===0;
    $('apcBtnPresupuesto').disabled=count===0;
    renderWatts();
    var issues=Compat.status(),el=$('apcCompat');
    if(issues.length){el.innerHTML='<div class="compat-err">⚠️ '+issues.join('<br>⚠️ ')+'</div>';}
    else if(count>=2){el.innerHTML='<div class="compat-ok">✅ Componentes compatibles</div>';}
    else{el.innerHTML='';}
    /* Actualizar barra y drawer mobile */
    var mb=$('apcMobileBar');
    if(mb){
      $('apcMobileCount').textContent=count+' componente'+(count!==1?'s':'');
      $('apcMobileTotal').textContent=fmt(totalTransfer);
      $('apcMobileSumBody').innerHTML=$('apcSumBody').innerHTML;
      $('apcMobileSubtitle').textContent=count+' componente'+(count!==1?'s':'');
      $('apcMobileTotalT').textContent=fmt(totalTransfer);
      $('apcMobileTotalC').textContent=fmt(totalCard);
      $('apcMobileBtnCart').disabled=!allReq||count===0;
      $('apcMobileBtnPresupuesto').disabled=count===0;
    }
  },
};

/* =====================================================
   CONTROLADOR PÚBLICO
   ===================================================== */
window.APC = {
  init: function(){
    APC.go(S.step);
    R.summary();
    /* Prefetch de todas las categorías en paralelo (segundo plano)
       así cuando el usuario hace click ya están en caché */
    setTimeout(function(){
      Object.keys(CFG.cats).forEach(function(key){
        if(key===S.step) return; /* la primera ya se está cargando */
        if(S.cache[key]!==undefined) return; /* ya en caché */
        fetchCatByKey(key).then(function(prods){
          if(S.cache[key]===undefined){ /* no la sobreescribir si el user ya la pidió */
            S.cache[key]=prods.filter(function(p){return !isBlacklisted(p,key);});
            S.cacheTs[key]=Date.now();
          }
        }).catch(function(){});
      });
    }, 1500); /* espera 1.5s para no competir con la carga inicial */
  },

  go: function(key,forceRefresh){
    S.step=key;R.tabs();R.header();
    var cached=S.cache[key]!==undefined;
    var fresh=cached&&(Date.now()-S.cacheTs[key])<CACHE_TTL;
    if(cached&&fresh&&!forceRefresh){R.grid();return;}
    S.busy=true;R.grid();
    fetchCatByKey(key).then(function(prods){
      S.cache[key]=prods.filter(function(p){return !isBlacklisted(p,key);});
      S.cacheTs[key]=Date.now();
      S.busy=false;
      if(S.step===key)R.grid();
    });
  },

  refresh: function(){APC.go(S.step,true);},

  pick: function(key,productId){
    var prods=S.cache[key]||[];
    var p=prods.filter(function(x){return x.id===productId;})[0];
    if(!p)return;
    if(isMulti(key)){
      if(!S.sel[key])S.sel[key]=[];
      var existing=S.sel[key].filter(function(i){return i.product.id===productId;})[0];
      if(existing){existing.qty++;}else{S.sel[key].push({product:p,qty:1});}
      R.grid();R.tabs();R.summary();
      showToast('✓ '+nameStr(p)+' agregado');
    } else {
      S.sel[key]=p;
      R.grid();R.tabs();R.summary();
      showToast('✓ '+nameStr(p));
      var keys=Object.keys(CFG.cats),idx=keys.indexOf(key);
      if(idx<keys.length-1)setTimeout(function(){APC.go(keys[idx+1]);},350);
    }
  },

  decrement: function(key,productId){
    if(!S.sel[key])return;
    if(isMulti(key)){
      var arr=S.sel[key];
      for(var i=0;i<arr.length;i++){if(arr[i].product.id===productId){arr[i].qty--;if(arr[i].qty<=0){arr.splice(i,1);if(arr.length===0)delete S.sel[key];}break;}}
    } else {delete S.sel[key];}
    R.grid();R.tabs();R.summary();
  },

  removeItem: function(key,productId){
    if(isMulti(key)){if(S.sel[key]){S.sel[key]=S.sel[key].filter(function(i){return i.product.id!==productId;});if(S.sel[key].length===0)delete S.sel[key];}}
    else{delete S.sel[key];}
    R.summary();R.tabs();
    if(S.step===key)R.grid();
  },

  next: function(){
    var keys=Object.keys(CFG.cats),idx=keys.indexOf(S.step);
    if(idx<keys.length-1)APC.go(keys[idx+1]);
  },

  skip: function(){
    var keys=Object.keys(CFG.cats),idx=keys.indexOf(S.step);
    if(idx<keys.length-1)APC.go(keys[idx+1]);
  },

  search: function(q){S.query=q;R.grid();},

  addAll: function(){
    var name=prompt('Nombre:');if(!name)return;
    var lastname=prompt('Apellido:');if(!lastname)return;
    var email=prompt('Email:');if(!email)return;
    var phone=prompt('Teléfono (opcional):')||'';

    var btn=$('apcBtnCart');
    btn.disabled=true;
    btn.innerHTML='<div class="apc-spinner" style="width:18px;height:18px;border-width:2px;border-color:rgba(255,255,255,.3);border-top-color:#fff;margin:0"></div> Generando pedido...';

    var items=[];
    Object.keys(S.sel).forEach(function(k){
      selArr(k).forEach(function(item){
        var v0=item.product.variants&&item.product.variants[0];
        items.push({
          variantId: v0?v0.id:null,
          sku: v0?v0.sku:null,
          qty: item.qty,
          /* precio de catálogo real (no price(), que ya devuelve el de Odoo si está cargado) */
          catalogPrice: v0?parseFloat(v0.price||0):0,
        });
      });
    });

    createOrderViaBackend(items, {name:name, lastname:lastname, email:email, phone:phone})
      .then(function(checkoutUrl){
        window.location.href=checkoutUrl;
      })
      .catch(function(err){
        btn.disabled=false;
        btn.innerHTML='🛒 Agregar todo al carrito';
        alert('Hubo un error al generar el pedido. Intentá de nuevo.'+(err&&err.message?' ('+err.message+')':''));
      });
  },

  closeModal: function(){$('apcOverlay').classList.remove('show');},

  openDrawer: function(){
    var d=$('apcMobileDrawer'),o=$('apcMobileOverlay');
    if(d){d.classList.add('open');}
    if(o){o.classList.add('open');}
    document.body.style.overflow='hidden';
  },
  closeDrawer: function(){
    var d=$('apcMobileDrawer'),o=$('apcMobileOverlay');
    if(d){d.classList.remove('open');}
    if(o){o.classList.remove('open');}
    document.body.style.overflow='';
  },

  reset: function(){
    if(!confirm('¿Empezar de nuevo? Se perderá la selección actual.'))return;
    S.sel={};APC.go(Object.keys(CFG.cats)[0]);R.summary();
  },

  descargarPresupuesto: function(){
    var hoy=new Date();
    var fecha=hoy.toLocaleDateString('es-AR',{day:'2-digit',month:'2-digit',year:'numeric'});
    var validez=new Date(hoy.getTime()+24*60*60*1000).toLocaleDateString('es-AR',{day:'2-digit',month:'2-digit',year:'numeric'});
    var totalT=0,totalC=0;
    var rows='';
    Object.keys(CFG.cats).forEach(function(k){
      var items=selArr(k);
      if(!items.length)return;
      items.forEach(function(item){
        var p=item.product,qty=item.qty||1;
        var pT=transferPrice(p)*qty, pC=price(p)*qty;
        totalT+=pT; totalC+=pC;
        var imgSrc=img(p);
        var imgHtml=imgSrc?'<img src="'+imgSrc+'" alt="">':'<div class="no-img">📦</div>';
        rows+='<tr>'
          +'<td class="img-cell">'+imgHtml+'</td>'
          +'<td class="cat-cell">'+CFG.cats[k].name+(qty>1?' ×'+qty:'')+'</td>'
          +'<td class="name-cell">'+nameStr(p).replace(/<[^>]+>/g,'')+'</td>'
          +'<td class="price-cell">'+fmt(pT)+'</td>'
          +'<td class="price-cell card-price">'+fmt(pC)+'</td>'
          +'</tr>';
      });
    });

    var html='<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">'
      +'<title>Presupuesto — Integrados Argentinos</title>'
      +'<style>'
      +'*{box-sizing:border-box;margin:0;padding:0}'
      +'body{font-family:Arial,sans-serif;color:#333;background:#fff;padding:30px;max-width:860px;margin:0 auto}'
      +'header{display:flex;align-items:center;justify-content:space-between;border-bottom:3px solid #1BA9E2;padding-bottom:16px;margin-bottom:24px}'
      +'.logo img{height:70px;max-width:320px;object-fit:contain}'
      +'.meta{text-align:right;font-size:12px;color:#666;line-height:1.7}'
      +'.meta strong{color:#333}'
      +'h2{font-size:15px;margin-bottom:12px;color:#1a1a1a}'
      +'table{width:100%;border-collapse:collapse;margin-bottom:24px}'
      +'th{background:#1a1a1a;color:#fff;padding:9px 12px;font-size:12px;text-align:left}'
      +'th.price-cell{text-align:right}'
      +'td{padding:10px 12px;border-bottom:1px solid #eee;font-size:13px;vertical-align:middle}'
      +'td.img-cell{width:60px;text-align:center}'
      +'td.img-cell img{width:50px;height:50px;object-fit:contain}'
      +'td.img-cell .no-img{font-size:24px}'
      +'td.cat-cell{width:130px;font-size:11px;font-weight:700;text-transform:uppercase;color:#999!important}'
      +'td.name-cell{font-weight:500;color:#222!important}'
      +'td.name-cell *{color:#222!important}'
      +'td.price-cell{text-align:right;font-weight:700;white-space:nowrap;color:#222!important}'
      +'td.card-price{color:#999!important;font-weight:400;font-size:12px;text-align:right}'
      +'tr:nth-child(even) td{background:#fafafa}'
      +'.totals{display:flex;gap:16px;justify-content:flex-end;margin-bottom:24px}'
      +'.total-box{padding:14px 20px;border-radius:8px;min-width:180px}'
      +'.total-transfer{background:linear-gradient(135deg,#1BA9E2,#34b7ec);color:#fff}'
      +'.total-card{background:#f5f5f5;border:1.5px solid #e0e0e0}'
      +'.total-lbl{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.5px;opacity:.8;margin-bottom:4px}'
      +'.total-amt{font-size:22px;font-weight:900;letter-spacing:-1px}'
      +'.total-card .total-amt{color:#333}'
      +'.nota{font-size:11px;color:#999;border-top:1px solid #eee;padding-top:12px;line-height:1.7}'
      +'.nota a{color:#1BA9E2}'
      +'@media print{body{padding:15px}.btn-print{display:none}}'
      +'</style></head><body>'
      +'<header>'
      +'<div class="logo"><img src="data:image/png;base64,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" alt="Integrados Argentinos"></div>'
      +'<div class="meta">'
      +'<strong>Presupuesto</strong><br>'
      +'Fecha: '+fecha+'<br>'
      +'Válido hasta: '+validez+'<br>'
      +'📍 Av. Forest 365 - Chacarita<br>'
      +'📞 +54 9 11 3922-0133<br>'
      +'✉️ info@integradosargentinos.com'
      +'</div>'
      +'</header>'
      +'<h2>Componentes seleccionados</h2>'
      +'<table>'
      +'<thead><tr>'
      +'<th></th>'
      +'<th>Categoría</th>'
      +'<th>Producto</th>'
      +'<th class="price-cell">Transferencia</th>'
      +'<th class="price-cell">Tarjeta/Cuotas</th>'
      +'</tr></thead>'
      +'<tbody>'+rows+'</tbody>'
      +'</table>'
      +'<div class="totals">'
      +'<div class="total-box total-card"><div class="total-lbl">Tarjeta · 6 cuotas sin interés</div><div class="total-amt">'+fmt(totalC)+'</div></div>'
      +'<div class="total-box total-transfer"><div class="total-lbl">Transferencia o depósito</div><div class="total-amt">'+fmt(totalT)+'</div></div>'
      +'</div>'
      +'<div class="nota">'
      +'⚡ Consumo estimado del sistema: ~'+estimateWatts()+'W<br>'
      +'Los precios son válidos por 24 horas a partir de la fecha de emisión. Sujetos a disponibilidad de stock.<br>'
      +'Precios de transferencia/depósito incluyen 25% de descuento sobre el precio de tarjeta.<br>'
      +'🌐 <a href="https://integradosargentinos.com">integradosargentinos.com</a> · '
      +'✉️ info@integradosargentinos.com · '
      +'📞 +54 9 11 3922-0133 · '
      +'📍 Av. Forest 365, Chacarita'
      +'</div>'
      +'<script>window.onload=function(){window.print();}<\/script>'
      +'</body></html>';

    var win=window.open('','_blank');
    win.document.write(html);
    win.document.close();
  },

  setMode: function(mode){S.mode=mode;},
};

if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',APC.init);
else APC.init();

/* Bloquea el scroll externo de la página y ajusta el alto del grid */
(function(){

  /* 1. Bloquear scroll del body — SOLO en desktop y cuando el builder está visible */
  function isMobile(){ return window.innerWidth <= 640; }

  function lockBodyScroll(){
    if(isMobile()) return; /* En mobile el scroll es natural */
    var wrapper=document.getElementById('apcBuilderWrapper');
    if(wrapper && wrapper.style.display!=='block') return;
    var el=document.getElementById('armador-pc');
    if(!el)return;
    document.body.style.overflow='hidden';
    document.documentElement.style.overflow='hidden';
  }

  /* 2. Ajustar alto del grid al espacio real disponible — solo en desktop */
  function fitGrid(){
    if(isMobile()){
      var grid=document.getElementById('apcGrid');
      if(grid){ grid.style.maxHeight='none'; grid.style.overflowY='visible'; }
      return;
    }
    var grid=document.getElementById('apcGrid');
    if(!grid)return;
    var top=grid.getBoundingClientRect().top;
    if(top<=0)return;
    var vh=(window.visualViewport?window.visualViewport.height:window.innerHeight);
    var avail=vh-top-10;
    grid.style.maxHeight=(avail>150?avail:150)+'px';
  }

  function init(){
    lockBodyScroll();
    setTimeout(fitGrid, 80);
    setTimeout(fitGrid, 400);
    setTimeout(fitGrid, 1000);
    setTimeout(fitGrid, 2000);
  }

  if(document.readyState==='loading'){
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  window.addEventListener('resize', fitGrid);
  if(window.visualViewport){
    window.visualViewport.addEventListener('resize', fitGrid);
  }
})();

}());
</script>

</div>

<script>
(function(){
  var path = window.location.pathname;
  if(path.indexOf('arma-tu-pc') !== -1){
    var gp = document.getElementById('apcGenericPage');
    var bw = document.getElementById('apcBuilderWrapper');
    if(gp) gp.style.display = 'none';
    if(bw) bw.style.display = 'block';
    if(window.innerWidth > 640){
      document.body.style.overflow = 'hidden';
      document.documentElement.style.overflow = 'hidden';
    }
  }
})();
</script>