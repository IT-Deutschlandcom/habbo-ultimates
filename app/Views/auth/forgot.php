<div class="auth-card cardx reveal"><div class="cardx-b p-4">
  <h3>Passwort vergessen</h3><p class="text-mut">Wir senden dir einen Link zum Zurücksetzen.</p>
  <form method="post" action="<?= url('/password/forgot') ?>"><?= csrf_field() ?>
    <div class="mb-3"><label class="form-label">E-Mail</label><input class="form-control" type="email" name="mail" required></div>
    <button class="btn btn-pink w-100">Link anfordern</button></form>
  <p class="small mt-3 mb-0"><a href="<?= url('/login') ?>">Zurück zum Login</a></p>
</div></div>
