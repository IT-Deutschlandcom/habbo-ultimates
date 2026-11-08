<?php $u = user(); ?>
<div class="wrap-wide">
  <?php if (!$u): ?>
  <?= \App\Core\View::partial('partials/login-panel', [
      'heading' => 'Willkommen im ' . setting('hero_title', cfg('site.name')),
      'intro' => setting('hero_text', 'Triff neue Freunde, baue deinen Traumraum und erlebe das Hotel unter Kirschblüten.'),
      'online' => (int)$stats['online'],
  ]) ?>
  <?php else: ?>
  <section class="hero reveal">
    <span class="pill"><span class="dot"></span><b data-online data-count="<?= (int)$stats['online'] ?>"><?= (int)$stats['online'] ?></b> Habbos online</span>
    <div class="dashboard-welcome">
      <img class="dashboard-figure" src="<?= e(look_url($u['look'])) ?>" data-avatar-fallback="<?= asset('img/ares/avatar-placeholder.png') ?>" alt="" width="90" height="160">
      <div><h1>Hey, <span class="grad-text"><?= e($u['username']) ?></span>!</h1><p><?= e($u['motto']) ?></p><span class="tag"><?= e($u['rank_name'] ?? 'Mitglied') ?></span></div>
    </div>
    <div class="d-flex gap-2 flex-wrap mt-4">
        <a class="btn btn-pink btn-lg" href="<?= url('/hotel') ?>"><i class="bi bi-play-fill"></i> Hotel betreten</a>
        <a class="btn btn-dark2 btn-lg" href="<?= url('/profile/' . rawurlencode($u['username'])) ?>">Mein Profil</a>
    </div>
  </section>
  <?php endif; ?>

  <div class="row g-3 mt-2">
    <?php foreach ([['people', 'Online', $stats['online']], ['person-plus', 'Mitglieder', $stats['members']], ['door-open', 'Räume', $stats['rooms']]] as [$ic, $l, $n]): ?>
    <div class="col-md-4 reveal"><div class="cardx stat tilt"><?= ui_icon($ic) ?><span class="n" data-count="<?= (int)$n ?>"><?= num($n) ?></span><small><?= $l ?></small></div></div>
    <?php endforeach; ?>
  </div>

  <div class="row g-3 mt-1">
    <div class="col-lg-8">
      <div class="cardx reveal">
        <div class="cardx-h"><div class="section-label"><?= ui_icon('newspaper') ?><div><h3>Neuigkeiten</h3><small>Aktuelles aus dem Hotel</small></div></div><a class="btn btn-dark2 btn-sm" href="<?= url('/news') ?>">Alle News</a></div>
        <div class="cardx-b"><div class="row g-3">
          <?php foreach ($news as $n): ?>
          <div class="col-md-6"><a class="news-card" href="<?= url('/news/' . $n['slug']) ?>">
            <div class="imw"><div class="im" style="background-image:url('<?= e($n['header'] ?: asset('img/headers/bg-default.png')) ?>')"></div></div>
            <div class="bd"><span class="cat"><?= e($n['cat'] ?? 'News') ?></span><h5><?= e($n['title']) ?></h5><p><?= e(mb_strimwidth((string)$n['short_story'], 0, 90, '…')) ?></p></div>
          </a></div>
          <?php endforeach; if (!$news): ?><p class="text-mut mb-0">Noch keine News.</p><?php endif; ?>
        </div></div>
      </div>
    </div>
    <div class="col-lg-4 d-flex flex-column gap-3">
      <?php if ($u): ?>
      <div class="cardx reveal"><div class="cardx-h"><h3>Dein Guthaben</h3><?= ui_icon('credits') ?></div><div class="cardx-b">
        <?php foreach ([['credits', 'Credits', $u['credits']], ['duckets', 'Pixel', $u['pixels']], ['diamonds', 'Diamanten', $u['points']]] as [$ic, $label, $amount]): ?>
        <div class="kv"><span class="section-label"><?= ui_icon($ic) ?><?= e($label) ?></span><b><?= num($amount) ?></b></div>
        <?php endforeach; ?>
      </div></div>
      <?php endif; ?>
      <?php if ($u && $gift): ?>
      <div class="cardx reveal"><div class="cardx-h"><div><h3>Tagesgeschenk</h3><small>Täglich Credits abholen</small></div><?= ui_icon('gift') ?></div>
        <div class="cardx-b text-center">
          <?php if ($gift['ready']): ?>
            <form method="post" action="<?= url('/gift') ?>"><?= csrf_field() ?><button class="btn btn-pink w-100"><i class="bi bi-gift"></i> <?= num($gift['amount']) ?> Credits abholen</button></form>
          <?php else: ?><p class="mb-0 text-mut">Nächstes Geschenk <?= date('d.m. H:i', $gift['next']) ?> Uhr</p><?php endif; ?>
        </div></div>
      <?php endif; ?>
      <?php if ($uoth): ?>
      <div class="cardx reveal"><div class="cardx-h"><div><h3>Habbo der Woche</h3><small>Ausgezeichnet vom Team</small></div><?= ui_icon('award') ?></div>
        <a class="cardx-b d-flex gap-3 align-items-center text-white" href="<?= url('/profile/' . rawurlencode($uoth['username'])) ?>">
          <div class="avatar-full" style="background-image:url('<?= e(look_url($uoth['look'])) ?>')"></div>
          <div><b><?= e($uoth['username']) ?></b><div class="text-mut small"><?= e($uoth['motto']) ?></div></div></a></div>
      <?php endif; ?>
      <?php if (!$u): ?>
      <div class="cardx cardx-b reveal text-center"><h4>Bereit für dein Abenteuer?</h4><p class="text-mut">Erstelle in Sekunden deinen Habbo.</p><a href="<?= url('/register') ?>" class="btn btn-pink w-100">Account erstellen</a></div>
      <?php endif; ?>
    </div>
  </div>
</div>
