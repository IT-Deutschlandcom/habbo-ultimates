<?php
declare(strict_types=1);

require dirname(__DIR__) . '/app/bootstrap.php';

use App\Core\{Router, Setting, Auth, View, DB};

if (!is_file(ROOT . '/storage/install.lock')) {
    header('Location: ' . url('install.php'));
    exit;
}

try {
    if (Setting::get('maintenance') === '1' && !str_starts_with(\App\Core\Request::path(), '/admin') && !in_array(\App\Core\Request::path(), ['/login'], true) && !Auth::can('maintenance_login') && \App\Core\Request::method() === 'GET') {
        http_response_code(503);
        header('Retry-After: 3600');
        View::render('errors/maintenance', ['title' => 'Wartung'], 'bare');
        exit;
    }

    $r = new Router();
    $g = fn() => null;

    // Öffentlich
    $r->get('/', 'HomeController@index');
    $r->get('/api/online', 'HomeController@online');
    $r->get('/api/search', 'HomeController@search');
    $r->get('/news', 'NewsController@index');
    $r->get('/news/{slug}', 'NewsController@show');
    $r->post('/news/{slug}/comment', 'NewsController@comment', ['auth']);
    $r->get('/community', 'CommunityController@index');
    $r->get('/community/staff', 'CommunityController@staff');
    $r->get('/community/ranking', 'CommunityController@ranking');
    $r->get('/community/photos', 'CommunityController@photos');
    $r->post('/community/photos/{id:\d+}/like', 'CommunityController@likePhoto', ['auth']);
    $r->get('/community/rares', 'CommunityController@rares');
    $r->get('/community/guilds', 'CommunityController@guilds');
    $r->get('/forum', 'ForumController@index');
    $r->get('/forum/thread/{slug}', 'ForumController@thread');
    $r->post('/forum/thread/{slug}/reply', 'ForumController@reply', ['auth']);
    $r->get('/forum/{slug}', 'ForumController@topicView');
    $r->post('/forum/{slug}/new', 'ForumController@create', ['auth']);
    $r->post('/vote', 'VoteController@vote', ['auth']);
    $r->get('/profile/{name}', 'ProfileController@show');
    $r->post('/profile/{name}/guestbook', 'ProfileController@guestbook', ['auth']);
    $r->post('/guestbook/{id:\d+}/delete', 'ProfileController@guestbookDelete', ['auth']);
    $r->get('/help', 'HelpController@index');
    $r->get('/help/faq/{slug}', 'HelpController@faq');
    $r->get('/jobs', 'JobsController@index');
    $r->get('/shop', 'ShopController@index');
    $r->get('/page/{slug}', 'HotelController@page');

    // Gäste
    $r->get('/login', 'AuthController@loginForm', ['guest']);
    $r->post('/login', 'AuthController@login', ['guest']);
    $r->get('/register', 'AuthController@registerForm', ['guest']);
    $r->post('/register', 'AuthController@register', ['guest']);
    $r->get('/password/forgot', 'AuthController@forgotForm', ['guest']);
    $r->post('/password/forgot', 'AuthController@forgot', ['guest']);
    $r->get('/password/reset/{token:[a-f0-9]+}', 'AuthController@resetForm', ['guest']);
    $r->post('/password/reset/{token:[a-f0-9]+}', 'AuthController@reset', ['guest']);

    // Angemeldet
    $r->post('/logout', 'AuthController@logout', ['auth']);
    $r->get('/me', 'HomeController@index', ['auth']);
    $r->post('/gift', 'HomeController@gift', ['auth']);
    $r->get('/hotel', 'HotelController@client', ['auth']);
    $r->get('/settings', 'SettingsController@index', ['auth']);
    $r->post('/settings/profile', 'SettingsController@profile', ['auth']);
    $r->post('/settings/password', 'SettingsController@password', ['auth']);
    $r->post('/settings/email', 'SettingsController@email', ['auth']);
    $r->post('/settings/namechange', 'SettingsController@namechange', ['auth']);
    $r->get('/shop/club', 'ShopController@club', ['auth']);
    $r->post('/shop/club', 'ShopController@buyClub', ['auth']);
    $r->get('/help/tickets', 'HelpController@tickets', ['auth']);
    $r->get('/help/tickets/new', 'HelpController@newForm', ['auth']);
    $r->post('/help/tickets/new', 'HelpController@create', ['auth']);
    $r->get('/help/tickets/{id:\d+}', 'HelpController@ticket', ['auth']);
    $r->post('/help/tickets/{id:\d+}/reply', 'HelpController@reply', ['auth']);
    $r->get('/jobs/{id:\d+}/apply', 'JobsController@applyForm', ['auth']);
    $r->post('/jobs/{id:\d+}/apply', 'JobsController@apply', ['auth']);

    // Housekeeping
    $p = ['perm:housekeeping'];
    $r->get('/admin', 'Admin\AdminController@dashboard', $p);
    $r->get('/admin/users', 'Admin\AdminController@users', $p);
    $r->get('/admin/users/{id:\d+}', 'Admin\AdminController@userEdit', $p);
    $r->post('/admin/users/{id:\d+}', 'Admin\AdminController@userSave', $p);
    $r->post('/admin/users/{id:\d+}/ban', 'Admin\AdminController@ban', $p);
    $r->get('/admin/bans', 'Admin\AdminController@bans', $p);
    $r->post('/admin/bans/{id:\d+}/unban', 'Admin\AdminController@unban', $p);
    $r->get('/admin/tickets', 'Admin\AdminController@tickets', $p);
    $r->get('/admin/tickets/{id:\d+}', 'Admin\AdminController@ticket', $p);
    $r->post('/admin/tickets/{id:\d+}', 'Admin\AdminController@ticketReply', $p);
    $r->get('/admin/applications', 'Admin\AdminController@applications', $p);
    $r->post('/admin/applications/{id:\d+}/close', 'Admin\AdminController@applicationClose', $p);
    $r->get('/admin/permissions', 'Admin\AdminController@permissions', $p);
    $r->post('/admin/permissions', 'Admin\AdminController@permissionsSave', $p);
    $r->get('/admin/settings', 'Admin\AdminController@settings', $p);
    $r->post('/admin/settings', 'Admin\AdminController@settingsSave', $p);
    $r->get('/admin/logs', 'Admin\AdminController@logs', $p);
    $r->get('/admin/forum', 'Admin\AdminController@forum', $p);
    $r->post('/admin/forum/{id:\d+}/{act:pin|lock|delete}', 'Admin\AdminController@forumAction', $p);
    $r->get('/admin/comments', 'Admin\AdminController@comments', $p);
    $r->post('/admin/comments/{id:\d+}/toggle', 'Admin\AdminController@commentToggle', $p);
    $r->get('/admin/badges', 'Admin\AdminController@badges', $p);
    $r->post('/admin/badges/{id:\d+}/{act:accept|decline}', 'Admin\AdminController@badgeDecide', $p);
    $r->get('/admin/rcon', 'Admin\AdminController@rcon', $p);
    $r->post('/admin/rcon', 'Admin\AdminController@rconSend', $p);
    $r->get('/admin/c/{k:[a-z_]+}', 'Admin\CrudController@index', $p);
    $r->get('/admin/c/{k:[a-z_]+}/new', 'Admin\CrudController@form', $p);
    $r->get('/admin/c/{k:[a-z_]+}/{id:\d+}', 'Admin\CrudController@form', $p);
    $r->post('/admin/c/{k:[a-z_]+}/save', 'Admin\CrudController@save', $p);
    $r->post('/admin/c/{k:[a-z_]+}/{id:\d+}/delete', 'Admin\CrudController@delete', $p);

    $r->dispatch();
} catch (\Throwable $e) {
    error_log((string)$e);
    http_response_code(500);
    if (\App\Core\Config::get('site.debug')) { echo '<pre>' . htmlspecialchars((string)$e) . '</pre>'; exit; }
    View::render('errors/500', ['title' => 'Fehler'], 'bare');
}
