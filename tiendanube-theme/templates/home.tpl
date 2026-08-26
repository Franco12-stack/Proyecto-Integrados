{# **** Inicio personalizado Integrados Argentinos **** #}
{% include 'snipplets/home/home-mas-vendidos.tpl' %}
{% include 'snipplets/home/home-armador-pc.tpl' %}
{% include 'snipplets/home/home-categorias-grid.tpl' %}

{# Popup promocional (se mantiene si está configurado) #}
{% if settings.home_promotional_popup and ("home_popup_image.jpg" | has_custom_image or settings.home_popup_title or settings.home_popup_txt or settings.home_news_box or (settings.home_popup_btn and settings.home_popup_url)) %}
	{% include 'snipplets/home/home-popup.tpl' %}
{% endif %}
