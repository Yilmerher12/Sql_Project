-- ============================================
-- PROYECTO SEMANAL: Análisis temporal con Window Functions y Vistas
-- Semana 15 — LEAD, LAG, FIRST_VALUE, LAST_VALUE, CREATE VIEW
-- Dominio: Waste Management (Gestión de Residuos)
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- DDL: Tipos de instalación (categorías) y métricas mensuales
-- Cada mes se registra el total de toneladas recibidas
-- por tipo de instalación. Esto permite comparar períodos.
-- ============================================
DROP VIEW  IF EXISTS v_period_analysis CASCADE;
DROP TABLE IF EXISTS monthly_tons CASCADE;
DROP TABLE IF EXISTS facility_types CASCADE;

CREATE TABLE facility_types (
    id   SERIAL PRIMARY KEY,
    name TEXT   NOT NULL
);

CREATE TABLE monthly_tons (
    id           SERIAL         PRIMARY KEY,
    period_date  DATE           NOT NULL,
    type_id      INT            REFERENCES facility_types(id),
    tons_received NUMERIC(12,2) NOT NULL
);

-- ============================================
-- DML: 2 tipos de instalación, 5 meses de datos
-- ============================================
INSERT INTO facility_types (name) VALUES
('Reciclaje'),
('Disposición Final');

INSERT INTO monthly_tons (period_date, type_id, tons_received) VALUES
('2026-01-01', 1,  820.50),
('2026-02-01', 1,  950.00),
('2026-03-01', 1,  780.00),
('2026-04-01', 1, 1100.75),
('2026-05-01', 1,  890.00),
('2026-01-01', 2, 4200.00),
('2026-02-01', 2, 3900.50),
('2026-03-01', 2, 4500.00),
('2026-04-01', 2, 4100.25),
('2026-05-01', 2, 4750.00);


-- ============================================
-- CONSULTA 1: LAG — variación mensual por tipo de instalación
-- Compara cada mes con el anterior dentro del mismo tipo.
-- delta > 0 = aumentó, delta < 0 = bajó respecto al mes previo.
-- ============================================
SELECT
    ft.name                                                           AS tipo_instalacion,
    m.period_date                                                     AS mes,
    m.tons_received                                                   AS toneladas,
    LAG(m.tons_received) OVER (
        PARTITION BY m.type_id
        ORDER BY m.period_date
    )                                                                 AS mes_anterior,
    m.tons_received - LAG(m.tons_received) OVER (
        PARTITION BY m.type_id
        ORDER BY m.period_date
    )                                                                 AS delta_toneladas
FROM monthly_tons m
INNER JOIN facility_types ft ON ft.id = m.type_id
ORDER BY tipo_instalacion, mes;


-- ============================================
-- CONSULTA 2: FIRST_VALUE y LAST_VALUE por tipo
-- Para cada fila muestra el mejor y peor mes del tipo.
-- LAST_VALUE requiere extender el frame hasta el final
-- de la partición; sin eso solo llega a la fila actual.
-- ============================================
SELECT
    ft.name          AS tipo_instalacion,
    m.period_date    AS mes,
    m.tons_received  AS toneladas,
    FIRST_VALUE(m.tons_received) OVER w AS mejor_mes,
    LAST_VALUE(m.tons_received)  OVER w AS peor_mes
FROM monthly_tons m
INNER JOIN facility_types ft ON ft.id = m.type_id
WINDOW w AS (
    PARTITION BY m.type_id
    ORDER BY m.tons_received DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY tipo_instalacion, mes;


-- ============================================
-- CONSULTA 3: CREATE VIEW — encapsular el análisis completo
-- La vista combina LAG, FIRST_VALUE y LAST_VALUE en una sola
-- consulta reutilizable, sin repetir la lógica cada vez.
-- ============================================
CREATE OR REPLACE VIEW v_period_analysis AS
SELECT
    ft.name          AS tipo_instalacion,
    m.type_id,
    m.period_date    AS mes,
    m.tons_received  AS toneladas,
    LAG(m.tons_received) OVER (
        PARTITION BY m.type_id ORDER BY m.period_date
    )                AS mes_anterior,
    FIRST_VALUE(m.tons_received) OVER (
        PARTITION BY m.type_id
        ORDER BY m.tons_received DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )                AS mejor_mes,
    LAST_VALUE(m.tons_received) OVER (
        PARTITION BY m.type_id
        ORDER BY m.tons_received DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )                AS peor_mes
FROM monthly_tons m
INNER JOIN facility_types ft ON ft.id = m.type_id;

-- Consultar la vista filtrando por Reciclaje (type_id = 1)
SELECT * FROM v_period_analysis
WHERE type_id = 1
ORDER BY mes;
