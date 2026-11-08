<div class="auth-card wide cardx reveal">
  <div class="cardx-b p-4">
    <div class="text-center mb-3"><img src="<?= asset('img/logo.png') ?>" style="height:84px;max-width:100%;object-fit:contain" alt=""></div>
    <h3 class="text-center">Account erstellen</h3><p class="text-center text-mut">Wähle deinen Look und starte durch.</p>
    <form method="post" action="<?= url('/register') ?>"><?= csrf_field() ?>
      <input type="text" name="website" tabindex="-1" autocomplete="off" style="position:absolute;left:-9999px" aria-hidden="true">
      <div class="row g-3">
        <div class="col-md-6"><label class="form-label">Benutzername</label><input class="form-control" name="username" maxlength="15" value="<?= old('username') ?>" required></div>
        <div class="col-md-6"><label class="form-label">E-Mail</label><input class="form-control" type="email" name="mail" value="<?= old('mail') ?>" required></div>
        <div class="col-md-6"><label class="form-label">Passwort (min. <?= (int)cfg('security.password_min') ?> Zeichen)</label><input class="form-control" type="password" name="password" required autocomplete="new-password"></div>
        <div class="col-md-6"><label class="form-label">Passwort wiederholen</label><input class="form-control" type="password" name="password2" required autocomplete="new-password"></div>
        <div class="col-md-6"><label class="form-label">Sicherheitsfrage: <?= e($captcha) ?> = ?</label><input class="form-control" name="captcha" inputmode="numeric" required></div>
        <div class="col-12"><label class="form-label">Geschlecht</label>
          <div class="d-flex gap-3"><label><input type="radio" name="gender" value="M" checked class="form-check-input"> Männlich</label><label><input type="radio" name="gender" value="F" class="form-check-input"> Weiblich</label></div></div>
        <div class="col-12"><label class="form-label">Look</label>
          <?php foreach ($looks as $g => $set): ?>
          <div class="row g-2 look-set" data-g="<?= e($g) ?>">
            <?php foreach ($set as $i => $lk): ?><div class="col-4 look-opt"><input type="radio" name="look" id="l<?= $g . $i ?>" value="<?= $i ?>" <?= $i === 0 ? 'checked' : '' ?>><label for="l<?= $g . $i ?>"><div class="avatar-full mx-auto" style="background-image:url('<?= e(look_url($lk)) ?>')"></div></label></div><?php endforeach; ?>
          </div>
          <?php endforeach; ?>
        </div>
        <?php if (setting('recaptcha_publickey')): ?><div class="col-12"><script src="https://www.google.com/recaptcha/api.js" async defer></script><div class="g-recaptcha" data-sitekey="<?= e(setting('recaptcha_publickey')) ?>"></div></div><?php endif; ?>
        <div class="col-12"><label class="small"><input type="checkbox" name="agb" value="1" class="form-check-input" required> Ich akzeptiere die <a href="<?= url('/page/rules') ?>" target="_blank">Hausregeln</a> und den <a href="<?= url('/page/privacy') ?>" target="_blank">Datenschutz</a>.</label></div>
        <div class="col-12"><button class="btn btn-pink w-100 py-2">Registrieren</button></div>
      </div>
    </form>
    <p class="text-center small mt-3 mb-0">Schon registriert? <a href="<?= url('/login') ?>">Einloggen</a></p>
  </div>
</div>
<script>
(() => { const r = document.querySelectorAll('input[name=gender]'), s = document.querySelectorAll('.look-set');
  const sync = () => { const g = document.querySelector('input[name=gender]:checked').value; s.forEach(x => { const on = x.dataset.g === g; x.style.display = on ? '' : 'none'; x.querySelectorAll('input').forEach((i, k) => { i.disabled = !on; if (on && k === 0) i.checked = true; }); }); };
  r.forEach(i => i.addEventListener('change', sync)); sync(); })();
</script>
