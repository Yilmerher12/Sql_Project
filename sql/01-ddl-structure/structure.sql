-- ============================================
-- DDL: Estructura inicial de la base de datos
-- Dominio: Waste Management (Gestión de Residuos)
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- 1. TABLA: trucks (Camiones)
-- ============================================
CREATE TABLE trucks (
    truck_id            SERIAL PRIMARY KEY,
    truck_plate         VARCHAR(10)  NOT NULL UNIQUE,
    truck_brand         VARCHAR(50)  NOT NULL,
    truck_capacity_tons DECIMAL(5,2) NOT NULL CHECK (truck_capacity_tons > 0),
    truck_status        VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (truck_status IN ('active', 'maintenance', 'inactive'))
);

-- ============================================
-- 2. TABLA: neighborhoods (Barrios)
-- ============================================
CREATE TABLE neighborhoods (
    neighborhood_id               SERIAL PRIMARY KEY,
    neighborhood_name             VARCHAR(100) NOT NULL,
    neighborhood_locality         VARCHAR(100) NOT NULL,
    neighborhood_estimated_houses INT DEFAULT 0 CHECK (neighborhood_estimated_houses >= 0)
);

-- ============================================
-- 3. TABLA: routes (Rutas)
-- ============================================
CREATE TABLE routes (
    route_id         SERIAL PRIMARY KEY,
    route_name       VARCHAR(100) NOT NULL,
    route_start_hour TIME NOT NULL,
    route_end_hour   TIME NOT NULL
);

-- ============================================
-- 4. RELACIÓN N:M: route_neighborhoods
-- ============================================
CREATE TABLE route_neighborhoods (
    route_id        INT NOT NULL REFERENCES routes(route_id) ON DELETE CASCADE,
    neighborhood_id INT NOT NULL REFERENCES neighborhoods(neighborhood_id) ON DELETE CASCADE,
    PRIMARY KEY (route_id, neighborhood_id)
);

-- ============================================
-- 5. TABLA TRANSACCIONAL: collections (Recolecciones)
-- ============================================
CREATE TABLE collections (
    collection_id                 SERIAL PRIMARY KEY,
    truck_id                      INT  NOT NULL REFERENCES trucks(truck_id),
    route_id                      INT  NOT NULL REFERENCES routes(route_id),
    collection_date               DATE NOT NULL,
    collection_actual_weight_tons DECIMAL(5,2) CHECK (collection_actual_weight_tons >= 0),
    collection_observations       TEXT
);
