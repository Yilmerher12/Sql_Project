-- ============================================
-- PROYECTO SEMANAL: CROSS JOIN y SELF JOIN
-- Semana 10 — Jerarquía de categorías de residuos
-- Dominio: Waste Management (Gestión de Residuos)
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- DDL: Tabla auto-referencial de categorías de residuos
-- ============================================
DROP TABLE IF EXISTS waste_categories;

CREATE TABLE waste_categories (
    category_id        SERIAL PRIMARY KEY,
    category_name      VARCHAR(100) NOT NULL UNIQUE,
    category_risk      VARCHAR(50)  NOT NULL DEFAULT 'Bajo',
    parent_category_id INT REFERENCES waste_categories(category_id) ON DELETE SET NULL
);

-- ============================================
-- DML: Datos jerárquicos
-- Nivel 0: Raíces (sin padre)
-- Nivel 1: Hijos (4 subcategorías)
-- Nivel 2: Nietos (3 sub-subcategorías)
-- ============================================

-- Nivel 0: Raíces
INSERT INTO waste_categories (category_id, category_name, parent_category_id) VALUES
(1, 'Material Reciclable', NULL),
(2, 'Material Peligroso',  NULL);

-- Nivel 1: Hijos
INSERT INTO waste_categories (category_id, category_name, parent_category_id) VALUES
(3, 'Plásticos',            1),
(4, 'Papel y Cartón',       1),
(5, 'Desechos Biológicos',  2),
(6, 'Químicos Industriales',2);

-- Nivel 2: Nietos
INSERT INTO waste_categories (category_id, category_name, parent_category_id) VALUES
(7, 'Botellas PET',      3),
(8, 'Envases de PVC',    3),
(9, 'Cajas de Embalaje', 4);

-- ============================================
-- CONSULTA 1: SELF JOIN básico (INNER JOIN)
-- Muestra subcategoría y su categoría padre.
-- Excluye las raíces porque no tienen padre.
-- ============================================
SELECT
    child.category_name  AS subcategoria,
    parent.category_name AS categoria_padre
FROM waste_categories child
INNER JOIN waste_categories parent ON child.parent_category_id = parent.category_id;


-- ============================================
-- CONSULTA 2: SELF JOIN con LEFT JOIN
-- Incluye las raíces usando COALESCE para etiquetarlas.
-- ============================================
SELECT
    child.category_name                              AS categoria,
    COALESCE(parent.category_name, 'Categoría Raíz') AS pertenece_a
FROM waste_categories child
LEFT JOIN waste_categories parent ON child.parent_category_id = parent.category_id
ORDER BY pertenece_a, categoria;


-- ============================================
-- CONSULTA 3: Contar hijos por padre
-- Cuántas subcategorías directas tiene cada categoría.
-- ============================================
SELECT
    parent.category_name       AS categoria_principal,
    COUNT(child.category_id)   AS total_subcategorias
FROM waste_categories parent
LEFT JOIN waste_categories child ON child.parent_category_id = parent.category_id
GROUP BY parent.category_id, parent.category_name
HAVING COUNT(child.category_id) > 0
ORDER BY total_subcategorias DESC;


-- ============================================
-- CONSULTA 4: Dos niveles jerárquicos
-- Recorre la jerarquía: Nieto → Hijo → Padre (Raíz)
-- ============================================
SELECT
    child.category_name       AS residuo_especifico,
    parent.category_name      AS subcategoria,
    grandparent.category_name AS categoria_general
FROM waste_categories child
LEFT JOIN waste_categories parent      ON child.parent_category_id  = parent.category_id
LEFT JOIN waste_categories grandparent ON parent.parent_category_id = grandparent.category_id
WHERE grandparent.category_name IS NOT NULL
ORDER BY categoria_general, subcategoria, residuo_especifico;
