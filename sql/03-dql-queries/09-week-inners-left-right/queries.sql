-- ============================================
-- PROYECTO SEMANAL: JOINs aplicados al dominio
-- Semana 09 — INNER JOIN y LEFT JOIN
-- Dominio: Waste Management (Gestión de Residuos)
-- Motor: PostgreSQL 16
-- Tablas usadas: trucks, routes, collections
-- ============================================

-- ============================================
-- CONSULTA 1: INNER JOIN principal
-- Une camiones con sus recolecciones.
-- Muestra solo los camiones que tienen actividad registrada.
-- ============================================
SELECT
    t.truck_plate                 AS placa_camion,
    t.truck_brand                 AS marca,
    c.collection_date             AS fecha_recoleccion,
    c.collection_actual_weight_tons AS toneladas_recolectadas
FROM trucks t
INNER JOIN collections c ON c.truck_id = t.truck_id
ORDER BY c.collection_date DESC;


-- ============================================
-- CONSULTA 2: JOIN con tres tablas
-- Encadena camiones + recolecciones + rutas.
-- Muestra qué ruta cubrió cada camión en cada operación.
-- ============================================
SELECT
    t.truck_plate  AS placa_camion,
    r.route_name   AS ruta_operada,
    c.collection_date AS fecha
FROM trucks t
INNER JOIN collections c ON c.truck_id  = t.truck_id
INNER JOIN routes      r ON c.route_id  = r.route_id
ORDER BY c.collection_date DESC;


-- ============================================
-- CONSULTA 3: LEFT JOIN — todos los camiones
-- Devuelve toda la flota aunque un camión no tenga
-- ninguna recolección registrada (aparece con NULL).
-- ============================================
SELECT
    t.truck_plate  AS placa,
    t.truck_status AS estado,
    c.collection_date AS ultima_actividad
FROM trucks t
LEFT JOIN collections c ON c.truck_id = t.truck_id
ORDER BY t.truck_plate;


-- ============================================
-- CONSULTA 4: Detectar camiones sin operaciones (huérfanos)
-- Filtra el LEFT JOIN para mostrar solo los que tienen NULL
-- en la tabla hija, es decir, nunca han salido a recolectar.
-- ============================================
SELECT
    t.truck_plate AS camion_sin_operacion,
    t.truck_brand AS marca,
    t.truck_status AS estado
FROM trucks t
LEFT JOIN collections c ON c.truck_id = t.truck_id
WHERE c.collection_id IS NULL;


-- ============================================
-- CONSULTA 5: Reporte agregado con LEFT JOIN + COUNT
-- Total de viajes realizados por cada camión,
-- incluyendo los que tienen 0 operaciones.
-- ============================================
SELECT
    t.truck_plate             AS placa,
    t.truck_brand             AS marca,
    COUNT(c.collection_id)    AS total_viajes_realizados
FROM trucks t
LEFT JOIN collections c ON c.truck_id = t.truck_id
GROUP BY t.truck_id, t.truck_plate, t.truck_brand
ORDER BY total_viajes_realizados DESC;
