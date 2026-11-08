<div class="wrap">
  <a href="<?= url('/forum') ?>" class="small"><i class="bi bi-arrow-left"></i> Forum</a>
  <h1 class="page-title mt-1"><?= e($t['title']) ?></h1><p class="page-sub"><?= e($t['description']) ?></p>
  <?php foreach ($threads as $th): ?>
  <a class="row-item" href="<?= url('/forum/thread/' . $th['slug']) ?>">
    <div class="avatar" style="background-image:url('<?= e(head_url($th['look'])) ?>')"></div>
    <div class="flex-grow-1"><?php if ($th['pinned']): ?><i class="bi bi-pin-angle-fill" style="color:var(--pink)"></i> <?php endif; ?><?php if ($th['locked']): ?><i class="bi bi-lock-fill text-mut"></i> <?php endif; ?><b><?= e($th['title']) ?></b>
      <div class="text-mut small">von <?= e($th['username']) ?> · <?= ago((int)($th['updated_at'] ?: $th['created_at'])) ?></div></div>
    <span class="tag gray"><i class="bi bi-chat"></i> <?= (int)$th['replies'] ?></span>
  </a>
  <?php endforeach; if (!$threads): ?><p class="text-mut">Noch keine Themen.</p><?php endif; ?>
  <?= \App\Core\View::partial('partials/pager', ['pg' => $pg, 'base' => '/forum/' . $t['slug'], 'qs' => '']) ?>
  <?php if (user()): ?>
  <div class="cardx mt-4"><div class="cardx-h"><h3>Neues Thema</h3></div><form class="cardx-b" method="post" action="<?= url('/forum/' . $t['slug'] . '/new') ?>"><?= csrf_field() ?>
    <input class="form-control mb-2" name="title" maxlength="120" placeholder="Titel" required>
    <textarea class="form-control mb-2" name="content" rows="5" placeholder="Inhalt (BBCode: [b] [i] [u] [url])" required></textarea>
    <button class="btn btn-pink">Thema erstellen</button></form></div>
  <?php endif; ?>
</div>
