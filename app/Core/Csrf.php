<?php
declare(strict_types=1);
namespace App\Core;

final class Csrf
{
    public static function token(): string
    {
        if (!Session::get('_csrf')) Session::set('_csrf', bin2hex(random_bytes(32)));
        return (string)Session::get('_csrf');
    }
    public static function check(): bool
    {
        $t = $_POST['_token'] ?? ($_SERVER['HTTP_X_CSRF_TOKEN'] ?? '');
        return is_string($t) && $t !== '' && hash_equals(self::token(), $t);
    }
}
