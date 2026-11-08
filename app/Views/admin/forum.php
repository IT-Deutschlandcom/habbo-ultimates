<h1 class="page-title">Forum-Moderation</h1>
<div class="cardx"><div class="table-responsive"><table class="table table-hover mb-0"><thead><tr><th>Thema</th><th>Bereich</th><th>Von</th><th>Antw.</th><th></th></tr></thead><tbody>
<?php foreach ($rows as $r): ?><tr><td><a href="<?= url('/forum/thread/' . $r['slug']) ?>"><?= e($r['title']) ?></a> <?= $r['pinned'] ? '<span class="tag">angepinnt</span>' : '' ?> <?= $r['locked'] ? '<span class="tag gray">gesperrt</span>' : '' ?></td><td><?= e($r['topic']) ?></td><td><?= e($r['username']) ?></td><td><?= (int)$r['replies'] ?></td>
<td class="text-end"><form class="d-inline-flex gap-1" method="post"><?= csrf_field() ?>
<?php foreach (['pin' => ['pin-angle', ''], 'lock' => ['lock', ''], 'delete' => ['trash', 'btn-ghost-danger']] as $a => [$ic, $cl]): ?><button class="btn btn-sm <?= $cl ?: 'btn-dark2' ?>" formaction="<?= url('/admin/forum/' . (int)$r['id'] . '/' . $a) ?>" <?= $a === 'delete' ? 'onclick="return confirm(\'Wirklich löschen?\')"' : '' ?>><i class="bi bi-<?= $ic ?>"></i></button><?php endforeach; ?></form></td></tr><?php endforeach; ?>
</tbody></table></div></div>
