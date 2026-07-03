-- ============================================
-- PROYECTO SEMANAL: Ranking con Window Functions
-- Semana 14 — ROW_NUMBER, RANK, DENSE_RANK
-- Dominio: Waste Management (Gestión de Residuos)
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- DDL: Marcas de camiones (categorías) y camiones (items)
-- Se usan las marcas como categoría natural del dominio.
-- Los camiones de la misma marca tienen la misma capacidad,
-- lo que genera empates reales para demostrar RANK vs DENSE_RANK.
-- ============================================
DROP TABLE IF EXISTS trucks_ranking CASCADE;
DROP TABLE IF EXISTS truck_brands CASCADE;

CREATE TABLE truck_brands (
    id   SERIAL PRIMARY KEY,
    name TEXT   NOT NULL
);

CREATE TABLE trucks_ranking (
    id           SERIAL         PRIMARY KEY,
    plate        TEXT           NOT NULL UNIQUE,
    capacity_tons NUMERIC(5,2)  NOT NULL,
    brand_id     INT            REFERENCES truck_brands(id),
    is_active    BOOLEAN        NOT NULL DEFAULT TRUE
);

-- ============================================
-- DML: 3 marcas y 12 camiones con empates intencionales
-- ============================================
INSERT INTO truck_brands (name) VALUES
('Hino'),
('Kenworth'),
('Freightliner');

INSERT INTO trucks_ranking (plate, capacity_tons, brand_id) VALUES
('SNA-001', 10.50, 1),
('SNA-002', 10.50, 1),  -- empate con SNA-001 (misma capacidad, misma marca)
('SNA-003', 10.50, 1),  -- triple empate para demostrar RANK vs DENSE_RANK
('SNA-004', 18.00, 2),
('SNA-005', 18.00, 2),  -- empate dentro de Kenworth
('SNA-006', 16.50, 2),
('SNA-007', 14.00, 2),
('SNA-008', 15.00, 3),
('SNA-009', 15.00, 3),  -- empate dentro de Freightliner
('SNA-010', 13.50, 3),
('SNA-011', 12.00, 3),
('SNA-012', 11.00, 3);


-- ============================================
-- CONSULTA 1: ROW_NUMBER() — enumerar camiones por marca
-- Asigna un número de fila único dentro de cada marca,
-- ordenados de mayor a menor capacidad.
-- Se usa en deduplicación o para quedarse con el top-1 por grupo.
-- ============================================
WITH camiones_numerados AS (
    SELECT
        t.plate,
        t.capacity_tons,
        b.name           AS brand,
        ROW_NUMBER() OVER (
            PARTITION BY t.brand_id
            ORDER BY t.capacity_tons DESC, t.id
        )                AS row_num
    FROM trucks_ranking t
    INNER JOIN truck_brands b ON b.id = t.brand_id
)
SELECT plate, brand, capacity_tons, row_num
FROM   camiones_numerados
ORDER BY brand, row_num;


-- ============================================
-- CONSULTA 2: RANK vs DENSE_RANK por marca
-- Muestra cómo difieren ante empates:
-- RANK salta números (1, 1, 3) — DENSE_RANK no los salta (1, 1, 2)
-- ============================================
SELECT
    t.plate,
    b.name                                                              AS brand,
    t.capacity_tons,
    RANK()       OVER (PARTITION BY t.brand_id ORDER BY t.capacity_tons DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY t.brand_id ORDER BY t.capacity_tons DESC) AS dense_rnk
FROM trucks_ranking t
INNER JOIN truck_brands b ON b.id = t.brand_id
ORDER BY brand, dense_rnk;


-- ============================================
-- CONSULTA 3: Top-2 camiones por marca con CTE
-- Obtiene los 2 camiones de mayor capacidad por marca.
-- Se usa DENSE_RANK para no excluir camiones empatados en posición 2.
-- ============================================
WITH ranking_por_marca AS (
    SELECT
        t.plate,
        b.name           AS brand,
        t.capacity_tons,
        DENSE_RANK() OVER (
            PARTITION BY t.brand_id
            ORDER BY t.capacity_tons DESC
        )                AS dense_rnk
    FROM trucks_ranking t
    INNER JOIN truck_brands b ON b.id = t.brand_id
)
SELECT plate, brand, capacity_tons, dense_rnk
FROM   ranking_por_marca
WHERE  dense_rnk <= 2
ORDER BY brand, dense_rnk;
