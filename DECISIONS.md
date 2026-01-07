# Decisiones Pendientes

Este documento registra las decisiones técnicas y funcionales que quedan por definir.

## 🔴 Alta Prioridad (bloquean desarrollo)

### DP-01: Stack de Backend
**Opciones:**
- Node.js + Express
- Python + FastAPI
- Node.js + NestJS

**Consideraciones:**
- Experiencia del equipo
- Facilidad de deployment
- Ecosistema de librerías

**Estado:** Pendiente

---

### DP-02: Plataforma de Hosting
**Opciones:**
- Railway
- Render
- Vercel + Supabase
- VPS propio (DigitalOcean, Linode)

**Consideraciones:**
- Costo mensual estimado
- Facilidad de deploy
- Escalabilidad futura
- Backup automático

**Estado:** Pendiente

---

### DP-03: Alcance del MVP
**Pregunta:** ¿Arrancamos con MVP básico o sistema completo?

**MVP propuesto:**
- ✅ Carga de costos de insumos
- ✅ Recetas con cálculo automático
- ✅ Carta con alertas de margen
- ❌ Historial de precios (fase 2)
- ❌ Comparativa de proveedores (fase 2)
- ❌ Menús ejecutivos (fase 2)
- ❌ Dashboard avanzado (fase 2)

**Estado:** Pendiente confirmación

---

## 🟡 Media Prioridad

### DP-04: Permisos por Rol
**Pregunta:** ¿El chef tiene permisos limitados?

**Propuesta:**
| Acción | Propietario | Socio | Chef |
|--------|:-----------:|:-----:|:----:|
| Cargar precios | ✅ | ✅ | ❌ |
| Ver costos | ✅ | ✅ | ✅ |
| Crear recetas | ✅ | ✅ | ✅ |
| Modificar carta | ✅ | ✅ | ❌ |
| Cambiar precios carta | ✅ | ✅ | ❌ |

**Estado:** Pendiente confirmación

---

### DP-05: Autenticación
**Opciones:**
- Usuario/contraseña simple
- Google OAuth
- Magic links por email
- PIN para acceso rápido

**Estado:** Pendiente

---

### DP-06: Importación de Datos Inicial
**Pregunta:** ¿Cómo migramos los datos del Excel actual?

**Opciones:**
- Script de importación único
- Carga manual
- Función de importación en la app

**Estado:** Pendiente

---

## 🟢 Baja Prioridad (pueden decidirse después)

### DP-07: Notificaciones
**Pregunta:** ¿Agregamos notificaciones en el futuro?

**Opciones:**
- Email cuando hay alertas
- WhatsApp (requiere integración)
- Solo en la app

**Estado:** Descartado para MVP

---

### DP-08: Backup y Export
**Pregunta:** ¿Permitimos exportar datos?

**Opciones:**
- Export a Excel
- Backup manual descargable
- Solo backup automático en servidor

**Estado:** Pendiente

---

### DP-09: Multi-establecimiento
**Pregunta:** ¿El sistema podría manejar más de un restaurante?

**Consideraciones:**
- ¿Hay planes de expansión?
- ¿Comparten proveedores/insumos?

**Estado:** Fuera de alcance inicial

---

## Registro de Decisiones Tomadas

| Fecha | Decisión | Detalle |
|-------|----------|---------|
| 2025-01-06 | Frecuencia carga | 1-2 semanas, manual con factura |
| 2025-01-06 | Alertas | Solo visuales en app, no WhatsApp |
| 2025-01-06 | Historial precios | Sí, con gráfico de evolución |
| 2025-01-06 | Sub-recetas | Sí, para salsas y guarniciones |
| 2025-01-06 | Sugerencia precio | Sí, cuando cae el margen |
| 2025-01-06 | Usuarios | Propietario, socio, chef |
| 2025-01-06 | Dispositivos | Notebook y celular (responsive) |
| 2025-01-06 | Integraciones | Ninguna, sistema independiente |
| 2025-01-06 | Comparar proveedores | Sí |
| 2025-01-06 | Menús ejecutivos | Sí |
