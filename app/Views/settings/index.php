<?php $u = user(); ?>
<div class="wrap"><h1 class="page-title">Einstellungen</h1><p class="page-sub">Verwalte dein Konto.</p>
  <div class="row g-3">
    <div class="col-md-6"><form class="cardx cardx-b h-100" method="post" action="<?= url('/settings/profile') ?>"><?= csrf_field() ?><h5>Motto</h5><input class="form-control mb-3" name="motto" maxlength="38" value="<?= e($u['motto']) ?>"><button class="btn btn-pink">Speichern</button></form></div>
    <div class="col-md-6"><form class="cardx cardx-b h-100" method="post" action="<?= url('/settings/password') ?>"><?= csrf_field() ?><h5>Passwort ändern</h5>
      <input class="form-control mb-2" type="password" name="current" placeholder="Aktuelles Passwort" required><input class="form-control mb-2" type="password" name="password" placeholder="Neues Passwort" required><input class="form-control mb-3" type="password" name="password2" placeholder="Wiederholen" required><button class="btn btn-pink">Ändern</button></form></div>
    <div class="col-md-6"><form class="cardx cardx-b h-100" method="post" action="<?= url('/settings/email') ?>"><?= csrf_field() ?><h5>E-Mail ändern</h5>
      <input class="form-control mb-2" type="email" name="mail" value="<?= e($u['mail']) ?>" required><input class="form-control mb-3" type="password" name="current" placeholder="Passwort bestätigen" required><button class="btn btn-pink">Ändern</button></form></div>
    <div class="col-md-6"><form class="cardx cardx-b h-100" method="post" action="<?= url('/settings/namechange') ?>" data-confirm="Namen für <?= (int)$price ?> ändern?"><?= csrf_field() ?><h5>Namen ändern</h5><p class="small text-mut">Kosten: <?= num($price) ?> Diamanten</p>
      <input class="form-control mb-3" name="username" maxlength="15" placeholder="Neuer Name" required><button class="btn btn-pink">Namen ändern</button></form></div>
  </div></div>
