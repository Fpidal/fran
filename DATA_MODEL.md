# Modelo de Datos

## Diagrama Entidad-Relación

```
┌─────────────────┐       ┌─────────────────┐
│   PROVEEDOR     │       │   CATEGORIA     │
├─────────────────┤       ├─────────────────┤
│ id              │       │ id              │
│ nombre          │       │ nombre          │
│ contacto        │       │ descripcion     │
│ telefono        │       └────────┬────────┘
│ email           │                │
└────────┬────────┘                │
         │                         │
         │ 1:N                     │ 1:N
         │                         │
         ▼                         ▼
┌─────────────────────────────────────────────┐
│                   INSUMO                     │
├─────────────────────────────────────────────┤
│ id                                           │
│ nombre                                       │
│ categoria_id  ──────────────────────────────►│
│ proveedor_id  ──────────────────────────────►│
│ unidad_medida                                │
│ medida_compra (cantidad por unidad)          │
│ iva_porcentaje                               │
│ merma_porcentaje                             │
│ activo                                       │
└──────────────────────┬──────────────────────┘
                       │
                       │ 1:N
                       ▼
┌─────────────────────────────────────────────┐
│              PRECIO_HISTORIAL                │
├─────────────────────────────────────────────┤
│ id                                           │
│ insumo_id  ─────────────────────────────────►│
│ precio                                       │
│ fecha_actualizacion                          │
│ precio_unitario (calculado)                  │
│ costo_con_iva (calculado)                    │
│ costo_final (calculado, con merma)           │
└─────────────────────────────────────────────┘


┌─────────────────────────────────────────────┐
│                   RECETA                     │
├─────────────────────────────────────────────┤
│ id                                           │
│ nombre                                       │
│ es_subreceta (boolean)                       │
│ descripcion                                  │
│ costo_total (calculado)                      │
│ activo                                       │
└──────────────────────┬──────────────────────┘
                       │
                       │ 1:N
                       ▼
┌─────────────────────────────────────────────┐
│             RECETA_INGREDIENTE               │
├─────────────────────────────────────────────┤
│ id                                           │
│ receta_id  ─────────────────────────────────►│
│ insumo_id (nullable) ───────────────────────►│
│ subreceta_id (nullable) ────────────────────►│ (ref a RECETA)
│ cantidad                                     │
│ extra                                        │
│ costo_porcion (calculado)                    │
│ incidencia (calculado)                       │
└─────────────────────────────────────────────┘


┌─────────────────────────────────────────────┐
│              SECCION_CARTA                   │
├─────────────────────────────────────────────┤
│ id                                           │
│ nombre (Entradas, Principales, etc.)         │
│ orden                                        │
└──────────────────────┬──────────────────────┘
                       │
                       │ 1:N
                       ▼
┌─────────────────────────────────────────────┐
│                PLATO_CARTA                   │
├─────────────────────────────────────────────┤
│ id                                           │
│ receta_id  ─────────────────────────────────►│
│ seccion_id ─────────────────────────────────►│
│ numero (orden en carta)                      │
│ nombre_carta (puede diferir de receta)       │
│ margen_objetivo                              │
│ precio_carta                                 │
│ precio_sugerido (calculado)                  │
│ margen_real (calculado)                      │
│ margen_contribucion (calculado)              │
│ estado (OK / ALERTA)                         │
│ activo                                       │
└─────────────────────────────────────────────┘


┌─────────────────────────────────────────────┐
│                    MENU                      │
├─────────────────────────────────────────────┤
│ id                                           │
│ nombre (Menu Carne, Menu Pescado, etc.)      │
│ descripcion                                  │
│ margen_objetivo                              │
│ precio_menu                                  │
│ costo_total (calculado)                      │
│ activo                                       │
└──────────────────────┬──────────────────────┘
                       │
                       │ 1:N
                       ▼
┌─────────────────────────────────────────────┐
│               MENU_COMPONENTE                │
├─────────────────────────────────────────────┤
│ id                                           │
│ menu_id  ───────────────────────────────────►│
│ receta_id (nullable) ───────────────────────►│
│ insumo_id (nullable) ───────────────────────►│
│ cantidad                                     │
│ costo_componente (calculado)                 │
└─────────────────────────────────────────────┘
```

