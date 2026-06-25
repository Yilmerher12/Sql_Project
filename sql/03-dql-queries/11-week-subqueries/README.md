# Semana 11 — Subqueries (Subconsultas)

## Tema de la semana

Una **subconsulta** (subquery) es una consulta SQL escrita dentro de otra consulta. El motor ejecuta primero la consulta interna y usa su resultado en la consulta externa.

Esta semana se trabajaron cuatro formas distintas de usar subconsultas, cada una con un propósito diferente.

---

## Tipos de subconsultas

### 1. Subconsulta escalar en WHERE

Devuelve **un solo valor** y se usa para comparar fila por fila.

```sql
WHERE capacity_tons > (
    SELECT AVG(capacity_tons)
    FROM waste_facilities
    WHERE facility_type = wf.facility_type
)
```

La subconsulta se evalúa **por cada fila** de la consulta externa. Aquí calcula el promedio del tipo de instalación al que pertenece esa fila y compara.

---

### 2. Subconsulta escalar en SELECT

Devuelve **un solo valor global** que aparece como columna en cada fila del resultado.

```sql
SELECT
    facility_name,
    ROUND((SELECT AVG(capacity_tons) FROM waste_facilities), 2) AS promedio_global
FROM waste_facilities;
```

Útil para mostrar un dato estadístico de referencia junto a cada registro.

---

### 3. NOT EXISTS — registros sin actividad

`EXISTS` evalúa si la subconsulta devuelve **al menos una fila** (retorna `TRUE` o `FALSE`). Con `NOT EXISTS` se detectan registros que no tienen ninguna fila relacionada en otra tabla (huérfanos).

```sql
WHERE NOT EXISTS (
    SELECT 1
    FROM facility_inspections fi
    WHERE fi.facility_id = wf.facility_id
)
```

Se usa `SELECT 1` porque el valor no importa, solo importa si existe o no la fila.

---

### 4. Tabla derivada en FROM

La subconsulta se escribe **dentro del FROM** y actúa como una tabla temporal en memoria. Es obligatorio ponerle un alias.

```sql
FROM (
    SELECT facility_type, COUNT(inspection_id) AS total
    FROM waste_facilities wf
    LEFT JOIN facility_inspections fi ON fi.facility_id = wf.facility_id
    GROUP BY facility_type
) AS stats
WHERE stats.total > 2
```

Permite aplicar filtros (`WHERE`) sobre resultados agregados, algo que no se puede hacer directamente con `HAVING` en todos los casos.

---

## Consultas del archivo

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
