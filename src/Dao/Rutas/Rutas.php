<?php

namespace Dao\Rutas;

use Dao\Table;

/**
 * DAO de la tabla `rutas`  (MODELO de referencia: copiar este patron en otros modulos).
 *
 * Reglas del DAO:
 *  - Solo habla con la base de datos. Nunca imprime HTML ni lee $_GET/$_POST.
 *  - Todas las consultas usan parametros (:nombre), jamas variables dentro del SQL.
 *  - Devuelve arreglos; el controlador decide que hacer con ellos.
 *
 * Tabla:
 *  rutacod (PK), rutaorigen, rutadestino, rutaest (ACT|INA), rutafch
 *
 * CONVENCION DE NOMBRES (igual que el DAO de referencia del docente):
 *    getAll()   -> lista todos los registros
 *    getById()  -> un registro por su PK
 *    new()      -> inserta
 *    update()   -> actualiza
 *    delete()   -> da de baja  (en este caso BAJA LOGICA, ver nota abajo)
 *
 * BAJA LOGICA: `rutas` es referenciada por `products.rutacod` con ON DELETE NO ACTION,
 * por lo que un DELETE fisico falla con error 1451. Por eso delete() marca
 * rutaest = 'INA'. Lo mismo aplica a `servicios`.
 */
class Rutas extends Table
{
    /**
     * Todas las rutas, ordenadas por origen y destino.
     * @return array
     */
    public static function getAll(): array
    {
        $sql = "SELECT rutacod, rutaorigen, rutadestino, rutaest, rutafch
                FROM rutas
                ORDER BY rutaorigen, rutadestino;";
        return self::obtenerRegistros($sql, array());
    }

    /**
     * Una ruta por su codigo.
     * @param int $rutacod
     * @return array|false
     */
    public static function getById(int $rutacod)
    {
        return self::obtenerUnRegistro(
            "SELECT rutacod, rutaorigen, rutadestino, rutaest, rutafch
             FROM rutas WHERE rutacod = :rutacod;",
            array("rutacod" => $rutacod)
        );
    }

    /**
     * Inserta una ruta nueva.
     * @param string $origen
     * @param string $destino
     * @param string $estado
     * @return bool
     */
    public static function new(string $origen, string $destino, string $estado = "ACT"): bool
    {
        return self::executeNonQuery(
            "INSERT INTO rutas (rutaorigen, rutadestino, rutaest, rutafch)
             VALUES (:origen, :destino, :estado, NOW());",
            array("origen" => $origen, "destino" => $destino, "estado" => $estado)
        );
    }

    /**
     * Actualiza una ruta.
     * @param int $rutacod
     * @param string $origen
     * @param string $destino
     * @param string $estado
     * @return bool
     */
    public static function update(int $rutacod, string $origen, string $destino, string $estado): bool
    {
        return self::executeNonQuery(
            "UPDATE rutas
             SET rutaorigen = :origen, rutadestino = :destino, rutaest = :estado
             WHERE rutacod = :rutacod;",
            array(
                "origen" => $origen,
                "destino" => $destino,
                "estado" => $estado,
                "rutacod" => $rutacod
            )
        );
    }

    /**
     * Baja logica: no se borra la fila porque las salidas la referencian (FK).
     * @param int $rutacod
     * @return bool
     */
    public static function delete(int $rutacod): bool
    {
        return self::executeNonQuery(
            "UPDATE rutas SET rutaest = 'INA' WHERE rutacod = :rutacod;",
            array("rutacod" => $rutacod)
        );
    }

    /**
     * Verifica si ya existe una ruta con el mismo origen y destino.
     * La tabla tiene UNIQUE (rutaorigen, rutadestino), asi que el formulario
     * debe validar esto antes de insertar o actualizar.
     *
     * @param string $origen
     * @param string $destino
     * @param int $rutacod  Codigo a excluir (cuando se edita una ruta existente)
     * @return bool
     */
    public static function existeDuplicado(string $origen, string $destino, int $rutacod = 0): bool
    {
        $fila = self::obtenerUnRegistro(
            "SELECT COUNT(*) AS total FROM rutas
             WHERE rutaorigen = :origen AND rutadestino = :destino AND rutacod <> :rutacod;",
            array("origen" => $origen, "destino" => $destino, "rutacod" => $rutacod)
        );
        return intval($fila["total"]) > 0;
    }

    /** Cantidad de rutas activas e inactivas (para la paginacion). */
    public static function contar(): int
    {
        $fila = self::obtenerUnRegistro("SELECT COUNT(*) AS total FROM rutas;", array());
        return intval($fila["total"]);
    }

    /**
     * Una pagina de rutas.
     *
     * @param int $pagina Numero de pagina, desde 1
     * @param int $items  Registros por pagina
     */
    public static function obtenerPagina(int $pagina, int $items): array
    {
        $sql = "SELECT rutacod, rutaorigen, rutadestino, rutaest, rutafch
                FROM rutas
                ORDER BY rutaorigen, rutadestino
                LIMIT :desde, :items;";
        return self::obtenerRegistros(
            $sql,
            array("desde" => ($pagina - 1) * $items, "items" => $items)
        );
    }

    /* ------------------------------------------------------------------
     * Alias de compatibilidad con la version anterior de este DAO.
     * Se pueden borrar cuando ningun modulo los use.
     * ------------------------------------------------------------------ */

    /** @deprecated Usar getById() */
    public static function obtenerPorId(int $rutacod)
    {
        return self::getById($rutacod);
    }

    /** @deprecated Usar new() */
    public static function insertar(string $origen, string $destino, string $estado = "ACT")
    {
        return self::new($origen, $destino, $estado);
    }

    /** @deprecated Usar update() */
    public static function actualizar(int $rutacod, string $origen, string $destino, string $estado)
    {
        return self::update($rutacod, $origen, $destino, $estado);
    }

    /** @deprecated Usar delete() */
    public static function desactivar(int $rutacod)
    {
        return self::delete($rutacod);
    }

    private function __construct()
    {
    }
}
