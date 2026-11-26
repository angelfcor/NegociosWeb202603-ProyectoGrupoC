<?php

namespace Controllers\Servicios;

use Controllers\PrivateController;
use Controllers\PrivateNoAuthException;
use Dao\Servicios\Servicios as DaoServicios;
use Utilities\Site;
use Utilities\Html;
use Views\Renderer;

class ServiciosForm extends PrivateController
{
    private $viewData = [];
    private $srvcod = 0;
    private $srvnom = "";
    private $srvdsc = "";
    private $srvest = "ACT";
    private $mode = "";
    private $error = "";

    private $modeDscArr = [
        "INS" => "Crear nuevo servicio",
        "DSP" => "Consultar servicio",
        "UPD" => "Actualizar servicio",
        "DEL" => "Eliminar servicio"
    ];

    public function run(): void
    {
        $this->getQueryParams();

        if ($this->isPostBack()) {
            $this->getPostBody();

            if ($this->validatePostBody()) {
                $this->processPostBody();
            }
        }

        $this->prepareViewData();

        Renderer::render(
            "servicios/serviciosForm",
            $this->viewData
        );
    }

    private function getQueryParams(): void
    {
        $this->mode = $_GET["mode"] ?? "";

        if (!isset($this->modeDscArr[$this->mode])) {
            Site::redirectToWithMsg(
                "index.php?page=Servicios_ServiciosList",
                "Modo no valido"
            );
        }

        if (!$this->isFeatureAutorized(
            "Controllers\\Servicios\\" . $this->mode
        )) {
            throw new PrivateNoAuthException();
        }

        if ($this->mode !== "INS") {
            $this->srvcod = intval($_GET["srvcod"] ?? 0);

            $servicio = DaoServicios::getById($this->srvcod);

            if (!$servicio) {
                Site::redirectToWithMsg(
                    "index.php?page=Servicios_ServiciosList",
                    "El servicio no existe"
                );
            }

            $this->srvnom = $servicio["srvnom"];
            $this->srvdsc = $servicio["srvdsc"] ?? "";
            $this->srvest = $servicio["srvest"];
        }
    }

    private function getPostBody(): void
    {
        $this->validateXsfToken($_POST["xsftoken"] ?? "");

        if (in_array($this->mode, ["INS", "UPD"])) {
            $this->srvnom = trim($_POST["srvnom"] ?? "");
            $this->srvdsc = trim($_POST["srvdsc"] ?? "");
            $this->srvest = $_POST["srvest"] ?? "";
        }
    }

    private function validatePostBody(): bool
    {
        if ($this->mode === "DEL") {
            return true;
        }

        if ($this->mode === "DSP") {
            return false;
        }

        if (empty($this->srvnom)) {
            $this->error = "Debe ingresar el nombre del servicio";
            return false;
        }

        if (mb_strlen($this->srvnom) > 80) {
            $this->error = "El nombre no puede superar 80 caracteres";
            return false;
        }

        if (mb_strlen($this->srvdsc) > 255) {
            $this->error = "La descripcion no puede superar 255 caracteres";
            return false;
        }

        if (!in_array($this->srvest, ["ACT", "INA"])) {
            $this->error = "Estado no valido";
            return false;
        }

        if (DaoServicios::existeDuplicado(
            $this->srvnom,
            $this->srvcod
        )) {
            $this->error = "El servicio ya existe";
            return false;
        }

        return true;
    }

    private function processPostBody(): void
    {
        switch ($this->mode) {

            case "INS":
                if (DaoServicios::new(
                    $this->srvnom,
                    $this->srvdsc,
                    $this->srvest
                )) {
                    Site::redirectToWithMsg(
                        "index.php?page=Servicios_ServiciosList",
                        "Servicio agregado correctamente"
                    );
                }
                break;

            case "UPD":
                if (DaoServicios::update(
                    $this->srvnom,
                    $this->srvdsc,
                    $this->srvest,
                    $this->srvcod
                )) {
                    Site::redirectToWithMsg(
                        "index.php?page=Servicios_ServiciosList",
                        "Servicio actualizado correctamente"
                    );
                }
                break;

            case "DEL":
                if (DaoServicios::delete($this->srvcod)) {
                    Site::redirectToWithMsg(
                        "index.php?page=Servicios_ServiciosList",
                        "Servicio eliminado correctamente"
                    );
                }
                break;
        }

        $this->error = "No se realizaron cambios";
    }

    private function generarXsfToken(): void
    {
        $token = bin2hex(random_bytes(32));

        $_SESSION["SERVICIOS_FORM_XSF_T"] = $token;

        $this->viewData["xsftoken"] = $token;
    }

    private function validateXsfToken($token): void
    {
        if (!isset($_SESSION["SERVICIOS_FORM_XSF_T"]) ||
            !is_string($token) ||
            !hash_equals(
                $_SESSION["SERVICIOS_FORM_XSF_T"],
                $token
            )) {

            Site::redirectToWithMsg(
                "index.php?page=Servicios_ServiciosList",
                "Algo no esta bien, intente nuevamente"
            );
        }
    }

    private function prepareViewData(): void
    {
        $this->viewData["mode"] = $this->mode;
        $this->viewData["modeDsc"] = $this->modeDscArr[$this->mode];

        $this->viewData["srvcod"] = $this->srvcod;
        $this->viewData["srvnom"] = Html::esc($this->srvnom);
        $this->viewData["srvdsc"] = Html::esc($this->srvdsc);
        $this->viewData["srvest"] = $this->srvest;

        $this->viewData["ACT"] = $this->srvest === "ACT";
        $this->viewData["INA"] = $this->srvest === "INA";

        $this->viewData["readonly"] = "";
        $this->viewData["disabled"] = "";
        $this->viewData["showGuardar"] = true;
        $this->viewData["btnTexto"] = "Guardar";

        $this->viewData["error"] = Html::esc($this->error);
        $this->viewData["hasError"] = !empty($this->error);

        if (in_array($this->mode, ["DSP", "DEL"])) {
            $this->viewData["readonly"] = "readonly";
            $this->viewData["disabled"] = "disabled";
        }

        if ($this->mode === "DSP") {
            $this->viewData["showGuardar"] = false;
        }

        if ($this->mode === "DEL") {
            $this->viewData["btnTexto"] = "Eliminar";
        }

        $this->viewData["action"] =
            "index.php?page=Servicios_ServiciosForm&mode=" . $this->mode;

        if ($this->mode !== "INS") {
            $this->viewData["action"] .=
                "&srvcod=" . $this->srvcod;
        }

        $this->generarXsfToken();
    }
}