-- =====================================================
-- GASTRO COST SYSTEM - Schema Completo
-- Base de datos PostgreSQL (Supabase)
-- =====================================================

-- =====================================================
-- PARTE 1: TABLAS BÁSICAS
-- =====================================================

CREATE TABLE IF NOT EXISTS categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    orden INT DEFAULT 0
);

INSERT INTO categorias (nombre, orden) VALUES
('Carnes', 1),
('Almacen', 2),
('Verduras_Frutas', 3),
('Pescados_Mariscos', 4),
('Lacteos_Fiambres', 5),
('Bebidas', 6),
('Salsas_Recetas', 7)
ON CONFLICT (nombre) DO NOTHING;

CREATE TABLE IF NOT EXISTS proveedores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(50),
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS secciones_carta (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    orden INT DEFAULT 0
);

INSERT INTO secciones_carta (nombre, orden) VALUES
('Entradas', 1),
('Platos Principales', 2),
('Pastas y Ensaladas', 3),
('Postres', 4)
ON CONFLICT DO NOTHING;

-- =====================================================
-- PARTE 2: TABLAS PRINCIPALES
-- =====================================================

CREATE TABLE IF NOT EXISTS insumos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria_id INT REFERENCES categorias(id),
    proveedor_id INT REFERENCES proveedores(id),
    unidad_medida VARCHAR(20) NOT NULL DEFAULT 'Kg',
    medida_compra DECIMAL(10,2) DEFAULT 1,
    iva_porcentaje DECIMAL(4,2) DEFAULT 0.21,
    merma_porcentaje DECIMAL(4,2) DEFAULT 0,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS precios (
    id SERIAL PRIMARY KEY,
    insumo_id INT REFERENCES insumos(id) ON DELETE CASCADE,
    precio DECIMAL(12,2) NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    precio_unitario DECIMAL(12,4),
    costo_con_iva DECIMAL(12,4),
    costo_final DECIMAL(12,4),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_precios_insumo_fecha ON precios(insumo_id, fecha DESC);

CREATE TABLE IF NOT EXISTS recetas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    es_subreceta BOOLEAN DEFAULT false,
    descripcion TEXT,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS receta_ingredientes (
    id SERIAL PRIMARY KEY,
    receta_id INT REFERENCES recetas(id) ON DELETE CASCADE,
    insumo_id INT REFERENCES insumos(id),
    subreceta_id INT REFERENCES recetas(id),
    cantidad DECIMAL(10,4) NOT NULL,
    extra DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_receta_ingredientes_receta ON receta_ingredientes(receta_id);
CREATE INDEX IF NOT EXISTS idx_receta_ingredientes_insumo ON receta_ingredientes(insumo_id);

CREATE TABLE IF NOT EXISTS platos_carta (
    id SERIAL PRIMARY KEY,
    receta_id INT REFERENCES recetas(id),
    seccion_id INT REFERENCES secciones_carta(id),
    numero INT DEFAULT 1,
    nombre_carta VARCHAR(100),
    margen_objetivo DECIMAL(4,2) NOT NULL DEFAULT 0.75,
    precio_carta DECIMAL(10,2) NOT NULL,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_platos_carta_seccion ON platos_carta(seccion_id);
CREATE INDEX IF NOT EXISTS idx_platos_carta_receta ON platos_carta(receta_id);

-- =====================================================
-- PARTE 3: SEGURIDAD (Row Level Security)
-- =====================================================

ALTER TABLE categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE proveedores ENABLE ROW LEVEL SECURITY;
ALTER TABLE insumos ENABLE ROW LEVEL SECURITY;
ALTER TABLE precios ENABLE ROW LEVEL SECURITY;
ALTER TABLE recetas ENABLE ROW LEVEL SECURITY;
ALTER TABLE receta_ingredientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE secciones_carta ENABLE ROW LEVEL SECURITY;
ALTER TABLE platos_carta ENABLE ROW LEVEL SECURITY;

-- Políticas públicas (ajustar en producción con auth)
CREATE POLICY "Allow all categorias" ON categorias FOR ALL USING (true);
CREATE POLICY "Allow all proveedores" ON proveedores FOR ALL USING (true);
CREATE POLICY "Allow all insumos" ON insumos FOR ALL USING (true);
CREATE POLICY "Allow all precios" ON precios FOR ALL USING (true);
CREATE POLICY "Allow all recetas" ON recetas FOR ALL USING (true);
CREATE POLICY "Allow all receta_ingredientes" ON receta_ingredientes FOR ALL USING (true);
CREATE POLICY "Allow all secciones_carta" ON secciones_carta FOR ALL USING (true);
CREATE POLICY "Allow all platos_carta" ON platos_carta FOR ALL USING (true);

-- =====================================================
-- PARTE 4: FUNCIONES ÚTILES
-- =====================================================

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para updated_at
DROP TRIGGER IF EXISTS update_insumos_updated_at ON insumos;
CREATE TRIGGER update_insumos_updated_at BEFORE UPDATE ON insumos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_recetas_updated_at ON recetas;
CREATE TRIGGER update_recetas_updated_at BEFORE UPDATE ON recetas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_platos_carta_updated_at ON platos_carta;
CREATE TRIGGER update_platos_carta_updated_at BEFORE UPDATE ON platos_carta
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
