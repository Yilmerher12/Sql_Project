# Semana 12 — CTEs y CASE WHEN

En esta semana aprendí dos herramientas que me ayudan a escribir consultas más organizadas y legibles: los **CTEs** para dividir la lógica en pasos, y **CASE WHEN** para clasificar valores con condiciones.

---

## 1. CTE — Common Table Expression

Aprendí que un CTE es una consulta con nombre que se define antes de la consulta principal usando `WITH`. No guarda datos en disco, solo existe durante esa ejecución.

```sql
WITH nombre_cte AS (
    SELECT ...
    FROM ...
)
SELECT * FROM nombre_cte;
```

Entendí que la ventaja no es hacer algo que no se podía hacer antes, sino **organizar** la lógica. En lugar de meter subconsultas anidadas y difíciles de leer, puedo dividir el problema en pasos con nombres que explican qué hace cada parte.

### CTEs encadenados

También aprendí que puedo definir varios CTEs en secuencia, donde el segundo puede usar el resultado del primero:

```sql
WITH primer_paso AS (
    SELECT category, SUM(value) AS total
    FROM items
    GROUP BY category
),
segundo_paso AS (
    SELECT category
    FROM primer_paso
    WHERE total > (SELECT AVG(total) FROM primer_paso)
)
SELECT * FROM segundo_paso;
```

---

## 2. CASE WHEN

Aprendí que `CASE WHEN` es como un `if/else` dentro de SQL. Me permite clasificar o transformar valores fila por fila:

```sql
CASE
    WHEN capacity_tons >= 1000 THEN 'Gran Escala'
    WHEN capacity_tons >=  300 THEN 'Mediana Escala'
    ELSE                            'Pequeña Escala'
END AS escala_operativa
```

Entendí que PostgreSQL evalúa las condiciones **en orden** y usa el primer `WHEN` que se cumpla. El `ELSE` es el caso por defecto si ninguna condición se cumple.

### COUNT condicional con CASE WHEN

Una técnica que me pareció muy útil es contar solo los registros que cumplen una condición dentro de un `COUNT`:

```sql
COUNT(CASE WHEN escala_operativa = 'Gran Escala' THEN 1 END) AS gran_escala
```

Aprendí que cuando la condición no se cumple, `CASE` devuelve `NULL`, y `COUNT` ignora los `NULL` — entonces solo cuenta los que sí cumplen.

---

## 3. Consultas del archivo

| Consulta | Descripción |
|---|---|
| 1 | CTE simple que cuenta recolecciones por instalación y la clasifica por escala con `CASE WHEN` |
| 2 | Dos CTEs encadenados: el primero agrupa toneladas por tipo, el segundo filtra los que están por encima del promedio |
| 3 | CTE + COUNT condicional: por tipo, cuenta cuántas instalaciones hay en cada banda de escala |

---

## Tablas creadas esta semana

**`facilities`** — Instalaciones de gestión de residuos.

| Columna | Tipo | Descripción |
|---|---|---|
| `facility_id` | SERIAL PK | Identificador único |
| `facility_name` | VARCHAR | Nombre de la instalación |
| `capacity_tons` | DECIMAL | Capacidad máxima en toneladas |
| `facility_type` | VARCHAR | Tipo de instalación |

**`facility_collections`** — Recolecciones recibidas por cada instalación.

| Columna | Tipo | Descripción |
|---|---|---|
| `collection_id` | SERIAL PK | Identificador único |
| `facility_id` | INT FK | Referencia a `facilities` |
| `tons_received` | DECIMAL | Toneladas recibidas en esa recolección |
| `collected_at` | DATE | Fecha de la recolección |

---

## Recursos Adicionales

- Consultas aplicadas al dominio de residuos: [Ver queries](/sql/03-dql-queries/12-week-ctes-case-when/queries.sql)
