<?php

namespace Controllers\Rutas;

use Controllers\PrivateController;
use Dao\Rutas\Rutas as DaoRutas;
use Utilities\Context;
use Utilities\Html;
use Utilities\Paging;
use Views\Renderer;

const RUTAS_LIST_VIEW = "rutas/rutasList";
const RUTAS_CRUD_C = "Controllers\\Rutas\\INS";
const RUTAS_CRUD_R = "Controllers\\Rutas\\DSP";
const RUTAS_CRUD_U = "Controllers\\Rutas\\UPD";
const RUTAS_CRUD_D = "Controllers\\Rutas\\DEL";

class RutasList extends PrivateController
{
    private $partialName = "";
    private $status = "";
    private $orderBy = "";
    private $orderDescending = false;
    private $pageNumber = 1;
    private $itemsPerPage = 10;
    private $viewData = [];
    private $rutas = [];
    private $rutasCount = 0;
    private $pages = 0;

    public function run(): void
    {
        $this->getParamsFromContext();
        $this->getParams();
        $tmpRutas = DaoRutas::getAllPaginated(
            $this->partialName,
            $this->status,
            $this->orderBy,
            $this->orderDescending,
            $this->pageNumber - 1,
            $this->itemsPerPage
        );
        $this->rutas = Html::escFilas($tmpRutas["rutas"], array("rutaorigen", "rutadestino"));
        $this->rutasCount = $tmpRutas["total"];
        $this->pages = $this->rutasCount > 0 ? (int)ceil($this->rutasCount / $this->itemsPerPage) : 1;
        if ($this->pageNumber > $this->pages) {
            $this->pageNumber = $this->pages;
        }
        $this->setParamsToContext();
        $this->setParamsToDataView();
        Renderer::render(RUTAS_LIST_VIEW, $this->viewData);
    }

    private function getParams(): void
    {
        $this->partialName = isset($_GET["partialName"]) ? trim($_GET["partialName"]) : $this->partialName;
        $this->status = isset($_GET["status"]) && in_array($_GET["status"], ["ACT", "INA", "EMP"]) ? $_GET["status"] : $this->status;
        if ($this->status === "EMP") {
            $this->status = "";
        }
        $this->orderBy = isset($_GET["orderBy"]) && in_array($_GET["orderBy"], ["rutacod", "rutaorigen", "rutadestino", "clear"]) ? $_GET["orderBy"] : $this->orderBy;
        if ($this->orderBy === "clear") {
            $this->orderBy = "";
        }
        $this->orderDescending = isset($_GET["orderDescending"]) ? boolval($_GET["orderDescending"]) : $this->orderDescending;
        $this->pageNumber = isset($_GET["pageNum"]) ? intval($_GET["pageNum"]) : $this->pageNumber;
        $this->itemsPerPage = isset($_GET["itemsPerPage"]) ? intval($_GET["itemsPerPage"]) : $this->itemsPerPage;
        if ($this->itemsPerPage < 1) {
            $this->itemsPerPage = 10;
        }
    }

    private function getParamsFromContext(): void
    {
        $this->partialName = Context::getContextByKey("rutas_partialName");
        $this->status = Context::getContextByKey("rutas_status");
        $this->orderBy = Context::getContextByKey("rutas_orderBy");
        $this->orderDescending = boolval(Context::getContextByKey("rutas_orderDescending"));
        $this->pageNumber = intval(Context::getContextByKey("rutas_page"));
        $this->itemsPerPage = intval(Context::getContextByKey("rutas_itemsPerPage"));
        if ($this->pageNumber < 1) {
            $this->pageNumber = 1;
        }
        if ($this->itemsPerPage < 1) {
            $this->itemsPerPage = 10;
        }
    }

    private function setParamsToContext(): void
    {
        Context::setContext("rutas_partialName", $this->partialName, true);
        Context::setContext("rutas_status", $this->status, true);
        Context::setContext("rutas_orderBy", $this->orderBy, true);
        Context::setContext("rutas_orderDescending", $this->orderDescending, true);
        Context::setContext("rutas_page", $this->pageNumber, true);
        Context::setContext("rutas_itemsPerPage", $this->itemsPerPage, true);
    }

    private function setParamsToDataView(): void
    {
        $this->viewData["partialName"] = Html::esc($this->partialName);
        $this->viewData["status"] = $this->status;
        $this->viewData["orderBy"] = $this->orderBy;
        $this->viewData["orderDescending"] = $this->orderDescending;
        $this->viewData["pageNum"] = $this->pageNumber;
        $this->viewData["itemsPerPage"] = $this->itemsPerPage;
        $this->viewData["rutasCount"] = $this->rutasCount;
        $this->viewData["pages"] = $this->pages;
        $this->viewData["rutas"] = $this->rutas;
        if ($this->orderBy !== "") {
            $orderByKey = "Order" . ucfirst($this->orderBy);
            if ($this->orderDescending) {
                $orderByKey .= "Desc";
            }
            $this->viewData[$orderByKey] = true;
        }
        $sortableColumns = array(
            "rutacod" => "Rutacod",
            "rutaorigen" => "Rutaorigen",
            "rutadestino" => "Rutadestino"
        );
        foreach ($sortableColumns as $column => $flag) {
            $this->viewData["OrderBy" . $flag] = ($this->orderBy === $column);
        }
        $statusKey = "status_" . ($this->status === "" ? "EMP" : $this->status);
        $this->viewData[$statusKey] = "selected";
        $this->viewData["create"] = $this->isFeatureAutorized(RUTAS_CRUD_C);
        $this->viewData["read"] = $this->isFeatureAutorized(RUTAS_CRUD_R);
        $this->viewData["update"] = $this->isFeatureAutorized(RUTAS_CRUD_U);
        $this->viewData["delete"] = $this->isFeatureAutorized(RUTAS_CRUD_D);
        $this->viewData["pagination"] = Paging::getPagination(
            $this->rutasCount,
            $this->itemsPerPage,
            $this->pageNumber,
            "index.php?page=Rutas_RutasList",
            "Rutas_RutasList"
        );
    }
}
