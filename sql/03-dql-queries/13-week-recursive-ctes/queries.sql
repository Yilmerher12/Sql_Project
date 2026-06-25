-- ============================================
-- PROYECTO SEMANAL: CTEs Recursivas
-- Semana 13 — WITH RECURSIVE
-- Dominio: Waste Management (Gestión de Residuos)
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- DDL: Tabla auto-referencial de zonas de recolección
-- Representa la jerarquía geográfica:
-- Ciudad → Localidad → Barrio (3 niveles)
-- ============================================
DROP TABLE IF EXISTS collection_zones CASCADE;

CREATE TABLE collection_zones (
    zone_id     SERIAL PRIMARY KEY,
    zone_name   TEXT   NOT NULL,
    zone_type   TEXT   NOT NULL,
    parent_id   INT    REFERENCES collection_zones(zone_id)
);

-- ============================================
-- DML: Jerarquía de 3 niveles
-- ============================================

-- Nivel 1: Ciudad (raíz, sin padre)
INSERT INTO collection_zones (zone_id, zone_name, zone_type, parent_id) VALUES
(1, 'Bogotá', 'Ciudad', NULL);

-- Nivel 2: Localidades (hijas de Bogotá)
INSERT INTO collection_zones (zone_id, zone_name, zone_type, parent_id) VALUES
(2, 'Chapinero',    'Localidad', 1),
(3, 'Kennedy',      'Localidad', 1),
(4, 'Suba',         'Localidad', 1),
(5, 'Engativá',     'Localidad', 1);

-- Nivel 3: Barrios (hijos de cada localidad)
INSERT INTO collection_zones (zone_id, zone_name, zone_type, parent_id) VALUES
(6,  'Rosales',           'Barrio', 2),
(7,  'Chico Norte',       'Barrio', 2),
(8,  'Kennedy Central',   'Barrio', 3),
(9,  'Castilla',          'Barrio', 3),
(10, 'Patio Bonito',      'Barrio', 3),
(11, 'Suba Centro',       'Barrio', 4),
(12, 'La Colina',         'Barrio', 4),
(13, 'Engativá Pueblo',   'Barrio', 5),
(14, 'Villas de Granada', 'Barrio', 5);


-- ============================================
-- CONSULTA 1: Árbol completo con depth y path
-- Recorre toda la jerarquía desde la raíz.
-- Calcula: depth (nivel 1, 2, 3) y path (ruta completa)
-- ============================================
WITH RECURSIVE arbol AS (
    -- Caso base: nodo raíz (sin padre)
    SELECT
        zone_id,
        zone_name,
        zone_type,
        parent_id,
        1         AS depth,
        zone_name AS path
    FROM collection_zones
    WHERE parent_id IS NULL

    UNION ALL

    -- Caso recursivo: une cada nodo con su padre ya procesado
    SELECT
        z.zone_id,
        z.zone_name,
        z.zone_type,
        z.parent_id,
        a.depth + 1,
        a.path || ' > ' || z.zone_name
    FROM collection_zones z
    INNER JOIN arbol a ON z.parent_id = a.zone_id
)
SELECT
    depth,
    REPEAT('  ', depth - 1) || zone_name AS zona_indentada,
    zone_type                             AS tipo,
    path                                  AS ruta_completa
FROM arbol
ORDER BY path;


-- ============================================
-- CONSULTA 2: Nodos de un nivel específico
-- Muestra solo los barrios (depth = 3)
-- ============================================
WITH RECURSIVE arbol AS (
    SELECT zone_id, zone_name, zone_type, parent_id, 1 AS depth, zone_name AS path
    FROM   collection_zones
    WHERE  parent_id IS NULL

    UNION ALL

    SELECT z.zone_id, z.zone_name, z.zone_type, z.parent_id, a.depth + 1, a.path || ' > ' || z.zone_name
    FROM   collection_zones z
    INNER JOIN arbol a ON z.parent_id = a.zone_id
)
SELECT
    zone_name AS barrio,
    path      AS ruta_completa
FROM arbol
WHERE depth = 3
ORDER BY path;


-- ============================================
-- CONSULTA 3: Hojas del árbol (zonas sin subzonas)
-- Detecta los nodos que no tienen ningún hijo,
-- es decir, los barrios finales del sistema.
-- ============================================
SELECT
    z.zone_id,
    z.zone_name AS zona_hoja,
    z.zone_type AS tipo
FROM collection_zones z
WHERE NOT EXISTS (
    SELECT 1
    FROM   collection_zones hijo
    WHERE  hijo.parent_id = z.zone_id
)
ORDER BY z.zone_name;
