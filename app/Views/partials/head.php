<?php use App\Core\{Csrf, Request, Session}; ?>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="csrf" content="<?= e(Csrf::token()) ?>">
<meta name="theme-color" content="#202225">
<title><?= e($title ?? '') ?> · <?= e(cfg('site.name')) ?></title>
<link rel="icon" href="<?= asset('img/logo-nav.png') ?>">
<link rel="stylesheet" href="<?= asset('vendor/bootstrap/bootstrap.min.css') ?>">
<link rel="stylesheet" href="<?= asset('vendor/icons/bootstrap-icons.min.css') ?>">
<link rel="stylesheet" href="<?= asset('css/app.css') ?>">
