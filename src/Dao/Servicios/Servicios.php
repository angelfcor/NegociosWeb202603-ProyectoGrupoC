<?php

namespace Dao\Servicios;

use Dao\Table;

class Servicios extends Table
{
    public static function getAll(): array
    {
        $sqlstr = "SELECT srvcod, srvnom, srvdsc, srvest,
            CASE WHEN srvest = 'ACT' THEN 'Activo'
                 WHEN srvest = 'INA' THEN 'Inactivo'
                 ELSE 'Sin Asignar' END AS srvestDsc
            FROM servicios ORDER BY srvcod";

        return self::obtenerRegistros($sqlstr);
    }

    public static function getById(int $srvcod)
    {
        return self::obtenerUnRegistro(
            "SELECT * FROM servicios WHERE srvcod = :srvcod",
            ["srvcod" => $srvcod]
        );
    }

    public static function new(
        string $srvnom,
        string $srvdsc,
        string $srvest
    ) {
        $sqlstr = "INSERT INTO servicios
            (srvnom, srvdsc, srvest)
            VALUES (:srvnom, :srvdsc, :srvest)";

        return self::executeNonQuery($sqlstr, [
            "srvnom" => $srvnom,
            "srvdsc" => $srvdsc,
            "srvest" => $srvest
        ]);
    }

    public static function update(
        string $srvnom,
        string $srvdsc,
        string $srvest,
        int $srvcod
    ) {
        $sqlstr = "UPDATE servicios SET
            srvnom = :srvnom,
            srvdsc = :srvdsc,
            srvest = :srvest
            WHERE srvcod = :srvcod";

        return self::executeNonQuery($sqlstr, [
            "srvnom" => $srvnom,
            "srvdsc" => $srvdsc,
            "srvest" => $srvest,
            "srvcod" => $srvcod
        ]);
    }

    public static function delete(int $srvcod)
    {
        return self::executeNonQuery(
            "UPDATE servicios SET srvest = 'INA'
            WHERE srvcod = :srvcod",
            ["srvcod" => $srvcod]
        );
    }

    public static function existeDuplicado(
        string $srvnom,
        int $srvcod = 0
    ): bool {
        $fila = self::obtenerUnRegistro(
            "SELECT COUNT(*) AS count FROM servicios
            WHERE srvnom = :srvnom AND srvcod <> :srvcod",
            [
                "srvnom" => $srvnom,
                "srvcod" => $srvcod
            ]
        );

        return intval($fila["count"]) > 0;
    }
}