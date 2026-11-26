<?php

namespace Controllers\Servicios;

use Controllers\PrivateController;
use Dao\Servicios\Servicios as DaoServicios;
use Utilities\Html;
use Views\Renderer;

class ServiciosList extends PrivateController
{
    private $viewData = [];

    public function run(): void
    {
        $servicios = DaoServicios::getAll();

        foreach ($servicios as &$servicio) {
            $servicio["srvdsc"] = $servicio["srvdsc"] ?? "";
        }

        unset($servicio);

        $this->viewData["servicios"] = Html::escFilas(
            $servicios,
            ["srvnom", "srvdsc"]
        );

        $this->viewData["serviciosCount"] = count($servicios);

        $this->viewData["create"] = $this->isFeatureAutorized(
            "Controllers\\Servicios\\INS"
        );

        $this->viewData["read"] = $this->isFeatureAutorized(
            "Controllers\\Servicios\\DSP"
        );

        $this->viewData["update"] = $this->isFeatureAutorized(
            "Controllers\\Servicios\\UPD"
        );

        $this->viewData["delete"] = $this->isFeatureAutorized(
            "Controllers\\Servicios\\DEL"
        );

        Renderer::render(
            "servicios/serviciosList",
            $this->viewData
        );
    }
}