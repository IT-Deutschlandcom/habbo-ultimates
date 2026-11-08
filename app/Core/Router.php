<?php
declare(strict_types=1);
namespace App\Core;

final class Router
{
    private array $routes = [];

    public function add(string $method, string $pattern, string $handler, array $mw = []): void
    {
        $re = '~^' . preg_replace_callback('~\{(\w+)(?::([^}]+))?\}~', fn($m) => '(?P<' . $m[1] . '>' . ($m[2] ?? '[^/]+') . ')', $pattern) . '$~';
        $this->routes[] = [$method, $re, $handler, $mw];
    }
    public function get(string $p, string $h, array $mw = []): void { $this->add('GET', $p, $h, $mw); }
    public function post(string $p, string $h, array $mw = []): void { $this->add('POST', $p, $h, $mw); }

    public function dispatch(): void
    {
        $method = Request::method();
        $path = Request::path();
        $allowedElsewhere = false;
        foreach ($this->routes as [$m, $re, $handler, $mw]) {
            if (!preg_match($re, $path, $mt)) continue;
            if ($m !== $method && !($method === 'HEAD' && $m === 'GET')) { $allowedElsewhere = true; continue; }
            $params = array_filter($mt, 'is_string', ARRAY_FILTER_USE_KEY);
            if ($method === 'POST' && !Csrf::check()) {
                if (Request::wantsJson()) { http_response_code(419); header('Content-Type: application/json'); exit(json_encode(['ok' => false, 'error' => 'Sitzung abgelaufen.'])); }
                flash('danger', 'Sicherheits-Token ungültig. Bitte versuche es erneut.');
                redirect($_SERVER['HTTP_REFERER'] ?? '/');
            }
            foreach ($mw as $w) self::runMiddleware($w);
            [$cls, $fn] = explode('@', $handler);
            $class = 'App\\Controllers\\' . $cls;
            (new $class())->$fn(...array_values($params));
            return;
        }
        if ($allowedElsewhere) { http_response_code(405); }
        else { http_response_code(404); }
        View::render($allowedElsewhere ? 'errors/405' : 'errors/404', ['title' => 'Nicht gefunden']);
    }

    private static function runMiddleware(string $w): void
    {
        [$name, $arg] = array_pad(explode(':', $w, 2), 2, null);
        switch ($name) {
            case 'auth':
                if (!Auth::check()) { flash('warning', 'Bitte logge dich zuerst ein.'); redirect('/login'); }
                break;
            case 'guest':
                if (Auth::check()) redirect('/');
                break;
            case 'perm':
                if (!Auth::check()) redirect('/login');
                if (!Auth::can('housekeeping') || ($arg && !Auth::can($arg))) {
                    http_response_code(403);
                    View::render('errors/403', ['title' => 'Kein Zugriff'], Auth::can('housekeeping') ? 'admin' : 'main');
                    exit;
                }
                break;
        }
    }
}
