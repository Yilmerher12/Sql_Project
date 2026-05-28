-- ============================================
-- PROYECTO SEMANAL: SELF JOIN en Gestión de Residuos
-- Semana 10 — CROSS JOIN y SELF JOIN
-- ============================================

-- NOTA: Dominio seleccionado: Waste Management (Gestión de Residuos)
-- Tabla jerárquica: waste_categories (Categorías de residuos: Padre -> Hijo -> Nieto)
-- Motor: MySQL

-- Nos conectamos a la base de datos principal
USE waste_management;

-- ============================================
-- 1. DDL: Creación de la tabla auto-referencial
-- ============================================
DROP TABLE IF EXISTS waste_categories;

CREATE TABLE waste_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    category_risk VARCHAR(50) NOT NULL DEFAULT 'Bajo',
    parent_category_id INT NULL,
    CONSTRAINT FK_waste_categories_parent 
        FOREIGN KEY (parent_category_id) 
        REFERENCES waste_categories(category_id) 
        ON DELETE SET NULL
);
-- ============================================
-- 2. DML: Insertar datos jerárquicos
--    - 2 registros raíz (parent_id = NULL)
--    - 4 registros hijos del nivel 1
--    - 3 registros del nivel 2 (nietos)
-- ============================================

-- Nivel 0: Raíces (No tienen padre, su parent_category_id es NULL)
INSERT INTO waste_categories (category_id, category_name, parent_category_id) VALUES 
(1, 'Material Reciclable', NULL),
(2, 'Material Peligroso', NULL);

-- Nivel 1: Hijos (Su padre es el 1 o el 2)
INSERT INTO waste_categories (category_id, category_name, parent_category_id) VALUES 
(3, 'Plásticos', 1),
(4, 'Papel y Cartón', 1),
(5, 'Desechos Biológicos', 2),
(6, 'Químicos Industriales', 2);

-- Nivel 2: Nietos (Su padre es el 3 o el 4)
INSERT INTO waste_categories (category_id, category_name, parent_category_id) VALUES 
(7, 'Botellas PET', 3),
(8, 'Envases de PVC', 3),
(9, 'Cajas de Embalaje', 4);


-- ============================================
-- CONSULTA 1: SELF JOIN básico (INNER JOIN)
-- Mostrar subcategoría y su categoría padre
-- Excluye registros raíz porque no tienen padre
-- ============================================

SELECT 
     child.category_name  AS subcategoria,
     parent.category_name AS categoria_padre
FROM waste_categories child
INNER JOIN waste_categories parent ON child.parent_category_id = parent.category_id;


-- ============================================
-- CONSULTA 2: Incluir la raíz con LEFT JOIN
-- Usa COALESCE para etiquetar la raíz principal
-- ============================================

SELECT 
     child.category_name                               AS categoria,
     COALESCE(parent.category_name, 'Categoría Raíz')  AS pertenece_a
FROM waste_categories child
LEFT JOIN waste_categories parent ON child.parent_category_id = parent.category_id
ORDER BY pertenece_a, categoria;


-- ============================================
-- CONSULTA 3: Contar hijos por padre
-- Cuántas subcategorías directas tiene cada categoría principal
-- ============================================

SELECT 
     parent.category_name         AS categoria_principal,
     COUNT(child.category_id)     AS total_subcategorias
FROM waste_categories parent
LEFT JOIN waste_categories child ON child.parent_category_id = parent.category_id
GROUP BY parent.category_id, parent.category_name
HAVING COUNT(child.category_id) > 0
ORDER BY total_subcategorias DESC;


-- ============================================
-- CONSULTA 4: Dos niveles jerárquicos
-- Ruta de clasificación: Nieto → Hijo → Padre (Raíz)
-- Usa tres aliases: child, parent, grandparent
-- ============================================

SELECT 
     child.category_name       AS residuo_especifico,
     parent.category_name      AS subcategoria,
     grandparent.category_name AS categoria_general
FROM waste_categories child
LEFT JOIN waste_categories parent      ON child.parent_category_id  = parent.category_id
LEFT JOIN waste_categories grandparent ON parent.parent_category_id = grandparent.category_id
-- Filtramos para mostrar solo los que realmente llegaron al nivel de "nieto"
WHERE grandparent.category_name IS NOT NULL 
ORDER BY categoria_general, subcategoria, residuo_especifico;