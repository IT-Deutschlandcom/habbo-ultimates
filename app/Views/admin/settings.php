<h1 class="page-title">Einstellungen</h1>
<form method="post" action="<?= url('/admin/settings') ?>"><?= csrf_field() ?>
<?php foreach ($groups as $g => $fields): ?><div class="cardx mb-3 reveal"><div class="cardx-h"><h3><?= e($g) ?></h3></div><div class="cardx-b row g-3">
  <?php foreach ($fields as $k => [$l, $t]): ?><div class="<?= $t === 'textarea' ? 'col-12' : 'col-md-6' ?>"><label class="form-label"><?= e($l) ?></label>
    <?php if ($t === 'textarea'): ?><textarea class="form-control" rows="5" name="s[<?= e($k) ?>]"><?= e(setting($k, '')) ?></textarea><?php else: ?><input class="form-control" name="s[<?= e($k) ?>]" value="<?= e(setting($k, '')) ?>"><?php endif; ?></div><?php endforeach; ?></div></div><?php endforeach; ?>
<button class="btn btn-pink">Speichern</button></form>
