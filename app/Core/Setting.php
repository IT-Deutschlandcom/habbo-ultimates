<?php
declare(strict_types=1);
namespace App\Core;

final class Setting
{
    private static ?array $all = null;

    public static function all(): array
    {
        if (self::$all === null) {
            self::$all = [];
            try {
                foreach (DB::all('SELECT `key`, `value` FROM website_settings') as $r) self::$all[$r['key']] = $r['value'];
            } catch (\Throwable) {}
        }
        return self::$all;
    }
    public static function get(string $k, mixed $d = null): mixed { $a = self::all(); return $a[$k] ?? $d; }
    public static function set(string $k, string $v): void
    {
        DB::exec('INSERT INTO website_settings (`key`,`value`) VALUES (?,?) ON DUPLICATE KEY UPDATE `value`=VALUES(`value`)', [$k, $v]);
        self::$all = null;
    }
}
