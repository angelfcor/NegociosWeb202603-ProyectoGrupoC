<?php

namespace Utilities;

use Dao\Security\Security as DaoSecurity;
class Security {
    private function __construct()
    {
        
    }
    private function __clone()
    {
        
    }
    public static function logout()
    {
        unset($_SESSION["login"]);
    }
    public static function login($userId, $userName, $userEmail)
    {
        // Regenera el id de sesion para evitar session fixation.
        if (session_status() === PHP_SESSION_ACTIVE) {
            session_regenerate_id(true);
        }
        $_SESSION["login"] = array(
            "isLogged" => true,
            "userId" => $userId,
            "userName" => $userName,
            "userEmail" => $userEmail
        );
    }
    /**
     * Genera (o reutiliza) el token anti-CSRF de la sesion.
     * @return string Token hexadecimal de 64 caracteres.
     */
    public static function csrfToken():string
    {
        if (!isset($_SESSION["csrf"]) || !is_string($_SESSION["csrf"]) || $_SESSION["csrf"] === "") {
            $_SESSION["csrf"] = bin2hex(random_bytes(32));
        }
        return $_SESSION["csrf"];
    }
    /**
     * Verifica el token anti-CSRF recibido contra el de la sesion.
     * @param mixed $token Token recibido por POST.
     * @return bool
     */
    public static function verifyCsrf($token):bool
    {
        if (!isset($_SESSION["csrf"]) || !is_string($token) || $token === "") {
            return false;
        }
        return hash_equals($_SESSION["csrf"], $token);
    }
    public static function isLogged():bool
    {
        return isset($_SESSION["login"]) && $_SESSION["login"]["isLogged"];
    }
    public static function getUser()
    {
        if (isset($_SESSION["login"])) {
            return $_SESSION["login"];
        }
        return false;
    }
    public static function getUserId()
    {
        if (isset($_SESSION["login"])) {
            return $_SESSION["login"]["userId"];
        }
        return 0;
    }
    public static function isAuthorized($userId, $function, $type = 'FNC'):bool
    {
        if (\Utilities\Context::getContextByKey("DEVELOPMENT") == "1") {
            $functionInDb = DaoSecurity::getFeature($function);
            if (!$functionInDb) {
                DaoSecurity::addNewFeature($function, $function, "ACT", $type);
            }
        }
        return DaoSecurity::getFeatureByUsuario($userId, $function);
    }
    public static function isInRol($userId, $rol):bool
    {
        if (\Utilities\Context::getContextByKey("DEVELOPMENT") == "1") {
            $rolInDb = DaoSecurity::getRol($rol);
            if (!$rolInDb) {
                DaoSecurity::addNewRol($rol, $rol, "ACT");
            }
        }
        return DaoSecurity::isUsuarioInRol($userId, $rol);
    }
}
