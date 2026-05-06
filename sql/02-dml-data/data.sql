USE waste_management;

-- ==========================================================
-- 1. POBLANDO LA TABLA: trucks (45 registros)
-- ==========================================================
INSERT INTO trucks (truck_plate, truck_brand, truck_capacity_tons, truck_status) VALUES
('SNA-001', 'Hino', 10.5, 'active'), ('SNA-002', 'Hino', 10.5, 'active'),
('SNA-003', 'Freightliner', 15.0, 'active'), ('SNA-004', 'Freightliner', 15.0, 'maintenance'),
('SNA-005', 'International', 12.0, 'active'), ('SNA-006', 'International', 12.0, 'active'),
('SNA-007', 'Kenworth', 18.0, 'active'), ('SNA-008', 'Kenworth', 18.0, 'active'),
('SNA-009', 'Mercedes-Benz', 11.0, 'active'), ('SNA-010', 'Mercedes-Benz', 11.0, 'inactive'),
('SNA-011', 'Scania', 14.5, 'active'), ('SNA-012', 'Scania', 14.5, 'active'),
('SNA-013', 'Hino', 10.5, 'active'), ('SNA-014', 'Freightliner', 15.0, 'active'),
('SNA-015', 'International', 12.0, 'maintenance'), ('SNA-016', 'Kenworth', 18.0, 'active'),
('SNA-017', 'Mercedes-Benz', 11.0, 'active'), ('SNA-018', 'Scania', 14.5, 'active'),
('SNA-019', 'Hino', 10.5, 'active'), ('SNA-020', 'Freightliner', 15.0, 'active'),
('SNA-021', 'International', 12.0, 'active'), ('SNA-022', 'Kenworth', 18.0, 'active'),
('SNA-023', 'Mercedes-Benz', 11.0, 'maintenance'), ('SNA-024', 'Scania', 14.5, 'active'),
('SNA-025', 'Hino', 10.5, 'active'), ('SNA-026', 'Freightliner', 15.0, 'active'),
('SNA-027', 'International', 12.0, 'active'), ('SNA-028', 'Kenworth', 18.0, 'inactive'),
('SNA-029', 'Mercedes-Benz', 11.0, 'active'), ('SNA-030', 'Scania', 14.5, 'active'),
('SNA-031', 'Hino', 10.5, 'active'), ('SNA-032', 'Freightliner', 15.0, 'active'),
('SNA-033', 'International', 12.0, 'active'), ('SNA-034', 'Kenworth', 18.0, 'active'),
('SNA-035', 'Mercedes-Benz', 11.0, 'maintenance'), ('SNA-036', 'Scania', 14.5, 'active'),
('SNA-037', 'Hino', 10.5, 'active'), ('SNA-038', 'Freightliner', 15.0, 'active'),
('SNA-039', 'International', 12.0, 'active'), ('SNA-040', 'Kenworth', 18.0, 'active'),
('SNA-041', 'Mercedes-Benz', 11.0, 'active'), ('SNA-042', 'Scania', 14.5, 'active'),
('SNA-043', 'Hino', 10.5, 'active'), ('SNA-044', 'Freightliner', 15.0, 'active'),
('SNA-045', 'International', 12.0, 'active');

