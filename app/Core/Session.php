<?php
declare(strict_types=1);
namespace App\Core;

final class Session
{
    private static array $oldCache = [];

    public static function start(): void
    {
        if (PHP_SAPI === 'cli' || session_status() === PHP_SESSION_ACTIVE) return;
        $dir = ROOT . '/storage/sessions';
        if (!is_dir($dir)) @mkdir($dir, 0775, true);
        if (is_dir($dir) && is_writable($dir)) session_save_path($dir);
        session_name((string)Config::get('security.session_name', 'cms_sid'));
        session_set_cookie_params([
            'lifetime' => 0, 'path' => '/', 'secure' => Request::isHttps(), 'httponly' => true, 'samesite' => 'Lax',
        ]);
        ini_set('session.use_strict_mode', '1');
        ini_set('session.gc_maxlifetime', (string)Config::get('security.session_lifetime', 86400));
        session_start();
        self::$oldCache = $_SESSION['_old'] ?? [];
        unset($_SESSION['_old']);
    }
    public static function get(string $k, mixed $d = null): mixed { return $_SESSION[$k] ?? $d; }
    public static function set(string $k, mixed $v): void { $_SESSION[$k] = $v; }
    public static function forget(string $k): void { unset($_SESSION[$k]); }
    public static function push(string $k, mixed $v): void { $_SESSION[$k][] = $v; }
    public static function pull(string $k, mixed $d = null): mixed { $v = $_SESSION[$k] ?? $d; unset($_SESSION[$k]); return $v; }
    public static function regenerate(): void { session_regenerate_id(true); }
    public static function destroy(): void
    {
        $_SESSION = [];
        if (session_status() === PHP_SESSION_ACTIVE) session_destroy();
    }
    public static function flashOld(array $post): void
    {
        unset($post['password'], $post['password2'], $post['_token']);
        $_SESSION['_old'] = $post;
    }
    public static function peekOld(string $k): ?string { return isset(self::$oldCache[$k]) && is_scalar(self::$oldCache[$k]) ? (string)self::$oldCache[$k] : null; }
}
