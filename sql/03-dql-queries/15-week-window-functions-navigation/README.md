# Semana 15 — Window Functions: Navegación y Vistas

En esta semana aprendí las funciones de ventana de **navegación**, que me permiten acceder al valor de otra fila dentro de la misma partición sin necesidad de hacer un self-join. También aprendí a crear **vistas** para guardar consultas reutilizables en la base de datos.

---

## 1. LAG y LEAD

Aprendí que `LAG` y `LEAD` son funciones que me permiten ver el valor de una fila anterior o siguiente, respectivamente, dentro del orden que defino:

```sql
LAG(tons_received)  OVER (PARTITION BY type_id ORDER BY period_date)  -- mira hacia atrás
LEAD(tons_received) OVER (PARTITION BY type_id ORDER BY period_date)  -- mira hacia adelante
```

- La **primera fila** de cada partición no tiene anterior → devuelve `NULL`
- La **última fila** no tiene siguiente → devuelve `NULL`

Entendí que el uso más útil de `LAG` es calcular variaciones entre períodos:

```sql
tons_received - LAG(tons_received) OVER (PARTITION BY type_id ORDER BY period_date) AS delta
```

Esto me da la diferencia respecto al mes anterior fila por fila, sin necesidad de hacer un JOIN de la tabla consigo misma.

---

## 2. FIRST_VALUE y LAST_VALUE

Aprendí que estas funciones devuelven el primer o último valor dentro de la ventana definida por `ORDER BY`. Lo que me costó entender fue el comportamiento de `LAST_VALUE`:

Por defecto, el frame de una window function va desde el inicio de la partición hasta **la fila actual**, no hasta el final. Eso hace que `LAST_VALUE` devuelva el valor de la fila actual en lugar del último real.

Para solucionarlo, aprendí a extender el frame explícitamente:

```sql
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
```

Eso le dice a PostgreSQL que el frame va de la primera hasta la última fila de la partición completa.

---

## 3. WINDOW alias

Aprendí que cuando uso la misma definición de ventana en varias funciones, puedo nombrarla una sola vez y reutilizarla con `WINDOW`:

```sql
SELECT
    FIRST_VALUE(tons_received) OVER w AS mejor_mes,
    LAST_VALUE(tons_received)  OVER w AS peor_mes
FROM monthly_tons
WINDOW w AS (
    PARTITION BY type_id
    ORDER BY tons_received DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
);
```

Esto evita repetir la misma cláusula `OVER(...)` y hace el código mucho más limpio.

---

## 4. CREATE VIEW

Aprendí que una vista es una **consulta guardada en la base de datos** a la que puedo darle un nombre y usarla como si fuera una tabla. No almacena datos propios, solo la definición de la consulta.

```sql
CREATE OR REPLACE VIEW v_period_analysis AS
SELECT ... FROM monthly_tons ...;

-- Luego la uso como si fuera una tabla:
SELECT * FROM v_period_analysis WHERE type_id = 1;
```

Entendí que la ventaja principal es encapsular lógica compleja (como window functions con frames) en un nombre simple, para no tener que repetirla cada vez que necesito ese análisis.

---

## 5. Consultas del archivo

| Consulta | Función | Descripción |
|---|---|---|
| 1 | `LAG` | Toneladas del mes actual vs mes anterior, con delta calculado por tipo |
| 2 | `FIRST_VALUE` + `LAST_VALUE` | Mejor y peor mes histórico por tipo de instalación |
| 3 | `CREATE VIEW` | Vista `v_period_analysis` que combina LAG, FIRST y LAST, luego consultada con filtro |

---

## Tablas creadas esta semana

**`facility_types`** — Tipos de instalación de residuos.

| Columna | Tipo | Descripción |
|---|---|---|
| `id` | SERIAL PK | Identificador único |
| `name` | TEXT | Nombre del tipo (Reciclaje, Disposición Final) |

**`monthly_tons`** — Toneladas mensuales recibidas por tipo de instalación.

| Columna | Tipo | Descripción |
|---|---|---|
| `id` | SERIAL PK | Identificador único |
| `period_date` | DATE | Primer día del mes del período |
| `type_id` | INT FK | Referencia a `facility_types` |
| `tons_received` | NUMERIC | Total de toneladas recibidas ese mes |

**`v_period_analysis`** — Vista que encapsula el análisis temporal completo creada esta semana.

---

## Recursos Adicionales

- Consultas aplicadas al dominio de residuos: [Ver queries](/sql/03-dql-queries/15-week-window-functions-navigation/queries.sql)
