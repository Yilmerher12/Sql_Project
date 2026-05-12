# Semana 07: Gestión de NULLs y Restricciones (Constraints)

En esta semana se profundiza en la naturaleza de los datos NULLS y en las reglas de integridad que aseguran que una base de datos sea confiable y profesional.

---

## 1. La Naturaleza de NULL

En SQL, **NULL** no es un valor, es una **propiedad** de un campo que indica que la información es **desconocida** o **inexistente**.

### Lo que NO es NULL

Para evitar errores técnicos en los reportes, es vital recordar:

- **No es 0:** El cero es un valor numérico definido.
- **No es un espacio (`' '`):** El espacio es un carácter de texto.
- **No es una cadena vacía (`''`):** Representa texto con longitud cero, pero sigue siendo un dato conocido.

### El Impacto en la Aritmética

Cualquier operación matemática que involucre un `NULL` dará como resultado `NULL`.

```math
10 + NULL = NULL
```

```math
500 * NULL = NULL
```

---

## 2. Filtrado y Comparación

Debido a que `NULL` representa lo desconocido, el operador de igualdad (`=`) no funciona. En su lugar, se utilizan operadores específicos que devuelven un valor booleano (Verdadero/Falso):

- **`IS NULL`**: Devuelve verdadero si el campo está vacío.
- **`IS NOT NULL`**: Devuelve verdadero si el campo contiene cualquier dato.

### Ejemplo Técnico

```sql
-- Aca queremos encontrar estudiantes que no registraron su segundo nombre
SELECT 
    primer_nombre, 
    primer_apellido 
FROM estudiantes 
WHERE segundo_nombre IS NULL; -- Busca específicamente el 'hueco' o valor null de información
```

---

## 3. Funciones de Manipulación de NULL

Estas funciones se utilizan principalmente en el `SELECT` para "limpiar" los resultados del reporte sin alterar los datos originales de la tabla.

### `COALESCE()`

Devuelve el primer valor no nulo de una lista de argumentos evaluados de izquierda a derecha.

**Sintaxis**: `COALESCE(opcion_1, opcion_2, ..., valor_final)`

**Uso común:** Mostrar un valor por defecto.

**¿Cómo trabaja el motor?**

1. Revisa la `opcion_1`. Si tiene datos, la muestra y termina.

2. Si la `opcion_1` es NULL, salta a la opcion_2.

3. Si todas son NULL, muestra el `valor_final` (que suele ser un texto que nosotros escribimos).

#### Ejemplo
```sql
SELECT 
    nombre_usuario,
    -- Si no tiene teléfono fijo, busca el móvil. Si no hay ninguno, pone 'Sin contacto'.
    COALESCE(tel_fijo, tel_movil, 'Sin contacto') AS contacto_principal
FROM usuarios;
```

### `NULLIF()`

Compara dos expresiones. Si son iguales, devuelve `NULL`; de lo contrario, devuelve la primera expresión.

**Sintaxis**: `NULLIF(valor_a_evaluar, valor_a_comparar)`

**Uso común:** Evitar errores de "división por cero" en cálculos estadísticos.  
Al convertir un `0` en `NULL`, la operación matemática devuelve `NULL` en lugar de romper la consulta.

#### Sintaxis

```sql
-- Si 'personas' es 0, NULLIF lo vuelve NULL para que la división no explote.
SELECT 
    monto_total / NULLIF(cantidad_personas, 0) AS pago_individual 
FROM cuentas;
```

---

## 4. Restricciones de Integridad (Constraints)

Las restricciones son reglas aplicadas a las columnas para garantizar la calidad de los datos antes de que se guarden en el disco duro.

| Restricción | Definición Técnica |
|---|---|
| `PRIMARY KEY` | Identificador único de la fila. No permite nulos y no se puede repetir. |
| `NOT NULL` | Obliga a que la columna siempre tenga un valor. |
| `UNIQUE` | Asegura que todos los valores en la columna sean diferentes. |
| `CHECK` | Valida que el dato cumpla una condición lógica (ej. `precio > 0`). |
| `FOREIGN KEY` | Crea un vínculo oficial entre dos tablas (Integridad Referencial). |

### Ejemplo de Implementación DDL

```sql
CREATE TABLE productos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) CHECK (precio > 0),
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);
```

---

## Recursos Adicionales

- Ejemplos de consultas con base al dominio de `recoleccion de residuos`: [Consultas](/sql/03-dql-queries/07-week-null-and-constraints/queries.sql)