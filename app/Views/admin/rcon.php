<h1 class="page-title">RCON-Konsole</h1><p class="page-sub">Befehle direkt an den Emulator senden.</p>
<?php if (!$enabled): ?><div class="alert alert-warning">RCON ist deaktiviert. Aktiviere es in <code>config.php</code> (<code>rcon.enabled</code>).</div><?php endif; ?>
<div class="row g-3"><?php foreach ($cmds as $c): ?><div class="col-md-6 reveal"><form class="cardx cardx-b" data-rcon method="post" action="<?= url('/admin/rcon') ?>"><?= csrf_field() ?><input type="hidden" name="command" value="<?= e($c['command']) ?>">
<h5><?= e($c['title']) ?></h5><p class="small text-mut"><?= e($c['description']) ?></p>
<?php foreach (array_filter(explode(',', (string)$c['fields'])) as $f): ?><input class="form-control mb-2" name="f_<?= e($f) ?>" placeholder="<?= e($f) ?>" required><?php endforeach; ?><button class="btn btn-pink btn-sm" <?= $enabled ? '' : 'disabled' ?>>Senden</button></form></div><?php endforeach; ?></div>
