# Casos de Uso

## CU-01: Cargar/Actualizar Precio de Insumo

**Actor:** Propietario, Socio

**Precondición:** Usuario autenticado

**Flujo principal:**
1. Usuario accede al módulo de Costos
2. Usuario busca el insumo por nombre o filtra por categoría/proveedor
3. Usuario selecciona el insumo a actualizar
4. Sistema muestra el precio actual y el historial
5. Usuario ingresa el nuevo precio y fecha (por defecto hoy)
6. Sistema calcula automáticamente:
   - Precio unitario
   - Costo con IVA
   - Costo final (con merma)
   - Variación % vs precio anterior
7. Usuario confirma
8. Sistema guarda el nuevo precio en el historial
9. Sistema recalcula costos de todas las recetas que usan este insumo
10. Sistema actualiza estado de platos en carta (alertas si corresponde)

**Flujo alternativo - Insumo nuevo:**
1. Usuario selecciona "Nuevo Insumo"
2. Usuario completa: nombre, categoría, proveedor, unidad, medida, IVA, merma
3. Usuario ingresa precio inicial
4. Sistema crea el insumo y registra el primer precio

---

## CU-02: Ver Historial de Precios

**Actor:** Propietario, Socio, Chef

**Flujo principal:**
1. Usuario accede al módulo de Costos
2. Usuario selecciona un insumo
3. Sistema muestra:
   - Gráfico de evolución de precios en el tiempo
   - Tabla con fechas y precios
   - Variación % entre períodos
4. Usuario puede filtrar por rango de fechas

---

## CU-03: Comparar Precios entre Proveedores

**Actor:** Propietario, Socio

**Flujo principal:**
1. Usuario accede a la comparativa de proveedores
2. Usuario selecciona un insumo
3. Sistema muestra todos los proveedores que ofrecen ese insumo
4. Sistema muestra precio actual de cada proveedor
5. Sistema destaca el precio más conveniente

**Nota:** Requiere que el mismo insumo esté cargado con distintos proveedores

---

## CU-04: Crear Receta

**Actor:** Propietario, Socio, Chef

**Flujo principal:**
1. Usuario accede al módulo de Recetas
2. Usuario selecciona "Nueva Receta"
3. Usuario ingresa nombre y descripción
4. Usuario indica si es sub-receta (salsa, guarnición, etc.)
5. Usuario agrega ingredientes:
   - Busca insumo o sub-receta
   - Ingresa cantidad
   - Opcionalmente ingresa costo extra
6. Sistema calcula en tiempo real:
   - Costo de cada ingrediente
   - Costo total de la receta
   - Incidencia % de cada ingrediente
7. Usuario confirma y guarda

---

## CU-05: Modificar Receta

**Actor:** Propietario, Socio, Chef

**Flujo principal:**
1. Usuario busca la receta a modificar
2. Usuario puede:
   - Agregar ingredientes
   - Quitar ingredientes
   - Modificar cantidades
   - Cambiar un ingrediente por otro
3. Sistema recalcula costo total
4. Si la receta está en carta, sistema muestra impacto en el margen
5. Usuario confirma cambios

---

## CU-06: Agregar Plato a la Carta

**Actor:** Propietario, Socio

**Flujo principal:**
1. Usuario accede al módulo de Carta
2. Usuario selecciona sección (Entradas, Principales, etc.)
3. Usuario selecciona "Agregar Plato"
4. Usuario busca la receta correspondiente
5. Usuario define:
   - Nombre en carta (puede diferir del nombre de receta)
   - Margen objetivo (por defecto 0.75)
   - Precio de carta
6. Sistema calcula y muestra:
   - Precio sugerido según margen
   - Margen real con el precio ingresado
   - Margen de contribución
   - Estado (OK o ALERTA)
7. Usuario confirma

---

## CU-07: Revisar Alertas de Margen

**Actor:** Propietario, Socio

**Flujo principal:**
1. Usuario accede al Dashboard o Carta
2. Sistema muestra platos con estado ALERTA (margen real < objetivo)
3. Para cada plato en alerta, sistema muestra:
   - Costo actual
   - Precio de carta actual
   - Margen real actual
   - Margen objetivo
   - Precio sugerido para recuperar margen
4. Usuario decide:
   - Actualizar precio de carta
   - Revisar/modificar receta
   - Aceptar el menor margen

---

## CU-08: Actualizar Precio de Carta

**Actor:** Propietario, Socio

**Flujo principal:**
1. Usuario selecciona plato (desde carta o desde alerta)
2. Sistema muestra precio actual y precio sugerido
3. Usuario ingresa nuevo precio
4. Sistema recalcula margen real y estado
5. Usuario confirma
6. Sistema actualiza el plato

---

## CU-09: Gestionar Menú Ejecutivo

**Actor:** Propietario, Socio

**Flujo principal:**
1. Usuario accede al módulo de Menús
2. Usuario selecciona menú existente o crea nuevo
3. Usuario define componentes:
   - Selecciona recetas (plato principal, guarnición, bebida)
   - Define cantidades
4. Sistema calcula costo total del menú
5. Usuario define margen objetivo y precio
6. Sistema muestra estado (OK/ALERTA)

---

## CU-10: Ver Dashboard

**Actor:** Propietario, Socio, Chef

**Flujo principal:**
1. Usuario accede al Dashboard
2. Sistema muestra:
   - Cantidad de platos en alerta
   - Lista de platos fuera de margen
   - Insumos con mayor variación reciente
   - Resumen de costos por categoría
3. Usuario puede hacer clic en cualquier item para ir al detalle

---

## Matriz de Permisos (Propuesta)

| Caso de Uso | Propietario | Socio | Chef |
|-------------|:-----------:|:-----:|:----:|
| CU-01 Cargar precios | ✅ | ✅ | ❌ |
| CU-02 Ver historial | ✅ | ✅ | ✅ |
| CU-03 Comparar proveedores | ✅ | ✅ | ❌ |
| CU-04 Crear receta | ✅ | ✅ | ✅ |
| CU-05 Modificar receta | ✅ | ✅ | ✅ |
| CU-06 Agregar plato carta | ✅ | ✅ | ❌ |
| CU-07 Revisar alertas | ✅ | ✅ | ✅ |
| CU-08 Actualizar precio carta | ✅ | ✅ | ❌ |
| CU-09 Gestionar menús | ✅ | ✅ | ❌ |
| CU-10 Ver dashboard | ✅ | ✅ | ✅ |

**Nota:** Los permisos son una propuesta inicial, pendiente de confirmación.
