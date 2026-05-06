# Data Definition Language (DDL) - Documentación Detallada de la Estructura

Este directorio contiene el archivo `structure.sql`, el cual define la arquitectura física de la base de datos `waste_management`. A continuación, se justifica cada decisión técnica tomada en el diseño de las entidades, columnas y restricciones.

---

## 1. Entidad: `trucks` (Camiones)
Representa la flota de vehículos. Es una entidad maestra independiente.

| Columna | Tipo de Dato | Restricciones | Justificación Técnica |
| :--- | :--- | :--- | :--- |
| **`truck_id`** | `INT` | `PK`, `AUTO_INCREMENT` | Identificador interno único. Se prefiere un entero autoincremental sobre la placa para optimizar los índices de búsqueda y facilitar las relaciones con otras tablas. |
| **`truck_plate`** | `VARCHAR(10)` | `NOT NULL`, `UNIQUE` | La placa es la identificación legal. Se define como `UNIQUE` para evitar que un mismo vehículo se registre dos veces, y `VARCHAR(10)` para soportar formatos internacionales o cambios de legislación. |
| **`truck_brand`** | `VARCHAR(50)` | `NOT NULL` | Almacena el fabricante. Es `NOT NULL` porque un vehículo sin marca no es auditable en una flota logística. |
| **`truck_capacity_tons`** | `DECIMAL(5,2)` | `NOT NULL` | Se usa `DECIMAL` en lugar de `FLOAT` para garantizar precisión exacta en el peso. El formato `(5,2)` permite hasta 999.99 toneladas, cubriendo cualquier camión de carga pesada existente. |
| **`truck_status`** | `ENUM(...)` | `DEFAULT 'active'` | Restringe el estado a tres valores: `active`, `maintenance`, `inactive`. Esto asegura la integridad del negocio, impidiendo que se asignen camiones en mantenimiento a nuevas rutas. |

---

## 2. Entidad: `neighborhoods` (Barrios)
Define las zonas geográficas atendidas. Es una entidad maestra independiente.

| Columna | Tipo de Dato | Restricciones | Justificación Técnica |
| :--- | :--- | :--- | :--- |
| **`neighborhood_id`** | `INT` | `PK`, `AUTO_INCREMENT` | Llave primaria subrogada para identificar cada zona de forma única. |
| **`neighborhood_name`** | `VARCHAR(100)` | `NOT NULL` | Nombre común del barrio. Se asignan 100 caracteres para nombres compuestos extensos. |
| **`neighborhood_locality`** | `VARCHAR(100)` | `NOT NULL` | Clasificación administrativa (localidad o comuna). Ayuda a agrupar datos en consultas de nivel superior (DQL). |
| **`neighborhood_estimated_houses`**| `INT` | `DEFAULT 0` | Dato estadístico para proyectar la carga de residuos. Se usa `INT` ya que el conteo de casas siempre es un número entero. |

---

## 3. Entidad: `routes` (Rutas)
Define la planificación del servicio.

| Columna | Tipo de Dato | Restricciones | Justificación Técnica |
| :--- | :--- | :--- | :--- |
| **`route_id`** | `INT` | `PK`, `AUTO_INCREMENT` | Identificador único del plan de ruta. |
| **`route_name`** | `VARCHAR(100)` | `NOT NULL` | Nombre identificador (ej: "Ruta Centro-Noche"). Facilita la lectura de reportes para los operarios. |
| **`route_start_hour`** | `TIME` | `NOT NULL` | Define el inicio de la ventana de recolección. El tipo `TIME` es más eficiente que un `DATETIME` porque la ruta es recurrente diariamente. |
| **`route_end_hour`** | `TIME` | `NOT NULL` | Define el cierre de la ventana operativa. |

---

## 4. Entidad Intermedia: `route_neighborhoods`
Resuelve la relación **Muchos a Muchos (N:M)** entre Rutas y Barrios.

*   **`route_id` & `neighborhood_id`**: Ambos actúan como una **Llave Primaria Compuesta**, lo que impide que un mismo barrio se asigne dos veces a la misma ruta por error.
*   **`FOREIGN KEY (route_id) REFERENCES routes ... ON DELETE CASCADE`**: Si una ruta se elimina, la asociación con sus barrios desaparece automáticamente, evitando registros huérfanos.
*   **`FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods ... ON DELETE CASCADE`**: Si un barrio se elimina de la base de datos, se retira de todas las rutas asociadas sin intervención manual.

---

## 5. Entidad: `collections` (Recolecciones)
Es la tabla transaccional donde se registra la operación real.

| Columna | Tipo de Dato | Restricciones | Justificación Técnica |
| :--- | :--- | :--- | :--- |
| **`collection_id`** | `INT` | `PK`, `AUTO_INCREMENT` | Identificador único de cada viaje o servicio realizado. |
| **`truck_id`** | `INT` | `FK`, `NOT NULL` | Referencia al camión que realizó el trabajo. Si el camión no existe en `trucks`, la base de datos rechazará el registro. |
| **`route_id`** | `INT` | `FK`, `NOT NULL` | Referencia a la planificación seguida. Permite comparar lo planeado vs. lo ejecutado. |
| **`collection_date`** | `DATE` | `NOT NULL` | Fecha exacta del servicio. Se usa `DATE` para facilitar filtros por año, mes o día en consultas DQL. |
| **`collection_actual_weight_tons`**| `DECIMAL(5,2)`| - | Peso real pesado en báscula al terminar la ruta. Puede ser nulo si el registro se crea antes de que el camión llegue al vertedero. |
| **`collection_observations`** | `TEXT` | - | Campo abierto para registrar novedades (ej: "Camión pinchado", "Barrio bloqueado"). El tipo `TEXT` permite descripciones largas. |

---

## Resumen de Reglas de Integridad
1.  **Integridad Referencial:** No se pueden crear registros de recolección para camiones o rutas inexistentes.
2.  **Unicidad:** No se permiten duplicados de placas de camiones.
3.  **Normalización:** El diseño cumple con la **Tercera Forma Normal (3NF)** al separar los datos fijos (catálogos de camiones y barrios) de los datos variables (recolecciones diarias).


### Comportamiento en Cascada
*   En la tabla intermedia `route_neighborhoods`, se aplicó `ON DELETE CASCADE`. Si una ruta es eliminada del sistema, sus asociaciones con los barrios desaparecen automáticamente para mantener limpia la tabla de relaciones.