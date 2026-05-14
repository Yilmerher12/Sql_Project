# SQL Project

Repositorio organizado por sublenguajes SQL y por semanas de trabajo académico con base al dominio Recoleccion de residuos.

---

# Estructura del Proyecto

```bash
sql/
│
├── 01-ddl-structure/
│   ├── structure.sql
│   └── README.md
│
├── 02-dml-data/
│   ├── data.sql
│   └── README.md
│
├── 03-dql-queries/
│   ├── 06-week-aggregate-function/
│   ├── 07-week-null-and-constraints/
│   ├── 09-week-inners-left-right/
│   └── README.md
│
└── README.md
```

# 01 - DDL Structure

📁 `01-ddl-structure`

Contiene todo el código SQL relacionado con la definición estructural de la base de datos del dominio asignado por el profesor.

## Contenido

- Creación de tablas
- Tipos de datos
- Relaciones
- Claves primarias y foráneas
- Restricciones (`NOT NULL`, `UNIQUE`, `CHECK`, etc.)

## Archivo principal

- [structure.sql](/sql/01-ddl-structure/structure.sql)

## Documentación

Esta carpeta incluye un `README.md` donde se explica la estructura y organización de la base de datos.

---

# 02 - DML Data

📁 `02-dml-data`

Contiene el código SQL encargado de poblar con registros la base de datos.

## Contenido

- Inserciones de datos
- Registros de prueba
- Poblamiento final de tablas

## Archivo principal

- [data.sql](/sql/01-ddl-structure/structure.sql)

## Documentación

Incluye un `README.md` con información sobre la inserción y organización de los datos.

---

# 03 - DQL Queries

📁 `03-dql-queries`

Sección principal del proyecto.

Contiene todas las consultas SQL desarrolladas desde la semana 06 en adelante, exceptuando la semana 08.

Cada carpeta representa una temática o semana de trabajo.

## Carpetas incluidas

### `06-week-aggregate-function`
- `Link:` [clic](/sql/03-dql-queries/06-week-aggregate-function/)


Consultas relacionadas con:

- `COUNT()`
- `SUM()`
- `AVG()`
- `MIN()`
- `MAX()`
- `GROUP BY`
- `ORDER BY`
- `HAVING`

---

### `07-week-null-and-constraints`
- `Link:` [clic](/sql/03-dql-queries/07-week-null-and-constraints/)

Consultas relacionadas con:

- Valores `NULL`
- Restricciones SQL
- Validaciones
- Manejo de datos vacíos
- 

---

### `09-week-inners-left-right`
- `Link:` [clic](/sql/03-dql-queries/09-week-inners-left-right/)

Consultas relacionadas con:

- `INNER JOIN`
- `LEFT JOIN`
- `RIGHT JOIN`
- Relaciones entre tablas

---

## READMEs Internos

Cada carpeta contiene su propio `README.md` con información y documentación relacionada con su contenido.