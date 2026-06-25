-- ============================================
-- PROYECTO SEMANAL: CTEs y CASE WHEN
-- Semana 12 — Common Table Expressions + Condicionales
-- Dominio: Waste Management (Gestión de Residuos)
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- DDL: Tablas para la semana 12
-- Instalaciones de residuos y sus recolecciones mensuales
-- ============================================
DROP TABLE IF EXISTS facility_collections CASCADE;
DROP TABLE IF EXISTS facilities CASCADE;

CREATE TABLE facilities (
    facility_id   SERIAL PRIMARY KEY,
    facility_name VARCHAR(100)  NOT NULL,
    capacity_tons DECIMAL(10,2) NOT NULL CHECK (capacity_tons > 0),
    facility_type VARCHAR(50)   NOT NULL
);

CREATE TABLE facility_collections (
    collection_id SERIAL PRIMARY KEY,
    facility_id   INT          NOT NULL REFERENCES facilities(facility_id),
    tons_received DECIMAL(8,2) NOT NULL CHECK (tons_received > 0),
    collected_at  DATE         NOT NULL
);

-- ============================================
-- DML: Datos de prueba
-- 6 instalaciones en 3 tipos, 12 recolecciones distribuidas
-- ============================================
INSERT INTO facilities (facility_name, capacity_tons, facility_type) VALUES
('Planta Norte',              500.00, 'Reciclaje'),
('Planta Sur',                250.00, 'Reciclaje'),
('Planta Fontibón',           300.00, 'Reciclaje'),
('Relleno Doña Juana',       5000.00, 'Disposición Final'),
('Relleno Alterno',          1200.00, 'Disposición Final'),
('Centro de Compostaje Este',  150.00, 'Compostaje');

INSERT INTO facility_collections (facility_id, tons_received, collected_at) VALUES
(1, 120.50, '2026-04-03'),
(1,  98.30, '2026-04-10'),
(1, 145.20, '2026-04-17'),
(2,  60.00, '2026-04-04'),
(2,  75.80, '2026-04-18'),
(3,  88.40, '2026-04-05'),
(3, 102.10, '2026-04-19'),
(4, 980.00, '2026-04-06'),
(4, 870.50, '2026-04-20'),
(5, 430.00, '2026-04-07'),
(6,  32.50, '2026-04-12'),
(6,  28.90, '2026-04-26');


-- ============================================
-- CONSULTA 1: CTE simple + CASE WHEN de clasificación
-- Clasifica cada instalación según su capacidad en 3 bandas
-- y cuenta cuántas recolecciones ha tenido.
-- ============================================
WITH instalaciones_con_actividad AS (
    SELECT
        f.facility_id,
        f.facility_name,
        f.capacity_tons,
        f.facility_type,
        COUNT(fc.collection_id) AS total_recolecciones
    FROM facilities f
    LEFT JOIN facility_collections fc ON fc.facility_id = f.facility_id
    GROUP BY f.facility_id, f.facility_name, f.capacity_tons, f.facility_type
)
SELECT
    facility_name        AS instalacion,
    capacity_tons        AS capacidad_tons,
    facility_type        AS tipo,
    total_recolecciones,
    CASE
        WHEN capacity_tons >= 1000 THEN 'Gran Escala'
        WHEN capacity_tons >=  300 THEN 'Mediana Escala'
        ELSE                            'Pequeña Escala'
    END AS escala_operativa
FROM instalaciones_con_actividad
ORDER BY capacity_tons DESC;


-- ============================================
-- CONSULTA 2: Dos CTEs encadenados
-- CTE 1: total de toneladas recibidas por tipo de instalación
-- CTE 2: tipos por encima del promedio global
-- Resultado: muestra solo los tipos "top"
-- ============================================
WITH toneladas_por_tipo AS (
    SELECT
        f.facility_type              AS tipo,
        SUM(fc.tons_received)        AS total_toneladas
    FROM facilities f
    INNER JOIN facility_collections fc ON fc.facility_id = f.facility_id
    GROUP BY f.facility_type
),
tipos_top AS (
    SELECT tipo
    FROM toneladas_por_tipo
    WHERE total_toneladas > (SELECT AVG(total_toneladas) FROM toneladas_por_tipo)
)
SELECT
    t.tipo,
    t.total_toneladas
FROM toneladas_por_tipo t
WHERE t.tipo IN (SELECT tipo FROM tipos_top)
ORDER BY t.total_toneladas DESC;


-- ============================================
-- CONSULTA 3: CTE + COUNT condicional por banda
-- Por tipo de instalación, cuenta cuántas hay en cada escala
-- ============================================
WITH clasificadas AS (
    SELECT
        facility_name,
        facility_type,
        capacity_tons,
        CASE
            WHEN capacity_tons >= 1000 THEN 'Gran Escala'
            WHEN capacity_tons >=  300 THEN 'Mediana Escala'
            ELSE                            'Pequeña Escala'
        END AS escala_operativa
    FROM facilities
)
SELECT
    facility_type                                                   AS tipo,
    COUNT(CASE WHEN escala_operativa = 'Gran Escala'    THEN 1 END) AS gran_escala,
    COUNT(CASE WHEN escala_operativa = 'Mediana Escala' THEN 1 END) AS mediana_escala,
    COUNT(CASE WHEN escala_operativa = 'Pequeña Escala' THEN 1 END) AS pequena_escala
FROM clasificadas
GROUP BY facility_type
ORDER BY facility_type;
