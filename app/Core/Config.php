<?php
declare(strict_types=1);
namespace App\Core;

final class Config
{
    private static array $d = [];
    public static function load(string $file): void { self::$d = require $file; }
    public static function get(string $key, mixed $default = null): mixed
    {
        $v = self::$d;
        foreach (explode('.', $key) as $p) {
            if (!is_array($v) || !array_key_exists($p, $v)) return $default;
            $v = $v[$p];
        }
        return $v;
    }
}
