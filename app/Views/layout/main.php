<?php
use App\Core\Request;
$u = user();
$path = Request::path();
$act = fn(string $p, bool $exact = false) => ($exact ? $path === $p : ($p === '/' ? $path === '/' : str_starts_with($path, $p))) ? ' active' : '';
$side = [
    'Allgemein' => [['/me', 'speedometer2', 'Dashboard']],
    'Community' => [['/news', 'newspaper', 'News'], ['/community', 'people', 'Community'], ['/forum', 'chat-square-text', 'Forum'], ['/community/staff', 'shield-check', 'Team']],
    'Entdecken' => [['/community/ranking', 'trophy', 'Ranking'], ['/community/photos', 'camera', 'Fotos'], ['/community/rares', 'gem', 'Rare-Werte'], ['/community/guilds', 'flag', 'Gruppen']],
    'Service' => [['/shop', 'bag-heart', 'Shop'], ['/shop/club', 'star', 'Club'], ['/help', 'life-preserver', 'Hilfe'], ['/jobs', 'briefcase', 'Jobs']],
];
?><!doctype html>
<html lang="de"><head><?= \App\Core\View::partial('partials/head', get_defined_vars()) ?></head>
<body class="<?= e($bodyClass ?? '') ?>">
<div id="loader"><img src="<?= asset('img/logo.png') ?>" alt=""><div class="pct">0%</div><div class="bar"><i></i></div><small>Lade das Hotel…</small></div>
<canvas id="petals"></canvas>
<header class="topbar">
  <button class="menu-btn" aria-label="Menü öffnen" aria-controls="site-sidebar" aria-expanded="false"><i class="bi bi-list"></i></button>
  <a class="brand" href="<?= url('/') ?>"><img src="<?= asset('img/logo-nav.png') ?>" alt="<?= e(cfg('site.name')) ?>"></a>
  <nav class="topnav">
    <a class="nl<?= $act('/', true) ?>" href="<?= url('/') ?>">Home</a>
    <a class="nl<?= $act('/community') ?>" href="<?= url('/community') ?>">Community</a>
    <a class="nl<?= $act('/news') ?>" href="<?= url('/news') ?>">News</a>
    <a class="nl<?= $act('/shop') ?>" href="<?= url('/shop') ?>">Shop</a>
    <a class="nl hide-m<?= $act('/community/staff') ?>" href="<?= url('/community/staff') ?>">Team</a>
    <?php if ($u): ?>
      <div class="wallet">
        <span title="Credits"><?= ui_icon('credits') ?><?= num($u['credits']) ?></span>
        <span title="Pixel"><?= ui_icon('duckets') ?><?= num($u['pixels']) ?></span>
        <span title="Diamanten"><?= ui_icon('diamonds') ?><?= num($u['points']) ?></span>
      </div>
      <a class="btn btn-pink ms-2" href="<?= url('/hotel') ?>"><i class="bi bi-play-fill"></i> Hotel</a>
    <?php else: ?>
      <a class="btn btn-dark2 ms-2" href="<?= url('/login') ?>">Einloggen</a>
      <a class="btn btn-pink ms-1" href="<?= url('/register') ?>">Registrieren</a>
    <?php endif; ?>
  </nav>
</header>
<div class="shell">
  <aside class="sidebar side" id="site-sidebar" aria-label="Hauptnavigation">
    <?php if ($u): ?>
    <a href="<?= url('/profile/' . rawurlencode($u['username'])) ?>" class="side-user text-decoration-none text-white">
      <span class="av" style="background-image:url('<?= e(head_url($u['look'])) ?>')"></span>
      <span><b><?= e($u['username']) ?></b><small><?= e($u['rank_name'] ?? 'Mitglied') ?></small></span>
    </a>
    <?php else: ?>
    <div class="side-user"><span><?= ui_icon('people') ?></span><span><b>Dein Sakura-Hotel</b><small>Freunde. Räume. Community.</small></span></div>
    <?php endif; ?>
    <?php foreach ($side as $h => $items): ?>
      <div class="side-h"><?= e($h) ?></div>
      <?php foreach ($items as [$p, $ic, $l]): ?>
        <?php $target = !$u && $p === '/me' ? '/' : $p; ?>
        <a class="si<?= $act($target, in_array($target, ['/', '/community', '/shop', '/me', '/help', '/community/staff'], true)) ?>" href="<?= url($target) ?>"><?= ui_icon($ic) ?><?= e($l) ?></a>
      <?php endforeach; ?>
    <?php endforeach; ?>
    <div class="side-h">Konto</div>
    <?php if ($u): ?>
    <a class="si<?= $act('/settings') ?>" href="<?= url('/settings') ?>"><?= ui_icon('gear') ?>Einstellungen</a>
    <a class="si<?= $act('/help/tickets') ?>" href="<?= url('/help/tickets') ?>"><?= ui_icon('ticket-detailed') ?>Meine Tickets</a>
    <?php if (can('housekeeping')): ?><a class="si" href="<?= url('/admin') ?>"><?= ui_icon('shield-lock') ?>Admin-Panel</a><?php endif; ?>
    <form method="post" action="<?= url('/logout') ?>"><?= csrf_field() ?><button class="si w-100 text-start"><?= ui_icon('box-arrow-left') ?>Abmelden</button></form>
    <?php else: ?>
    <a class="si<?= $act('/login') ?>" href="<?= url('/login') ?>"><?= ui_icon('key') ?>Einloggen</a>
    <a class="si<?= $act('/register') ?>" href="<?= url('/register') ?>"><?= ui_icon('person-plus') ?>Registrieren</a>
    <?php endif; ?>
  </aside>
  <main class="main"><?= $content ?>
    <footer class="text-center text-mut small mt-5 pt-4" style="border-top:1px solid var(--line)">
      © <?= date('Y') ?> <?= e(cfg('site.name')) ?> · <a href="<?= url('/page/rules') ?>">Hausregeln</a> · <a href="<?= url('/page/privacy') ?>">Datenschutz</a> · <a href="<?= url('/page/imprint') ?>">Impressum</a>
      <div class="mt-1">Dieser Dienst ist nicht mit Sulake Oy verbunden.</div>
    </footer>
  </main>
</div>
<?= \App\Core\View::partial('partials/foot') ?>
</body></html>
