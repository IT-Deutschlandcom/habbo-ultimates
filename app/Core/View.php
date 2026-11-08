<?php
declare(strict_types=1);
namespace App\Core;

final class View
{
    public static function partial(string $tpl, array $data = []): string
    {
        $file = APP . '/Views/' . $tpl . '.php';
        if (!is_file($file)) throw new \RuntimeException("View fehlt: $tpl");
        extract($data, EXTR_SKIP);
        ob_start();
        include $file;
        return (string)ob_get_clean();
    }
    public static function render(string $tpl, array $data = [], string $layout = 'main'): void
    {
        $data['content'] = self::partial($tpl, $data);
        header('Content-Type: text/html; charset=utf-8');
        header('X-Frame-Options: SAMEORIGIN');
        header('X-Content-Type-Options: nosniff');
        header('Referrer-Policy: strict-origin-when-cross-origin');
        header('Permissions-Policy: camera=(), microphone=(), geolocation=()');
        if (Request::isHttps()) header('Strict-Transport-Security: max-age=31536000');
        echo self::partial('layout/' . $layout, $data);
    }
}
