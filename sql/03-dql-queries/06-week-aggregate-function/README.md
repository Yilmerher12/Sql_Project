# Semana 06: Funciones de Agregación y Agrupamiento

En SQL, las **Funciones de Agregación** son herramientas que procesan un conjunto de datos (múltiples registros) para devolver un único valor resultante que resume dicha información. Son fundamentales para la generación de reportes y análisis métricos.

---

## 1. Conceptos Fundamentales
A diferencia de las consultas estándar que proyectan datos fila por fila, las funciones de agregación realizan cálculos matemáticos internos sobre una columna específica. El resultado de estas funciones es una "columna virtual" que suele nombrarse mediante el uso de un **Alias (`AS`)**.

---

## 2. Catálogo de Funciones de Agregación

### A. COUNT()
Se utiliza para contar la existencia de registros o valores dentro de una columna.

| Forma | Acción Técnica |
| :--- | :--- |
| **`COUNT(*)`** | Cuenta todas las filas del conjunto de resultados, incluyendo valores nulos. |
| **`COUNT(columna)`** | Cuenta los registros que poseen un valor real (ignora los `NULL`). |
| **`COUNT(DISTINCT columna)`** | Cuenta únicamente los valores diferentes o únicos, descartando duplicados. |

* **Sintaxis:** `SELECT COUNT(*) AS total FROM tabla;`

```SQL
SELECT COUNT(nombre_columna/ *) FROM nombre_tabla;
```
```SQL
SELECT departamento_id, COUNT(*) 
FROM empleados 
GROUP BY departamento_id;

```

### B. SUM()
Acumula el contenido numérico de una columna. Requiere estrictamente tipos de datos numéricos (INT, DECIMAL, FLOAT).

* **Variaciones:**
    * `SUM(columna)`: Suma todos los valores (ignora nulos).
    * `SUM(DISTINCT columna)`: Suma solo valores únicos.
    * `SUM(col_a + col_b)`: Permite realizar operaciones aritméticas entre columnas antes de realizar la suma total.
* **Sintaxis:** `SELECT SUM(monto) AS total_acumulado FROM ventas;`

```SQL
SELECT SUM(nombre_columna) AS nombre_deseado FROM nombre_tabla;
```
<small>*Aunque tambien*</small>

```SQL
SELECT SUM(cantidad * precio) AS total_venta FROM pedidos; -- suma de una multiplicacion usando dos columnas
```

### C. MIN() & MAX()
Funciones encargadas de identificar los límites (extremos) de un conjunto de datos.

* **Alcance:** Aceptan cualquier tipo de dato (Numérico, Fechas, Texto).
* **Comportamiento:** Ignoran los valores `NULL`.
    * En fechas: `MIN` es la más antigua, `MAX` la más reciente.
    * En texto: `MIN` es el primer valor alfabético, `MAX` el último.
* **Sintaxis:** `SELECT MIN(precio), MAX(precio) FROM productos;`

```SQL
SELECT 
    MIN(precio) AS precio_minimo, 
    MAX(precio) AS precio_maximo 
FROM productos_tecnologia;
```

### D. AVG()
Calcula la media aritmética (Promedio). Realiza internamente la suma de los valores y la división por el conteo de los mismos.

* **Importante:** Solo toma en cuenta registros con valores no nulos para la división final. Si un registro es `NULL`, no suma ni divide.
* **Sintaxis:** `SELECT AVG(calificacion) AS promedio FROM evaluaciones;`

```SQL
SELECT AVG(nota_examen) AS promedio_clase FROM estudiantes; -- el promedio de todos los registros (que no sean 'NULL') de la tabla nota_examen
```

---

## 3. Cláusulas de Organización y Filtrado

### GROUP BY (Agrupamiento)
Palabra clave utilizada para organizar los resultados en contenedores lógicos basados en valores idénticos de una o más columnas.
* **Efecto:** "Colapsa" múltiples filas en una sola fila resumen por cada categoría encontrada.
* **Manejo de NULLs:** Considera al `NULL` como una categoría válida y crea un grupo específico para ella.

```SQL

SELECT tipo, COUNT(id), SUM(capacidad)
FROM vehiculos
GROUP BY tipo; --agrupa los registros de la columna 'tipo'
```

### HAVING (Validación de Agregados)
Funciona como un validador o filtro de exclusión, pero actúa exclusivamente sobre los resultados de las funciones de agregación.
* **Diferencia Crítica:** A diferencia del `WHERE`, `HAVING` puede evaluar condiciones como `SUM(monto) > 500`.

```SQL
SELECT ciudad_destino, AVG(precio_tiquete)
FROM vuelos
WHERE estado_vuelo = 'confirmado'           -- PASO 1: Filtra filas individuales.
GROUP BY ciudad_destino                    -- PASO 2: Agrupa por ciudad.
HAVING AVG(precio_tiquete) > 500;          -- PASO 3: Filtra el cálculo del promedio.
```

---

## 4. Matriz de Comportamiento Técnico

| Función | ¿Ignora NULL? | Tipo de Dato | ¿Permite `*`? |
| :--- | :--- | :--- | :--- |
| **COUNT** | Solo en `COUNT(col)` | Todos | **Sí** |
| **SUM** | Sí | Numérico | No |
| **MIN/MAX** | Sí | Todos | No |
| **AVG** | Sí | Numérico | No |
| **GROUP BY** | **No** (Crea grupo) | Todos | N/A |

## Recursos Adicionales

- Ejemplos de consultas con base al dominio de `recoleccion de residuos`: [Consultas](/sql/03-dql-queries/06-week-aggregate-function/queries.sql)