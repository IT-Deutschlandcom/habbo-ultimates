<div class="wrap-wide">
  <h1 class="page-title">News</h1><p class="page-sub">Alle Neuigkeiten aus dem Hotel.</p>
  <div class="d-flex flex-wrap gap-2 mb-3">
    <a class="btn btn-sm <?= !$cat ? 'btn-pink' : 'btn-dark2' ?>" href="<?= url('/news') ?>">Alle</a>
    <?php foreach ($cats as $c): ?><a class="btn btn-sm <?= (int)$cat === (int)$c['id'] ? 'btn-pink' : 'btn-dark2' ?>" href="<?= url('/news?cat=' . (int)$c['id']) ?>"><?= e($c['category']) ?></a><?php endforeach; ?>
  </div>
  <div class="row g-3">
    <?php foreach ($items as $n): ?>
    <div class="col-md-6 col-lg-4 reveal"><a class="news-card tilt" href="<?= url('/news/' . $n['slug']) ?>">
      <div class="imw"><div class="im" style="background-image:url('<?= e($n['header'] ?: asset('img/headers/bg-default.png')) ?>')"></div></div>
      <div class="bd"><span class="cat"><?= e($n['cat'] ?? 'News') ?></span><h5><?= e($n['title']) ?></h5><p><?= e(mb_strimwidth((string)$n['short_story'], 0, 110, '…')) ?></p>
      <div class="small text-mut mt-2"><?= date('d.m.Y', (int)$n['timestamp']) ?> · <i class="bi bi-chat"></i> <?= (int)$n['comments'] ?></div></div>
    </a></div>
    <?php endforeach; if (!$items): ?><p class="text-mut">Keine News gefunden.</p><?php endif; ?>
  </div>
  <?= \App\Core\View::partial('partials/pager', ['pg' => $pg, 'base' => '/news', 'qs' => $cat ? 'cat=' . (int)$cat : '']) ?>
</div>
