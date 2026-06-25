FROM postgres:16-alpine

ENV POSTGRES_DB=waste_management
ENV POSTGRES_USER=waste_user
ENV POSTGRES_PASSWORD=waste_pass

COPY sql/01-ddl-structure/structure.sql /docker-entrypoint-initdb.d/01_structure.sql
COPY sql/02-dml-data/data.sql           /docker-entrypoint-initdb.d/02_data.sql
