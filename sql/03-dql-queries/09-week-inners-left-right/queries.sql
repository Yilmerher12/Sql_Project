-- ============================================
-- PROYECTO SEMANAL: JOINs aplicados a la base de datos waste_management de mi dominio
-- Semana 09 — INNER JOIN y LEFT JOIN
-- ============================================

-- NOTA: Dominio seleccionado: Waste Management (Gestión de Residuos)
-- Tablas involucradas: localities, neighborhoods, trucks, routes, collections.

PRAGMA foreign_keys = ON;

-- ============================================
-- 1. ESTRUCTURA DDL (Tablas de mi Dominio)
-- Que igual el documento completo esta en la ruta sql/01-ddl-structure/structure.sql, y 02-dml-data/data.sql
-- Lo de aca solo es una referencia a esto, con base a lo que esta pidiendo el profesor.
-- ============================================

DROP TABLE IF EXISTS collections;
DROP TABLE IF EXISTS route_neighborhoods;
DROP TABLE IF EXISTS routes;
DROP TABLE IF EXISTS trucks;
DROP TABLE IF EXISTS neighborhoods;
DROP TABLE IF EXISTS localities;

-- Tabla de referencia: Localidades
CREATE TABLE localities (
    locality_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    locality_name TEXT NOT NULL UNIQUE
);

-- Tabla principal: Barrios (Relación 1:N con Localidades)
-- Muchos barrios pueden pertenecer a una localidad, pero cada barrio solo puede estar en una localidad
CREATE TABLE neighborhoods (
    neighborhood_id               INTEGER PRIMARY KEY AUTOINCREMENT,
    neighborhood_name             TEXT NOT NULL,
    neighborhood_estimated_houses INTEGER DEFAULT 0 CHECK (neighborhood_estimated_houses >= 0),
    locality_id                   INTEGER NOT NULL REFERENCES localities(locality_id)
);

-- Tabla de Camiones
-- El CHECK para evitar ingreso de camiones con capacidad negativa o cero
CREATE TABLE trucks (
    truck_id            INTEGER PRIMARY KEY AUTOINCREMENT,
    truck_plate         TEXT NOT NULL UNIQUE,
    truck_brand         TEXT NOT NULL,
    truck_capacity_tons DECIMAL(5, 2) NOT NULL CHECK (truck_capacity_tons > 0),
    truck_status        TEXT DEFAULT 'active'
);

-- Tabla de Rutas
CREATE TABLE routes (
    route_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    route_name       TEXT NOT NULL,
    route_start_hour TEXT NOT NULL,
    route_end_hour   TEXT NOT NULL
);

-- Tabla transaccional: Recolecciones (Relación con camiones y rutas)
-- Una recoleccion esta asociado a un camión y a una ruta, con detalles de peso y observaciones
CREATE TABLE collections (
    collection_id                INTEGER PRIMARY KEY AUTOINCREMENT,
    truck_id                     INTEGER NOT NULL REFERENCES trucks(truck_id),
    route_id                     INTEGER NOT NULL REFERENCES routes(route_id),
    collection_date              TEXT NOT NULL,
    collection_actual_weight_tons DECIMAL(5, 2) CHECK (collection_actual_weight_tons >= 0),
    collection_observations      TEXT
);

-- ============================================
-- 2. DATOS DE PRUEBA REALISTAS
-- ============================================

INSERT INTO localities (locality_name) VALUES ('Chapinero'), ('Usaquén'), ('Suba');

INSERT INTO neighborhoods (neighborhood_name, locality_id, neighborhood_estimated_houses) VALUES 
('Rosales', 1, 300), 
('Cedritos', 2, 1200),
('Niza', 3, 1000);

INSERT INTO trucks (truck_plate, truck_brand, truck_capacity_tons, truck_status) VALUES 
('SNA-001', 'Hino', 10.5, 'active'), 
('SNA-002', 'Freightliner', 15.0, 'maintenance'), -- Camión "Huérfano" (Sin recolecciones)
('SNA-003', 'International', 12.0, 'active');

INSERT INTO routes (route_name, route_start_hour, route_end_hour) VALUES 
('Ruta Norte', '06:00:00', '14:00:00'),
('Ruta Suba Nocturna', '21:00:00', '05:00:00');

-- Insertamos recolecciones solo para el camión 1 y 3 (el 2 queda como huérfano)
INSERT INTO collections (truck_id, route_id, collection_date, collection_actual_weight_tons) VALUES 
(1, 1, '2026-05-01', 8.5),
(3, 2, '2026-05-01', 11.2);


-- ============================================
-- CONSULTA 1: INNER JOIN principal
-- Une Camiones con sus Recolecciones
-- Muestra solo los camiones que YA tienen actividad registrada
-- ============================================

SELECT 
    t.truck_plate AS placa_camion,
    c.collection_date AS fecha_recoleccion,
    c.collection_actual_weight_tons AS toneladas
FROM trucks t
INNER JOIN collections c ON t.truck_id = c.truck_id;


-- ============================================
-- CONSULTA 2: JOIN con tres tablas
-- Encadena Barrios + Localidades + Rutas (vía lógica de negocio)
-- Muestra la ubicación y el contexto de las recolecciones
-- ============================================

SELECT 
    l.locality_name AS localidad,
    n.neighborhood_name AS barrio,
    r.route_name AS ruta_asignada
FROM neighborhoods n
INNER JOIN localities l ON n.locality_id = l.locality_id
INNER JOIN routes r ON r.route_id = n.neighborhood_id; -- Usamos el ID como vínculo lógico


-- ============================================
-- CONSULTA 3: LEFT JOIN — todos los registros
-- Obtiene todos los camiones aunque no hayan salido a recolectar (aparecerá NULL)
-- ============================================

SELECT 
    t.truck_plate AS placa,
    t.truck_status AS estado,
    c.collection_date AS ultima_actividad
FROM trucks t
LEFT JOIN collections c ON t.truck_id = c.truck_id;


-- ============================================
-- CONSULTA 4: Detectar huérfanos (camiones sin actividad)
-- Filtra para mostrar solo los vehículos que no tienen registros en 'collections'
-- ============================================

SELECT 
    t.truck_plate AS camion_sin_operacion,
    t.truck_brand AS marca
FROM trucks t
LEFT JOIN collections c ON t.truck_id = c.truck_id
WHERE c.collection_id IS NULL;


-- ============================================
-- CONSULTA 5: Reporte agregado con LEFT JOIN + COUNT
-- Cantidad de viajes de recolección realizados por cada camión
-- ============================================

SELECT 
    t.truck_plate AS placa,
    COUNT(c.collection_id) AS total_viajes_realizados
FROM trucks t
LEFT JOIN collections c ON t.truck_id = c.truck_id
GROUP BY t.truck_plate
ORDER BY total_viajes_realizados DESC;