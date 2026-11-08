<div class="wrap-wide">
  <h1 class="page-title">Team</h1><p class="page-sub">Die Menschen hinter dem Hotel.</p>
  <?php foreach ($ranks as $r): ?>
  <h5 class="mt-4 grad-text"><?= e($r['rank_name']) ?></h5>
  <div class="row g-3">
    <?php foreach ($r['users'] as $u): ?>
    <div class="col-6 col-md-4 col-lg-3 reveal"><a class="cardx cardx-b hover d-flex gap-3 align-items-center text-white" href="<?= url('/profile/' . rawurlencode($u['username'])) ?>">
      <div class="avatar" style="background-image:url('<?= e(head_url($u['look'])) ?>')"></div><div style="min-width:0"><b><?= e($u['username']) ?></b> <span class="dot d-inline-block" style="<?= $u['online'] ? '' : 'background:#555;box-shadow:none;animation:none' ?>"></span><div class="text-mut small text-truncate"><?= e($u['motto']) ?></div></div></a></div>
    <?php endforeach; ?>
  </div>
  <?php endforeach; ?>
</div>
