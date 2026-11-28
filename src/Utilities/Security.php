<?php

namespace Utilities;

use Dao\Security\Security as DaoSecurity;

class Security
{
    private function __construct()
    {
    }

    private function __clone()
    {
    }

    // Inicializar una sesion segura
    public static function startSession(): void
    {
        if (session_status() === PHP_SESSION_NONE) {

            $https = !empty($_SERVER["HTTPS"]) &&
                $_SERVER["HTTPS"] !== "off";

            ini_set("session.use_strict_mode", "1");
            ini_set("session.use_only_cookies", "1");

            session_set_cookie_params([
                "lifetime" => 0,
                "path" => "/",
                "secure" => $https,
                "httponly" => true,
                "samesite" => "Lax"
            ]);

            session_start();
        }
    }

    // Cerrar y destruir la sesion
    public static function logout()
    {
        if (session_status() === PHP_SESSION_ACTIVE) {

            $_SESSION = [];

            if (ini_get("session.use_cookies")) {

                $params = session_get_cookie_params();

                setcookie(session_name(), "", [
                    "expires" => time() - 42000,
                    "path" => $params["path"],
                    "domain" => $params["domain"],
                    "secure" => $params["secure"],
                    "httponly" => $params["httponly"],
                    "samesite" => $params["samesite"] ?? "Lax"
                ]);
            }

            session_destroy();
        }
    }

    // Crear sesion del usuario
    public static function login($userId, $userName, $userEmail)
    {
        self::startSession();

        // Prevenir la fijacion de sesiones
        if (!session_regenerate_id(true)) {
            throw new \RuntimeException(
                "No se pudo regenerar la sesion."
            );
        }

        // Renovar el token al autenticar al usuario
        unset($_SESSION["csrf"]);

        $_SESSION["login"] = [
            "isLogged" => true,
            "userId" => $userId,
            "userName" => $userName,
            "userEmail" => $userEmail
        ];
    }

    // Generar token CSRF
    public static function csrfToken(): string
    {
        self::startSession();

        if (
            !isset($_SESSION["csrf"]) ||
            !is_string($_SESSION["csrf"]) ||
            $_SESSION["csrf"] === ""
        ) {
            $_SESSION["csrf"] = bin2hex(random_bytes(32));
        }

        return $_SESSION["csrf"];
    }

    // Validar token CSRF
    public static function verifyCsrf($token): bool
    {
        if (
            !isset($_SESSION["csrf"]) ||
            !is_string($_SESSION["csrf"]) ||
            !is_string($token) ||
            $token === ""
        ) {
            return false;
        }

        return hash_equals($_SESSION["csrf"], $token);
    }

    // Verificar si el usuario esta autenticado
    public static function isLogged(): bool
    {
        return isset($_SESSION["login"]["isLogged"]) &&
            $_SESSION["login"]["isLogged"] === true;
    }

    // Obtener informacion del usuario
    public static function getUser()
    {
        if (self::isLogged()) {
            return $_SESSION["login"];
        }

        return false;
    }

    // Obtener codigo del usuario
    public static function getUserId()
    {
        if (self::isLogged()) {
            return $_SESSION["login"]["userId"];
        }

        return 0;
    }

    // Verificar permisos
    public static function isAuthorized(
        $userId,
        $function,
        $type = 'FNC'
    ): bool
    {
        if (
            \Utilities\Context::getContextByKey("DEVELOPMENT") == "1"
        ) {
            $functionInDb = DaoSecurity::getFeature($function);

            if (!$functionInDb) {
                DaoSecurity::addNewFeature(
                    $function,
                    $function,
                    "ACT",
                    $type
                );
            }
        }

        return DaoSecurity::getFeatureByUsuario(
            $userId,
            $function
        );
    }

    // Verificar rol
    public static function isInRol($userId, $rol): bool
    {
        if (
            \Utilities\Context::getContextByKey("DEVELOPMENT") == "1"
        ) {
            $rolInDb = DaoSecurity::getRol($rol);

            if (!$rolInDb) {
                DaoSecurity::addNewRol(
                    $rol,
                    $rol,
                    "ACT"
                );
            }
        }

        return DaoSecurity::isUsuarioInRol($userId, $rol);
    }
}