# Semana 09: Relaciones y Uniones entre Tablas (JOINs)

En esta semana aprendí que en las bases de datos relacionales la información no está en un solo lugar. Entendí que, para normalizar los datos, debemos repartirlos en varias tablas y luego usar los **JOINs** para volver a unirlos en un solo reporte horizontal.

---

## 1. Alias de Tablas (Identificadores Cortos)

Antes de unir tablas, aprendí que es fundamental usar **Alias de Tabla**. A diferencia de los alias de columna (`AS`), estos se ponen directamente después del nombre de la tabla en el `FROM` o el `JOIN`.

### ¿Qué hace?
Le asigna un "apodo" a la tabla para que no tenga que escribir su nombre completo cada vez que llamo a una columna.

### ¿Dónde se pone?
En la declaración de las tablas. En el `FROM` *tabla_A* y `JOINs` *tabla_A*

```sql
-- 'u' es el alias de usuarios y 'p' es el alias de pedidos
SELECT u.nombre, p.total 
FROM usuarios u 
INNER JOIN pedidos p ON u.id = p.usuario_id;
```

---

## 2. INNER JOIN (Cruce por Coincidencia)

Este es el tipo de unión más estricto. Entendí que solo me va a mostrar los registros que tienen "pareja" en ambas tablas.

### ¿Qué hace?
Fusiona filas de la Tabla A con la Tabla B siempre que se cumpla una condición de igualdad. Principalmente con `FKs` y `PKs`.

### ¿Dónde se pone?
Después del `FROM`.

### La Cláusula ON
Es la validación. Es lo que le dice al motor que una solo los registros que cumplan con que el valor de la **PK** es igual al de la **FK** en la otra tabla.

### Ejemplo Comentado

```sql
SELECT 
    c.nombre_cliente, 
    v.monto_venta
FROM clientes c
-- Une la tabla ventas (v) con clientes (c)
INNER JOIN ventas v 
ON c.id = v.cliente_id; -- Solo muestra clientes que SÍ han comprado algo
```

---

## 3. LEFT JOIN y RIGHT JOIN (Prioridad de Tablas)

Aprendí que a veces no quiero borrar los datos que no tienen coincidencia. Para eso usamos los Outer Joins, que dan prioridad a un lado de la relación.

A diferencia del anterior, los `Outer JOINs` muestran las filas que no cumplan la condicion, y le asignan **NULL** al campo. 

### LEFT JOIN (Prioridad a la Izquierda)

Muestra todos los registros de la primera tabla (la que está en el `FROM`), aunque no tengan nada en la segunda tabla.

**Si no hay coincidencia:** El reporte rellena los huecos con `NULL`.

### RIGHT JOIN (Prioridad a la Derecha)

Es lo mismo, pero la prioridad la tiene la tabla que escribimos después de la palabra `JOIN`.

### Ejemplo Comentado

```sql
-- Queremos ver todos los usuarios, incluso los que no tienen pedidos
SELECT 
    u.nombre, 
    p.id_pedido
FROM usuarios u
LEFT JOIN pedidos p 
ON u.id = p.usuario_id; -- Si un usuario no tiene pedido, el id_pedido saldrá como NULL
```

---

## 4. FULL OUTER JOIN (La Unión Total)

Entendí que este es el nivel máximo de unión: muestra absolutamente todo lo de la Tabla A y la Tabla B, coincidan o no.

### ¿Qué hace?
Si hay coincidencia, une. Si no hay, rellena con `NULL` en el lado donde falte la información.

### Nota técnica en MySQL
Aprendí que MySQL no soporta `FULL OUTER JOIN` directamente. Para lograrlo, debo unir un `LEFT JOIN` y un `RIGHT JOIN` usando la instrucción `UNION`.

### Ejemplo (Simulación con UNION)

```sql
-- Trae todo lo de la izquierda
SELECT * FROM tabla_a LEFT JOIN tabla_b ON a.id = b.id
UNION -- Junta ambos resultados y elimina duplicados
-- Trae todo lo de la derecha
SELECT * FROM tabla_a RIGHT JOIN tabla_b ON a.id = b.id;
```

---

# Resumen de Comportamiento

| Tipo de JOIN | ¿Qué registros veo? | ¿Qué pasa con los que no coinciden? |
|---|---|---|
| INNER | Solo los que tienen pareja en ambos lados. | Se eliminan del reporte. |
| LEFT | Todo lo de la izquierda + parejas. | Se rellenan con `NULL` a la derecha. |
| RIGHT | Todo lo de la derecha + parejas. | Se rellenan con `NULL` a la izquierda. |
| FULL | Todo lo de ambas tablas. | Se rellenan con `NULL` donde falte el par. |

---

# Recursos Adicionales


- Práctica de JOINS con el:`proyecto de residuos`: [Ver consultas SQL](/sql/03-dql-queries/07-week-null-and-constraints/queries.sql)