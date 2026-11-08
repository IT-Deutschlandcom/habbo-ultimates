<div class="wrap">
  <a href="<?= url('/forum/' . $th['topic_slug']) ?>" class="small"><i class="bi bi-arrow-left"></i> <?= e($th['topic_title']) ?></a>
  <div class="cardx mt-2"><div class="cardx-b d-flex gap-3">
    <div class="text-center" style="width:90px"><div class="avatar-full mx-auto" style="background-image:url('<?= e(look_url($th['look'])) ?>')"></div><a href="<?= url('/profile/' . rawurlencode($th['username'])) ?>"><b><?= e($th['username']) ?></b></a></div>
    <div class="flex-grow-1"><h2 style="font-size:1.4rem"><?= e($th['title']) ?></h2><div class="text-mut small mb-2"><?= date('d.m.Y H:i', (int)$th['created_at']) ?> · <?= (int)$th['views'] ?> Aufrufe</div><div class="bb"><?= render_text((string)$th['content']) ?></div>
      <div class="mt-3"><?= \App\Core\View::partial('partials/votes', ['entity' => 2, 'id' => (int)$th['id'], 'votes' => $votes, 'mine' => $mine]) ?></div></div>
  </div></div>
  <h5 class="mt-4">Antworten (<?= count($comments) ?>)</h5>
  <?php foreach ($comments as $c): ?>
  <div class="row-item align-items-start"><div class="avatar" style="background-image:url('<?= e(head_url($c['look'])) ?>')"></div>
    <div><a href="<?= url('/profile/' . rawurlencode($c['username'])) ?>"><b><?= e($c['username']) ?></b></a> <small class="text-mut"><?= ago((int)$c['created_at']) ?></small><div class="bb"><?= render_text((string)$c['content']) ?></div></div></div>
  <?php endforeach; ?>
  <?php if ($th['locked']): ?><p class="text-mut"><i class="bi bi-lock"></i> Thema geschlossen.</p>
  <?php elseif (user()): ?>
  <form method="post" action="<?= url('/forum/thread/' . $th['slug'] . '/reply') ?>" class="mt-3"><?= csrf_field() ?><textarea class="form-control mb-2" name="content" rows="4" required placeholder="Deine Antwort…"></textarea><button class="btn btn-pink">Antworten</button></form>
  <?php else: ?><p class="text-mut"><a href="<?= url('/login') ?>">Einloggen</a> zum Antworten.</p><?php endif; ?>
</div>
