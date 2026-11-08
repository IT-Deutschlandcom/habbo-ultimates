<a href="<?= url('/admin/users') ?>" class="small"><i class="bi bi-arrow-left"></i> Nutzer</a>
<div class="d-flex gap-3 align-items-center mt-2 mb-3"><div class="avatar lg" style="background-image:url('<?= e(look_url($u['look'])) ?>');background-size:cover"></div><div><h1 class="page-title mb-0"><?= e($u['username']) ?></h1><span class="tag"><?= e($u['rank_name']) ?></span> <small class="text-mut">ID <?= (int)$u['id'] ?> · IP <?= e($u['ip_current'] ?? '') ?></small></div></div>
<div class="row g-3"><div class="col-lg-7"><form class="cardx cardx-b" method="post" action="<?= url('/admin/users/' . (int)$u['id']) ?>"><?= csrf_field() ?>
  <div class="row g-3">
    <div class="col-md-6"><label class="form-label">Motto</label><input class="form-control" name="motto" value="<?= e($u['motto']) ?>" maxlength="127"></div>
    <div class="col-md-6"><label class="form-label">E-Mail</label><input class="form-control" name="mail" value="<?= e($u['mail']) ?>"></div>
    <div class="col-4"><label class="form-label">Credits</label><input class="form-control" type="number" name="credits" value="<?= (int)$u['credits'] ?>"></div>
    <div class="col-4"><label class="form-label">Pixel</label><input class="form-control" type="number" name="pixels" value="<?= (int)($cur[0] ?? $u['pixels'] ?? 0) ?>"></div>
    <div class="col-4"><label class="form-label">Diamanten</label><input class="form-control" type="number" name="points" value="<?= (int)($cur[5] ?? $u['points'] ?? 0) ?>"></div>
    <div class="col-md-6"><label class="form-label">Rang</label><select class="form-select" name="rank"><?php foreach ($ranks as $r): ?><option value="<?= (int)$r['id'] ?>" <?= (int)$r['id'] === (int)$u['rank'] ? 'selected' : '' ?>><?= (int)$r['id'] ?> – <?= e($r['rank_name']) ?></option><?php endforeach; ?></select></div>
    <div class="col-md-6"><label class="form-label">Neues Passwort (optional)</label><input class="form-control" type="password" name="new_password" autocomplete="new-password"></div>
    <div class="col-12"><button class="btn btn-pink">Speichern</button></div>
  </div></form></div>
<div class="col-lg-5"><form class="cardx cardx-b mb-3" method="post" action="<?= url('/admin/users/' . (int)$u['id'] . '/ban') ?>" data-confirm="Nutzer bannen?"><?= csrf_field() ?><h5>Bannen</h5>
  <select class="form-select mb-2" name="type"><?php foreach ($banTypes as $b): ?><option value="<?= (int)$b['id'] ?>"><?= e($b['message']) ?></option><?php endforeach; ?></select>
  <input class="form-control mb-2" name="reason" placeholder="Grund" maxlength="255"><button class="btn btn-ghost-danger w-100">Bannen</button></form>
  <div class="cardx cardx-b"><h5>Bann-Historie</h5><?php foreach ($bans as $b): ?><div class="kv"><span><?= e($b['ban_reason']) ?> <small class="text-mut">(<?= e($b['staff'] ?? '?') ?>)</small></span><small>bis <?= date('d.m.Y', (int)$b['ban_expire']) ?></small></div><?php endforeach; if (!$bans): ?><span class="text-mut">Keine Banns.</span><?php endif; ?></div></div></div>
