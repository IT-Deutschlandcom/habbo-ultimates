<div class="wrap">
  <h1 class="page-title">Hilfe</h1><p class="page-sub">Antworten auf häufige Fragen – oder erstelle ein Ticket.</p>
  <form class="d-flex gap-2 mb-3" method="get" action="<?= url('/help') ?>"><input class="form-control" name="q" value="<?= e($q) ?>" placeholder="Suche in der FAQ…"><button class="btn btn-pink">Suchen</button></form>
  <div class="d-flex gap-2 mb-4"><a class="btn btn-dark2" href="<?= url('/help/tickets/new') ?>"><i class="bi bi-plus-lg"></i> Neues Ticket</a><a class="btn btn-dark2" href="<?= url('/help/tickets') ?>"><i class="bi bi-ticket-detailed"></i> Meine Tickets</a></div>
  <?php foreach ($cats as $c): $list = array_filter($faq, fn($f) => (int)$f['category'] === (int)$c['id']); if (!$list) continue; ?>
  <div class="cardx mb-3 reveal"><div class="cardx-h"><h3><?= e($c['category']) ?></h3></div><div class="cardx-b"><?php foreach ($list as $f): ?><a class="row-item" href="<?= url('/help/faq/' . $f['slug']) ?>"><i class="bi bi-question-circle" style="color:var(--pink)"></i><?= e($f['title']) ?></a><?php endforeach; ?></div></div>
  <?php endforeach; if (!$faq): ?><p class="text-mut">Keine Einträge gefunden.</p><?php endif; ?>
</div>
