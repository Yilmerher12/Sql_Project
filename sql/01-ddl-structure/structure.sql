CREATE DATABASE IF NOT EXISTS waste_management;
USE waste_management;

-- ============================================
-- 1. TABLA DE CATEGORÍAS: Localidades
-- ============================================
-- Esta es la tabla que te pide el ejercicio para la relación 1:N.
CREATE TABLE localities (
    locality_id INT AUTO_INCREMENT PRIMARY KEY,
    locality_name VARCHAR(100) NOT NULL UNIQUE
);

-- ============================================
-- 2. TABLA: neighborhoods (Barrios)
-- ============================================
CREATE TABLE neighborhoods (
    neighborhood_id INT AUTO_INCREMENT PRIMARY KEY,
    neighborhood_name VARCHAR(100) NOT NULL,
    -- CHECK: No tiene sentido tener barrios con casas negativas
    neighborhood_estimated_houses INT DEFAULT 0 CHECK (neighborhood_estimated_houses >= 0),
    -- Relación 1:N con Localidades
    locality_id INT NOT NULL,
    FOREIGN KEY (locality_id) REFERENCES localities(locality_id) ON DELETE RESTRICT
);

-- ============================================
-- 3. TABLA: trucks (Camiones)
-- ============================================
CREATE TABLE trucks (
    truck_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_plate VARCHAR(10) NOT NULL UNIQUE,
    truck_brand VARCHAR(50) NOT NULL,
    -- CHECK: Evita que alguien registre un camión con capacidad cero o negativa
    truck_capacity_tons DECIMAL(5, 2) NOT NULL CHECK (truck_capacity_tons > 0),
    truck_status ENUM('active', 'maintenance', 'inactive') DEFAULT 'active'
);

-- ============================================
-- 4. TABLA: routes (Rutas)
-- ============================================
CREATE TABLE routes (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL,
    route_start_hour TIME NOT NULL,
    route_end_hour TIME NOT NULL
);

-- ============================================
-- 5. RELACIÓN N:M: route_neighborhoods
-- ============================================
CREATE TABLE route_neighborhoods (
    route_id INT NOT NULL,
    neighborhood_id INT NOT NULL,
    PRIMARY KEY (route_id, neighborhood_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id) ON DELETE CASCADE,
    FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods(neighborhood_id) ON DELETE CASCADE
);

-- ============================================
-- 6. TABLA TRANSACCIONAL: collections (Recolecciones)
-- ============================================
CREATE TABLE collections (
    collection_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_id INT NOT NULL,
    route_id INT NOT NULL,
    collection_date DATE NOT NULL,
    -- Permitimos NULL en el peso para simular viajes que aún no se pesan
    collection_actual_weight_tons DECIMAL(5, 2) CHECK (collection_actual_weight_tons >= 0),
    collection_observations TEXT,
    FOREIGN KEY (truck_id) REFERENCES trucks(truck_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);