<div class="wrap">
  <h1 class="page-title">Jobs</h1><p class="page-sub">Werde Teil unseres Teams.</p>
  <div class="row g-3"><?php foreach ($jobs as $j): ?>
  <div class="col-md-6 reveal"><div class="cardx cardx-b hover h-100"><i class="bi bi-briefcase fs-3" style="color:var(--pink)"></i><h4 class="mt-1"><?= e($j['job']) ?></h4><p class="text-mut"><?= e($j['small_description']) ?></p>
    <?php if (!user()): ?><a class="btn btn-dark2" href="<?= url('/login') ?>">Einloggen zum Bewerben</a>
    <?php elseif (in_array((int)$j['id'], array_map('intval', $mine), true)): ?><span class="tag green">Bereits beworben</span>
    <?php else: ?><a class="btn btn-pink" href="<?= url('/jobs/' . (int)$j['id'] . '/apply') ?>">Bewerben</a><?php endif; ?></div></div>
  <?php endforeach; if (!$jobs): ?><p class="text-mut">Aktuell keine offenen Stellen.</p><?php endif; ?></div>
</div>
