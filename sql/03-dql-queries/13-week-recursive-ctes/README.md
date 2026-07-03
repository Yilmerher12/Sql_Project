# Semana 13 — CTEs Recursivas (WITH RECURSIVE)

En esta semana aprendí a recorrer estructuras jerárquicas usando CTEs recursivas. Entendí que es la herramienta estándar de SQL para navegar datos con relaciones padre-hijo cuando no sé de antemano cuántos niveles existen.

---

## 1. ¿Qué es una CTE recursiva?

Aprendí que una CTE recursiva es una CTE que **se llama a sí misma** para seguir bajando niveles en una jerarquía. Siempre tiene dos partes unidas por `UNION ALL`:

```sql
WITH RECURSIVE nombre AS (
    -- CASO BASE: el punto de partida (los nodos raíz)
    SELECT id, name, parent_id, 1 AS depth
    FROM tabla
    WHERE parent_id IS NULL

    UNION ALL

    -- CASO RECURSIVO: une cada nodo con su padre ya procesado
    SELECT t.id, t.name, t.parent_id, r.depth + 1
    FROM tabla t
    INNER JOIN nombre r ON t.parent_id = r.id
)
SELECT * FROM nombre;
```

Entendí que el motor repite el caso recursivo usando los resultados de la vuelta anterior, hasta que la JOIN no encuentra más filas nuevas. En ese punto se detiene.

---

## 2. Calcular depth y path

Aprendí dos cosas útiles que se pueden calcular durante la recursión:

**`depth`** — el nivel de profundidad. En el caso base arranca en `1`, y en el caso recursivo se incrementa con `a.depth + 1`.

**`path`** — la ruta completa desde la raíz. En el caso base es el nombre del nodo, y en el caso recursivo se concatena con `||`:

```sql
a.path || ' > ' || z.zone_name
-- Resultado: 'Bogotá > Chapinero > Rosales'
```

Para que visualmente se vea como un árbol indentado, usé `REPEAT`:

```sql
REPEAT('  ', depth - 1) || zone_name
-- Resultado nivel 3: '    Rosales'
```

---

## 3. La jerarquía del dominio

Usé la tabla `collection_zones` para representar la jerarquía geográfica del sistema de recolección en tres niveles:

```
Bogotá                        ← Nivel 1 (raíz, sin padre)
  ├── Chapinero               ← Nivel 2
  │     ├── Rosales           ← Nivel 3
  │     └── Chico Norte       ← Nivel 3
  ├── Kennedy                 ← Nivel 2
  └── Suba                    ← Nivel 2
```

---

## 4. Consultas del archivo

| Consulta | Descripción |
|---|---|
| 1 | Árbol completo con `depth`, indentación visual y `path` completo |
| 2 | Solo los nodos del nivel 3 (barrios) con su ruta completa |
| 3 | Hojas del árbol: zonas que no tienen ninguna subzona hija (`NOT EXISTS`) |

---

## Tabla creada esta semana

**`collection_zones`** — Jerarquía geográfica de zonas de recolección.

| Columna | Tipo | Descripción |
|---|---|---|
| `zone_id` | SERIAL PK | Identificador único |
| `zone_name` | TEXT | Nombre de la zona |
| `zone_type` | TEXT | Tipo: Ciudad, Localidad, Barrio |
| `parent_id` | INT FK | Apunta al nodo padre en la misma tabla (NULL si es raíz) |

---

## Recursos Adicionales

- Consultas aplicadas al dominio de residuos: [Ver queries](/sql/03-dql-queries/13-week-recursive-ctes/queries.sql)
