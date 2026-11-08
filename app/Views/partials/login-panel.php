<section class="ares-login cardx" aria-labelledby="welcome-title">
  <div class="auth-card">
    <div class="cardx-b p-4">
      <header class="login-heading">
        <img class="login-logo" src="<?= asset('img/logo.png') ?>" alt="<?= e(cfg('site.name')) ?>">
        <?php if (isset($online)): ?>
        <span class="pill"><span class="dot"></span><b data-online><?= (int)$online ?></b> Habbos online</span>
        <?php endif; ?>
        <h1 id="welcome-title"><?= e($heading) ?></h1>
        <p class="text-mut"><?= e($intro) ?></p>
      </header>
      <form method="post" action="<?= url('/login') ?>"><?= csrf_field() ?>
        <div class="mb-3"><label class="form-label section-label" for="login-name"><?= ui_icon('people') ?>Benutzername oder E-Mail</label><input id="login-name" class="form-control" name="username" value="<?= old('username') ?>" required <?= !empty($autofocus) ? 'autofocus' : '' ?> autocomplete="username"></div>
        <div class="mb-3"><label class="form-label section-label" for="login-password"><?= ui_icon('key') ?>Passwort</label><input id="login-password" class="form-control" type="password" name="password" required autocomplete="current-password"></div>
        <button class="btn btn-pink w-100 py-2">Einloggen</button>
      </form>
      <div class="login-links"><a href="<?= url('/password/forgot') ?>">Passwort vergessen?</a><a href="<?= url('/register') ?>">Neu hier? Registrieren</a></div>
    </div>
  </div>
  <aside class="login-world">
    <span class="tag">Dein nächstes Abenteuer</span>
    <img src="<?= asset('img/ares/room.png') ?>" width="400" height="400" alt="Isometrischer Habbo-Raum" class="login-room">
    <h2>Dein Raum. Deine Freunde.</h2>
    <p class="text-mut">Gestalte dein Zuhause, entdecke die Community und erlebe <?= e(cfg('site.name')) ?>.</p>
    <a class="btn btn-pink" href="<?= url('/register') ?>">Jetzt dabei sein</a>
  </aside>
</section>
