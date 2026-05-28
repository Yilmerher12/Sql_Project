-- ============================================
-- PROYECTO SEMANAL: Subqueries en Gestión de Residuos
-- Semana 11 — Subqueries (escalar, IN, EXISTS, FROM)
-- Motor: MySQL
-- ============================================

USE waste_management;

-- ============================================
-- 1. DDL: Creación de tablas para la Semana 11
-- ============================================
DROP TABLE IF EXISTS facility_inspections;
DROP TABLE IF EXISTS waste_facilities;

-- Tabla Principal (Plantas o instalaciones de manejo de residuos)
CREATE TABLE waste_facilities (
    facility_id   INT AUTO_INCREMENT PRIMARY KEY,
    facility_name VARCHAR(100) NOT NULL,
    capacity_tons DECIMAL(10,2) NOT NULL CHECK (capacity_tons > 0), -- Este es nuestro 'value'
    facility_type VARCHAR(50) NOT NULL -- Esta es nuestra 'category'
);

-- Tabla Hija (Inspecciones realizadas a las instalaciones)
CREATE TABLE facility_inspections (
    inspection_id   INT AUTO_INCREMENT PRIMARY KEY,
    facility_id     INT NOT NULL,
    inspection_date DATE NOT NULL,
    FOREIGN KEY (facility_id) REFERENCES waste_facilities(facility_id) ON DELETE CASCADE
);

-- ============================================
-- 2. DML: Insertar datos de prueba
-- ============================================

-- Insertamos instalaciones de diferentes tipos y capacidades
INSERT INTO waste_facilities (facility_name, capacity_tons, facility_type) VALUES 
('Planta de Reciclaje Norte', 500.00, 'Reciclaje'),
('Planta de Reciclaje Sur', 250.00, 'Reciclaje'),
('Relleno Sanitario Doña Juana', 5000.00, 'Disposición Final'),
('Relleno Alterno', 1200.00, 'Disposición Final'),
('Centro de Compostaje', 150.00, 'Compostaje'),
('Planta Nueva Fontibón', 300.00, 'Reciclaje'); -- Esta será la instalación SIN inspecciones

-- Insertamos inspecciones para algunas instalaciones (La ID 6 queda sin inspecciones)
INSERT INTO facility_inspections (facility_id, inspection_date) VALUES 
(1, '2026-01-15'),
(1, '2026-03-20'),
(2, '2026-02-10'),
(3, '2026-01-05'),
(3, '2026-04-12'),
(3, '2026-05-18'),
(4, '2026-02-28'),
(5, '2026-03-10');


-- ============================================
-- CONSULTA 1: Subquery escalar en el WHERE
-- OBJETIVO: Mostrar instalaciones cuya capacidad sea MAYOR al promedio de su propio tipo.
-- EXPLICACIÓN: Una subconsulta 'escalar' devuelve un solo valor (un número). 
-- Aquí el motor calcula el promedio por categoría y lo compara fila por fila.
-- ============================================

SELECT 
    wf.facility_name AS instalacion,
    wf.capacity_tons AS capacidad_toneladas,
    wf.facility_type AS tipo
FROM waste_facilities wf
WHERE wf.capacity_tons > (
    -- Esta subconsulta calcula el promedio SOLO para el tipo de instalación actual
    SELECT AVG(wf2.capacity_tons)
    FROM waste_facilities wf2
    WHERE wf2.facility_type = wf.facility_type
)
ORDER BY wf.facility_type, wf.capacity_tons DESC;


-- ============================================
-- CONSULTA 2: Subquery escalar en el SELECT
-- OBJETIVO: Mostrar la capacidad global promedio al lado de cada instalación.
-- EXPLICACIÓN: Se ejecuta la subconsulta en las columnas para mostrar un dato 
-- estadístico general que sirva de punto de comparación en el reporte.
-- ============================================

SELECT 
    facility_name AS instalacion,
    capacity_tons AS capacidad,
    -- Calculamos el promedio global de toda la tabla y lo mostramos como columna
    ROUND((SELECT AVG(capacity_tons) FROM waste_facilities), 2) AS promedio_global_toneladas
FROM waste_facilities
ORDER BY capacity_tons DESC;


-- ============================================
-- CONSULTA 3: NOT EXISTS — items sin actividad
-- OBJETIVO: Buscar instalaciones que NO tengan registros de inspección.
-- EXPLICACIÓN: EXISTS evalúa si la subconsulta devuelve al menos una fila (True/False).
-- Es la forma más rápida y óptima a nivel de motor para buscar registros "huérfanos".
-- ============================================

SELECT 
    wf.facility_name AS instalacion_sin_inspecciones
FROM waste_facilities wf
WHERE NOT EXISTS (
    -- Intenta buscar un simple '1' en la tabla hija donde los IDs coincidan
    SELECT 1 
    FROM facility_inspections fi
    WHERE fi.facility_id = wf.facility_id
);


-- ============================================
-- CONSULTA 4: Tabla derivada en el FROM
-- OBJETIVO: Mostrar tipos de instalación que tengan más de 2 inspecciones en total.
-- EXPLICACIÓN: En lugar de leer una tabla real, el FROM lee el resultado de una 
-- subconsulta como si fuera una tabla temporal en memoria. ¡Obligatorio usar un alias!
-- ============================================

SELECT 
    stats_inspecciones.tipo_instalacion,
    stats_inspecciones.total_inspecciones
FROM (
    -- Esta es la "Tabla Derivada". Genera un reporte interno primero.
    SELECT 
        wf.facility_type AS tipo_instalacion,
        COUNT(fi.inspection_id) AS total_inspecciones
    FROM waste_facilities wf
    LEFT JOIN facility_inspections fi ON fi.facility_id = wf.facility_id
    GROUP BY wf.facility_type
) AS stats_inspecciones -- Alias obligatorio en MySQL para tablas derivadas
WHERE stats_inspecciones.total_inspecciones > 2
ORDER BY stats_inspecciones.total_inspecciones DESC;