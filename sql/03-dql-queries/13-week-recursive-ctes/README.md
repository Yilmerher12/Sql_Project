# Semana 13 — CTEs Recursivas (WITH RECURSIVE)

## Tema de la semana

Una **CTE recursiva** es una CTE que se llama a sí misma para recorrer estructuras jerárquicas o en árbol. Es la herramienta estándar de SQL para navegar datos con relaciones padre-hijo sin saber de antemano cuántos niveles existen.

---

## Concepto: WITH RECURSIVE

Una CTE recursiva tiene siempre dos partes unidas por `UNION ALL`:

```sql
WITH RECURSIVE nombre AS (
    -- CASO BASE: el punto de partida (nodos raíz)
    SELECT ... FROM tabla WHERE parent_id IS NULL

    UNION ALL

    -- CASO RECURSIVO: une cada nodo con su padre ya procesado
    SELECT ... FROM tabla
    INNER JOIN nombre ON tabla.parent_id = nombre.id
)
SELECT * FROM nombre;
```

**¿Cómo funciona internamente?**

1. PostgreSQL ejecuta el **caso base** y obtiene la primera fila (o filas) de resultados.
2. Luego ejecuta el **caso recursivo** usando los resultados anteriores como punto de partida.
3. Repite el paso 2 hasta que la JOIN no encuentre más filas nuevas.
4. Acumula todos los resultados en la CTE final.

---

## Aplicación al dominio

La tabla `collection_zones` representa la jerarquía geográfica del sistema de recolección:

```
Bogotá                        ← Nivel 1 (raíz, parent_id = NULL)
  ├── Chapinero               ← Nivel 2
  │     ├── Rosales           ← Nivel 3
  │     └── Chico Norte       ← Nivel 3
  ├── Kennedy                 ← Nivel 2
  │     ├── Kennedy Central   ← Nivel 3
  │     ├── Castilla          ← Nivel 3
  │     └── Patio Bonito      ← Nivel 3
  ├── Suba                    ← Nivel 2
  └── Engativá                ← Nivel 2
```

Con `WITH RECURSIVE` se puede recorrer este árbol entero en una sola consulta, calculando el nivel de profundidad (`depth`) y la ruta completa (`path`) de cada nodo.

---

## Técnicas usadas

### Calcular depth (nivel de profundidad)

En el caso base se asigna `1 AS depth`. En el caso recursivo se incrementa: `a.depth + 1`.

### Construir el path (ruta completa)

En el caso base se inicia con el nombre del nodo. En el caso recursivo se concatena con `||`:

```sql
a.path || ' > ' || z.zone_name
-- Resultado: 'Bogotá > Chapinero > Rosales'
```

### Indentar la visualización

```sql
REPEAT('  ', depth - 1) || zone_name
```

`REPEAT` genera espacios en blanco según el nivel, dando efecto visual de árbol.

---

## Consultas del archivo

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
| `parent_id` | INT FK | Referencia al nodo padre en la misma tabla (NULL si es raíz) |
