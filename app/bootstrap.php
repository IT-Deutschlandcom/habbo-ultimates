<?php
declare(strict_types=1);

define('ROOT', dirname(__DIR__));
define('APP', __DIR__);

spl_autoload_register(function (string $c): void {
    if (str_starts_with($c, 'App\\')) {
        $f = APP . '/' . str_replace('\\', '/', substr($c, 4)) . '.php';
        if (is_file($f)) require $f;
    }
});

require APP . '/helpers.php';

use App\Core\{Config, Session, Request};

Config::load(ROOT . '/config.php');
date_default_timezone_set(Config::get('site.timezone', 'UTC'));
mb_internal_encoding('UTF-8');

if (Config::get('site.debug')) { ini_set('display_errors', '1'); error_reporting(E_ALL); }
else { ini_set('display_errors', '0'); error_reporting(E_ALL); }
ini_set('log_errors', '1');
ini_set('error_log', ROOT . '/storage/logs/php-error.log');

Request::enforceHost();
Request::enforceHttps();
Session::start();
