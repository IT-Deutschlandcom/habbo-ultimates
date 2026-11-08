<h1 class="page-title">Nutzer</h1>
<form class="d-flex gap-2 mb-3" method="get"><input class="form-control" name="q" value="<?= e($q) ?>" placeholder="Name oder E-Mail suchen…"><button class="btn btn-pink">Suchen</button></form>
<div class="cardx"><div class="table-responsive"><table class="table table-hover mb-0"><thead><tr><th>Nutzer</th><th>E-Mail</th><th>Rang</th><th>Credits</th><th>Status</th><th>Registriert</th></tr></thead><tbody>
<?php foreach ($rows as $r): ?><tr><td><a href="<?= url('/admin/users/' . (int)$r['id']) ?>" class="d-flex align-items-center gap-2"><span class="avatar sm" style="background-image:url('<?= e(head_url($r['look'])) ?>')"></span><?= e($r['username']) ?></a></td><td><?= e($r['mail']) ?></td><td><span class="tag"><?= e($r['rank_name']) ?></span></td><td><?= num($r['credits']) ?></td><td><span class="tag <?= $r['online'] ? 'green' : 'gray' ?>"><?= $r['online'] ? 'online' : 'offline' ?></span></td><td><?= date('d.m.Y', (int)$r['account_created']) ?></td></tr><?php endforeach; ?>
</tbody></table></div></div>
<?= \App\Core\View::partial('partials/pager', ['pg' => $pg, 'base' => '/admin/users', 'qs' => $q !== '' ? 'q=' . urlencode($q) : '']) ?>
