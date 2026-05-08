-- ============================================
-- PROYECTO SEMANAL: Funciones de Agregación
-- Semana 06 — COUNT, SUM, AVG, GROUP BY, HAVING
-- ============================================

-- NOTA: Usa el esquema de tu Semana 03. Adapta nombres al dominio.

-- ============================================
-- REPORTE 1: Totales globales
-- ============================================
-- TODO: Cuenta todos los registros y calcula suma/promedio
--       de la columna numérica más relevante de tu dominio

--Estas sentencias, cuenta el total de recoleccion, la suma total de toneladas y el peso promedio de recoleccion para todas las recolecciones registrada
SELECT 
    COUNT(*) AS total_collections_made, --cambio de nombre de la columna para que sea mas descriptiva
    SUM(collection_actual_weight_tons) AS total_tons_collected, --lo mismo aqui
    AVG(collection_actual_weight_tons) AS average_weight --aqui igual
FROM collections; --todo de la tabla collections


-- ============================================
-- REPORTE 2: Extremos
-- ============================================
-- TODO: Obtén el valor mínimo y máximo de la columna numérica

--Estas sentencias, muestran el peso minimo y maximo recolectado por cada camion, agrupando por el id del camion.
--NOTA: En algunos camiones, el peso minimo y maximo puede ser el mismo, si tuvieron solo una recoleccion o si el peso fue constante.
SELECT truck_id,
MIN(collection_actual_weight_tons) AS min_collected_weight, --cambie el nombre de la columna para que sea mas descriptiva
MAX(collection_actual_weight_tons) AS max_collected_weight  --lo mismo aqui
FROM collections
GROUP BY truck_id; --aqui esta la agrupacion por cada camion


-- ============================================
-- REPORTE 3: Subtotales por categoría (GROUP BY)
-- ============================================
-- TODO: Agrupa por la columna de categoría/tipo principal de tu dominio
--       y calcula COUNT + AVG o SUM para cada grupo

-- Estas sentencias, cuentan cuantas recoleccions ha hecho cada camion, suman el peso total recolectado y calculan el peso promedio por recoleccion para cada camion.

SELECT truck_id,
COUNT(*) AS truck_total_collections, -- le cambie el nombre a la columna para que sea mas descriptiva
SUM(collection_actual_weight_tons) AS total_collected_weight, -- aca tambien
AVG(collection_actual_weight_tons) AS average_collected_weight -- igual aqui
FROM collections -- todo proveniente de la tabla collections
GROUP BY truck_id -- aqui agrupe los registros de cada camion por su id, para obtener los totales por camion.
ORDER BY total_collected_weight DESC; -- lo ordena de mayor a menor peso total recolectado por cada camion



-- ============================================
-- REPORTE 4: Filtro de grupos (HAVING)
-- ============================================
-- TODO: Muestra solo los grupos que superen un umbral de negocio
-- Estas sentencias, muestra el total de toneladas recolectadas, el promedio del peso por recoleccion, pero de los camiones que hayan realizado mas de 1 recoleccion.

SELECT truck_id,
COUNT(*) AS truck_total_collections, -- le cambie el nombre a la columna para que sea mas descriptiva
SUM(collection_actual_weight_tons) AS total_collected_weight, -- aca tambien
AVG(collection_actual_weight_tons) AS average_collected_weight -- igual aqui
FROM collections -- todo proveniente de la tabla collections
GROUP BY truck_id -- aqui agrupe los registros de cada camion por su id, para obtener los totales por camion.
HAVING COUNT(*) > 1
ORDER BY total_collected_weight DESC; -- los ordena de mayor a menor por el peso total recolectado.
