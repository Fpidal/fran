# Gastro Cost System

Sistema de gestión de costos gastronómicos para restaurantes.

## 🚀 Estado del Proyecto

**✅ MVP Funcionando** - La aplicación está operativa con:
- 156 insumos cargados
- Precios actualizados
- Sistema de categorías y proveedores

## 📱 Funcionalidades Implementadas

### ✅ Módulo de Costos (Insumos)
- Lista de insumos con precios actuales
- Carga de nuevos precios con fecha
- Cálculo automático de costo final (con IVA y merma)
- Indicador de variación de precio (🔺 subió, 🔻 bajó)
- Filtros por categoría y búsqueda
- CRUD completo de insumos

### ✅ Módulo de Recetas
- Crear recetas con ingredientes
- Soporte para sub-recetas (salsas, guarniciones)
- Cálculo automático del costo total
- Visualización de incidencia por ingrediente

### ✅ Módulo de Carta
- Organización por secciones (Entradas, Principales, etc.)
- Definición de margen objetivo por plato (75%, 80%, etc.)
- Alerta visual cuando el margen cae bajo objetivo
- Sugerencia de precio para recuperar margen
- Actualización rápida de precios

### ✅ Dashboard
- Contador de insumos, recetas, platos
- Indicador de alertas de margen
- Estado general del sistema

## 🛠️ Stack Tecnológico

| Componente | Tecnología |
|------------|------------|
| Frontend | Next.js 14 + React 18 |
| Estilos | Tailwind CSS |
| Base de datos | PostgreSQL (Supabase) |
| Hosting | Vercel (frontend) + Supabase (DB) |
| Iconos | Lucide React |

## 📊 Datos Cargados

### Categorías (7)
- Carnes
- Almacén
- Verduras/Frutas
- Pescados/Mariscos
- Lácteos/Fiambres
- Bebidas
- Salsas/Recetas

### Proveedores (26)
Triunfo, Fran M., Morres, Delico, Berardi, Blancaluna, Frigolar, Colucci, Servimar, Coca Cola, Avicola, Divisa, Fresh, y más.

### Insumos (156)
Todos los productos del Excel original con:
- Unidad de medida
- Medida de compra
- IVA correspondiente
- Porcentaje de merma

## 🔧 Instalación Local

### 1. Clonar el repositorio
```bash
git clone https://github.com/Fpidal/fran.git
cd fran
```

### 2. Instalar dependencias
```bash
npm install
```

### 3. Configurar variables de entorno
Crear archivo `.env.local`:
```
NEXT_PUBLIC_SUPABASE_URL=https://tu-proyecto.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=tu-anon-key
```

### 4. Ejecutar en desarrollo
```bash
npm run dev
```

Abrir [http://localhost:3000](http://localhost:3000)

## 📁 Estructura del Proyecto

```
gastro-app/
├── src/
│   ├── app/
│   │   ├── page.tsx              # Dashboard
│   │   ├── layout.tsx            # Layout principal
│   │   ├── globals.css           # Estilos globales
│   │   ├── costos/
│   │   │   └── page.tsx          # Módulo de costos
│   │   ├── recetas/
│   │   │   └── page.tsx          # Módulo de recetas
│   │   └── carta/
│   │       └── page.tsx          # Módulo de carta
│   ├── components/
│   │   └── Sidebar.tsx           # Navegación lateral
│   ├── lib/
│   │   └── supabase.ts           # Cliente de Supabase
│   └── types/
│       └── database.ts           # Tipos TypeScript
├── supabase/
│   └── schema.sql                # Script de base de datos
├── package.json
├── tailwind.config.js
├── tsconfig.json
└── README.md
```

## 🗄️ Base de Datos

### Tablas
- `categorias` - Categorías de insumos
- `proveedores` - Proveedores
- `insumos` - Productos/ingredientes
- `precios` - Historial de precios
- `recetas` - Recetas y sub-recetas
- `receta_ingredientes` - Ingredientes de cada receta
- `secciones_carta` - Secciones de la carta
- `platos_carta` - Platos en carta con márgenes

### Diagrama
```
categorias ──┐
             ├──> insumos ──> precios
proveedores ─┘        │
                      ├──> receta_ingredientes <── recetas
                      │                              │
secciones_carta ──> platos_carta <─────────────────┘
```

## 🔜 Próximas Features (Fase 2)

- [ ] Historial de precios con gráfico de evolución
- [ ] Comparativa de precios entre proveedores
- [ ] Menús ejecutivos
- [ ] Dashboard avanzado con métricas
- [ ] Autenticación de usuarios
- [ ] Roles y permisos (propietario, socio, chef)
- [ ] Importación masiva desde Excel
- [ ] Exportación de reportes

## 👥 Usuarios

| Usuario | Rol | Acceso |
|---------|-----|--------|
| Propietario (Joaquín) | Admin | Total |
| Socio | Admin | Total |
| Chef | Operativo | Por definir |

## 📞 Información del Proyecto

- **Proyecto:** Sistema de Costeo Gastronómico
- **Versión:** 1.0.0 MVP
- **Repositorio:** https://github.com/Fpidal/fran
