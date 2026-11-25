<?php

namespace Utilities;

/**
 * Escape de salida.
 *
 * El Renderer de la plantilla NO escapa HTML: {{variable}} se imprime tal cual.
 * Todo texto que venga de la base de datos o del usuario debe pasar por aqui
 * en el CONTROLADOR antes de enviarse a la vista (evita XSS).
 * No lo apliques a HTML que tu propio codigo genera (ej. la paginacion).
 */
class Html
{
    public static function esc($valor): string
    {
        return htmlspecialchars((string) $valor, ENT_QUOTES, 'UTF-8');
    }

    /**
     * Escapa los campos indicados de cada fila de un arreglo de registros.
     *
     * @param array $filas   Registros (arreglos asociativos)
     * @param array $campos  Nombres de las columnas de texto a escapar
     */
    public static function escFilas(array $filas, array $campos): array
    {
        foreach ($filas as &$fila) {
            foreach ($campos as $campo) {
                if (isset($fila[$campo])) {
                    $fila[$campo] = self::esc($fila[$campo]);
                }
            }
        }
        unset($fila);
        return $filas;
    }

    private function __construct()
    {
    }
}
