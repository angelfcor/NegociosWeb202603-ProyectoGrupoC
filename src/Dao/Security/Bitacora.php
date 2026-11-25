<?php

namespace Dao\Security;

/**
 * Stub de la bitacora de auditoria.
 *
 * La tabla `bitacora` ya existe en la base de datos (ver docs/scripts/01_security.sql),
 * pero todavia NO se ha visto en clase, por lo que NO se implementa un modulo completo.
 *
 * Solo se deja este stub para que cualquier referencia a Bitacora::log() no
 * provoque un error fatal. Cuando se implemente la bitacora, este metodo debe:
 *   1. Insertar en `bitacora` (bitacorafch, bitprograma, bitdescripcion,
 *      bitobservacion, bitTipo, bitusuario).
 *   2. Devolver true en caso de exito y false en caso de error.
 *
 * La implementacion real es trabajo del equipo (tarea de Seguridad).
 */
class Bitacora extends \Dao\Table
{
    public static function log(...$args):bool
    {
        // Sin implementacion: la bitacora es un stub en esta etapa.
        return true;
    }
}
