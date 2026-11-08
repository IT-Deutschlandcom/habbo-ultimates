<div class="wrap">
  <a href="<?= url('/news') ?>" class="small"><i class="bi bi-arrow-left"></i> Alle News</a>
  <article class="cardx mt-2 reveal">
    <?php if ($n['header']): ?><div style="height:240px;background:url('<?= e($n['header']) ?>') center/cover"></div><?php endif; ?>
    <div class="cardx-b p-4">
      <span class="tag"><?= e($n['cat'] ?? 'News') ?></span>
      <h1 class="mt-2" style="font-size:1.9rem"><?= e($n['title']) ?></h1>
      <div class="text-mut small mb-3">von <?= e($n['author_name'] ?? 'Team') ?> · <?= date('d.m.Y H:i', (int)$n['timestamp']) ?></div>
      <div class="bb"><?= render_text((string)$n['full_story']) ?></div>
      <hr style="border-color:var(--line)">
      <?= \App\Core\View::partial('partials/votes', ['entity' => 1, 'id' => (int)$n['id'], 'votes' => $votes, 'mine' => $mine]) ?>
    </div>
  </article>
  <h4 class="mt-4">Kommentare (<?= count($comments) ?>)</h4>
  <?php foreach ($comments as $c): ?>
    <div class="row-item align-items-start"><div class="avatar" style="background-image:url('<?= e(head_url($c['look'])) ?>')"></div>
      <div><a href="<?= url('/profile/' . rawurlencode($c['username'])) ?>"><b><?= e($c['username']) ?></b></a> <small class="text-mut"><?= ago((int)$c['timestamp']) ?></small><div class="bb"><?= render_text((string)$c['message']) ?></div></div></div>
  <?php endforeach; ?>
  <?php if (user()): ?>
  <form method="post" action="<?= url('/news/' . $n['slug'] . '/comment') ?>" class="mt-3"><?= csrf_field() ?>
    <textarea class="form-control mb-2" name="message" rows="3" maxlength="500" placeholder="Dein Kommentar…" required></textarea><button class="btn btn-pink">Kommentieren</button></form>
  <?php else: ?><p class="text-mut"><a href="<?= url('/login') ?>">Logge dich ein</a>, um zu kommentieren.</p><?php endif; ?>
</div>
