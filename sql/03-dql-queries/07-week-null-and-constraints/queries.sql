-- ============================================
-- PROYECTO SEMANAL: NULL y Constraints
-- Semana 07 — NOT NULL, UNIQUE, CHECK, FK
-- ============================================


-- ============================================
-- PARTE 1: ESQUEMA CON CONSTRAINTS
-- ============================================

-- TODO: Crear la tabla de categorías/grupos de tu dominio
--       Incluir: PK, NOT NULL, UNIQUE donde aplique

--cree o separe el dato localidad de la tabla de barrios, para poder una tabla de localidades relacionadas con estas por medio de su PK
CREATE TABLE localities (
    locality_id INT AUTO_INCREMENT PRIMARY KEY,
    locality_name VARCHAR(100) NOT NULL UNIQUE -- El UNIQUE evita que se repite la localidad en la tabla y si o si debe tener un nombre, no puede ser NULL
);

-- TODO: Crear la tabla principal con todos los constraints
--       Incluir: PK, FK, NOT NULL, UNIQUE, CHECK, DEFAULT

-- modifique la tabla de barrios, la relacion con la tabla localidades de 1:N
-- aqui en el dato de neighborhood_estimated_houses (casas estimadas por barrio) tiene un valor por default y un check para validar que se agregue un valor positivo y mayor a 0
CREATE TABLE neighborhoods (
    neighborhood_id INT AUTO_INCREMENT PRIMARY KEY,
    neighborhood_name VARCHAR(100) NOT NULL,
    neighborhood_estimated_houses INT DEFAULT 0 CHECK (neighborhood_estimated_houses >= 0),
    locality_id INT NOT NULL, -- relacion usando la FK de la tabla localidades, no puede ser NULL
    FOREIGN KEY (locality_id) REFERENCES localities(locality_id) ON DELETE RESTRICT
);


-- ============================================
-- PARTE 2: DATOS DE PRUEBA
-- ============================================

-- TODO: Insertar 3 categorías
-- aqui se insertan 3 localidades, con un valor evitando que sea nulo.
-- este solo es de ejemplo, ya que el codigo completo con todos los registros incluyendo estas categorias se encuentra en la carpeta 02-dml/data.sql
INSERT INTO localities (locality_name) VALUES 
('Chapinero'), ('Suba'), ('Kennedy');

-- TODO: Insertar 6 items, al menos 2 con columna_opcional = NULL
-- aqui agregamos todo los datos de la tablla collection (recolecciones)
-- en el ultimos dos registros de agregan valores NULL, para demostrar el uso de este tipo de datos
INSERT INTO collections (truck_id, route_id, collection_date, collection_actual_weight_tons, collection_observations) VALUES
(1, 1, '2026-05-08', 12.50, 'Ruta sin novedades'),
(2, 2, '2026-05-08', 10.80, 'Tráfico pesado en la 80'),
(3, 3, '2026-05-08', 15.20, 'Normal'),
(4, 4, '2026-05-08', 9.40, 'Normal'),
(5, 5, '2026-05-08', 11.20, NULL), -- dato nulo en la columna de observaciones
(6, 6, '2026-05-08', NULL, NULL); -- dato nulo en la columna de observaciones y en la columna de peso


-- ============================================
-- PARTE 3: CONSULTAS CON NULL
-- ============================================

-- TODO: Mostrar items donde columna_opcional IS NULL
-- aca consultados el registro anterior con el dato nulo en la columna de observaciones, usando IS NULL
SELECT collection_id, collection_date
FROM collections
WHERE collection_observations IS NULL;

-- TODO: Mostrar todos los items usando COALESCE para reemplazar NULL
-- aqui al usar ese ultimo registro con datos nulos en la columna observaciones y peso
-- usamos COALESCE para mostrar un valor numero 0.00 en el peso y un mensaje en las observaciones, evitando los valores NULL y mostrando info mas util
SELECT 
    collection_id,
    COALESCE(collection_actual_weight_tons, 0.00) AS weight_display, -- modica el nombre de la columna para mejor descripcion
    COALESCE(collection_observations, 'Sin novedades registradas') AS notes -- modica el nombre de la columna para mejor descripcion
FROM collections;