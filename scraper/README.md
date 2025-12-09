# ComoPrecio Scraper

Scraper de precios para la app ComoPrecio. Extrae precios de tiendas españolas y guarda los resultados en `data/products.json`.

## 🚀 Uso Local

```bash
cd scraper
npm install
npm run scrape
```

## 🏪 Tiendas Soportadas

| Tienda | Estado | Notas |
|--------|--------|-------|
| Amazon ES | ✅ Funcional | Usa Cheerio para HTML |
| PCComponentes | ✅ Funcional | Usa selectores de datos |
| MediaMarkt | ✅ Funcional | Usa selectores de test |
| AliExpress | ⏳ Pendiente | Requiere API/Puppeteer |
| eBay | ⏳ Pendiente | Requiere API |
| Fnac | ⏳ Pendiente | Requiere scraping |
| Carrefour | ⏳ Pendiente | Requiere scraping |

## ⏰ Automatización

El workflow de GitHub Actions (`update-prices.yml`) ejecuta el scraper:
- 🕕 6:00 AM UTC (8:00 AM España)
- 🕕 6:00 PM UTC (8:00 PM España)

También puedes ejecutarlo manualmente desde GitHub Actions.

## 📁 Estructura

```
scraper/
├── package.json     # Dependencias
├── scraper.js       # Script principal
└── README.md        # Este archivo

data/
└── products.json    # Datos de productos (actualizado por scraper)

.github/workflows/
└── update-prices.yml # Automatización diaria
```

## 🔧 Añadir Nuevo Producto

Edita `PRODUCTS_TO_SCRAPE` en `scraper.js`:

```javascript
{
  id: 'nuevo-producto-id',
  searchTerms: ['Término de búsqueda'],
  brand: 'Marca',
  category: 'Categoría',
  stores: ['amazon', 'pccomponentes']
}
```

## 🔧 Añadir Nueva Tienda

1. Añade configuración en `STORES`
2. Crea función `scrapeNuevaTienda(searchTerm)`
3. Añádela a `SCRAPERS` mapping
