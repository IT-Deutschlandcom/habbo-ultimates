<div class="wrap-wide">
  <h1 class="page-title">Shop</h1><p class="page-sub">Unterstütze das Hotel und sichere dir Vorteile.</p>
  <a class="btn btn-pink mb-3" href="<?= url('/shop/club') ?>"><i class="bi bi-star-fill"></i> Club beitreten</a>
  <div class="row g-3">
    <?php foreach ($offers as $o): ?>
    <div class="col-md-6 col-lg-4 reveal"><div class="cardx hover tilt h-100"><?php if ($o['image']): ?><div style="height:140px;background:url('<?= e($o['image']) ?>') center/contain no-repeat;margin:1rem"></div><?php endif; ?>
      <div class="cardx-b"><h5><?= e($o['title']) ?></h5><p class="text-mut small"><?= e($o['description']) ?></p><span class="tag"><?= e($o['price']) ?></span></div></div></div>
    <?php endforeach; if (!$offers): ?><div class="col-12"><div class="cardx cardx-b text-center text-mut">Aktuell sind keine Angebote verfügbar.</div></div><?php endif; ?>
  </div>
</div>
