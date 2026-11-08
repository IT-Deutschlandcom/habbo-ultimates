<div class="wrap-wide">
  <h1 class="page-title">Fotos</h1><p class="page-sub">Schnappschüsse aus dem Hotel.</p>
  <div class="row g-3">
    <?php foreach ($photos as $p): ?>
    <div class="col-6 col-md-4 col-lg-3 reveal"><div class="cardx hover"><img class="w-100" src="<?= e($p['url']) ?>" alt="" loading="lazy">
      <div class="cardx-b d-flex justify-content-between align-items-center py-2"><a href="<?= url('/profile/' . rawurlencode($p['username'])) ?>"><?= e($p['username']) ?></a>
        <?php if (user()): ?><form method="post" action="<?= url('/community/photos/' . (int)$p['id'] . '/like') ?>"><?= csrf_field() ?><button class="vote-btn"><i class="bi bi-heart-fill" style="color:var(--pink)"></i> <?= (int)$p['likes'] ?></button></form><?php else: ?><span class="tag"><i class="bi bi-heart-fill"></i> <?= (int)$p['likes'] ?></span><?php endif; ?></div></div></div>
    <?php endforeach; if (!$photos): ?><p class="text-mut">Noch keine Fotos.</p><?php endif; ?>
  </div>
  <?= \App\Core\View::partial('partials/pager', ['pg' => $pg, 'base' => '/community/photos', 'qs' => '']) ?>
</div>
