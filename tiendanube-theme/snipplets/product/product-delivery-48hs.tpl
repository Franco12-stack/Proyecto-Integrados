{# Leyenda de entrega en 48hs - solo para productos con el tag "48hs" #}

{% if '48hs' in product.tags %}
	<div class="delivery-48hs-message font-medium mb-4">
		<span class="float-left mr-2">
			<svg class="icon-inline svg-icon-accent icon-lg"><use xlink:href="#truck"/></svg>
		</span>
		<span class="text-accent">{{ "Entrega de este producto en 48hs" | translate }}</span>
	</div>
{% endif %}
