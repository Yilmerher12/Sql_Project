# Semana 12 — CTEs y CASE WHEN

## Tema de la semana

Esta semana se combinaron dos herramientas de SQL avanzado:

- **CTE (Common Table Expression):** Una consulta nombrada y temporal que se define antes de la consulta principal con `WITH`.
- **CASE WHEN:** Una expresión condicional que clasifica valores dentro de una consulta, similar a un `if/else`.

---

## Concepto: CTE (Common Table Expression)

Un CTE se declara con `WITH nombre AS (...)` y se puede usar como si fuera una tabla dentro de la consulta principal que le sigue. No se guarda en disco, existe solo durante esa ejecución.

**¿Para qué sirve?**
- Dividir consultas complejas en partes más legibles
- Reutilizar un resultado parcial varias veces sin repetir código
- Encadenar múltiples pasos de transformación

**Estructura básica:**

```sql
WITH nombre_cte AS (
    SELECT ...
    FROM ...
)
SELECT ...
FROM nombre_cte;
```

**Dos CTEs encadenados:**

```sql
WITH primer_cte AS (
    SELECT ...
),
segundo_cte AS (
    SELECT ...
    FROM primer_cte
    WHERE ...
)
SELECT * FROM segundo_cte;
```

---

## Concepto: CASE WHEN

Permite clasificar o transformar valores fila por fila dentro de una consulta.

```sql
CASE
    WHEN capacity_tons >= 1000 THEN 'Gran Escala'
    WHEN capacity_tons >=  300 THEN 'Mediana Escala'
    ELSE                            'Pequeña Escala'
END AS escala_operativa
```

PostgreSQL evalúa las condiciones **en orden** y usa el primer `WHEN` que se cumpla. El `ELSE` actúa como caso por defecto.

**COUNT condicional con CASE WHEN:**

Una técnica útil es contar solo los registros que cumplen una condición usando `CASE` dentro de `COUNT`:

```sql
COUNT(CASE WHEN escala_operativa = 'Gran Escala' THEN 1 END) AS gran_escala
```

Si la condición no se cumple, `CASE` devuelve `NULL` y `COUNT` ignora los `NULL` — por eso solo cuenta los que sí cumplen.

---

## Consultas del archivo

| Consulta | Descripción |
|---|---|
| 1 | CTE simple: cuenta recolecciones por instalación y clasifica por escala con `CASE WHEN` |
| 2 | Dos CTEs encadenados: el primero agrupa toneladas por tipo, el segundo filtra los tipos por encima del promedio |
| 3 | CTE + COUNT condicional: por tipo, cuenta cuántas instalaciones hay en cada banda de escala |

---

## Tablas creadas esta semana

**`facilities`** — Instalaciones de gestión de residuos (versión semana 12).

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
