<a href="<?= url('/admin/c/' . $r['key']) ?>" class="small"><i class="bi bi-arrow-left"></i> <?= e($r['title']) ?></a>
<h1 class="page-title mt-1"><?= e($title) ?></h1>
<form class="cardx cardx-b" method="post" action="<?= url('/admin/c/' . $r['key'] . '/save') ?>" enctype="multipart/form-data"><?= csrf_field() ?>
<input type="hidden" name="id" value="<?= (int)($row['id'] ?? 0) ?>">
<?php foreach ($r['fields'] as $f): [$n, $l, $t] = $f; $v = $row[$n] ?? ''; ?>
  <div class="mb-3"><label class="form-label"><?= e($l) ?></label>
  <?php if ($t === 'textarea'): ?><textarea class="form-control" name="<?= e($n) ?>" rows="<?= (int)($f[3] ?? 4) ?>"><?= e($v) ?></textarea>
  <?php elseif ($t === 'bool'): ?><div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="<?= e($n) ?>" value="1" <?= (string)$v === '1' ? 'checked' : '' ?>></div>
  <?php elseif ($t === 'image'): ?><input class="form-control mb-2" name="<?= e($n) ?>" value="<?= e($v) ?>" placeholder="https://… oder /uploads/…"><input class="form-control" type="file" name="<?= e($n) ?>_file" accept="image/png,image/jpeg,image/gif,image/webp">
  <?php elseif (str_starts_with($t, 'select:')): ?><select class="form-select" name="<?= e($n) ?>"><?php foreach ($opts[$n] ?? [] as $o): ?><option value="<?= (int)$o['id'] ?>" <?= (string)$o['id'] === (string)$v ? 'selected' : '' ?>><?= e($o['label']) ?></option><?php endforeach; ?></select>
  <?php else: ?><input class="form-control" type="<?= $t === 'number' ? 'number' : 'text' ?>" name="<?= e($n) ?>" value="<?= e($v) ?>"><?php endif; ?></div>
<?php endforeach; ?>
<button class="btn btn-pink">Speichern</button></form>
