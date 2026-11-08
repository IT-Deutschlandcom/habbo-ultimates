<div class="wrap"><h1 class="page-title">Neues Ticket</h1><p class="page-sub">Beschreibe dein Anliegen so genau wie möglich.</p>
  <form class="cardx cardx-b" method="post" action="<?= url('/help/tickets/new') ?>"><?= csrf_field() ?>
    <div class="mb-3"><label class="form-label">Betreff</label><input class="form-control" name="subject" maxlength="255" value="<?= old('subject') ?>" required></div>
    <div class="mb-3"><label class="form-label">Nachricht</label><textarea class="form-control" name="message" rows="7" required><?= old('message') ?></textarea></div>
    <button class="btn btn-pink">Absenden</button></form></div>
