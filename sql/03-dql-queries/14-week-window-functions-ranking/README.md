# Semana 14 — Window Functions: Ranking

En esta semana aprendí que las **funciones de ventana** son una forma de hacer cálculos sobre filas relacionadas sin que el resultado colapse en una sola fila como lo hace `GROUP BY`. Entendí que esa es la diferencia clave: sigues viendo cada fila individual, pero con información calculada sobre el grupo al que pertenece.

---

## 1. La cláusula OVER()

Aprendí que todo window function necesita la cláusula `OVER()` que define la "ventana" sobre la que opera. Dentro de `OVER()` hay dos partes importantes:

```sql
RANK() OVER (
    PARTITION BY brand_id   -- divide en grupos independientes (como GROUP BY pero sin colapsar)
    ORDER BY capacity_tons DESC  -- define el orden dentro de cada grupo
)
```

- **`PARTITION BY`** — divide las filas en particiones. Cada partición se procesa por separado. Si lo omito, toda la tabla es una sola partición.
- **`ORDER BY`** — define el criterio de ordenamiento dentro de cada partición, que determina el ranking.

---

## 2. ROW_NUMBER, RANK y DENSE_RANK

Aprendí que las tres asignan un número a cada fila, pero difieren cuando hay **empates** (filas con el mismo valor):

| Función | Comportamiento ante empates | Ejemplo (3 empates en posición 1) |
|---|---|---|
| `ROW_NUMBER()` | Siempre único, rompe empates arbitrariamente | 1, 2, 3, 4 |
| `RANK()` | Repite el número y salta los siguientes | 1, 1, 1, 4 |
| `DENSE_RANK()` | Repite el número pero NO salta los siguientes | 1, 1, 1, 2 |

Entendí esto claramente con los camiones Hino, que todos tienen 10.5 tons de capacidad:

```
RANK()       → 1, 1, 1, 4   (salta al 4 porque 3 filas ocupan la posición 1)
DENSE_RANK() → 1, 1, 1, 2   (no salta, el siguiente valor distinto es posición 2)
ROW_NUMBER() → 1, 2, 3, 4   (siempre único, no importa el empate)
```

---

## 3. Top-N por grupo con CTE

Aprendí que no puedo usar `WHERE` directamente sobre un window function porque el motor los evalúa en momentos distintos. La solución es encapsular el window function en una CTE y filtrar afuera:

```sql
WITH ranking AS (
    SELECT
        plate,
        capacity_tons,
        DENSE_RANK() OVER (PARTITION BY brand_id ORDER BY capacity_tons DESC) AS dense_rnk
    FROM trucks_ranking
)
SELECT * FROM ranking WHERE dense_rnk <= 2;
```

Usé `DENSE_RANK` en lugar de `RANK` para no excluir camiones que estén empatados en la segunda posición.

---

## 4. Consultas del archivo

| Consulta | Función | Descripción |
|---|---|---|
| 1 | `ROW_NUMBER()` | Numera cada camión dentro de su marca, ordenado por capacidad |
| 2 | `RANK` vs `DENSE_RANK` | Muestra lado a lado cómo difieren ante los empates de capacidad |
| 3 | `DENSE_RANK` + CTE | Obtiene los 2 camiones de mayor capacidad por marca |

---

## Tablas creadas esta semana

**`truck_brands`** — Marcas de camiones.

| Columna | Tipo | Descripción |
|---|---|---|
| `id` | SERIAL PK | Identificador único |
| `name` | TEXT | Nombre de la marca |

**`trucks_ranking`** — Camiones con su capacidad para el ejercicio de ranking.

| Columna | Tipo | Descripción |
|---|---|---|
| `id` | SERIAL PK | Identificador único |
| `plate` | TEXT UNIQUE | Placa del camión |
| `capacity_tons` | NUMERIC | Capacidad en toneladas |
| `brand_id` | INT FK | Referencia a `truck_brands` |
| `is_active` | BOOLEAN | Estado del camión |

---

## Recursos Adicionales

- Consultas aplicadas al dominio de residuos: [Ver queries](/sql/03-dql-queries/14-week-window-functions-ranking/queries.sql)
