<div class="wrap"><h1 class="page-title">Bewerbung: <?= e($j['job']) ?></h1><div class="bb text-mut mb-3"><?= render_text((string)$j['full_description']) ?></div>
  <form class="cardx cardx-b" method="post" action="<?= url('/jobs/' . (int)$j['id'] . '/apply') ?>"><?= csrf_field() ?>
    <div class="mb-3"><label class="form-label">Vorname</label><input class="form-control" name="firstname" maxlength="50" required></div>
    <div class="row g-2 mb-3"><?php foreach (['monday' => 'Montag', 'tuesday' => 'Dienstag', 'wednesday' => 'Mittwoch', 'thursday' => 'Donnerstag', 'friday' => 'Freitag', 'saturday' => 'Samstag', 'sunday' => 'Sonntag'] as $k => $l): ?>
      <div class="col-6 col-md-3"><label class="form-label"><?= $l ?></label><input class="form-control" name="<?= $k ?>" placeholder="z. B. 16–20 Uhr" maxlength="50"></div><?php endforeach; ?></div>
    <div class="mb-3"><label class="form-label">Warum du? (min. 20 Zeichen)</label><textarea class="form-control" name="message" rows="6" required></textarea></div>
    <button class="btn btn-pink">Bewerbung senden</button></form></div>
