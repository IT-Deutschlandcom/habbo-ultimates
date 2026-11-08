<h1 class="page-title">Dashboard</h1><p class="page-sub">Überblick über das Hotel.</p>
<div class="row g-3">
<?php foreach ([['people', 'Nutzer', 'users'], ['broadcast', 'Online', 'online'], ['person-plus', 'Neu heute', 'new_today'], ['ticket-detailed', 'Offene Tickets', 'tickets'], ['slash-circle', 'Aktive Banns', 'bans'], ['briefcase', 'Bewerbungen', 'apps'], ['chat-square-text', 'Forum-Themen', 'threads'], ['newspaper', 'News', 'news']] as [$ic, $l, $k]): ?>
  <div class="col-6 col-lg-3 reveal"><div class="cardx kpi"><div class="ic"><i class="bi bi-<?= $ic ?>"></i></div><div><div class="n" data-count="<?= (int)$s[$k] ?>">0</div><small><?= $l ?></small></div></div></div>
<?php endforeach; ?>
</div>
<div class="row g-3 mt-1">
  <div class="col-lg-7"><div class="cardx reveal"><div class="cardx-h"><div><h3>Registrierungen</h3><small>Letzte 7 Tage</small></div></div><div class="cardx-b">
    <?php $mx = max(1, ...array_column($chart, 'v')); ?><div class="bars"><?php foreach ($chart as $c): ?><div><i style="height:<?= max(4, round($c['v'] / $mx * 110)) ?>px"></i><b class="text-white"><?= (int)$c['v'] ?></b><?= e($c['d']) ?></div><?php endforeach; ?></div></div></div></div>
  <div class="col-lg-5"><div class="cardx reveal"><div class="cardx-h"><h3>Neueste Nutzer</h3></div><div class="cardx-b">
    <?php foreach ($newUsers as $n): ?><a class="row-item" href="<?= url('/admin/users/' . (int)$n['id']) ?>"><div class="avatar sm" style="background-image:url('<?= e(head_url($n['look'])) ?>')"></div><span class="flex-grow-1"><?= e($n['username']) ?></span><small class="text-mut"><?= ago((int)$n['account_created']) ?></small></a><?php endforeach; ?></div></div></div>
</div>
<div class="cardx mt-3 reveal"><div class="cardx-h"><h3>Letzte Staff-Aktionen</h3></div><div class="cardx-b">
  <?php foreach ($logs as $l): ?><div class="kv"><span><b><?= e($l['username'] ?? '?') ?></b> · <?= e($l['type']) ?> · <?= e($l['value']) ?></span><small class="text-mut"><?= ago((int)$l['timestamp']) ?></small></div><?php endforeach; if (!$logs): ?><span class="text-mut">Keine Einträge.</span><?php endif; ?></div></div>