-- ==========================================================
-- 2. POBLANDO LA TABLA: neighborhoods (45 registros)
-- ==========================================================
INSERT INTO neighborhoods (neighborhood_name, neighborhood_locality, neighborhood_estimated_houses) VALUES
('Chapinero Alto', 'Chapinero', 450), ('Rosales', 'Chapinero', 300),
('Chico Norte', 'Chapinero', 600), ('Cedritos', 'Usaquén', 1200),
('Santa Ana', 'Usaquén', 250), ('San Cristóbal Norte', 'Usaquén', 800),
('Modelia', 'Fontibón', 950), ('Hayuelos', 'Fontibón', 1100),
('Ciudad Salitre', 'Fontibón', 1500), ('Kennedy Central', 'Kennedy', 2000),
('Castilla', 'Kennedy', 1800), ('Patio Bonito', 'Kennedy', 2500),
('Suba Centro', 'Suba', 2200), ('La Colina', 'Suba', 1300),
('Lombardía', 'Suba', 900), ('Teusaquillo Centro', 'Teusaquillo', 500),
('Galerías', 'Teusaquillo', 700), ('La Soledad', 'Teusaquillo', 400),
('Engativá Pueblo', 'Engativá', 1400), ('Villas de Granada', 'Engativá', 1600),
('Garces Navas', 'Engativá', 1900), ('Bosa Centro', 'Bosa', 2100),
('El Recreo', 'Bosa', 2300), ('Metrovivienda', 'Bosa', 1700),
('Venecia', 'Tunjuelito', 850), ('San Vicente', 'Tunjuelito', 600),
('Restrepo', 'Antonio Nariño', 900), ('La Fragua', 'Antonio Nariño', 450),
('Paloquemao', 'Los Mártires', 300), ('Santa Isabel', 'Los Mártires', 750),
('Quinta Paredes', 'Teusaquillo', 550), ('Niza', 'Suba', 1000),
('Pasadena', 'Suba', 850), ('Mazuren', 'Suba', 1150),
('Lisboa', 'Usaquén', 700), ('Toberín', 'Usaquén', 950),
('El Tunal', 'Tunjuelito', 1800), ('Candelaria La Nueva', 'Ciudad Bolívar', 2400),
('El Perdomo', 'Ciudad Bolívar', 2100), ('Arborizadora Alta', 'Ciudad Bolívar', 2600),
('San Felipe', 'Barrios Unidos', 500), ('Siete de Agosto', 'Barrios Unidos', 650),
('Metrópolis', 'Barrios Unidos', 800), ('Las Nieves', 'Santa Fe', 350),
('La Macarena', 'Santa Fe', 420);

-- ==========================================================
-- 3. POBLANDO LA TABLA: routes (25 registros)
-- ==========================================================
INSERT INTO routes (route_name, route_start_hour, route_end_hour) VALUES
('Ruta Norte Residencial', '06:00:00', '14:00:00'),
('Ruta Norte Comercial', '20:00:00', '04:00:00'),
('Ruta Sur Industrial', '05:00:00', '13:00:00'),
('Ruta Occidente 1', '06:30:00', '14:30:00'),
('Ruta Occidente 2', '07:00:00', '15:00:00'),
('Ruta Kennedy Pesada', '05:30:00', '13:30:00'),
('Ruta Suba Nocturna', '21:00:00', '05:00:00'),
('Ruta Chapinero Express', '04:00:00', '10:00:00'),
('Ruta Teusaquillo Histórica', '06:00:00', '12:00:00'),
('Ruta Engativá Completa', '05:00:00', '15:00:00'),
('Ruta Bosa 1', '06:00:00', '14:00:00'),
('Ruta Ciudad Bolívar Alta', '04:30:00', '12:30:00'),
('Ruta Barrios Unidos', '07:30:00', '15:30:00'),
('Ruta Centro Histórico', '22:00:00', '04:00:00'),
('Ruta Santa Fe Comercial', '18:00:00', '02:00:00'),
('Ruta Usaquén Mañana', '05:00:00', '13:00:00'),
('Ruta Usaquén Noche', '21:00:00', '05:00:00'),
('Ruta Fontibón Aeropuerto', '06:00:00', '14:00:00'),
('Ruta Tunjuelito Sur', '05:30:00', '13:30:00'),
('Ruta Antonio Nariño', '07:00:00', '13:00:00'),
('Ruta Mártires Comercio', '19:00:00', '03:00:00'),
('Ruta Niza-Pasadena', '06:00:00', '14:00:00'),
('Ruta Salitre-Modelia', '06:00:00', '14:00:00'),
('Ruta Venecia-Tunal', '05:00:00', '13:00:00'),
('Ruta Galerías-Soledad', '07:00:00', '14:00:00');

-- ==========================================================
-- 4. POBLANDO LA TABLA: route_neighborhoods (N:M)
-- ==========================================================
-- Cada ruta cubre al menos 2 barrios
INSERT INTO route_neighborhoods (route_id, neighborhood_id) VALUES
(1, 4), (1, 5), (2, 6), (2, 35), (3, 38), (3, 39), (4, 7), (4, 8),
(5, 9), (5, 43), (6, 10), (6, 11), (7, 13), (7, 14), (8, 1), (8, 2),
(9, 16), (9, 18), (10, 19), (10, 20), (11, 22), (11, 23), (12, 38), (12, 40),
(13, 41), (13, 42), (14, 44), (14, 45), (15, 29), (15, 30), (16, 35), (16, 36),
(17, 4), (17, 36), (18, 7), (18, 9), (19, 25), (19, 37), (20, 27), (20, 28),
(21, 29), (21, 30), (22, 32), (22, 33), (23, 7), (23, 9), (24, 25), (24, 37),
(25, 17), (25, 31);

