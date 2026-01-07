# Especificación del Proyecto

## 1. Visión General

Sistema de costeo gastronómico que permite:
- Cargar y mantener actualizados los costos de insumos
- Calcular automáticamente el costo de recetas y platos
- Alertar cuando los márgenes de ganancia caen por debajo del objetivo
- Sugerir ajustes de precios de carta

## 2. Usuarios del Sistema

| Usuario | Rol | Permisos (por definir) |
|---------|-----|------------------------|
| Propietario | Administrador | Acceso total |
| Socio | Administrador | Acceso total |
| Chef | Operativo | Por definir |

### Dispositivos de acceso
- Notebook
- Celular (webapp responsive)

## 3. Módulos del Sistema

### 3.1 Módulo de Costos (Insumos)

**Funcionalidades:**
- Alta, baja y modificación de insumos
- Carga de precios con fecha de actualización
- Historial de precios por insumo (gráfico de evolución)
- Comparativa de precios entre proveedores
- Indicador de variación vs precio anterior

**Datos del insumo:**
| Campo | Descripción |
|-------|-------------|
| Producto | Nombre del insumo |
| Categoría | Carnes, Almacén, Verduras/Frutas, Pescados/Mariscos, Lácteos/Fiambres, Bebidas, Salsas/Recetas |
| Fecha actualización | Última fecha de actualización del precio |
| Precio anterior | Precio antes de la última actualización |
| Variación % | Porcentaje de cambio |
| Precio | Precio actual de compra |
| Unidad de medida | Kg, Ltos, Un, Riestra, etc. |
| Medida | Cantidad en la unidad (ej: 5 para "5 litros") |
| Costo unitario | Precio / Medida |
| IVA | Porcentaje de IVA (0.21) |
| Costo + IVA | Costo con IVA incluido |
| Merma % | Porcentaje de merma (opcional) |
| Costo final | Costo final con merma aplicada |
| Proveedor | Nombre del proveedor |

**Frecuencia de actualización:** 1-2 semanas
**Método de carga:** Manual con factura/lista de precios del proveedor

### 3.2 Módulo de Recetas

**Funcionalidades:**
- Crear recetas con lista de ingredientes
- Soporte para sub-recetas (salsas, guarniciones)
- Cálculo automático del costo total
- Recálculo automático cuando cambian precios de insumos
- Visualización de incidencia de cada ingrediente

**Datos de la receta:**
| Campo | Descripción |
|-------|-------------|
| Nombre del plato | Identificador de la receta |
| Costo total | Suma de costos de ingredientes |

**Datos por ingrediente:**
| Campo | Descripción |
|-------|-------------|
| Categoría | Categoría del insumo |
| Producto | Nombre del insumo o sub-receta |
| Costo final | Costo unitario del insumo |
| Cantidad | Cantidad utilizada |
| Costo porción | Costo final × Cantidad |
| Extra | Costo adicional (opcional) |
| Costo total | Costo porción + Extra |
| Incidencia % | Peso del ingrediente en el costo total |

**Sub-recetas:**
Las sub-recetas (salsas, guarniciones, preparados) funcionan igual que las recetas pero pueden ser usadas como ingrediente en otras recetas.

Ejemplos de sub-recetas actuales:
- Salsa de Pimienta
- Espinaca a la Crema
- Aderezo Caesar
- Boloñesa
- Fondo oscuro
- Pure de Papa
- Pure de Batata
- Ñoquis de Papa

### 3.3 Módulo de Carta

**Funcionalidades:**
- Gestión de platos de la carta
- Definición de margen objetivo por plato
- Cálculo de precio sugerido según margen
- Alerta visual cuando el margen real < margen objetivo
- Sugerencia de nuevo precio para recuperar margen
- Agrupación por secciones

**Secciones de la carta:**
- Entradas
- Platos Principales
- Pastas y Ensaladas
- (otras según necesidad)

