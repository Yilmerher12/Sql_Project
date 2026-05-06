CREATE DATABASE IF NOT EXISTS waste_management;
USE waste_management;

-- 1. Catálogo de vehículos disponibles
CREATE TABLE trucks (
    truck_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_plate VARCHAR(10) NOT NULL UNIQUE,
    truck_brand VARCHAR(50) NOT NULL,
    truck_capacity_tons DECIMAL(5, 2) NOT NULL,
    truck_status ENUM('active', 'maintenance', 'inactive') DEFAULT 'active'
);

-- 2. Catálogo de zonas geográficas
CREATE TABLE neighborhoods (
    neighborhood_id INT AUTO_INCREMENT PRIMARY KEY,
    neighborhood_name VARCHAR(100) NOT NULL,
    neighborhood_locality VARCHAR(100) NOT NULL,
    neighborhood_estimated_houses INT DEFAULT 0
);

-- 3. Definición de rutas y horarios teóricos
CREATE TABLE routes (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL,
    route_start_hour TIME NOT NULL,
    route_end_hour TIME NOT NULL
);

-- 4. Relación Muchos a Muchos: Asignación de barrios a rutas
CREATE TABLE route_neighborhoods (
    route_id INT NOT NULL,
    neighborhood_id INT NOT NULL,
    PRIMARY KEY (route_id, neighborhood_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id) ON DELETE CASCADE,
    FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods(neighborhood_id) ON DELETE CASCADE
);

-- 5. Tabla transaccional: Registro real de operaciones
CREATE TABLE collections (
    collection_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_id INT NOT NULL,
    route_id INT NOT NULL,
    collection_date DATE NOT NULL,
    collection_actual_weight_tons DECIMAL(5, 2),
    collection_observations TEXT,
    FOREIGN KEY (truck_id) REFERENCES trucks(truck_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);