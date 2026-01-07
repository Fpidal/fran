# Guía de Instalación Completa

## Requisitos Previos

- Node.js 18+ instalado
- Cuenta en Supabase (gratis)
- Cuenta en Vercel (gratis, opcional para deploy)

---

## Paso 1: Crear Proyecto en Supabase

1. Ir a [supabase.com](https://supabase.com) y crear cuenta
2. Click en **"New Project"**
3. Configurar:
   - Nombre: `gastro-cost-system`
   - Password: elegir una contraseña segura
   - Region: la más cercana
4. Esperar ~2 minutos a que se cree

---

## Paso 2: Crear Tablas en la Base de Datos

1. En Supabase, ir a **SQL Editor** (menú izquierdo)
2. Click en **"New Query"**
3. Ejecutar los siguientes scripts en orden:

### Script 1: Tablas Básicas
```sql
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
('Entradas', 1),('Platos Principales', 2),('Pastas y Ensaladas', 3),('Postres', 4);
```

### Script 2: Tablas Principales
```sql
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
```

### Script 3: Seguridad
```sql
ALTER TABLE categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE proveedores ENABLE ROW LEVEL SECURITY;
ALTER TABLE insumos ENABLE ROW LEVEL SECURITY;
ALTER TABLE precios ENABLE ROW LEVEL SECURITY;
ALTER TABLE recetas ENABLE ROW LEVEL SECURITY;
ALTER TABLE receta_ingredientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE secciones_carta ENABLE ROW LEVEL SECURITY;
ALTER TABLE platos_carta ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all categorias" ON categorias FOR ALL USING (true);
CREATE POLICY "Allow all proveedores" ON proveedores FOR ALL USING (true);
CREATE POLICY "Allow all insumos" ON insumos FOR ALL USING (true);
CREATE POLICY "Allow all precios" ON precios FOR ALL USING (true);
CREATE POLICY "Allow all recetas" ON recetas FOR ALL USING (true);
CREATE POLICY "Allow all receta_ingredientes" ON receta_ingredientes FOR ALL USING (true);
CREATE POLICY "Allow all secciones_carta" ON secciones_carta FOR ALL USING (true);
CREATE POLICY "Allow all platos_carta" ON platos_carta FOR ALL USING (true);
```

---

## Paso 3: Obtener Credenciales de Supabase

1. Ir a **Settings** → **API**
2. Copiar:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public key**: `eyJ...` (la larga)

---

## Paso 4: Configurar el Proyecto Local

```bash
# Clonar repositorio
git clone https://github.com/Fpidal/fran.git
cd fran

# Instalar dependencias
npm install

# Crear archivo de configuración
cp .env.example .env.local
```

Editar `.env.local`:
```
NEXT_PUBLIC_SUPABASE_URL=https://tu-proyecto.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...tu-key-aqui
```

---

## Paso 5: Ejecutar

```bash
npm run dev
```

Abrir [http://localhost:3000](http://localhost:3000)

---

## Paso 6: Deploy en Vercel (Opcional)

1. Subir código a GitHub
2. Ir a [vercel.com](https://vercel.com)
3. **New Project** → Importar repositorio
4. Agregar variables de entorno:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
5. **Deploy**

---

## Solución de Problemas

### Error: "Invalid API key"
- Verificar que las variables en `.env.local` estén correctas
- Reiniciar el servidor (`Ctrl+C` y `npm run dev`)

### Error: "relation does not exist"
- Ejecutar los scripts SQL en Supabase

### Los datos no se muestran
- Verificar en Supabase que las tablas tengan datos
- Revisar la consola del navegador (F12) por errores