**Datos por plato:**
| Campo | Descripción |
|-------|-------------|
| Número | Orden en la carta |
| Producto | Nombre del plato |
| Costo | Costo de la receta (automático) |
| Margen objetivo | Margen deseado (ej: 0.75 = 75%) |
| Precio sugerido | Costo / (1 - Margen) |
| Precio carta | Precio real en carta |
| Incidencia | Peso del costo sobre el precio |
| Margen contribución | Precio carta - Costo |
| Estado | OK / Alerta (si margen real < objetivo) |

**Fórmulas:**
```
Precio sugerido = Costo / (1 - Margen objetivo)
Margen real = (Precio carta - Costo) / Precio carta
Margen contribución = Precio carta - Costo
```

### 3.4 Módulo de Menús Ejecutivos

Misma lógica que la carta pero para:
- Menú Carne
- Menú Pescado
- Menús de eventos
- Menús especiales

**Datos por menú:**
| Campo | Descripción |
|-------|-------------|
| Nombre del menú | Identificador |
| Componentes | Lista de items con cantidades |
| Costo total | Suma de costos |
| Margen objetivo | Margen deseado |
| Precio sugerido | Según fórmula |

### 3.5 Dashboard (por definir)

**Posibles vistas:**
- Platos fuera de margen (alertas activas)
- Insumos con mayor variación reciente
- Resumen de costos por categoría
- Evolución de costos en el tiempo

## 4. Flujo de Trabajo Principal

```
┌─────────────────────────────────────────────────────────────┐
│  1. CARGA DE COSTOS                                         │
│     Usuario carga precios de insumos (manual, con factura)  │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  2. RECÁLCULO DE RECETAS                                    │
│     Sistema actualiza costos de todas las recetas           │
│     que usan los insumos modificados                        │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  3. RECÁLCULO DE CARTA                                      │
│     Sistema actualiza costos de platos en carta             │
│     y recalcula márgenes                                    │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  4. GENERACIÓN DE ALERTAS                                   │
│     Sistema identifica platos con margen < objetivo         │
│     y los marca visualmente                                 │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  5. REVISIÓN Y AJUSTE                                       │
│     Usuario revisa alertas y decide:                        │
│     - Ajustar precio de carta                               │
│     - Cambiar ingredientes                                  │
│     - Aceptar menor margen                                  │
└─────────────────────────────────────────────────────────────┘
```

## 5. Categorías de Insumos

| Categoría | Ejemplos |
|-----------|----------|
| Carnes | Bife de chorizo, Lomo, Molleja, Costillar, etc. |
| Almacén | Aceites, Arroz, Harina, Conservas, etc. |
| Verduras/Frutas | Papa, Cebolla, Tomate, Limón, etc. |
| Pescados/Mariscos | Merluza, Salmón, Langostinos, Vieiras, etc. |
| Lácteos/Fiambres | Quesos, Jamón, Crema, Manteca, etc. |
| Bebidas | Agua, Gaseosa, Vino, Café, etc. |
| Salsas/Recetas | Sub-recetas preparadas |

## 6. Proveedores Actuales

| Proveedor | Productos principales |
|-----------|----------------------|
| Triunfo | Almacén (30 productos) |
| Fran M. | Verduras/Frutas (24 productos) |
| Morres | Varios (13 productos) |
| Delico | Bebidas (30 productos) |
| Berardi | Varios (7 productos) |
| Blancaluna | Varios (7 productos) |
| Frigolar | Varios (5 productos) |
| Colucci | Pescados |
| Servimar | Bebidas |
| Cocacola F | Bebidas |

## 7. Requerimientos No Funcionales

- **Responsive**: Debe funcionar bien en notebook y celular
- **Performance**: Recálculos deben ser instantáneos
- **Disponibilidad**: Acceso 24/7 (hosting en la nube)
- **Backup**: Resguardo automático de datos
- **Sin integraciones**: Sistema 100% independiente

## 8. Decisiones Pendientes

- [ ] Permisos diferenciados por rol (chef vs propietario)
- [ ] Tecnología de backend (Node.js vs Python)
- [ ] Plataforma de hosting
- [ ] Alcance del MVP vs sistema completo
- [ ] Diseño de interfaz de usuario
