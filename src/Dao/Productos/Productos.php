<?php

namespace Dao\Productos;

use Dao\Table;

class Productos extends Table
{
    public static function getAll(): array
    {
        $sqlstr = "SELECT
            p.productId,
            p.productName,
            p.productDescription,
            p.productPrice,
            p.productImgUrl,
            p.productStock,
            p.productCapacidad,
            p.productSalida,
            p.rutacod,
            p.srvcod,
            p.productStatus,
            r.rutaorigen,
            r.rutadestino,
            s.srvnom,
            CASE
                WHEN p.productStatus = 'ACT' THEN 'Activo'
                WHEN p.productStatus = 'INA' THEN 'Inactivo'
                ELSE 'Sin asignar'
            END AS productStatusDsc
            FROM products p
            LEFT JOIN rutas r ON p.rutacod = r.rutacod
            LEFT JOIN servicios s ON p.srvcod = s.srvcod
            ORDER BY p.productSalida ASC";

        return self::obtenerRegistros($sqlstr);
    }

    public static function getById(int $productId)
    {
        return self::obtenerUnRegistro(
            "SELECT * FROM products
             WHERE productId = :productId",
            ["productId" => $productId]
        );
    }

    public static function new(
        string $productName,
        string $productDescription,
        float $productPrice,
        string $productImgUrl,
        int $productStock,
        int $productCapacidad,
        string $productSalida,
        int $rutacod,
        int $srvcod,
        string $productStatus
    ) {
        $sqlstr = "INSERT INTO products (
            productName,
            productDescription,
            productPrice,
            productImgUrl,
            productStock,
            productCapacidad,
            productSalida,
            rutacod,
            srvcod,
            productStatus
        ) VALUES (
            :productName,
            :productDescription,
            :productPrice,
            :productImgUrl,
            :productStock,
            :productCapacidad,
            :productSalida,
            :rutacod,
            :srvcod,
            :productStatus
        )";

        return self::executeNonQuery($sqlstr, [
            "productName" => $productName,
            "productDescription" => $productDescription,
            "productPrice" => $productPrice,
            "productImgUrl" => $productImgUrl,
            "productStock" => $productStock,
            "productCapacidad" => $productCapacidad,
            "productSalida" => $productSalida,
            "rutacod" => $rutacod,
            "srvcod" => $srvcod,
            "productStatus" => $productStatus
        ]);
    }

    public static function update(
        string $productName,
        string $productDescription,
        float $productPrice,
        string $productImgUrl,
        int $productStock,
        int $productCapacidad,
        string $productSalida,
        int $rutacod,
        int $srvcod,
        string $productStatus,
        int $productId
    ) {
        $sqlstr = "UPDATE products SET
            productName = :productName,
            productDescription = :productDescription,
            productPrice = :productPrice,
            productImgUrl = :productImgUrl,
            productStock = :productStock,
            productCapacidad = :productCapacidad,
            productSalida = :productSalida,
            rutacod = :rutacod,
            srvcod = :srvcod,
            productStatus = :productStatus
            WHERE productId = :productId";

        return self::executeNonQuery($sqlstr, [
            "productName" => $productName,
            "productDescription" => $productDescription,
            "productPrice" => $productPrice,
            "productImgUrl" => $productImgUrl,
            "productStock" => $productStock,
            "productCapacidad" => $productCapacidad,
            "productSalida" => $productSalida,
            "rutacod" => $rutacod,
            "srvcod" => $srvcod,
            "productStatus" => $productStatus,
            "productId" => $productId
        ]);
    }

    // Eliminación definitiva del producto
    public static function delete(int $productId)
    {
        return self::executeNonQuery(
            "DELETE FROM products
             WHERE productId = :productId",
            ["productId" => $productId]
        );
    }

    public static function getRutas(): array
    {
        return self::obtenerRegistros(
            "SELECT rutacod, rutaorigen, rutadestino
             FROM rutas
             WHERE rutaest = 'ACT'
             ORDER BY rutaorigen"
        );
    }

    public static function getServicios(): array
    {
        return self::obtenerRegistros(
            "SELECT srvcod, srvnom
             FROM servicios
             WHERE srvest = 'ACT'
             ORDER BY srvnom"
        );
    }
}
