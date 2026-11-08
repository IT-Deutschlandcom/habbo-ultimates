<h1 class="page-title">Banns</h1>
<div class="cardx"><div class="table-responsive"><table class="table table-hover mb-0"><thead><tr><th>Nutzer</th><th>Grund</th><th>Von</th><th>Bis</th><th></th></tr></thead><tbody>
<?php foreach ($rows as $r): $act = (int)$r['ban_expire'] > time(); ?><tr><td><?= e($r['username'] ?? ($r['ip'] ?? '?')) ?></td><td><?= e($r['ban_reason']) ?></td><td><?= e($r['staff'] ?? '–') ?></td><td><?= date('d.m.Y H:i', (int)$r['ban_expire']) ?> <span class="tag <?= $act ? 'red' : 'gray' ?>"><?= $act ? 'aktiv' : 'abgelaufen' ?></span></td>
<td><?php if ($act): ?><form method="post" action="<?= url('/admin/bans/' . (int)$r['id'] . '/unban') ?>"><?= csrf_field() ?><button class="btn btn-sm btn-dark2">Entbannen</button></form><?php endif; ?></td></tr><?php endforeach; ?>
</tbody></table></div></div>
