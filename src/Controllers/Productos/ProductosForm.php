<?php
namespace Controllers\Productos;

use Controllers\PrivateController;
use Controllers\PrivateNoAuthException;
use Dao\Productos\Productos as DaoProductos;
use Utilities\Site;
use Utilities\Html;
use Views\Renderer;

class ProductosForm extends PrivateController
{
    private $viewData = [];

    private $productId = 0;
    private $productName = "";
    private $productDescription = "";
    private $productPrice = "";
    private $productImgUrl = "";
    private $productStock = 0;
    private $productCapacidad = 0;
    private $productSalida = "";
    private $rutacod = 0;
    private $srvcod = 0;
    private $productStatus = "ACT";

    private $mode = "";
    private $error = "";

    private $modeDscArr = [
        "INS" => "Crear nueva salida",
        "DSP" => "Consultar salida",
        "UPD" => "Actualizar salida",
        "DEL" => "Eliminar salida"
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
            "productos/productosForm",
            $this->viewData
        );
    }

    private function getQueryParams(): void
    {
        $this->mode = $_GET["mode"] ?? "";

        if (!isset($this->modeDscArr[$this->mode])) {
            Site::redirectToWithMsg(
                "index.php?page=Productos_ProductosList",
                "Modo no valido"
            );
        }

        if (!$this->isFeatureAutorized(
            "Controllers\\Productos\\" . $this->mode
        )) {
            throw new PrivateNoAuthException();
        }

        if ($this->mode !== "INS") {

            $this->productId = intval($_GET["productId"] ?? 0);

            $producto = DaoProductos::getById($this->productId);

            if (!$producto) {
                Site::redirectToWithMsg(
                    "index.php?page=Productos_ProductosList",
                    "La salida no existe"
                );
            }

            $this->productName = $producto["productName"];
            $this->productDescription = $producto["productDescription"];
            $this->productPrice = $producto["productPrice"];
            $this->productImgUrl = $producto["productImgUrl"];
            $this->productStock = $producto["productStock"];
            $this->productCapacidad = $producto["productCapacidad"];

            $this->productSalida = date(
                "Y-m-d\TH:i",
                strtotime($producto["productSalida"])
            );

            $this->rutacod = $producto["rutacod"];
            $this->srvcod = $producto["srvcod"];
            $this->productStatus = $producto["productStatus"];
        }
    }

    private function getPostBody(): void
    {
        $this->validateXsfToken($_POST["xsftoken"] ?? "");

        if (in_array($this->mode, ["INS", "UPD"])) {

            $this->productName = trim($_POST["productName"] ?? "");

            $this->productDescription = trim(
                $_POST["productDescription"] ?? ""
            );

            $this->productPrice = trim(
                $_POST["productPrice"] ?? ""
            );

            $this->productImgUrl = trim(
                $_POST["productImgUrl"] ?? ""
            );

            $this->productStock = intval(
                $_POST["productStock"] ?? 0
            );

            $this->productCapacidad = intval(
                $_POST["productCapacidad"] ?? 0
            );

            $this->productSalida = $_POST["productSalida"] ?? "";

            $this->rutacod = intval($_POST["rutacod"] ?? 0);

            $this->srvcod = intval($_POST["srvcod"] ?? 0);

            $this->productStatus = $_POST["productStatus"] ?? "";
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

        if (empty($this->productName)) {
            $this->error = "Debe ingresar el nombre de la salida";
            return false;
        }

        if (mb_strlen($this->productName) > 255) {
            $this->error = "El nombre supera los 255 caracteres";
            return false;
        }

        if (
            !is_numeric($this->productPrice) ||
            floatval($this->productPrice) <= 0
        ) {
            $this->error = "El precio debe ser mayor que cero";
            return false;
        }

        if (
            empty($this->productSalida) ||
            strtotime($this->productSalida) === false
        ) {
            $this->error = "Debe ingresar una fecha de salida valida";
            return false;
        }

        if ($this->productCapacidad <= 0) {
            $this->error = "La capacidad debe ser mayor que cero";
            return false;
        }

        if (
            $this->productStock < 0 ||
            $this->productStock > $this->productCapacidad
        ) {
            $this->error = "Las libras disponibles deben estar entre cero y la capacidad";
            return false;
        }

        if ($this->rutacod <= 0 || $this->srvcod <= 0) {
            $this->error = "Debe seleccionar una ruta y un servicio";
            return false;
        }

        if (!in_array($this->productStatus, ["ACT", "INA"])) {
            $this->error = "Estado no valido";
            return false;
        }

        $rutas = DaoProductos::getRutas();
        $servicios = DaoProductos::getServicios();

        $rutaValida = false;

        foreach ($rutas as $ruta) {
            if (intval($ruta["rutacod"]) === $this->rutacod) {
                $rutaValida = true;
                break;
            }
        }

        $servicioValido = false;

        foreach ($servicios as $servicio) {
            if (intval($servicio["srvcod"]) === $this->srvcod) {
                $servicioValido = true;
                break;
            }
        }

        if (!$rutaValida || !$servicioValido) {
            $this->error = "La ruta o el servicio seleccionado no es valido";
            return false;
        }

        return true;
    }

    private function processPostBody(): void
    {
        switch ($this->mode) {

            case "INS":

                if (DaoProductos::new(
                    $this->productName,
                    $this->productDescription,
                    floatval($this->productPrice),
                    $this->productImgUrl,
                    $this->productStock,
                    $this->productCapacidad,
                    date(
                        "Y-m-d H:i:s",
                        strtotime($this->productSalida)
                    ),
                    $this->rutacod,
                    $this->srvcod,
                    $this->productStatus
                )) {
                    Site::redirectToWithMsg(
                        "index.php?page=Productos_ProductosList",
                        "Salida agregada correctamente"
                    );
                }

                break;

            case "UPD":

                if (DaoProductos::update(
                    $this->productName,
                    $this->productDescription,
                    floatval($this->productPrice),
                    $this->productImgUrl,
                    $this->productStock,
                    $this->productCapacidad,
                    date(
                        "Y-m-d H:i:s",
                        strtotime($this->productSalida)
                    ),
                    $this->rutacod,
                    $this->srvcod,
                    $this->productStatus,
                    $this->productId
                )) {
                    Site::redirectToWithMsg(
                        "index.php?page=Productos_ProductosList",
                        "Salida actualizada correctamente"
                    );
                }

                break;

            case "DEL":

                if (DaoProductos::delete($this->productId)) {
                    Site::redirectToWithMsg(
                        "index.php?page=Productos_ProductosList",
                        "Salida eliminada correctamente"
                    );
                }

                break;
        }

        $this->error = "No se realizaron cambios";
    }

    private function generarXsfToken(): void
    {
        $token = bin2hex(random_bytes(32));

        $_SESSION["PRODUCTOS_FORM_XSF_T"] = $token;

        $this->viewData["xsftoken"] = $token;
    }

    private function validateXsfToken($token): void
    {
        if (
            !isset($_SESSION["PRODUCTOS_FORM_XSF_T"]) ||
            !is_string($token) ||
            !hash_equals(
                $_SESSION["PRODUCTOS_FORM_XSF_T"],
                $token
            )
        ) {
            Site::redirectToWithMsg(
                "index.php?page=Productos_ProductosList",
                "Algo no esta bien, intente nuevamente"
            );
        }
    }

    private function prepareViewData(): void
    {
        $this->viewData["mode"] = $this->mode;

        $this->viewData["modeDsc"] =
            $this->modeDscArr[$this->mode];

        $this->viewData["productId"] = $this->productId;
        $this->viewData["productName"] = Html::esc($this->productName);
        $this->viewData["productDescription"] = Html::esc($this->productDescription);
        $this->viewData["productPrice"] = Html::esc((string)$this->productPrice);
        $this->viewData["productImgUrl"] = Html::esc($this->productImgUrl);

        $this->viewData["productStock"] = $this->productStock;
        $this->viewData["productCapacidad"] = $this->productCapacidad;

        $this->viewData["productSalida"] = Html::esc($this->productSalida);

        $this->viewData["rutacod"] = $this->rutacod;
        $this->viewData["srvcod"] = $this->srvcod;

        $this->viewData["productStatus"] = $this->productStatus;

        $this->viewData["ACT"] = $this->productStatus === "ACT";
        $this->viewData["INA"] = $this->productStatus === "INA";

        // Cargar rutas y marcar la ruta seleccionada
        $this->viewData["rutas"] = Html::escFilas(
            DaoProductos::getRutas(),
            ["rutaorigen", "rutadestino"]
        );

        foreach ($this->viewData["rutas"] as &$ruta) {
            $ruta["selected"] =
                intval($ruta["rutacod"]) === intval($this->rutacod);
        }
        unset($ruta);

        // Cargar servicios y marcar el servicio seleccionado
        $this->viewData["servicios"] = Html::escFilas(
            DaoProductos::getServicios(),
            ["srvnom"]
        );

        foreach ($this->viewData["servicios"] as &$servicio) {
            $servicio["selected"] =
                intval($servicio["srvcod"]) === intval($this->srvcod);
        }
        unset($servicio);

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
            "index.php?page=Productos_ProductosForm&mode=" . $this->mode;

        if ($this->mode !== "INS") {
            $this->viewData["action"] .=
                "&productId=" . $this->productId;
        }

        $this->generarXsfToken();
    }
}
