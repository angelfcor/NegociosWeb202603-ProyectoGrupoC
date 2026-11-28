<?php

namespace Controllers\Sec;

use Controllers\PublicController;
use Utilities\Validators;
use Utilities\Security;
use Utilities\Site;
use Views\Renderer;

class Register extends PublicController
{
    private $txtEmail = "";
    private $txtPswd = "";
    private $errorEmail = "";
    private $errorPswd = "";
    private $hasErrors = false;
    private $xsftoken = "";

    public function run(): void
    {
        if ($this->isPostBack()) {

            // Validar token CSRF
            if (!Security::verifyCsrf($_POST["xsftoken"] ?? "")) {

                $this->errorEmail = "Token de seguridad invalido.";
                $this->hasErrors = true;
                $this->xsftoken = Security::csrfToken();

                Renderer::render(
                    "security/sigin",
                    get_object_vars($this)
                );

                return;
            }

            $this->txtEmail = $_POST["txtEmail"] ?? "";
            $this->txtPswd = $_POST["txtPswd"] ?? "";

            if (!Validators::IsValidEmail($this->txtEmail)) {

                $this->errorEmail = "El correo no tiene el formato adecuado";
                $this->hasErrors = true;
            }

            if (!Validators::IsValidPassword($this->txtPswd)) {

                $this->errorPswd = "La contraseña debe tener al menos 8 caracteres, una mayuscula, un numero y un caracter especial.";
                $this->hasErrors = true;
            }

            if (!$this->hasErrors) {

                try {

                    if (\Dao\Security\Security::newUsuario(
                        $this->txtEmail,
                        $this->txtPswd
                    )) {

                        Site::redirectToWithMsg(
                            "index.php?page=sec_login",
                            "¡Usuario Registrado Satisfactoriamente!"
                        );

                        return;
                    }

                    $this->errorEmail = "No se pudo registrar el usuario.";
                    $this->hasErrors = true;

                } catch (\Throwable $ex) {

                    error_log($ex->getMessage());

                    $this->errorEmail = "No se pudo registrar el usuario.";
                    $this->hasErrors = true;
                }
            }
        }

        $this->txtPswd = "";
        $this->xsftoken = Security::csrfToken();

        Renderer::render(
            "security/sigin",
            get_object_vars($this)
        );
    }
}