-- ==========================================================
-- 5. POBLANDO LA TABLA: collections (Historial Reciente)
-- ==========================================================
-- Fechas desde el 1 de abril de 2026 hasta el 5 de mayo de 2026.
INSERT INTO collections (truck_id, route_id, collection_date, collection_actual_weight_tons, collection_observations) VALUES
(1, 1, '2026-04-01', 8.50, 'Operación normal'),
(2, 2, '2026-04-01', 9.20, 'Exceso de residuos comerciales'),
(3, 3, '2026-04-02', 14.10, 'Ruta completada sin novedades'),
(5, 4, '2026-04-02', 11.50, 'Demora por tráfico en Av. Esperanza'),
(6, 5, '2026-04-03', 10.80, 'Todo en orden'),
(7, 6, '2026-04-03', 17.50, 'Casi al límite de capacidad'),
(8, 7, '2026-04-04', 16.20, 'Recolección nocturna fluida'),
(9, 8, '2026-04-04', 7.40, 'Menos residuos de lo esperado'),
(11, 9, '2026-04-05', 12.30, 'Sin novedad'),
(12, 10, '2026-04-05', 13.90, 'Ruta extensa pero completada'),
(13, 11, '2026-04-06', 9.10, 'Normal'),
(14, 12, '2026-04-06', 14.50, 'Zonas de difícil acceso en Ciudad Bolívar'),
(16, 13, '2026-04-07', 15.80, 'Mucho material reciclable'),
(17, 14, '2026-04-07', 8.90, 'Restricción de paso en zona histórica'),
(18, 15, '2026-04-08', 12.10, 'Normal'),
(19, 16, '2026-04-08', 9.50, 'Normal'),
(20, 17, '2026-04-09', 13.40, 'Normal'),
(21, 18, '2026-04-09', 11.20, 'Normal'),
(22, 19, '2026-04-10', 16.80, 'Alta carga en Venecia'),
(24, 20, '2026-04-10', 13.10, 'Normal'),
-- Segunda quincena de Abril
(1, 21, '2026-04-15', 8.20, 'Operación nocturna en Mártires'),
(2, 22, '2026-04-15', 9.60, 'Normal'),
(3, 23, '2026-04-16', 14.80, 'Capacidad máxima alcanzada'),
(5, 24, '2026-04-16', 11.90, 'Normal'),
(6, 25, '2026-04-17', 10.20, 'Normal'),
(7, 1, '2026-04-17', 17.10, 'Normal'),
(8, 2, '2026-04-18', 15.50, 'Normal'),
(9, 3, '2026-04-18', 7.90, 'Baja carga'),
(11, 4, '2026-04-19', 12.80, 'Normal'),
(12, 5, '2026-04-19', 13.20, 'Normal'),
(13, 6, '2026-04-20', 9.80, 'Camión con falla leve al final'),
(14, 7, '2026-04-20', 14.00, 'Lluvia intensa'),
(16, 8, '2026-04-21', 16.40, 'Normal'),
(17, 9, '2026-04-21', 8.30, 'Normal'),
(18, 10, '2026-04-22', 12.70, 'Normal'),
(19, 11, '2026-04-22', 9.90, 'Normal'),
(20, 12, '2026-04-23', 13.50, 'Normal'),
(21, 13, '2026-04-23', 11.60, 'Normal'),
(22, 14, '2026-04-24', 16.10, 'Normal'),
(24, 15, '2026-04-24', 13.40, 'Normal'),
-- Mayo 2026 (Reciente)
(25, 1, '2026-05-01', 9.30, 'Festivo: Menos basura residencial'),
(26, 2, '2026-05-01', 14.20, 'Festivo: Mucha basura en zonas comerciales'),
(27, 3, '2026-05-02', 11.10, 'Normal'),
(29, 4, '2026-05-02', 10.40, 'Normal'),
(30, 5, '2026-05-03', 13.80, 'Normal'),
(31, 6, '2026-05-03', 8.70, 'Normal'),
(32, 7, '2026-05-04', 14.40, 'Inicia semana con alta carga'),
(33, 8, '2026-05-04', 11.50, 'Normal'),
(34, 9, '2026-05-05', 17.20, 'Normal'),
(36, 10, '2026-05-05', 13.90, 'Sin novedades en Engativá');