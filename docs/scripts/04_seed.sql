-- ENCAEX Cupos: datos de prueba. TODOS LOS DATOS SON INVENTADOS (precios, capacidades, fechas).
SET NAMES utf8mb4;
USE `encaex`;

-- ---------------------------------------------------------------------------
-- Seguridad (RBAC): roles -> funciones -> usuarios
-- ---------------------------------------------------------------------------
INSERT INTO `roles` (`rolescod`, `rolesdsc`, `rolesest`) VALUES
    ('administrador', 'Administra rutas, servicios y salidas', 'ACT'),
    ('cliente', 'Cliente que reserva cupos', 'ACT');

-- fncod de un controlador = nombre completo de su clase (con namespace). Tipo CTR.
-- fncod de un item del menu = el "id" en nav.config.json. Tipo MNU.
-- Cada modulo nuevo agrega aqui sus funciones (ver CONTRIBUTING.md).
--
-- CONVENCION POR MODULO (7 filas): <Modulo>List, <Modulo>Form, INS, DSP, UPD, DEL y Menu_<Modulo>.
-- Las 4 de INS/DSP/UPD/DEL controlan los botones "Nuevo", "Ver", "Editar" y "Eliminar"
-- de la lista. Si falta alguna, ese boton no aparece (ver Controllers\<Modulo>\<Modulo>List.php).
INSERT INTO `funciones` (`fncod`, `fndsc`, `fnest`, `fntyp`) VALUES
    ('Controllers\\Rutas\\RutasList', 'Lista de rutas', 'ACT', 'CTR'),
    ('Controllers\\Rutas\\RutasForm', 'Formulario de rutas', 'ACT', 'CTR'),
    ('Controllers\\Rutas\\INS', 'Crear ruta', 'ACT', 'CTR'),
    ('Controllers\\Rutas\\DSP', 'Ver ruta', 'ACT', 'CTR'),
    ('Controllers\\Rutas\\UPD', 'Editar ruta', 'ACT', 'CTR'),
    ('Controllers\\Rutas\\DEL', 'Eliminar ruta', 'ACT', 'CTR'),
    ('Menu_Rutas', 'Menu: Rutas', 'ACT', 'MNU');

INSERT INTO `funciones_roles` (`rolescod`, `fncod`, `fnrolest`, `fnexp`) VALUES
    ('administrador', 'Controllers\\Rutas\\RutasList', 'ACT', NULL),
    ('administrador', 'Controllers\\Rutas\\RutasForm', 'ACT', NULL),
    ('administrador', 'Controllers\\Rutas\\INS', 'ACT', NULL),
    ('administrador', 'Controllers\\Rutas\\DSP', 'ACT', NULL),
    ('administrador', 'Controllers\\Rutas\\UPD', 'ACT', NULL),
    ('administrador', 'Controllers\\Rutas\\DEL', 'ACT', NULL),
    ('administrador', 'Menu_Rutas', 'ACT', NULL);

-- Usuarios de prueba. Las contrasenas dependen de PWD_HASH=ChangeThisSecretAsap en parameters.env.
--   admin@encaex.test    /  Admin#2026x
--   cliente@encaex.test  /  Cliente#2026x
INSERT INTO `usuario`
    (`useremail`, `username`, `userpswd`, `userfching`, `userpswdest`, `userpswdexp`, `userest`, `useractcod`, `userpswdchg`, `usertipo`)
VALUES
    ('admin@encaex.test', 'Admin ENCAEX', '$2y$10$4cGwfEhUTmo5ki.dIWHhy.ZJszYhDALg37eLWXLWr7dnkBDSQKJ4O', NOW(), 'ACT', '2030-01-01', 'ACT', 'seed-admin', NOW(), 'ADM'),
    ('cliente@encaex.test', 'Cliente Demo', '$2y$10$RczY2H3z7dgv9UZbz1qeU.kIe09KFvjPOeqRmjM.H4ZCi2./eFlei', NOW(), 'ACT', '2030-01-01', 'ACT', 'seed-cliente', NOW(), 'PBL');

INSERT INTO `roles_usuarios` (`usercod`, `rolescod`, `roleuserest`, `roleuserfch`, `roleuserexp`)
SELECT `usercod`, 'administrador', 'ACT', NOW(), NULL FROM `usuario` WHERE `useremail` = 'admin@encaex.test';
INSERT INTO `roles_usuarios` (`usercod`, `rolescod`, `roleuserest`, `roleuserfch`, `roleuserexp`)
SELECT `usercod`, 'cliente', 'ACT', NOW(), NULL FROM `usuario` WHERE `useremail` = 'cliente@encaex.test';

