<h1 class="page-title">Berechtigungen</h1><p class="page-sub">Welcher Rang darf was? Es können nur Ränge unter deinem eigenen verwaltet werden.</p>
<form method="post" action="<?= url('/admin/permissions') ?>"><?= csrf_field() ?>
<div class="cardx"><div class="table-responsive"><table class="table table-sm table-hover mb-0"><thead><tr><th>Berechtigung</th><?php foreach ($ranks as $r): ?><th class="text-center" title="<?= e($r['rank_name']) ?>"><?= (int)$r['id'] ?></th><?php endforeach; ?></tr></thead><tbody>
<?php foreach ($perms as $p): ?><tr><td><code><?= e($p['permission']) ?></code><div class="small text-mut"><?= e($p['description']) ?></div></td><?php foreach ($ranks as $r): ?><td class="text-center"><input type="checkbox" class="form-check-input" name="p[<?= (int)$r['id'] ?>][]" value="<?= (int)$p['id'] ?>" <?= !empty($map[$p['id']][$r['id']]) ? 'checked' : '' ?>></td><?php endforeach; ?></tr><?php endforeach; ?>
</tbody></table></div></div>
<button class="btn btn-pink mt-3">Speichern</button></form>
<div class="small text-mut mt-2"><?php foreach ($ranks as $r) echo (int)$r['id'] . ' = ' . e($r['rank_name']) . ' · '; ?></div>
