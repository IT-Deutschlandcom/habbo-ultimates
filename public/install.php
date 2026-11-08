<?php
declare(strict_types=1);
/** Web-Installer – läuft nur, solange storage/install.lock fehlt. Danach sperrt er sich selbst. */
$root = dirname(__DIR__);
$lock = $root . '/storage/install.lock';
if (is_file($lock)) { http_response_code(403); exit('Bereits installiert. Lösche storage/install.lock nur, wenn du neu installieren willst.'); }

session_start();
if (empty($_SESSION['t'])) $_SESSION['t'] = bin2hex(random_bytes(16));
$h = fn($s) => htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8');
$err = []; $ok = false;
$v = ['host' => '127.0.0.1', 'port' => '3306', 'name' => 'habbodream', 'user' => 'root', 'admin' => 'Admin', 'mail' => ''];

$checks = [
    'PHP ≥ 8.3' => PHP_VERSION_ID >= 80300, 'pdo_mysql' => extension_loaded('pdo_mysql'), 'mbstring' => extension_loaded('mbstring'),
    'gd (Uploads)' => extension_loaded('gd'), 'fileinfo' => extension_loaded('fileinfo'),
    'config.php beschreibbar' => is_writable($root . '/config.php'), 'storage/ beschreibbar' => is_writable($root . '/storage'),
];

