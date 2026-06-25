-- ============================================
-- PROYECTO SEMANAL: Subqueries
-- Semana 11 — Subquery escalar, IN, EXISTS, FROM
-- Dominio: Waste Management (Gestión de Residuos)
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- DDL: Tablas para la semana 11
-- ============================================
DROP TABLE IF EXISTS facility_inspections;
DROP TABLE IF EXISTS waste_facilities;

-- Tabla principal: instalaciones de manejo de residuos
CREATE TABLE waste_facilities (
    facility_id   SERIAL PRIMARY KEY,
    facility_name VARCHAR(100)  NOT NULL,
    capacity_tons DECIMAL(10,2) NOT NULL CHECK (capacity_tons > 0),
    facility_type VARCHAR(50)   NOT NULL
);

-- Tabla hija: inspecciones realizadas a cada instalación
CREATE TABLE facility_inspections (
    inspection_id   SERIAL PRIMARY KEY,
    facility_id     INT  NOT NULL REFERENCES waste_facilities(facility_id) ON DELETE CASCADE,
    inspection_date DATE NOT NULL
);

-- ============================================
-- DML: Datos de prueba
-- ============================================

INSERT INTO waste_facilities (facility_name, capacity_tons, facility_type) VALUES
('Planta de Reciclaje Norte',    500.00, 'Reciclaje'),
('Planta de Reciclaje Sur',      250.00, 'Reciclaje'),
('Relleno Sanitario Doña Juana',5000.00, 'Disposición Final'),
('Relleno Alterno',             1200.00, 'Disposición Final'),
('Centro de Compostaje',         150.00, 'Compostaje'),
('Planta Nueva Fontibón',        300.00, 'Reciclaje');  -- sin inspecciones (para NOT EXISTS)

-- Inspecciones (la instalación 6 queda sin ninguna)
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
-- CONSULTA 1: Subquery escalar en WHERE
-- Instalaciones con capacidad mayor al promedio de su propio tipo.
-- ============================================
SELECT
    wf.facility_name  AS instalacion,
    wf.capacity_tons  AS capacidad_toneladas,
    wf.facility_type  AS tipo
FROM waste_facilities wf
WHERE wf.capacity_tons > (
    SELECT AVG(wf2.capacity_tons)
    FROM   waste_facilities wf2
    WHERE  wf2.facility_type = wf.facility_type
)
ORDER BY wf.facility_type, wf.capacity_tons DESC;


-- ============================================
-- CONSULTA 2: Subquery escalar en SELECT
-- Muestra el promedio global junto a cada instalación.
-- ============================================
SELECT
    facility_name AS instalacion,
    capacity_tons AS capacidad,
    ROUND((SELECT AVG(capacity_tons) FROM waste_facilities), 2) AS promedio_global_toneladas
FROM waste_facilities
ORDER BY capacity_tons DESC;


-- ============================================
-- CONSULTA 3: NOT EXISTS — instalaciones sin inspecciones
-- ============================================
SELECT
    wf.facility_name AS instalacion_sin_inspecciones
FROM waste_facilities wf
WHERE NOT EXISTS (
    SELECT 1
    FROM   facility_inspections fi
    WHERE  fi.facility_id = wf.facility_id
);


-- ============================================
-- CONSULTA 4: Tabla derivada en FROM
-- Tipos de instalación con más de 2 inspecciones en total.
-- ============================================
SELECT
    stats.tipo_instalacion,
    stats.total_inspecciones
FROM (
    SELECT
        wf.facility_type          AS tipo_instalacion,
        COUNT(fi.inspection_id)   AS total_inspecciones
    FROM waste_facilities wf
    LEFT JOIN facility_inspections fi ON fi.facility_id = wf.facility_id
    GROUP BY wf.facility_type
) AS stats
WHERE stats.total_inspecciones > 2
ORDER BY stats.total_inspecciones DESC;
