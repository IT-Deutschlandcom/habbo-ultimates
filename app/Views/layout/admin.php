<?php
use App\Core\Request;
use App\Controllers\Admin\CrudController;
$u = user(); $path = Request::path();
$a = fn(string $p, bool $x = false) => ($x ? $path === $p : str_starts_with($path, $p)) ? ' active' : '';
$items = [
    ['/admin', 'speedometer2', 'Dashboard', 'housekeeping', true],
    ['/admin/users', 'people', 'Nutzer', 'housekeeping_remote_control'],
    ['/admin/bans', 'slash-circle', 'Banns', 'housekeeping_ban_user'],
    ['/admin/tickets', 'ticket-detailed', 'Tickets', 'housekeeping_website_helptool'],
    ['/admin/applications', 'briefcase', 'Bewerbungen', 'housekeeping_jobs'],
    ['/admin/forum', 'chat-square-text', 'Forum-Moderation', 'housekeeping_forum'],
    ['/admin/comments', 'chat-dots', 'Kommentare', 'housekeeping_website_news'],
    ['/admin/badges', 'patch-check', 'Badge-Anfragen', 'housekeeping_badges'],
    ['/admin/rcon', 'terminal', 'RCON-Konsole', 'housekeeping_rcon'],
    ['/admin/permissions', 'key', 'Berechtigungen', 'housekeeping_permissions'],
    ['/admin/settings', 'sliders', 'Einstellungen', 'housekeeping_config'],
    ['/admin/logs', 'journal-text', 'Staff-Logs', 'housekeeping_logs'],
];
?><!doctype html>
<html lang="de"><head><?= \App\Core\View::partial('partials/head', get_defined_vars()) ?></head>
<body class="admin-body">
<canvas id="petals" style="opacity:.4"></canvas>
<header class="topbar">
  <button class="menu-btn" aria-label="Menü öffnen" aria-controls="site-sidebar" aria-expanded="false"><i class="bi bi-list"></i></button>
  <a class="brand" href="<?= url('/admin') ?>"><img src="<?= asset('img/logo-nav.png') ?>" alt=""></a>
  <span class="tag ms-2">Admin</span>
  <nav class="topnav"><a class="nl" href="<?= url('/') ?>"><i class="bi bi-box-arrow-up-right"></i> Website</a><span class="ms-2 small"><?= e($u['username'] ?? '') ?></span></nav>
</header>
<div class="shell">
  <aside class="sidebar side" id="site-sidebar" aria-label="Admin-Navigation">
    <?php foreach ($items as $it): [$p, $ic, $l, $perm] = $it; $exact = $it[4] ?? false; if (!can($perm)) continue; ?>
      <a class="si<?= $a($p, !empty($exact)) ?>" href="<?= url($p) ?>"><?= ui_icon($ic) ?><?= e($l) ?></a>
    <?php endforeach; ?>
    <div class="side-h">Inhalte</div>
    <?php foreach (CrudController::resources() as $k => $r): if (!can($r['perm'])) continue; ?>
      <a class="si<?= $a('/admin/c/' . $k) ?>" href="<?= url('/admin/c/' . $k) ?>"><?= ui_icon($r['icon']) ?><?= e($r['title']) ?></a>
    <?php endforeach; ?>
  </aside>
  <main class="main"><div class="wrap-wide"><?= $content ?></div></main>
</div>
<?= \App\Core\View::partial('partials/foot') ?>
</body></html>
