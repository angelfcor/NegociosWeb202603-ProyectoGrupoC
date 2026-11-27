<?php

namespace Controllers\Productos;

use Controllers\PrivateController;
use Dao\Productos\Productos as DaoProductos;
use Utilities\Html;
use Views\Renderer;

class ProductosList extends PrivateController
{
    private $viewData = [];

    public function run(): void
    {
        $productos = DaoProductos::getAll();

        $this->viewData["productos"] = Html::escFilas(
            $productos,
            [
                "productName",
                "productDescription",
                "productImgUrl",
                "rutaorigen",
                "rutadestino",
                "srvnom"
            ]
        );

        $this->viewData["productosCount"] = count($productos);

        $this->viewData["create"] = $this->isFeatureAutorized(
            "Controllers\\Productos\\INS"
        );

        $this->viewData["read"] = $this->isFeatureAutorized(
            "Controllers\\Productos\\DSP"
        );

        $this->viewData["update"] = $this->isFeatureAutorized(
            "Controllers\\Productos\\UPD"
        );

        $this->viewData["delete"] = $this->isFeatureAutorized(
            "Controllers\\Productos\\DEL"
        );

        Renderer::render(
            "productos/productosList",
            $this->viewData
        );
    }
}
