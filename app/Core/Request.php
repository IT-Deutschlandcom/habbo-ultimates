<?php
declare(strict_types=1);
namespace App\Core;

final class Request
{
    public static function isHttps(): bool
    {
        if (!empty($_SERVER['HTTPS']) && strtolower((string)$_SERVER['HTTPS']) !== 'off') return true;
        if (($_SERVER['SERVER_PORT'] ?? '') === '443') return true;
        return Config::get('site.trust_proxy') && strtolower((string)($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '')) === 'https';
    }
    public static function host(): string
    {
        $h = strtolower((string)($_SERVER['HTTP_HOST'] ?? $_SERVER['SERVER_NAME'] ?? 'localhost'));
        return preg_match('/^[a-z0-9.\-]+(:\d+)?$/', $h) ? $h : 'localhost';
    }
    public static function enforceHost(): void
    {
        $allowed = Config::get('security.allowed_hosts', []);
        if ($allowed && !in_array(preg_replace('/:\d+$/', '', self::host()), $allowed, true)) {
            http_response_code(400);
            exit('Ungültiger Host.');
        }
    }
    public static function enforceHttps(): void
    {
        if (Config::get('site.force_https') && !self::isHttps() && PHP_SAPI !== 'cli') {
            header('Location: https://' . preg_replace('/:\d+$/', '', self::host()) . ($_SERVER['REQUEST_URI'] ?? '/'), true, 301);
            exit;
        }
    }
    public static function baseUrl(): string
    {
        $b = (string)Config::get('site.base_url', '');
        if ($b !== '') return rtrim($b, '/');
        return (self::isHttps() ? 'https' : 'http') . '://' . self::host();
    }
    public static function ip(): string
    {
        $ip = (string)($_SERVER['REMOTE_ADDR'] ?? '0.0.0.0');
        if (Config::get('site.trust_proxy') && !empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $c = trim(explode(',', (string)$_SERVER['HTTP_X_FORWARDED_FOR'])[0]);
            if (filter_var($c, FILTER_VALIDATE_IP)) $ip = $c;
        }
        return $ip;
    }
    public static function method(): string { return strtoupper($_SERVER['REQUEST_METHOD'] ?? 'GET'); }
    public static function path(): string
    {
        $p = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
        return '/' . trim(rawurldecode($p), '/');
    }
    public static function str(string $k, int $max = 255): string { return mb_substr(trim((string)($_POST[$k] ?? '')), 0, $max); }
    public static function int(string $k, int $d = 0): int { return isset($_POST[$k]) ? (int)$_POST[$k] : $d; }
    public static function wantsJson(): bool { return str_contains((string)($_SERVER['HTTP_ACCEPT'] ?? ''), 'application/json') || ($_SERVER['HTTP_X_REQUESTED_WITH'] ?? '') === 'XMLHttpRequest'; }
}
