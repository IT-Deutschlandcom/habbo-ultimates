<div class="wrap">
  <h1 class="page-title">Gruppen</h1><p class="page-sub">Die beliebtesten Gruppen im Hotel.</p>
  <?php foreach ($guilds as $g): ?>
  <div class="row-item reveal"><i class="bi bi-flag-fill fs-3" style="color:var(--pink)"></i><div class="flex-grow-1"><b><?= e($g['name']) ?></b><div class="small text-mut"><?= e($g['description']) ?> · Besitzer: <?= e($g['username']) ?></div></div><span class="tag"><?= (int)$g['members'] ?> Mitglieder</span></div>
  <?php endforeach; if (!$guilds): ?><p class="text-mut">Noch keine Gruppen.</p><?php endif; ?>
</div>
