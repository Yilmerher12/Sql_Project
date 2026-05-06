# Data Manipulation Language (DML) - Gestión de Datos

Este directorio contiene el archivo `data.sql`, encargado de poblar la base de datos con información realista para pruebas de estrés, validación de relaciones y práctica de consultas complejas.

## 1. Contexto de los Datos
Para dar mayor realismo al proyecto, se ha utilizado el contexto geográfico de **Bogotá, Colombia**. 
*   **Barrios y Localidades:** Se incluyen sectores reales (Suba, Kennedy, Chapinero, etc.) para permitir análisis de datos por zonas administrativas.
*   **Temporalidad:** Los registros de recolección cubren el periodo de **abril y mayo de 2026**, permitiendo practicar filtros de fechas actuales.

---

## 2. Estrategia de Inserción

### A. Entidades Maestras (Trucks & Neighborhoods)
Se insertaron **45 registros** en cada una de estas tablas. 
*   **Camiones:** Se incluyeron diversas marcas (Hino, Kenworth, Mercedes-Benz) con capacidades que varían entre 10 y 18 toneladas para probar funciones de agregación (`SUM`, `AVG`).
*   **Barrios:** La variedad de localidades permite practicar el agrupamiento (`GROUP BY`) por sectores geográficos.

### B. Entidad de Planificación (Routes)
Se definieron **25 rutas** con horarios diferenciados. La inclusión de columnas tipo `TIME` permite realizar prácticas sobre eficiencia de turnos (mañana vs. noche).

### C. Relaciones N:M (Route_Neighborhoods)
Se generaron aproximadamente **50 asociaciones**. 
*   **Lógica:** Cada ruta tiene asignados al menos dos barrios. Esto es fundamental para practicar `JOIN`s múltiples y entender cómo una sola unidad logística (Ruta) impacta en diversos puntos geográficos.

### D. Entidad Transaccional (Collections)
Se incluyeron **50 registros históricos**. 
*   **Pesos Variables:** Los valores de `collection_actual_weight_tons` no siempre coinciden con la capacidad del camión, lo que permite crear consultas de "eficiencia de carga" o "sobrecarga".
*   **Observaciones:** Se añadieron textos variables para practicar operadores de búsqueda de patrones como `LIKE`.

---

## 3. Orden de Ejecución Obligatorio
Debido a las restricciones de **Integridad Referencial** (Foreign Keys) definidas en el DDL, los datos deben cargarse en el siguiente orden:

1.  **`trucks`**: No depende de nadie.
2.  **`neighborhoods`**: No depende de nadie.
3.  **`routes`**: No depende de nadie.
4.  **`route_neighborhoods`**: Requiere que existan previamente los IDs de rutas y barrios.
5.  **`collections`**: Requiere que existan previamente los IDs de camiones y rutas.

## 4. Propósito de las Pruebas
Esta volumetría de datos (+40 registros por tabla maestra) garantiza que las consultas DQL (Data Query Language) devuelvan resultados significativos y permitan visualizar el comportamiento de la base de datos en un entorno cercano al real.