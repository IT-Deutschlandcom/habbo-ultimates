<div class="wrap-wide">
  <h1 class="page-title">Community</h1><p class="page-sub">Alles rund um die Bewohner des Hotels.</p>
  <div class="row g-3">
    <div class="col-lg-4"><div class="cardx reveal"><div class="cardx-h"><div><h3>Reichste Habbos</h3><small>Top 5 nach Credits</small></div></div><div class="cardx-b">
      <?php foreach ($topUsers as $i => $t): ?><a class="row-item" href="<?= url('/profile/' . rawurlencode($t['username'])) ?>"><b style="color:var(--pink)">#<?= $i + 1 ?></b><div class="avatar sm" style="background-image:url('<?= e(head_url($t['look'])) ?>')"></div><span class="flex-grow-1"><?= e($t['username']) ?></span><b><?= num($t['credits']) ?></b></a><?php endforeach; ?>
      <a class="btn btn-dark2 w-100 btn-sm" href="<?= url('/community/ranking') ?>">Zum Ranking</a></div></div></div>
    <div class="col-lg-4"><div class="cardx reveal"><div class="cardx-h"><div><h3>Neu im Forum</h3><small>Letzte Themen</small></div></div><div class="cardx-b">
      <?php foreach ($forum as $f): ?><a class="row-item" href="<?= url('/forum/thread/' . $f['slug']) ?>"><span class="flex-grow-1"><b><?= e($f['title']) ?></b><br><small class="text-mut"><?= e($f['username']) ?> · <?= ago((int)$f['created_at']) ?></small></span></a><?php endforeach; if (!$forum): ?><span class="text-mut">Noch nichts.</span><?php endif; ?></div></div></div>
    <div class="col-lg-4"><div class="cardx reveal"><div class="cardx-h"><div><h3>Fotos</h3><small>Neueste Schnappschüsse</small></div></div><div class="cardx-b"><div class="row g-2">
      <?php foreach ($photos as $ph): ?><div class="col-6"><img class="img-fluid rounded-3" src="<?= e($ph['url']) ?>" alt="" loading="lazy"></div><?php endforeach; ?></div>
      <a class="btn btn-dark2 w-100 btn-sm mt-2" href="<?= url('/community/photos') ?>">Alle Fotos</a></div></div></div>
  </div>
  <div class="row g-3 mt-1">
    <?php foreach ([['/community/staff', 'shield-check', 'Team', 'Lerne unser Team kennen'], ['/community/guilds', 'flag', 'Gruppen', 'Die größten Gruppen'], ['/community/rares', 'gem', 'Rare-Werte', 'Was ist was wert?'], ['/help', 'life-preserver', 'Hilfe', 'FAQ & Support']] as [$h, $ic, $t, $s]): ?>
    <div class="col-6 col-lg-3"><a href="<?= url($h) ?>" class="cardx cardx-b text-center d-block text-white hover tilt reveal"><i class="bi bi-<?= $ic ?> fs-2" style="color:var(--pink)"></i><h5 class="mb-0 mt-1"><?= $t ?></h5><small class="text-mut"><?= $s ?></small></a></div>
    <?php endforeach; ?>
  </div>
</div>
