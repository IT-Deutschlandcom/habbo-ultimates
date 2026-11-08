<div class="auth-card cardx reveal"><div class="cardx-b p-4">
  <h3>Neues Passwort</h3>
  <form method="post" action="<?= url('/password/reset/' . $token) ?>"><?= csrf_field() ?>
    <div class="mb-3"><label class="form-label">Neues Passwort</label><input class="form-control" type="password" name="password" required autocomplete="new-password"></div>
    <div class="mb-3"><label class="form-label">Wiederholen</label><input class="form-control" type="password" name="password2" required autocomplete="new-password"></div>
    <button class="btn btn-pink w-100">Speichern</button></form>
</div></div>