function split_sql(string $sql): array {
    $out = []; $buf = ''; $q = null; $n = strlen($sql);
    for ($i = 0; $i < $n; $i++) {
        $c = $sql[$i];
        if ($q) {
            $buf .= $c;
            if ($c === '\\' && $i + 1 < $n) { $buf .= $sql[++$i]; continue; }
            if ($c === $q) { if ($i + 1 < $n && $sql[$i + 1] === $q) { $buf .= $sql[++$i]; continue; } $q = null; }
            continue;
        }
        if ($c === '-' && substr($sql, $i, 3) === '-- ') { $j = strpos($sql, "\n", $i); $i = $j === false ? $n : $j; continue; }
        if ($c === "'" || $c === '"' || $c === '`') { $q = $c; $buf .= $c; continue; }
        if ($c === ';') { if (trim($buf) !== '') $out[] = $buf; $buf = ''; continue; }
        $buf .= $c;
    }
    if (trim($buf) !== '') $out[] = $buf;
    return $out;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!hash_equals($_SESSION['t'], (string)($_POST['t'] ?? ''))) exit('Ungültiges Token.');
    foreach (array_keys($v) as $k) $v[$k] = trim((string)($_POST[$k] ?? ''));
    $pass = (string)($_POST['pass'] ?? ''); $apass = (string)($_POST['apass'] ?? '');
    if (in_array(false, $checks, true)) $err[] = 'Systemvoraussetzungen nicht erfüllt.';
    if (!preg_match('/^[A-Za-z0-9_]{1,64}$/', $v['name'])) $err[] = 'Datenbankname ungültig (nur A–Z, 0–9, _).';
    if (!preg_match('/^[A-Za-z0-9\-=?!@:.]{3,15}$/', $v['admin'])) $err[] = 'Admin-Name: 3–15 Zeichen.';
    if (!filter_var($v['mail'], FILTER_VALIDATE_EMAIL)) $err[] = 'Ungültige Admin-E-Mail.';
    if (strlen($apass) < 8) $err[] = 'Admin-Passwort: mindestens 8 Zeichen.';
    if (!$err) {
        try {
            $pdo = new PDO("mysql:host={$v['host']};port=" . (int)$v['port'] . ';charset=utf8mb4', $v['user'], $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
            $pdo->exec("CREATE DATABASE IF NOT EXISTS `{$v['name']}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            $pdo->exec("USE `{$v['name']}`");
            if ($pdo->query("SHOW TABLES LIKE 'users'")->fetch()) throw new RuntimeException('Die Datenbank enthält bereits Tabellen. Bitte eine leere Datenbank verwenden.');
            $pdo->exec('SET FOREIGN_KEY_CHECKS=0');
            foreach (['01_base_jan-d.sql', '02_ares_additions.sql'] as $f)
                foreach (split_sql((string)file_get_contents($root . '/database/' . $f)) as $s) $pdo->exec($s);
            $pdo->exec('SET FOREIGN_KEY_CHECKS=1');
            $now = time();
            $cfgLook = 'hr-115-42.hd-195-19.ch-3030-82.lg-275-1408.fa-1201.ca-1804-64';
            $st = $pdo->prepare('INSERT INTO users (username, real_name, password, mail, account_created, last_login, last_online, motto, look, gender, `rank`, credits, ip_register, ip_current) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
            $ip = (string)($_SERVER['REMOTE_ADDR'] ?? '');
            $st->execute([$v['admin'], $v['admin'], password_hash($apass, PASSWORD_DEFAULT), strtolower($v['mail']), $now, $now, $now, 'Gründer', $cfgLook, 'M', 9, 10000, $ip, $ip]);
            $id = (int)$pdo->lastInsertId();
            $pdo->prepare('INSERT IGNORE INTO users_settings (user_id, credits) VALUES (?, 10000)')->execute([$id]);

            $cfg = file_get_contents($root . '/config.php');
            $blk = preg_match("/'db'\s*=>\s*\[.*?\],/s", $cfg, $m) ? $m[0] : '';
            if ($blk === '') throw new RuntimeException('config.php: db-Block nicht gefunden.');
            $new = $blk;
            foreach (['host' => $v['host'], 'name' => $v['name'], 'user' => $v['user'], 'password' => $pass] as $k => $val)
                $new = preg_replace("/('$k'\s*=>\s*)'[^']*'/", '$1' . var_export($val, true), $new, 1);
            $new = preg_replace("/('port'\s*=>\s*)\d+/", '${1}' . (int)$v['port'], $new, 1);
            file_put_contents($root . '/config.php', str_replace($blk, $new, $cfg), LOCK_EX);
            file_put_contents($lock, date('c'));
            $ok = true;
        } catch (Throwable $e) { $err[] = 'Fehler: ' . $e->getMessage(); }
    }
}
?><!doctype html><html lang="de"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Installation</title>
<link rel="stylesheet" href="assets/vendor/bootstrap/bootstrap.min.css"><link rel="stylesheet" href="assets/vendor/icons/bootstrap-icons.min.css"><link rel="stylesheet" href="assets/css/app.css"></head>
<body><div class="auth-wrap"><div class="auth-card wide cardx"><div class="cardx-b p-4">
<div class="text-center mb-3"><img src="assets/img/logo.png" style="height:90px;max-width:100%;object-fit:contain" alt=""></div>
<?php if ($ok): ?>
  <h3 class="text-center">Installation abgeschlossen 🌸</h3>
  <p class="text-center text-mut">Die Datenbank wurde angelegt und <code>config.php</code> aktualisiert. Der Installer ist jetzt gesperrt.</p>
  <a class="btn btn-pink w-100" href="login">Zum Login</a>
<?php else: ?>
  <h3 class="text-center">Installation</h3>
  <ul class="list-unstyled small"><?php foreach ($checks as $l => $o): ?><li><i class="bi bi-<?= $o ? 'check-circle-fill text-success' : 'x-circle-fill text-danger' ?>"></i> <?= $h($l) ?></li><?php endforeach; ?></ul>
  <?php foreach ($err as $e): ?><div class="alert alert-danger"><?= $h($e) ?></div><?php endforeach; ?>
  <form method="post"><input type="hidden" name="t" value="<?= $h($_SESSION['t']) ?>"><div class="row g-3">
    <div class="col-8"><label class="form-label">DB-Host</label><input class="form-control" name="host" value="<?= $h($v['host']) ?>"></div>
    <div class="col-4"><label class="form-label">Port</label><input class="form-control" name="port" value="<?= $h($v['port']) ?>"></div>
    <div class="col-md-4"><label class="form-label">Datenbankname</label><input class="form-control" name="name" value="<?= $h($v['name']) ?>"></div>
    <div class="col-md-4"><label class="form-label">DB-Benutzer</label><input class="form-control" name="user" value="<?= $h($v['user']) ?>"></div>
    <div class="col-md-4"><label class="form-label">DB-Passwort</label><input class="form-control" type="password" name="pass"></div>
    <div class="col-md-4"><label class="form-label">Admin-Name</label><input class="form-control" name="admin" value="<?= $h($v['admin']) ?>"></div>
    <div class="col-md-4"><label class="form-label">Admin-E-Mail</label><input class="form-control" type="email" name="mail" value="<?= $h($v['mail']) ?>"></div>
    <div class="col-md-4"><label class="form-label">Admin-Passwort</label><input class="form-control" type="password" name="apass"></div>
    <div class="col-12"><button class="btn btn-pink w-100">Installieren</button></div></div></form>
<?php endif; ?>
</div></div></div></body></html>
