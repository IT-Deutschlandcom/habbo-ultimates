<?php
declare(strict_types=1);

require_once dirname(__DIR__) . '/app/bootstrap.php';

use App\Core\{Auth, Setting, View};

function frontend_fixture(string $page): string
{
    $member = in_array($page, ['dashboard', 'admin'], true);
    $u = $member ? [
        'id' => 1, 'username' => 'Sakura', 'rank' => 9, 'rank_name' => 'Team',
        'look' => cfg('hotel.default_look'), 'motto' => 'Willkommen unter Kirschblueten',
        'credits' => 1200, 'pixels' => 250, 'points' => 85,
    ] : null;
    foreach (['user' => $u, 'loaded' => true, 'perms' => $member ? ['housekeeping'] : []] as $key => $value) {
        (new ReflectionProperty(Auth::class, $key))->setValue(null, $value);
    }
    (new ReflectionProperty(Setting::class, 'all'))->setValue(null, []);
    $_SERVER['REQUEST_URI'] = match ($page) {
        'login' => '/login', 'register' => '/register', 'dashboard' => '/me', 'admin' => '/admin', default => '/',
    };
    $data = ['title' => 'Habbo Dream DE'];
    $template = match ($page) {
        'login' => 'auth/login', 'register' => 'auth/register', default => 'home/index',
    };
    $data += [
        'captcha' => '2 + 3', 'looks' => cfg('hotel.looks'),
        'stats' => ['online' => 12, 'members' => 234, 'rooms' => 56],
        'news' => [['slug' => 'sakura', 'title' => 'Neu im Sakura-Hotel', 'cat' => 'Community',
            'header' => asset('img/headers/bg-default.png'), 'short_story' => 'Freunde treffen und neue Raeume entdecken.']],
        'uoth' => $u,
        'gift' => $member ? ['ready' => true, 'amount' => 50] : null,
    ];
    $data['content'] = View::partial($template, $data);
    return View::partial($page === 'admin' ? 'layout/admin' : 'layout/main', $data);
}
