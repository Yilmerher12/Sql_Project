# Semana 10 — CROSS JOIN y SELF JOIN

## Tema de la semana

Esta semana se trabajaron dos tipos de JOIN especiales que permiten relacionar una tabla **consigo misma** (SELF JOIN) o combinar cada fila de una tabla con cada fila de otra sin condición de unión (CROSS JOIN).

El foco principal fue el **SELF JOIN**, que se usa cuando los datos tienen una **jerarquía interna**: un registro padre que puede tener varios registros hijos dentro de la misma tabla.

---

## Concepto: SELF JOIN

Un SELF JOIN ocurre cuando una tabla se une **a sí misma** usando dos alias distintos. Esto es posible gracias a una columna `parent_id` que apunta al `id` de otro registro en la misma tabla.

**Ejemplo del dominio:**

La tabla `waste_categories` representa una jerarquía de residuos:

```
Material Reciclable        ← Nivel 0 (raíz, parent_id = NULL)
  ├── Plásticos            ← Nivel 1
  │     ├── Botellas PET   ← Nivel 2
  │     └── Envases de PVC ← Nivel 2
  └── Papel y Cartón       ← Nivel 1
        └── Cajas de Embalaje ← Nivel 2
```

Para consultar esta jerarquía, se une la tabla consigo misma usando dos roles:

```sql
SELECT
    child.category_name  AS subcategoria,
    parent.category_name AS categoria_padre
FROM waste_categories child
INNER JOIN waste_categories parent ON child.parent_category_id = parent.category_id;
```

- `child` → alias para los registros hijos
- `parent` → alias para los registros padres
- La condición une el `parent_category_id` del hijo con el `category_id` del padre

---

## Diferencia entre INNER y LEFT en SELF JOIN

| Tipo | Resultado |
|---|---|
| `INNER JOIN` | Solo muestra los nodos que tienen padre (excluye la raíz) |
| `LEFT JOIN` | Muestra todos, incluida la raíz (su padre aparece como NULL) |

Con `COALESCE` se puede etiquetar la raíz:

```sql
COALESCE(parent.category_name, 'Categoría Raíz')
```

---

## Consultas del archivo

| Consulta | Descripción |
|---|---|
| 1 | SELF JOIN básico — subcategorías con su categoría padre |
| 2 | LEFT JOIN — incluye la raíz, etiquetada con COALESCE |
| 3 | Contar hijos directos por categoría padre |
| 4 | Dos niveles en una sola consulta: nieto → hijo → abuelo |

---

## Tabla creada esta semana

**`waste_categories`** — Categoría auto-referencial de residuos.

| Columna | Tipo | Descripción |
|---|---|---|
| `category_id` | SERIAL PK | Identificador único |
| `category_name` | VARCHAR | Nombre de la categoría |
| `category_risk` | VARCHAR | Nivel de riesgo (default: 'Bajo') |
| `parent_category_id` | INT FK | Referencia al padre en la misma tabla |
