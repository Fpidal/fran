# 🗺️ ROADMAP - Gastro Cost System

**Última actualización:** Enero 2026

---

## 📊 Estado Actual del Proyecto

### ✅ FASE 1 - COMPLETADA

#### Infraestructura
- [x] Proyecto Next.js 14 + React 18 + TypeScript
- [x] Base de datos PostgreSQL en Supabase
- [x] Estilos con Tailwind CSS
- [x] Configuración de Docker para deploy
- [x] Scripts de deploy para Google Cloud VPS
- [x] Documentación de instalación

#### Base de Datos (Supabase)
- [x] Schema completo con 9 tablas
- [x] Categorías (7): Carnes, Pescados_Mariscos, Verduras_Frutas, Lácteos, Almacen, Bebidas, Salsas_Recetas
- [x] Proveedores (26 cargados)
- [x] Insumos (156 productos con precios)
- [x] Recetas (47 recetas del menú)
- [x] Ingredientes de recetas (226 registros)
- [x] Secciones de carta (4): Entradas, Platos Principales, Pastas y Ensaladas, Postres
- [x] Platos en carta (49) con precios y márgenes

#### Módulo de Costos (/costos)
- [x] Lista de insumos con precios actuales
- [x] Filtro por categoría
- [x] Búsqueda por nombre
- [x] Carga de nuevos precios con fecha
- [x] Cálculo automático de costo final (precio + IVA + merma)
- [x] Indicador visual de variación de precio (↑↓)
- [x] Vista expandible con historial de últimos 3 precios

#### Módulo de Recetas (/recetas)
- [x] Lista de recetas con costo calculado
- [x] Crear nueva receta
- [x] Agregar ingredientes (insumos)
- [x] Soporte para sub-recetas (recetas dentro de recetas)
- [x] Cálculo automático del costo total
- [x] Incidencia porcentual por ingrediente
- [x] Editar/eliminar recetas

#### Módulo de Carta (/carta)
- [x] Organización por secciones
- [x] Visualización de platos con:
  - Precio de carta
  - Costo calculado
  - Margen actual vs objetivo
- [x] Alerta visual cuando margen < objetivo (rojo)
- [x] Sugerencia de precio para recuperar margen
- [x] Actualización rápida de precios

#### Dashboard (/)
- [x] Resumen de insumos totales
- [x] Resumen de recetas
- [x] Resumen de platos en carta
- [x] Alertas de márgenes bajos
- [x] Insumos con mayor variación de precio

---

### 🔄 EN PROGRESO - FASE 1.5

#### Limpieza de Datos
- [x] Importación masiva desde Excel
- [ ] Eliminar duplicados en receta_ingredientes
- [ ] Verificar integridad de referencias FK
- [ ] Completar precios faltantes de insumos

#### Deploy
- [x] Dockerfile optimizado
- [x] docker-compose.yml con Nginx
- [x] Script de instalación automática (install-gcp.sh)
- [x] Documentación DEPLOY-GCP.md
- [ ] Deploy en VPS Google Cloud
- [ ] Configurar dominio y SSL

---

## 🔜 FASE 2 - PRÓXIMAS FEATURES

### Prioridad Alta
- [ ] **Historial de precios con gráfico**
  - Gráfico de evolución por insumo
  - Tendencia de los últimos 30/60/90 días
  
- [ ] **Comparativa entre proveedores**
  - Mismo insumo, distintos proveedores
  - Sugerencia del más económico
  
- [ ] **Menús ejecutivos/del día**
  - Composición de menús con entrada + principal + postre
  - Costo y margen del menú completo
  - Rotación semanal

### Prioridad Media
- [ ] **Dashboard avanzado**
  - Top 10 platos más rentables
  - Top 10 insumos más costosos
  - Evolución de food cost mensual
  - Alertas automáticas por email
  
- [ ] **Importación masiva**
  - Upload de Excel con precios
  - Actualización batch de costos
  - Log de cambios

- [ ] **Reportes PDF**
  - Ficha técnica de receta
  - Listado de precios por categoría
  - Análisis de rentabilidad

### Prioridad Baja
- [ ] **Autenticación de usuarios**
  - Login con email/password
  - Roles: Admin, Chef, Encargado
  - Permisos por módulo
  
- [ ] **Multi-sucursal**
  - Precios por ubicación
  - Proveedores locales

---

## 🛠️ FASE 3 - FEATURES AVANZADAS

- [ ] **Integración con proveedores**
  - API para recibir listas de precios
  - Actualización automática
  
- [ ] **Planificación de compras**
  - Estimación según ventas proyectadas
  - Lista de compras automática
  
- [ ] **Análisis predictivo**
  - Proyección de costos
  - Alertas de tendencias
  
- [ ] **App móvil**
  - Consulta de precios en el momento
  - Carga rápida desde el mercado

---

## 📁 Archivos del Proyecto

```
gastro-app/
├── src/
│   ├── app/
│   │   ├── page.tsx              # Dashboard principal
│   │   ├── layout.tsx            # Layout con sidebar
│   │   ├── globals.css           # Estilos Tailwind
│   │   ├── costos/page.tsx       # Módulo de costos
│   │   ├── recetas/page.tsx      # Módulo de recetas  
│   │   └── carta/page.tsx        # Módulo de carta
│   ├── components/
│   │   └── Sidebar.tsx           # Navegación lateral
│   ├── lib/
│   │   └── supabase.ts           # Cliente Supabase
│   └── types/
│       └── database.ts           # Tipos TypeScript
├── supabase/
│   └── schema.sql                # Schema completo DB
├── Dockerfile                    # Build para producción
├── docker-compose.yml            # Orquestación Docker
├── nginx.conf                    # Reverse proxy
├── install-gcp.sh                # Script instalación GCP
├── DEPLOY-GCP.md                 # Guía de deploy
├── ROADMAP.md                    # Este archivo
└── README.md                     # Documentación principal
```

---

## 📈 Métricas Objetivo

| Métrica | Actual | Objetivo |
|---------|--------|----------|
| Insumos cargados | 156 | 200+ |
| Recetas activas | 47 | 80+ |
| Platos en carta | 49 | 60+ |
| Tiempo carga precio | ~30s | <10s |
| Cobertura precios | ~60% | 100% |

---

## 🔗 Links Útiles

- **Supabase Dashboard:** https://supabase.com/dashboard
- **Repositorio:** (pendiente subir a GitHub)
- **Producción:** (pendiente deploy)

---

## 📝 Notas de Desarrollo

### Limpiar duplicados en ingredientes:
```sql
DELETE FROM receta_ingredientes
WHERE id NOT IN (
  SELECT MIN(id)
  FROM receta_ingredientes
  GROUP BY receta_id, insumo_id
);
```

### Ver insumos sin precio:
```sql
SELECT i.nombre 
FROM insumos i 
LEFT JOIN insumo_precios p ON i.id = p.insumo_id 
WHERE p.id IS NULL;
```

### Ver recetas sin ingredientes:
```sql
SELECT r.nombre 
FROM recetas r 
LEFT JOIN receta_ingredientes ri ON r.id = ri.receta_id 
WHERE ri.id IS NULL;
```
