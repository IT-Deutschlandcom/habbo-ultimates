<?php $me = user(); $own = $me && (int)$me['id'] === (int)$p['id']; ?>
<div class="wrap-wide"><div class="row g-3">
  <div class="col-lg-4">
    <div class="cardx text-center reveal"><div class="cardx-b py-4">
      <div class="avatar-full mx-auto" style="width:90px;height:160px;background-image:url('<?= e(look_url($p['look'])) ?>')"></div>
      <h3 class="mt-2 mb-0"><?= e($p['username']) ?> <span class="tag <?= $p['online'] ? 'green' : 'gray' ?>"><?= $p['online'] ? 'Online' : 'Offline' ?></span></h3>
      <div class="text-mut"><?= e($p['motto']) ?></div>
      <div class="mt-2"><span class="tag"><?= e($p['rank_name'] ?? 'Mitglied') ?></span></div>
      <div class="d-flex justify-content-center gap-1 mt-3 flex-wrap"><?php foreach ($badges as $b): ?><img src="<?= e(cfg('hotel.badge_url', 'https://images.habbo.com/c_images/album1584/') . rawurlencode($b['badge_code']) . '.gif') ?>" alt="" title="<?= e($b['badge_code']) ?>"><?php endforeach; ?></div>
      <div class="kv mt-3"><span>Registriert</span><b><?= date('d.m.Y', (int)$p['account_created']) ?></b></div>
      <div class="kv"><span>Zuletzt online</span><b><?= $p['last_online'] ? ago((int)$p['last_online']) : '–' ?></b></div>
      <?php if ($own): ?><a href="<?= url('/settings') ?>" class="btn btn-dark2 w-100 mt-2">Einstellungen</a><?php endif; ?>
    </div></div>
  </div>
  <div class="col-lg-8 d-flex flex-column gap-3">
    <div class="cardx reveal"><div class="cardx-h"><div><h3>Räume</h3><small>Beliebteste Räume</small></div></div><div class="cardx-b">
      <?php foreach ($rooms as $r): ?><div class="kv"><span><i class="bi bi-door-open"></i> <?= e($r['name']) ?></span><b><?= (int)$r['users'] ?> Besucher</b></div><?php endforeach; if (!$rooms): ?><span class="text-mut">Keine Räume.</span><?php endif; ?></div></div>
    <?php if ($photos): ?><div class="cardx reveal"><div class="cardx-h"><h3>Fotos</h3></div><div class="cardx-b"><div class="row g-2"><?php foreach ($photos as $ph): ?><div class="col-4"><img class="img-fluid rounded-3" src="<?= e($ph['url']) ?>" alt="" loading="lazy"></div><?php endforeach; ?></div></div></div><?php endif; ?>
    <div class="cardx reveal"><div class="cardx-h"><div><h3>Gästebuch</h3><small><?= count($guestbook) ?> Einträge</small></div></div><div class="cardx-b">
      <?php if ($me): ?><form method="post" action="<?= url('/profile/' . rawurlencode($p['username']) . '/guestbook') ?>" class="d-flex gap-2 mb-3"><?= csrf_field() ?><input class="form-control" name="content" maxlength="500" placeholder="Schreib etwas Nettes…" required><button class="btn btn-pink">Senden</button></form><?php endif; ?>
      <?php foreach ($guestbook as $g): ?>
        <div class="row-item align-items-start"><div class="avatar sm" style="background-image:url('<?= e(head_url($g['look'])) ?>')"></div>
          <div class="flex-grow-1"><b><?= e($g['username']) ?></b> <small class="text-mut"><?= ago((int)$g['created_at']) ?></small><div><?= e($g['content']) ?></div></div>
          <?php if ($me && ($own || (int)$g['user_id'] === (int)$me['id'] || can('housekeeping'))): ?><form method="post" action="<?= url('/guestbook/' . (int)$g['id'] . '/delete') ?>" data-confirm="Eintrag löschen?"><?= csrf_field() ?><button class="btn btn-sm btn-ghost-danger"><i class="bi bi-trash"></i></button></form><?php endif; ?></div>
      <?php endforeach; if (!$guestbook): ?><span class="text-mut">Noch keine Einträge.</span><?php endif; ?></div></div>
  </div>
</div></div>
