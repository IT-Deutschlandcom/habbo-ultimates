<div class="wrap">
  <h1 class="page-title">Forum</h1><p class="page-sub">Diskutiere mit der Community.</p>
  <?php foreach ($topics as $t): ?>
  <a class="row-item reveal" href="<?= url('/forum/' . $t['slug']) ?>">
    <i class="bi bi-chat-square-text fs-3" style="color:var(--pink)"></i>
    <div class="flex-grow-1"><b><?= e($t['title']) ?></b><div class="text-mut small"><?= e($t['description']) ?></div></div>
    <div class="text-end small text-mut"><b class="text-white"><?= (int)$t['threads'] ?></b> Themen<br><b class="text-white"><?= (int)$t['posts'] ?></b> Beiträge</div>
  </a>
  <?php endforeach; if (!$topics): ?><p class="text-mut">Keine Bereiche verfügbar.</p><?php endif; ?>
</div>
