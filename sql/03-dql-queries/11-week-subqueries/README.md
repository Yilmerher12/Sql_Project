# Semana 11 — Subqueries (Subconsultas)

En esta semana aprendí que una subconsulta es simplemente una consulta SQL escrita **dentro de otra consulta**. Entendí que el motor ejecuta primero la consulta interna y usa ese resultado en la consulta externa, sin que yo tenga que hacerlo en dos pasos separados.

---

## 1. Subconsulta escalar en WHERE

Aprendí que una subconsulta escalar devuelve **un solo valor** y se puede usar directamente en una comparación. Lo interesante es que se evalúa **por cada fila** de la consulta externa:

```sql
WHERE capacity_tons > (
    SELECT AVG(capacity_tons)
    FROM waste_facilities
    WHERE facility_type = wf.facility_type  -- compara contra el tipo de esa fila específica
)
```

Entendí que aquí el motor calcula el promedio del tipo de instalación de cada fila y lo compara fila por fila. Eso lo hace una subconsulta **correlacionada**.

---

## 2. Subconsulta escalar en SELECT

Aprendí que también puedo poner una subconsulta dentro del `SELECT` para agregar un dato estadístico global como si fuera una columna más:

```sql
SELECT
    facility_name,
    ROUND((SELECT AVG(capacity_tons) FROM waste_facilities), 2) AS promedio_global
FROM waste_facilities;
```

Este promedio es el mismo para todas las filas, pero sirve como punto de comparación en el reporte.

---

## 3. NOT EXISTS — registros sin actividad

Entendí que `EXISTS` evalúa si una subconsulta devuelve al menos una fila, y devuelve `TRUE` o `FALSE`. Con `NOT EXISTS` puedo detectar los registros que no tienen ninguna fila relacionada en otra tabla:

```sql
WHERE NOT EXISTS (
    SELECT 1  -- el valor no importa, solo si existe la fila
    FROM facility_inspections fi
    WHERE fi.facility_id = wf.facility_id
)
```

Aprendí que se usa `SELECT 1` porque el motor no necesita saber qué devuelve la subconsulta, solo si devuelve algo.

---

## 4. Tabla derivada en FROM

Aprendí que puedo escribir una subconsulta dentro del `FROM` y tratarla como si fuera una tabla temporal. Es obligatorio ponerle un alias:

```sql
FROM (
    SELECT facility_type, COUNT(inspection_id) AS total
    FROM waste_facilities wf
    LEFT JOIN facility_inspections fi ON fi.facility_id = wf.facility_id
    GROUP BY facility_type
) AS stats
WHERE stats.total > 2
```

Entendí que esto me permite aplicar un `WHERE` sobre el resultado de una agregación, algo que no se puede hacer directamente sobre un `HAVING` en todos los casos.

---

## 5. Consultas del archivo

| Consulta | Tipo | Descripción |
|---|---|---|
| 1 | Escalar en WHERE | Instalaciones con capacidad mayor al promedio de su tipo |
| 2 | Escalar en SELECT | Promedio global mostrado junto a cada instalación |
| 3 | NOT EXISTS | Instalaciones sin ninguna inspección registrada |
| 4 | Tabla derivada | Tipos de instalación con más de 2 inspecciones en total |

---

## Tablas creadas esta semana

**`waste_facilities`** — Instalaciones de gestión de residuos.

| Columna | Tipo | Descripción |
|---|---|---|
| `facility_id` | SERIAL PK | Identificador único |
| `facility_name` | VARCHAR | Nombre de la instalación |
| `capacity_tons` | DECIMAL | Capacidad máxima en toneladas |
| `facility_type` | VARCHAR | Tipo: Reciclaje, Disposición Final, Compostaje |

**`facility_inspections`** — Inspecciones realizadas a cada instalación.

| Columna | Tipo | Descripción |
|---|---|---|
| `inspection_id` | SERIAL PK | Identificador único |
| `facility_id` | INT FK | Referencia a `waste_facilities` |
| `inspection_date` | DATE | Fecha de la inspección |

---

## Recursos Adicionales

- Consultas aplicadas al dominio de residuos: [Ver queries](/sql/03-dql-queries/11-week-subqueries/queries.sql)
