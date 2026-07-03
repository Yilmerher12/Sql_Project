# Semana 10 — CROSS JOIN y SELF JOIN

En esta semana aprendí a relacionar una tabla **consigo misma**, algo que no había visto antes. Entendí que esto es posible cuando los datos tienen una jerarquía interna, donde un registro puede ser "padre" de otro dentro de la misma tabla.

---

## 1. SELF JOIN — Unión de una tabla consigo misma

Aprendí que un SELF JOIN no es un tipo de JOIN nuevo, sino simplemente usar `INNER JOIN` o `LEFT JOIN` sobre la misma tabla dos veces, con **alias distintos** para diferenciar quién es el padre y quién es el hijo.

Lo que hace posible esto es tener una columna `parent_id` que apunta al `id` de otro registro en la misma tabla:

```sql
-- 'child' es el alias del registro hijo, 'parent' es el alias del registro padre
SELECT
    child.category_name  AS subcategoria,
    parent.category_name AS categoria_padre
FROM waste_categories child
INNER JOIN waste_categories parent ON child.parent_category_id = parent.category_id;
```

Entendí que la clave está en la condición `ON`: une el `parent_category_id` del hijo con el `category_id` del padre. Sin eso, la consulta no sabría cómo conectarlos.

---

## 2. Diferencia entre INNER y LEFT en un SELF JOIN

Aprendí que la elección entre INNER y LEFT cambia qué registros aparecen:

| Tipo | ¿Qué muestra? |
|---|---|
| `INNER JOIN` | Solo los nodos que tienen padre (la raíz queda excluida) |
| `LEFT JOIN` | Todos los nodos, incluida la raíz (su padre aparece como NULL) |

Para que la raíz aparezca con una etiqueta legible y no como NULL, aprendí a usar `COALESCE`:

```sql
COALESCE(parent.category_name, 'Categoría Raíz')
```

---

## 3. La jerarquía del dominio

En el proyecto de gestión de residuos, usé la tabla `waste_categories` para representar los tipos de residuos en tres niveles:

```
Material Reciclable        ← Nivel 0 (raíz, sin padre)
  ├── Plásticos            ← Nivel 1
  │     ├── Botellas PET   ← Nivel 2
  │     └── Envases de PVC ← Nivel 2
  └── Papel y Cartón       ← Nivel 1
        └── Cajas de Embalaje ← Nivel 2
```

---

## 4. Consultas del archivo

| Consulta | Descripción |
|---|---|
| 1 | SELF JOIN básico: muestra cada subcategoría con su categoría padre |
| 2 | LEFT JOIN: incluye la raíz, etiquetada con COALESCE |
| 3 | Contar hijos directos por cada categoría padre |
| 4 | Dos niveles en una sola consulta: nieto → hijo → abuelo |

---

## Tabla creada esta semana

**`waste_categories`** — Categorías de residuos con estructura auto-referencial.

| Columna | Tipo | Descripción |
|---|---|---|
| `category_id` | SERIAL PK | Identificador único |
| `category_name` | VARCHAR | Nombre de la categoría |
| `category_risk` | VARCHAR | Nivel de riesgo (default: 'Bajo') |
| `parent_category_id` | INT FK | Apunta al padre dentro de la misma tabla |

---

## Recursos Adicionales

- Consultas aplicadas al dominio de residuos: [Ver queries](/sql/03-dql-queries/10-week-cross-self-joins/queries.sql)
