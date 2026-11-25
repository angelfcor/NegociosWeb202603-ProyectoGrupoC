<?php

namespace Dao\Rutas;

use Dao\Table;

const RUTAS_SELECT_COLUMNS = "rutacod, rutaorigen, rutadestino, rutaest, rutafch,
    case when rutaest = 'ACT' then 'Activa'
         when rutaest = 'INA' then 'Inactiva'
         else 'Sin Asignar' end as rutaestDsc";
const RUTAS_SELECT_ALL = "SELECT " . RUTAS_SELECT_COLUMNS . " FROM rutas";
const RUTAS_SELECT_BY_ID = "SELECT " . RUTAS_SELECT_COLUMNS . " FROM rutas WHERE rutacod = :rutacod;";
const RUTAS_INSERT = "INSERT INTO rutas (rutaorigen, rutadestino, rutaest, rutafch) VALUES (:rutaorigen, :rutadestino, :rutaest, NOW());";
const RUTAS_UPDATE = "UPDATE rutas SET rutaorigen = :rutaorigen, rutadestino = :rutadestino, rutaest = :rutaest WHERE rutacod = :rutacod;";
const RUTAS_DELETE = "UPDATE rutas SET rutaest = 'INA' WHERE rutacod = :rutacod;";

class Rutas extends Table
{
    private function __construct()
    {
        throw new \Exception('Not implemented');
    }
    private function __clone()
    {
        throw new \Exception('Not implemented');
    }

    public static function getAll(): array
    {
        return self::obtenerRegistros(RUTAS_SELECT_ALL);
    }

    public static function getAllPaginated(
        string $partialName = "",
        string $status = "",
        string $orderBy = "",
        bool $orderDescending = false,
        int $page = 0,
        int $itemsPerPage = 10
    ): array {
        $sqlstr = "SELECT " . RUTAS_SELECT_COLUMNS . " FROM rutas";
        $sqlstrCount = "SELECT COUNT(*) as count FROM rutas";
        $conditions = [];
        $params = [];
        if ($partialName != "") {
            $conditions[] = "(rutaorigen LIKE :partialOrigen OR rutadestino LIKE :partialDestino)";
            $params["partialOrigen"] = "%" . $partialName . "%";
            $params["partialDestino"] = "%" . $partialName . "%";
        }
        if (!in_array($status, ["ACT", "INA", ""])) {
            throw new \Exception("Error Processing Request Status has invalid value");
        }
        if ($status != "") {
            $conditions[] = "rutaest = :status";
            $params["status"] = $status;
        }
        if (count($conditions) > 0) {
            $sqlstr .= " WHERE " . implode(" AND ", $conditions);
            $sqlstrCount .= " WHERE " . implode(" AND ", $conditions);
        }
        if (!in_array($orderBy, ["rutacod", "rutaorigen", "rutadestino", ""])) {
            throw new \Exception("Error Processing Request OrderBy has invalid value");
        }
        if ($orderBy != "") {
            $sqlstr .= " ORDER BY " . $orderBy;
            if ($orderDescending) {
                $sqlstr .= " DESC";
            }
        }
        $numeroDeRegistros = self::obtenerUnRegistro($sqlstrCount, $params)["count"];
        $pagesCount = ceil($numeroDeRegistros / $itemsPerPage);
        if ($page > $pagesCount - 1) {
            $page = $pagesCount - 1;
        }
        if ($page < 0) {
            $page = 0;
        }
        $sqlstr .= " LIMIT :desde, :items;";
        $params["desde"] = (int)($page * $itemsPerPage);
        $params["items"] = (int)$itemsPerPage;
        $registros = self::obtenerRegistros($sqlstr, $params);
        return [
            "rutas" => $registros,
            "total" => $numeroDeRegistros,
            "page" => $page,
            "itemsPerPage" => $itemsPerPage
        ];
    }

    public static function getById(int $rutacod)
    {
        return self::obtenerUnRegistro(
            RUTAS_SELECT_BY_ID,
            [
                "rutacod" => $rutacod
            ]
        );
    }

    public static function new(
        string $rutaorigen,
        string $rutadestino,
        string $rutaest = "ACT"
    ) {
        return self::executeNonQuery(
            RUTAS_INSERT,
            [
                "rutaorigen" => $rutaorigen,
                "rutadestino" => $rutadestino,
                "rutaest" => $rutaest
            ]
        );
    }

    public static function update(
        string $rutaorigen,
        string $rutadestino,
        string $rutaest,
        int $rutacod
    ) {
        return self::executeNonQuery(
            RUTAS_UPDATE,
            [
                "rutaorigen" => $rutaorigen,
                "rutadestino" => $rutadestino,
                "rutaest" => $rutaest,
                "rutacod" => $rutacod
            ]
        );
    }

    public static function delete(int $rutacod)
    {
        return self::executeNonQuery(
            RUTAS_DELETE,
            [
                "rutacod" => $rutacod
            ]
        );
    }

    public static function existeDuplicado(string $rutaorigen, string $rutadestino, int $rutacod = 0): bool
    {
        $fila = self::obtenerUnRegistro(
            "SELECT COUNT(*) as count FROM rutas
             WHERE rutaorigen = :rutaorigen AND rutadestino = :rutadestino AND rutacod <> :rutacod;",
            [
                "rutaorigen" => $rutaorigen,
                "rutadestino" => $rutadestino,
                "rutacod" => $rutacod
            ]
        );
        return intval($fila["count"]) > 0;
    }
}
