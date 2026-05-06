# Sistema de Gestión de Residuos (Waste Management)

## Información del Autor
*   **Nombre:** Yilmer Hernández Camargo
*   **Programa:** Análisis y Desarrollo de Software (ADSO)
*   **Institución:** Servicio Nacional de Aprendizaje (SENA)
*   **Trimestre:** IV

---

## 1. Objetivo del Proyecto
Este repositorio tiene como finalidad académica el diseño, implementación y explotación de una base de datos relacional orientada al dominio de la recolección de residuos urbanos. 

El enfoque principal es fortalecer el dominio de los sublenguajes de SQL:
*   **DDL (Data Definition Language):** Creación de estructuras, definición de tipos de datos y aplicación de restricciones de integridad.
*   **DML (Data Manipulation Language):** Poblamiento de datos masivos (+40 registros) y gestión de la información.
*   **DQL (Data Query Language):** Ejecución de consultas complejas, uniones (JOINs) y generación de reportes lógicos.

## 2. Definición del Dominio
El proyecto se centra en la logística de una empresa de recoleccion de residuso. El sistema debe ser capaz de rastrear qué vehículos operan en qué zonas y registrar cada evento de recolección realizado.

### Entidades Base (Requerimientos del Instructor)
Según las instrucciones recibidas, el modelo se fundamenta en las siguientes entidades:
1.  **Routes (Rutas):** Define el trayecto y los horarios teóricos de operación.
2.  **Trucks (Camiones):** Gestiona la flota de vehículos, su capacidad y estado técnico.
3.  **Neighborhoods (Barrios):** Identifica las zonas geográficas y localidades atendidas.
4.  **Collections (Recolecciones):** Registro transaccional que vincula la ejecución real de una ruta con un vehículo y una fecha específica.

## 3. Estructura del Repositorio
Para una mejor navegación y comprensión del ciclo de vida de la base de datos, el código se organiza de la siguiente manera:

*   **`docs/`**: Contiene el diseño lógico y la justificación de la arquitectura.
*   **`sql/01-ddl-structure/`**: Scripts de creación de la base de datos y tablas. Incluye documentación sobre restricciones y tipos de datos elegidos.
*   **`sql/02-dml-data/`**: Scripts para la inserción de datos de prueba.
*   **`sql/03-dql-queries/`**: Laboratorio de consultas para la práctica de sentencias de selección y filtrado.

## 4. Función del Repositorio
Este espacio sirve como bitácora de aprendizaje. Cada decisión técnica (por qué un tipo de dato `DECIMAL` en lugar de `FLOAT`, o el uso de una tabla intermedia) se encuentra documentada en los respectivos directorios para facilitar la revisión y el entendimiento del modelo relacional.