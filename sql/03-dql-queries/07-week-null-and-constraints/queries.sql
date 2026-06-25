-- ============================================
-- PROYECTO SEMANAL: NULL y Constraints
-- Semana 07 — NOT NULL, UNIQUE, CHECK, FK
-- Dominio: Waste Management (Gestión de Residuos)
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PARTE 1: ESQUEMA CON CONSTRAINTS
-- ============================================

-- Tabla de categorías del dominio: Localidades
-- Se crea aquí porque es una evolución sobre la estructura inicial.
-- La tabla neighborhoods original tenía locality como texto plano;
-- esta semana se formaliza en su propia entidad con PK, NOT NULL y UNIQUE.
CREATE TABLE localities (
    locality_id   SERIAL PRIMARY KEY,
    locality_name VARCHAR(100) NOT NULL UNIQUE
);

-- ============================================
-- PARTE 2: DATOS DE PRUEBA
-- ============================================

-- Todas las localidades del dominio (14 registros)
INSERT INTO localities (locality_name) VALUES
('Chapinero'),
('Usaquén'),
('Fontibón'),
('Kennedy'),
('Suba'),
('Teusaquillo'),
('Engativá'),
('Bosa'),
('Tunjuelito'),
('Antonio Nariño'),
('Los Mártires'),
('Ciudad Bolívar'),
('Barrios Unidos'),
('Santa Fe');

-- Inserción en collections: 6 registros, 2 con valores NULL
-- Se usa la tabla collections porque ya tiene columnas opcionales (peso y observaciones),
-- lo que permite demostrar el comportamiento de NULL en datos reales del dominio.
INSERT INTO collections (truck_id, route_id, collection_date, collection_actual_weight_tons, collection_observations) VALUES
(1, 1, '2026-05-08', 12.50, 'Ruta sin novedades'),
(2, 2, '2026-05-08', 10.80, 'Tráfico pesado en la 80'),
(3, 3, '2026-05-08', 15.20, 'Normal'),
(4, 4, '2026-05-08',  9.40, 'Normal'),
(5, 5, '2026-05-08', 11.20,  NULL),  -- observaciones sin registrar
(6, 6, '2026-05-08',  NULL,  NULL);  -- camión aún no llegó a báscula

-- ============================================
-- PARTE 3: CONSULTAS CON NULL
-- ============================================

-- Recolecciones sin observaciones registradas (IS NULL)
SELECT collection_id, collection_date
FROM   collections
WHERE  collection_observations IS NULL;

-- Reporte con COALESCE: reemplaza NULL por valores legibles
SELECT
    collection_id,
    COALESCE(collection_actual_weight_tons, 0.00)          AS weight_display,
    COALESCE(collection_observations, 'Sin novedades registradas') AS notes
FROM collections;
