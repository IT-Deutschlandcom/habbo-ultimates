<div class="d-flex justify-content-between align-items-center"><div><h1 class="page-title"><?= e($r['title']) ?></h1></div><a class="btn btn-pink" href="<?= url('/admin/c/' . $r['key'] . '/new') ?>"><i class="bi bi-plus-lg"></i> Neu</a></div>
<div class="cardx mt-2"><div class="table-responsive"><table class="table table-hover mb-0"><thead><tr><?php foreach ($r['list'] as $c => $l): ?><th><?= e(is_array($l) ? $l[0] : $l) ?></th><?php endforeach; ?><th></th></tr></thead><tbody>
<?php foreach ($rows as $row): ?><tr>
<?php foreach ($r['list'] as $c => $l): $v = $row[$c] ?? ''; ?><td><?= is_array($l) && $l[1] === 'date' ? date('d.m.Y', (int)$v) : e(mb_strimwidth((string)$v, 0, 80, '…')) ?></td><?php endforeach; ?>
<td class="text-end text-nowrap"><a class="btn btn-sm btn-dark2" href="<?= url('/admin/c/' . $r['key'] . '/' . (int)$row['id']) ?>"><i class="bi bi-pencil"></i></a>
<form class="d-inline" method="post" action="<?= url('/admin/c/' . $r['key'] . '/' . (int)$row['id'] . '/delete') ?>" data-confirm="Wirklich löschen?"><?= csrf_field() ?><button class="btn btn-sm btn-ghost-danger"><i class="bi bi-trash"></i></button></form></td></tr><?php endforeach; ?>
</tbody></table></div></div>
