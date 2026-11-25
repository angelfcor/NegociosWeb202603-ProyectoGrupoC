SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS `encaex` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `encaex`;

CREATE TABLE
    `usuario` (
        `usercod` bigint(10) NOT NULL AUTO_INCREMENT,
        `useremail` varchar(80) DEFAULT NULL,
        `username` varchar(80) DEFAULT NULL,
        `userpswd` varchar(128) DEFAULT NULL,
        `userfching` datetime DEFAULT NULL,
        `userpswdest` char(3) DEFAULT NULL,
        `userpswdexp` datetime DEFAULT NULL,
        `userest` char(3) DEFAULT NULL,
        `useractcod` varchar(128) DEFAULT NULL,
        `userpswdchg` varchar(128) DEFAULT NULL,
        `usertipo` char(3) DEFAULT NULL COMMENT 'Tipo de Usuario, Normal, Consultor o Cliente',
        PRIMARY KEY (`usercod`),
        UNIQUE KEY `useremail_UNIQUE` (`useremail`),
        KEY `usertipo` (
            `usertipo`,
            `useremail`,
            `usercod`,
            `userest`
        )
    ) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8;

CREATE TABLE
    `roles` (
        `rolescod` varchar(128) NOT NULL,
        `rolesdsc` varchar(45) DEFAULT NULL,
        `rolesest` char(3) DEFAULT NULL,
        PRIMARY KEY (`rolescod`)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE
    `roles_usuarios` (
        `usercod` bigint(10) NOT NULL,
        `rolescod` varchar(128) NOT NULL,
        `roleuserest` char(3) DEFAULT NULL,
        `roleuserfch` datetime DEFAULT NULL,
        `roleuserexp` datetime DEFAULT NULL,
        PRIMARY KEY (`usercod`, `rolescod`),
        KEY `rol_usuario_key_idx` (`rolescod`),
        CONSTRAINT `rol_usuario_key` FOREIGN KEY (`rolescod`) REFERENCES `roles` (`rolescod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
        CONSTRAINT `usuario_rol_key` FOREIGN KEY (`usercod`) REFERENCES `usuario` (`usercod`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE
    `funciones` (
        `fncod` varchar(255) NOT NULL,
        `fndsc` varchar(255) DEFAULT NULL,
        `fnest` char(3) DEFAULT NULL,
        `fntyp` char(3) DEFAULT NULL,
        PRIMARY KEY (`fncod`)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE
    `funciones_roles` (
        `rolescod` varchar(128) NOT NULL,
        `fncod` varchar(255) NOT NULL,
        `fnrolest` char(3) DEFAULT NULL,
        `fnexp` datetime DEFAULT NULL,
        PRIMARY KEY (`rolescod`, `fncod`),
        KEY `rol_funcion_key_idx` (`fncod`),
        CONSTRAINT `funcion_rol_key` FOREIGN KEY (`rolescod`) REFERENCES `roles` (`rolescod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
        CONSTRAINT `rol_funcion_key` FOREIGN KEY (`fncod`) REFERENCES `funciones` (`fncod`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE
    `bitacora` (
        `bitacoracod` int(11) NOT NULL AUTO_INCREMENT,
        `bitacorafch` datetime DEFAULT NULL,
        `bitprograma` varchar(255) DEFAULT NULL,
        `bitdescripcion` varchar(255) DEFAULT NULL,
        `bitobservacion` mediumtext,
        `bitTipo` char(3) DEFAULT NULL,
        `bitusuario` bigint(18) DEFAULT NULL,
        PRIMARY KEY (`bitacoracod`)
    ) ENGINE = InnoDB AUTO_INCREMENT = 10 DEFAULT CHARSET = utf8;

-- ENCAEX: corregido en carretillaanom -> (1) productId es int(11) como products (la FK con bigint fallaba),
-- (2) el nombre es 'anom' porque asi lo consulta src/Dao/Cart/Cart.php.
CREATE TABLE
    `products` (
        `productId` int(11) NOT NULL AUTO_INCREMENT,
        `productName` varchar(255) NOT NULL,
        `productDescription` text NOT NULL,
        `productPrice` decimal(10, 2) NOT NULL,
        `productImgUrl` varchar(255) NOT NULL,
        `productStock` int(11) NOT NULL DEFAULT 0,
        `productStatus` char(3) NOT NULL,
        PRIMARY KEY (`productId`)
    ) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

CREATE TABLE
    `carretilla` (
        `usercod` BIGINT(10) NOT NULL,
        `productId` int(11) NOT NULL,
        `crrctd` INT(5) NOT NULL,
        `crrprc` DECIMAL(12, 2) NOT NULL,
        `crrfching` DATETIME NOT NULL,
        PRIMARY KEY (`usercod`, `productId`),
        INDEX `productId_idx` (`productId` ASC),
        CONSTRAINT `carretilla_user_key` FOREIGN KEY (`usercod`) REFERENCES `usuario` (`usercod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
        CONSTRAINT `carretilla_prd_key` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`) ON DELETE NO ACTION ON UPDATE NO ACTION
    );

CREATE TABLE
    `carretillaanom` (
        `anoncod` varchar(128) NOT NULL,
        `productId` int(11) NOT NULL,
        `crrctd` int(5) NOT NULL,
        `crrprc` decimal(12, 2) NOT NULL,
        `crrfching` datetime NOT NULL,
        PRIMARY KEY (`anoncod`, `productId`),
        KEY `productId_idx` (`productId`),
        CONSTRAINT `carretillaanom_prd_key` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`) ON DELETE NO ACTION ON UPDATE NO ACTION
    );

USE `encaex`;

-- Rutas: origen y destino de una salida. Ej.: Miami -> San Pedro Sula.
CREATE TABLE
    `rutas` (
        `rutacod` int(11) NOT NULL AUTO_INCREMENT,
        `rutaorigen` varchar(80) NOT NULL,
        `rutadestino` varchar(80) NOT NULL,
        `rutaest` char(3) NOT NULL DEFAULT 'ACT',
        `rutafch` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`rutacod`),
        UNIQUE KEY `ruta_origen_destino_UNIQUE` (`rutaorigen`, `rutadestino`)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Servicios: tipo de servicio que se vende (One Box, Carga consolidada...).
CREATE TABLE
    `servicios` (
        `srvcod` int(11) NOT NULL AUTO_INCREMENT,
        `srvnom` varchar(80) NOT NULL,
        `srvdsc` varchar(255) DEFAULT NULL,
        `srvest` char(3) NOT NULL DEFAULT 'ACT',
        PRIMARY KEY (`srvcod`),
        UNIQUE KEY `srvnom_UNIQUE` (`srvnom`)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- DECISION DE DISENO: una "salida" ES una fila de `products`.
--   productStock     = libras disponibles (cupo restante)   <- la "capacidad limitada"
--   productCapacidad = libras totales de la salida
--   productPrice     = precio por libra
ALTER TABLE `products`
    ADD COLUMN `productCapacidad` int(11) NOT NULL DEFAULT 0 AFTER `productStock`,
    ADD COLUMN `productSalida` datetime NULL AFTER `productCapacidad`,
    ADD COLUMN `rutacod` int(11) NULL AFTER `productSalida`,
    ADD COLUMN `srvcod` int(11) NULL AFTER `rutacod`,
    ADD KEY `products_ruta_idx` (`rutacod`),
    ADD KEY `products_srv_idx` (`srvcod`),
    ADD CONSTRAINT `products_ruta_key` FOREIGN KEY (`rutacod`) REFERENCES `rutas` (`rutacod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `products_srv_key` FOREIGN KEY (`srvcod`) REFERENCES `servicios` (`srvcod`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ENCAEX Cupos: datos de prueba. TODOS LOS DATOS SON INVENTADOS (precios, capacidades, fechas).
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