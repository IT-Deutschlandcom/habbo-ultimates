<div class="wrap">
  <h1 class="page-title">Ranking</h1><p class="page-sub">Die besten Habbos nach Kategorie.</p>
  <div class="d-flex gap-2 flex-wrap mb-3"><?php foreach ($boards as $k => $b): ?><a class="btn btn-sm <?= $k === $key ? 'btn-pink' : 'btn-dark2' ?>" href="<?= url('/community/ranking?b=' . $k) ?>"><?= e($b[0]) ?></a><?php endforeach; ?></div>
  <?php foreach ($rows as $i => $r): ?>
  <a class="row-item reveal" href="<?= url('/profile/' . rawurlencode($r['username'])) ?>"><b style="width:2rem;color:<?= $i < 3 ? 'var(--pink)' : 'var(--mut)' ?>">#<?= $i + 1 ?></b><div class="avatar sm" style="background-image:url('<?= e(head_url($r['look'])) ?>')"></div><span class="flex-grow-1"><?= e($r['username']) ?></span><b><?= num($r['v']) ?></b> <small class="text-mut"><?= e($label) ?></small></a>
  <?php endforeach; ?>
</div>
