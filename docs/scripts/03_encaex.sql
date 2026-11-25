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
