<?php

namespace Controllers\Sec;

class Login extends \Controllers\PublicController
{
    private $txtEmail = "";
    private $txtPswd = "";
    private $errorEmail = "";
    private $errorPswd = "";
    private $generalError = "";
    private $hasError = false;
    private $xsftoken = "";

    public function run(): void
    {
        if ($this->isPostBack()) {

            // Validar token CSRF
            if (!\Utilities\Security::verifyCsrf(
                $_POST["xsftoken"] ?? ""
            )) {
                $this->generalError = "Token de seguridad invalido.";
                $this->hasError = true;
                $this->xsftoken = \Utilities\Security::csrfToken();

                \Views\Renderer::render(
                    "security/login",
                    get_object_vars($this)
                );

                return;
            }

            $this->txtEmail = $_POST["txtEmail"] ?? "";
            $this->txtPswd = $_POST["txtPswd"] ?? "";

            if (!\Utilities\Validators::IsValidEmail($this->txtEmail)) {
                $this->errorEmail = "¡Correo no tiene el formato adecuado!";
                $this->hasError = true;
            }

            if (\Utilities\Validators::IsEmpty($this->txtPswd)) {
                $this->errorPswd = "¡Debe ingresar una contraseña!";
                $this->hasError = true;
            }

            if (!$this->hasError) {

                $dbUser = \Dao\Security\Security::getUsuarioByEmail(
                    $this->txtEmail
                );

                if ($dbUser) {

                    if (
                        $dbUser["userest"] !=
                        \Dao\Security\Estados::ACTIVO
                    ) {
                        $this->generalError = "¡Credenciales son incorrectas!";
                        $this->hasError = true;
                    }

                    if (!\Dao\Security\Security::verifyPassword(
                        $this->txtPswd,
                        $dbUser["userpswd"]
                    )) {
                        $this->generalError = "¡Credenciales son incorrectas!";
                        $this->hasError = true;
                    }

                    if (!$this->hasError) {

                        \Utilities\Security::login(
                            $dbUser["usercod"],
                            $dbUser["username"],
                            $dbUser["useremail"]
                        );

                        \Utilities\Site::redirectTo("index.php");
                        return;
                    }

                } else {

                    $this->generalError = "¡Credenciales son incorrectas!";
                    $this->hasError = true;
                }
            }
        }

        $this->txtPswd = "";

        // Generar token para el formulario
        $this->xsftoken = \Utilities\Security::csrfToken();

        $dataView = get_object_vars($this);

        \Views\Renderer::render(
            "security/login",
            $dataView
        );
    }
}