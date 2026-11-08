<?php
declare(strict_types=1);

require __DIR__ . '/frontend-fixture.php';
set_error_handler(static function (int $severity, string $message, string $file, int $line): never {
    throw new ErrorException($message, 0, $severity, $file, $line);
});
function check(bool $ok, string $message): void
{
    if (!$ok) throw new RuntimeException($message);
}
foreach (['guest', 'login', 'register', 'dashboard', 'admin'] as $page) {
    $html = frontend_fixture($page);
    check(str_contains($html, 'id="site-sidebar"'), "$page: missing navigation");
    check(str_contains($html, 'aria-expanded="false"'), "$page: missing menu state");
    check(str_contains($html, 'img/ares/sprites.png'), "$page: missing sprites");
    check(!str_contains($html, 'ng-') && !str_contains($html, 'routerLink='), "$page: Angular dependency");
    if (in_array($page, ['guest', 'login'], true)) {
        check(str_contains($html, 'name="_token"'), 'Login CSRF missing');
        check(substr_count($html, 'name="username"') === 1, "$page: expected one login form");
        check(str_contains($html, 'action="' . url('/login') . '"'), "$page: wrong login endpoint");
        check(str_contains($html, 'name="password"'), "$page: login password missing");
        check(str_contains($html, 'img/ares/room.png'), 'Ares login art missing');
        check((bool)preg_match('~</div>\s*</div>\s*<aside class="login-world">~', $html), 'Login panels must be siblings');
        check(str_contains($html, 'class="login-heading"'), "$page: centered heading missing");
    }
    if ($page === 'dashboard') {
        check(!str_contains($html, 'name="password"'), 'Members must not see the guest login');
        check(str_contains($html, '/profile/Sakura'), 'Dashboard profile target missing');
        check(str_contains($html, 'Dein Guthaben'), 'Dashboard wallet missing');
    }
    preg_match_all('/viewBox="(\d+) (\d+) (\d+) (\d+)"/', $html, $icons, PREG_SET_ORDER);
    foreach ($icons as [, $x, $y, $w, $h]) {
        check($x + $w <= 462 && $y + $h <= 2200, 'Sprite exceeds atlas');
    }
    check(str_contains($html, 'overflow="hidden"><image'), 'Sprite crop clipping missing');
}
[$width, $height] = getimagesize(ROOT . '/public/assets/img/ares/sprites.png');
check($width === 462 && $height === 2200, 'Unexpected atlas dimensions');
$css = file_get_contents(ROOT . '/public/assets/css/app.css');
check(str_contains($css, '--bg: #202225'), 'Charcoal background missing');
check(!str_contains($css, 'backdrop-filter'), 'Glass effect must not return');
check(str_contains($css, '.pixel-icon image { image-rendering: auto; }'), 'Sprite downsampling must be smooth');
check(!preg_match('/\.pixel-icon[^{]*\{[^}]*image-rendering:\s*pixelated/', $css), 'Nearest-neighbor icon scaling must not return');
foreach ([
    'speedometer2' => ['dashboard', 29, 30], 'newspaper' => ['news', 30, 36],
    'shield-check' => ['employees', 23, 32], 'gear' => ['settings', 23, 28],
    'box-arrow-left' => ['logout', 34, 36],
] as $name => [$file, $w, $h]) {
    $path = ROOT . '/public/assets/img/ares/icons/' . $file . '.png';
    [$actualWidth, $actualHeight] = getimagesize($path);
    check($actualWidth === $w && $actualHeight === $h, "$name: changed native dimensions");
    $icon = ui_icon($name);
    check(str_contains($icon, 'icons/' . $file . '.png'), "$name: wrong icon asset");
    check(str_contains($icon, 'width="' . $w . '" height="' . $h . '"'), "$name: wrong display dimensions");
}
check(str_contains(file_get_contents(ROOT . '/public/index.php'), "'/me', 'HomeController@index', ['auth']"), 'Dashboard auth route missing');
echo "Frontend rendering: guest login, dashboard, admin, native icons and sprite bounds OK\n";
