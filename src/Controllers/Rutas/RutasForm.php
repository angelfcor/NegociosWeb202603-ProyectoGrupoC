<?php

namespace Controllers\Rutas;

use Controllers\PrivateController;
use Controllers\PrivateNoAuthException;
use Dao\Rutas\Rutas as DaoRutas;
use Utilities\Html;
use Utilities\Security;
use Utilities\Site;
use Utilities\Validators;
use Views\Renderer;

class RutasForm extends PrivateController
{
    private $viewData = [];
    private $mode = "DSP";
    private $modeDescriptions = [
        "INS" => "Nueva Ruta",
        "DSP" => "Detalle de Ruta %s",
        "UPD" => "Editar Ruta %s",
        "DEL" => "Desactivar Ruta %s"
    ];
    private $readonly = "";
    private $showCommitBtn = true;
    private $errorGeneral = "";
    private $ruta = [
        "rutacod" => 0,
        "rutaorigen" => "",
        "rutadestino" => "",
        "rutaest" => "ACT"
    ];

    public function run(): void
    {
        try {
            $this->getData();

            if ($this->isPostBack() && $this->mode !== "DSP") {
                if (!Security::verifyCsrf($_POST["csrf_token"] ?? "")) {
                    $this->errorGeneral = "La solicitud no es válida. Volvé a abrir el formulario.";
                } elseif ($this->mode === "DEL") {
                    $this->handleDelete();
                } elseif ($this->validateData()) {
                    $this->handlePostAction();
                }
            }

            $this->setViewData();
            Renderer::render("rutas/rutasForm", $this->viewData);
        } catch (PrivateNoAuthException $ex) {
            throw $ex;
        } catch (\Exception $ex) {
            Site::redirectToWithMsg(
                "index.php?page=Rutas_RutasList",
                $ex->getMessage()
            );
        }
    }

    private function getData(): void
    {
        $this->mode = $_GET["mode"] ?? "NOF";

        if (!is_string($this->mode) || !isset($this->modeDescriptions[$this->mode])) {
            throw new \Exception("Modo de formulario inválido.");
        }

        if (!$this->isFeatureAutorized("Controllers\\Rutas\\" . $this->mode)) {
            throw new PrivateNoAuthException();
        }

        $this->readonly = ($this->mode === "DSP" || $this->mode === "DEL")
            ? "readonly" : "";
        $this->showCommitBtn = $this->mode !== "DSP";

        if ($this->mode !== "INS") {
            $codigo = isset($_GET["rutacod"]) && is_scalar($_GET["rutacod"])
                ? intval($_GET["rutacod"]) : 0;

            if ($codigo <= 0) {
                throw new \Exception("El código de la ruta es inválido.");
            }

            $this->ruta = DaoRutas::getById($codigo);
            if (!$this->ruta) {
                throw new \Exception("No se encontró la ruta.");
            }
        }
    }

    private function validateData(): bool
    {
        $origen = $_POST["rutaorigen"] ?? "";
        $destino = $_POST["rutadestino"] ?? "";
        $estado = $_POST["rutaest"] ?? "";

        $this->ruta["rutaorigen"] = is_string($origen) ? trim($origen) : "";
        $this->ruta["rutadestino"] = is_string($destino) ? trim($destino) : "";
        $this->ruta["rutaest"] = is_string($estado) ? $estado : "";

        $tieneErrores = false;

        if (Validators::IsEmpty($this->ruta["rutaorigen"])) {
            $this->ruta["rutaorigen_error"] = "El origen es obligatorio.";
            $tieneErrores = true;
        } elseif (strlen($this->ruta["rutaorigen"]) > 80) {
            $this->ruta["rutaorigen_error"] = "El origen no puede superar 80 caracteres.";
            $tieneErrores = true;
        }

        if (Validators::IsEmpty($this->ruta["rutadestino"])) {
            $this->ruta["rutadestino_error"] = "El destino es obligatorio.";
            $tieneErrores = true;
        } elseif (strlen($this->ruta["rutadestino"]) > 80) {
            $this->ruta["rutadestino_error"] = "El destino no puede superar 80 caracteres.";
            $tieneErrores = true;
        }

        if (!in_array($this->ruta["rutaest"], ["ACT", "INA"], true)) {
            $this->ruta["rutaest_error"] = "El estado seleccionado es inválido.";
            $tieneErrores = true;
        }

        if (!$tieneErrores && DaoRutas::existeDuplicado(
            $this->ruta["rutaorigen"],
            $this->ruta["rutadestino"],
            intval($this->ruta["rutacod"])
        )) {
            $this->errorGeneral = "Ya existe una ruta con ese origen y destino.";
            $tieneErrores = true;
        }

        return !$tieneErrores;
    }

    private function handlePostAction(): void
    {
        switch ($this->mode) {
            case "INS":
                $resultado = DaoRutas::new(
                    $this->ruta["rutaorigen"],
                    $this->ruta["rutadestino"],
                    $this->ruta["rutaest"]
                );
                if ($resultado !== false) {
                    Site::redirectToWithMsg(
                        "index.php?page=Rutas_RutasList",
                        "Ruta creada correctamente."
                    );
                }
                break;
            case "UPD":
                $resultado = DaoRutas::update(
                    $this->ruta["rutaorigen"],
                    $this->ruta["rutadestino"],
                    $this->ruta["rutaest"],
                    intval($this->ruta["rutacod"])
                );
                if ($resultado !== false) {
                    Site::redirectToWithMsg(
                        "index.php?page=Rutas_RutasList",
                        "Ruta actualizada correctamente."
                    );
                }
                break;
        }

        $this->errorGeneral = "No se pudo guardar la información de la ruta.";
    }

    private function handleDelete(): void
    {
        $resultado = DaoRutas::delete(intval($this->ruta["rutacod"]));

        if ($resultado !== false) {
            Site::redirectToWithMsg(
                "index.php?page=Rutas_RutasList",
                "Ruta desactivada correctamente."
            );
        }

        $this->errorGeneral = "No se pudo desactivar la ruta.";
    }

    private function setViewData(): void
    {
        $this->viewData["mode"] = $this->mode;
        $this->viewData["rutacod"] = intval($this->ruta["rutacod"]);
        $this->viewData["FormTitle"] = sprintf(
            $this->modeDescriptions[$this->mode],
            intval($this->ruta["rutacod"])
        );
        $this->viewData["readonly"] = $this->readonly;
        $this->viewData["showCommitBtn"] = $this->showCommitBtn;
        $this->viewData["confirmText"] = $this->mode === "DEL" ? "Desactivar" : "Confirmar";
        $this->viewData["csrf_token"] = Html::esc(Security::csrfToken());
        $this->viewData["errorGeneral"] = Html::esc($this->errorGeneral);

        $this->ruta["rutaest_act"] = $this->ruta["rutaest"] === "ACT" ? "selected" : "";
        $this->ruta["rutaest_ina"] = $this->ruta["rutaest"] === "INA" ? "selected" : "";
        $this->ruta["rutaorigen"] = Html::esc($this->ruta["rutaorigen"]);
        $this->ruta["rutadestino"] = Html::esc($this->ruta["rutadestino"]);
        $this->viewData["ruta"] = $this->ruta;
    }
}
