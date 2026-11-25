<?php

namespace Controllers\Rutas;

use Controllers\PrivateController;
use Dao\Rutas\Rutas as DaoRutas;
use Utilities\Html;
use Utilities\Paging;
use Views\Renderer;

/**
 * Lista de rutas  (CONTROLADOR LIST de referencia: copiar este patron en otros modulos).
 *
 * URL:  index.php?page=Rutas_RutasList
 *
 * Patron del proyecto (List + Form):
 *   - <Modulo>List.php  -> este archivo: muestra la tabla paginada con los botones
 *                          de accion segun los permisos del usuario.
 *   - <Modulo>Form.php  -> lo hace otra persona del equipo (tarea 3).
 *
 * Reglas del controlador:
 *  - Hereda de PrivateController (exige sesion y que el rol del usuario tenga
 *    permiso sobre ESTA clase en la tabla funciones_roles).
 *  - Lee la peticion ($_GET / $_POST), pide datos al DAO, prepara $viewData y
 *    llama a Renderer::render(). Nunca escribe SQL ni arma HTML a mano.
 */
class RutasList extends PrivateController
{
    private const ITEMS_VALIDOS = array(1, 5, 10, 20, 50, 100);

    const RUTAS_LIST_VIEW = "rutas/rutasList";

    // Permisos CRUD (uno por modo). Deben existir en la tabla `funciones`.
    const RUTAS_CRUD_C = "Controllers\\Rutas\\INS";
    const RUTAS_CRUD_R = "Controllers\\Rutas\\DSP";
    const RUTAS_CRUD_U = "Controllers\\Rutas\\UPD";
    const RUTAS_CRUD_D = "Controllers\\Rutas\\DEL";

    public function run(): void
    {
        // 1. Leer y validar parametros de la URL (nunca confiar en ellos).
        $items = isset($_GET["itemsPerPage"]) ? intval($_GET["itemsPerPage"]) : 10;
        if (!in_array($items, self::ITEMS_VALIDOS, true)) {
            $items = 10;
        }
        $total = DaoRutas::contar();
        $totalPaginas = max(1, intval(ceil($total / $items)));
        $pagina = isset($_GET["pageNum"]) ? intval($_GET["pageNum"]) : 1;
        $pagina = min(max(1, $pagina), $totalPaginas);

        // 2. Pedir datos al DAO.
        $rutas = DaoRutas::obtenerPagina($pagina, $items);

        // 3. Preparar datos de la vista (escapando el texto que viene de la BD).
        $rutas = Html::escFilas($rutas, array("rutaorigen", "rutadestino"));
        foreach ($rutas as &$ruta) {
            $ruta["estadoTexto"] = $ruta["rutaest"] === "ACT" ? "Activa" : "Inactiva";
        }
        unset($ruta);

        $viewData = array(
            "rutas" => $rutas,
            "hayRutas" => count($rutas) > 0,
            "totalRutas" => $total,
            "paginacion" => Paging::getPagination(
                $total,
                $items,
                $pagina,
                "index.php?page=Rutas_RutasList",
                "Rutas_RutasList"
            ),
            // Flags de permisos: la vista decide que botones mostrar.
            "create" => $this->isFeatureAutorized(self::RUTAS_CRUD_C),
            "read" => $this->isFeatureAutorized(self::RUTAS_CRUD_R),
            "update" => $this->isFeatureAutorized(self::RUTAS_CRUD_U),
            "delete" => $this->isFeatureAutorized(self::RUTAS_CRUD_D)
        );

        // 4. Renderizar: src/Views/templates/rutas/rutasList.view.tpl
        Renderer::render(self::RUTAS_LIST_VIEW, $viewData);
    }
}