## Tablas Detalladas

### PROVEEDOR
```sql
CREATE TABLE proveedor (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(50),
    email VARCHAR(100),
    notas TEXT,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### CATEGORIA
```sql
CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    orden INT DEFAULT 0
);

-- Datos iniciales
INSERT INTO categoria (nombre, orden) VALUES
('Carnes', 1),
('Almacen', 2),
('Verduras_Frutas', 3),
('Pescados_Mariscos', 4),
('Lacteos_Fiambres', 5),
('Bebidas', 6),
('Salsas_Recetas', 7);
```

### INSUMO
```sql
CREATE TABLE insumo (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria_id INT REFERENCES categoria(id),
    proveedor_id INT REFERENCES proveedor(id),
    unidad_medida VARCHAR(20) NOT NULL, -- Kg, Ltos, Un, Riestra
    medida_compra DECIMAL(10,2) DEFAULT 1, -- cantidad por unidad de compra
    iva_porcentaje DECIMAL(4,2) DEFAULT 0.21,
    merma_porcentaje DECIMAL(4,2) DEFAULT 0,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### PRECIO_HISTORIAL
```sql
CREATE TABLE precio_historial (
    id SERIAL PRIMARY KEY,
    insumo_id INT REFERENCES insumo(id) ON DELETE CASCADE,
    precio DECIMAL(12,2) NOT NULL, -- precio de compra
    fecha_actualizacion DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Campos calculados (pueden ser generados o triggers)
    precio_unitario DECIMAL(12,4), -- precio / medida_compra
    costo_con_iva DECIMAL(12,4),   -- precio_unitario * (1 + iva)
    costo_final DECIMAL(12,4)      -- costo_con_iva * (1 + merma)
);

-- Vista para obtener precio actual de cada insumo
CREATE VIEW insumo_precio_actual AS
SELECT DISTINCT ON (insumo_id)
    i.*,
    ph.precio,
    ph.fecha_actualizacion,
    ph.precio_unitario,
    ph.costo_con_iva,
    ph.costo_final,
    LAG(ph.precio) OVER (PARTITION BY ph.insumo_id ORDER BY ph.fecha_actualizacion) as precio_anterior
FROM insumo i
LEFT JOIN precio_historial ph ON i.id = ph.insumo_id
ORDER BY insumo_id, fecha_actualizacion DESC;
```

### RECETA
```sql
CREATE TABLE receta (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    es_subreceta BOOLEAN DEFAULT false,
    descripcion TEXT,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### RECETA_INGREDIENTE
```sql
CREATE TABLE receta_ingrediente (
    id SERIAL PRIMARY KEY,
    receta_id INT REFERENCES receta(id) ON DELETE CASCADE,
    insumo_id INT REFERENCES insumo(id), -- NULL si es subreceta
    subreceta_id INT REFERENCES receta(id), -- NULL si es insumo
    cantidad DECIMAL(10,4) NOT NULL,
    extra DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraint: debe tener insumo O subreceta, no ambos
    CONSTRAINT ingrediente_tipo CHECK (
        (insumo_id IS NOT NULL AND subreceta_id IS NULL) OR
        (insumo_id IS NULL AND subreceta_id IS NOT NULL)
    )
);
```

### SECCION_CARTA
```sql
CREATE TABLE seccion_carta (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    orden INT DEFAULT 0
);

INSERT INTO seccion_carta (nombre, orden) VALUES
('Entradas', 1),
('Platos Principales', 2),
('Pastas y Ensaladas', 3),
('Postres', 4);
```

### PLATO_CARTA
```sql
CREATE TABLE plato_carta (
    id SERIAL PRIMARY KEY,
    receta_id INT REFERENCES receta(id),
    seccion_id INT REFERENCES seccion_carta(id),
    numero INT, -- orden en la sección
    nombre_carta VARCHAR(100), -- nombre para mostrar (puede diferir de receta)
    margen_objetivo DECIMAL(4,2) NOT NULL DEFAULT 0.75,
    precio_carta DECIMAL(10,2),
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### MENU
```sql
CREATE TABLE menu (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    margen_objetivo DECIMAL(4,2) DEFAULT 0.75,
    precio_menu DECIMAL(10,2),
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### MENU_COMPONENTE
```sql
CREATE TABLE menu_componente (
    id SERIAL PRIMARY KEY,
    menu_id INT REFERENCES menu(id) ON DELETE CASCADE,
    receta_id INT REFERENCES receta(id),
    insumo_id INT REFERENCES insumo(id),
    cantidad DECIMAL(10,4) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT componente_tipo CHECK (
        (receta_id IS NOT NULL AND insumo_id IS NULL) OR
        (receta_id IS NULL AND insumo_id IS NOT NULL)
    )
);
```

## Funciones de Cálculo

### Calcular costo de receta
```sql
CREATE OR REPLACE FUNCTION calcular_costo_receta(p_receta_id INT)
RETURNS DECIMAL(12,4) AS $$
DECLARE
    v_costo DECIMAL(12,4) := 0;
BEGIN
    SELECT COALESCE(SUM(
        CASE 
            WHEN ri.insumo_id IS NOT NULL THEN
                (SELECT costo_final FROM insumo_precio_actual WHERE id = ri.insumo_id) * ri.cantidad + ri.extra
            WHEN ri.subreceta_id IS NOT NULL THEN
                calcular_costo_receta(ri.subreceta_id) * ri.cantidad + ri.extra
        END
    ), 0)
    INTO v_costo
    FROM receta_ingrediente ri
    WHERE ri.receta_id = p_receta_id;
    
    RETURN v_costo;
END;
$$ LANGUAGE plpgsql;
```

### Calcular precio sugerido
```sql
CREATE OR REPLACE FUNCTION calcular_precio_sugerido(p_costo DECIMAL, p_margen DECIMAL)
RETURNS DECIMAL(10,2) AS $$
BEGIN
    IF p_margen >= 1 THEN
        RETURN NULL; -- Margen inválido
    END IF;
    RETURN ROUND(p_costo / (1 - p_margen), 2);
END;
$$ LANGUAGE plpgsql;
```

### Vista de carta con cálculos
```sql
CREATE VIEW carta_completa AS
SELECT 
    pc.id,
    pc.numero,
    COALESCE(pc.nombre_carta, r.nombre) as nombre,
    sc.nombre as seccion,
    calcular_costo_receta(pc.receta_id) as costo,
    pc.margen_objetivo,
    calcular_precio_sugerido(calcular_costo_receta(pc.receta_id), pc.margen_objetivo) as precio_sugerido,
    pc.precio_carta,
    CASE 
        WHEN pc.precio_carta > 0 THEN 
            ROUND((pc.precio_carta - calcular_costo_receta(pc.receta_id)) / pc.precio_carta, 4)
        ELSE 0 
    END as margen_real,
    pc.precio_carta - calcular_costo_receta(pc.receta_id) as margen_contribucion,
    CASE 
        WHEN pc.precio_carta > 0 AND 
             (pc.precio_carta - calcular_costo_receta(pc.receta_id)) / pc.precio_carta < pc.margen_objetivo
        THEN 'ALERTA'
        ELSE 'OK'
    END as estado
FROM plato_carta pc
JOIN receta r ON pc.receta_id = r.id
JOIN seccion_carta sc ON pc.seccion_id = sc.id
WHERE pc.activo = true
ORDER BY sc.orden, pc.numero;
```

## Índices Recomendados

```sql
CREATE INDEX idx_precio_historial_insumo ON precio_historial(insumo_id, fecha_actualizacion DESC);
CREATE INDEX idx_receta_ingrediente_receta ON receta_ingrediente(receta_id);
CREATE INDEX idx_receta_ingrediente_insumo ON receta_ingrediente(insumo_id);
CREATE INDEX idx_plato_carta_receta ON plato_carta(receta_id);
CREATE INDEX idx_insumo_categoria ON insumo(categoria_id);
CREATE INDEX idx_insumo_proveedor ON insumo(proveedor_id);
```
