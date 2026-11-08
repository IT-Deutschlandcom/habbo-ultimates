<div class="wrap">
  <div class="d-flex justify-content-between align-items-center"><h1 class="page-title">Meine Tickets</h1><a class="btn btn-pink" href="<?= url('/help/tickets/new') ?>">Neues Ticket</a></div><p class="page-sub">Verfolge deine Support-Anfragen.</p>
  <?php foreach ($tickets as $t): ?>
  <a class="row-item" href="<?= url('/help/tickets/' . (int)$t['id']) ?>"><span class="tag gray">#<?= (int)$t['id'] ?></span><b class="flex-grow-1"><?= e($t['subject']) ?></b><span class="tag <?= $t['status'] === 'closed' ? 'gray' : 'green' ?>"><?= e($t['status']) ?></span><small class="text-mut"><?= ago((int)$t['timestamp']) ?></small></a>
  <?php endforeach; if (!$tickets): ?><p class="text-mut">Du hast noch keine Tickets.</p><?php endif; ?>
</div>
