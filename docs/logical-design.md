# Diseño Lógico de la Base de Datos

Esta carpeta contiene la documentación no técnica y los diagramas necesarios para entender la estructura de la base de datos desde una perspectiva lógica.

## Contenido
*   **[logical-design.md](./logical-design.md)**: Explicación detallada del Modelo Entidad-Relación, reglas de cardinalidad y descripción funcional de las entidades.

## Propósito
El objetivo de estos documentos es servir como guía de referencia para entender cómo se mapean los procesos de la vida real (recolección de basura) a una estructura de datos organizada, cumpliendo con los estándares de normalización aprendidos en el programa ADSO.

En esta sección se detalla la lógica detrás de la abstracción de las entidades del dominio de Gestión de Residuos.

## 1. Entidades y Atributos Lógicos

### Trucks (Camiones)
Representa los activos físicos de la empresa. Su función principal es el transporte de residuos.
*   **Atributos clave:** Identificación interna, placa legal, marca y capacidad máxima.

### Neighborhoods (Barrios)
Representa la división geográfica de la ciudad. 
*   **Atributos clave:** Nombre, sector/localidad y carga de viviendas estimada para proyección de demanda.

### Routes (Rutas)
Es la planificación del servicio. Define ventanas de tiempo (mañana/tarde/noche) para la operación.
*   **Atributos clave:** Nombre descriptivo de la zona y horario de operación teórica.

### Collections (Recolecciones)
Es el núcleo transaccional del sistema. Registra la ejecución real del servicio, capturando datos variables como el peso recogido, que puede diferir de la capacidad del camión.

## 2. Diagrama Entidad-Relación (Concepto)
```erDiagram
    TRUCKS ||--o{ COLLECTIONS : performs
    ROUTES ||--o{ COLLECTIONS : assigned_to
    ROUTES }|--|{ NEIGHBORHOODS : covers
    
    TRUCKS {
        int truck_id PK
        string truck_plate
        string truck_brand
        decimal truck_capacity_tons
        enum truck_status
    }
    NEIGHBORHOODS {
        int neighborhood_id PK
        string neighborhood_name
        string neighborhood_locality
        int neighborhood_estimated_houses
    }
    ROUTES {
        int route_id PK
        string route_name
        time route_start_hour
        time route_end_hour
    }
    COLLECTIONS {
        int collection_id PK
        int truck_id FK
        int route_id FK
        date collection_date
        decimal collection_actual_weight_tons
        text collection_observations
    }
```



## 3. Justificación de Relaciones

### La relación Muchos a Muchos (Routes ↔ Neighborhoods)
En la vida real, una ruta de aseo no siempre termina en un solo barrio. Puede cruzar tres barrios pequeños o un barrio grande puede requerir dos rutas distintas. 
*   **Decisión de diseño:** Se implementó una tabla intermedia para evitar la redundancia de datos y permitir que el sistema sea flexible ante cambios en la planeación urbana.

### La relación de Collections
Cada registro de recolección debe responder tres preguntas:
1.  **¿Qué se hizo?** (La Ruta)
2.  **¿Con qué se hizo?** (El Camión)
3.  **¿Cuándo se hizo?** (La Fecha)
Por ello, esta entidad actúa como el punto de unión entre la flota y la planificación.