-- ---------------------------------------------------------------------------
-- Negocio: rutas, servicios y salidas (salida = fila de products)
-- ---------------------------------------------------------------------------
INSERT INTO `rutas` (`rutacod`, `rutaorigen`, `rutadestino`, `rutaest`) VALUES
    (1, 'Miami', 'San Pedro Sula', 'ACT'),
    (2, 'Miami', 'Tegucigalpa', 'ACT'),
    (3, 'San Pedro Sula', 'Tegucigalpa', 'ACT');

INSERT INTO `servicios` (`srvcod`, `srvnom`, `srvdsc`, `srvest`) VALUES
    (1, 'One Box', 'Reempaque: tus compras en linea consolidadas en una sola caja.', 'ACT'),
    (2, 'Carga consolidada', 'Carga comercial consolidada con apoyo en el proceso aduanal.', 'ACT'),
    (3, 'Distribucion nacional', 'Carga puerta a puerta entre ciudades de Honduras.', 'ACT');

-- 12 salidas = 3 servicios/rutas x 4 jueves de diciembre 2026.
-- productStock = libras disponibles; productCapacidad = libras totales; productPrice = USD por libra.
INSERT INTO `products`
    (`productName`, `productDescription`, `productPrice`, `productImgUrl`, `productStock`, `productCapacidad`, `productSalida`, `rutacod`, `srvcod`, `productStatus`)
VALUES
    ('One Box · Miami → San Pedro Sula', 'Salida semanal de One Box.', 2.50, 'public/imgs/hero/1.jpg', 520, 800, '2026-12-03 18:00:00', 1, 1, 'ACT'),
    ('One Box · Miami → San Pedro Sula', 'Salida semanal de One Box.', 2.50, 'public/imgs/hero/1.jpg', 800, 800, '2026-12-10 18:00:00', 1, 1, 'ACT'),
    ('One Box · Miami → San Pedro Sula', 'Salida semanal de One Box.', 2.50, 'public/imgs/hero/1.jpg', 800, 800, '2026-12-17 18:00:00', 1, 1, 'ACT'),
    ('One Box · Miami → San Pedro Sula', 'Salida semanal de One Box.', 2.50, 'public/imgs/hero/1.jpg', 800, 800, '2026-12-24 18:00:00', 1, 1, 'ACT'),
    ('Carga consolidada · Miami → Tegucigalpa', 'Salida semanal de carga consolidada.', 1.90, 'public/imgs/hero/2.jpg', 0, 2000, '2026-12-03 20:00:00', 2, 2, 'ACT'),
    ('Carga consolidada · Miami → Tegucigalpa', 'Salida semanal de carga consolidada.', 1.90, 'public/imgs/hero/2.jpg', 1350, 2000, '2026-12-10 20:00:00', 2, 2, 'ACT'),
    ('Carga consolidada · Miami → Tegucigalpa', 'Salida semanal de carga consolidada.', 1.90, 'public/imgs/hero/2.jpg', 2000, 2000, '2026-12-17 20:00:00', 2, 2, 'ACT'),
    ('Carga consolidada · Miami → Tegucigalpa', 'Salida semanal de carga consolidada.', 1.90, 'public/imgs/hero/2.jpg', 2000, 2000, '2026-12-24 20:00:00', 2, 2, 'ACT'),
    ('Distribucion nacional · San Pedro Sula → Tegucigalpa', 'Salida de carga nacional.', 0.85, 'public/imgs/hero/3.jpg', 1100, 1500, '2026-12-03 07:00:00', 3, 3, 'ACT'),
    ('Distribucion nacional · San Pedro Sula → Tegucigalpa', 'Salida de carga nacional.', 0.85, 'public/imgs/hero/3.jpg', 1500, 1500, '2026-12-10 07:00:00', 3, 3, 'ACT'),
    ('Distribucion nacional · San Pedro Sula → Tegucigalpa', 'Salida de carga nacional.', 0.85, 'public/imgs/hero/3.jpg', 1500, 1500, '2026-12-17 07:00:00', 3, 3, 'ACT'),
    ('Distribucion nacional · San Pedro Sula → Tegucigalpa', 'Salida de carga nacional.', 0.85, 'public/imgs/hero/3.jpg', 1500, 1500, '2026-12-24 07:00:00', 3, 3, 'ACT');
