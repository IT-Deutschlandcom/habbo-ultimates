<div class="wrap-wide">
  <h1 class="page-title">Rare-Werte</h1><p class="page-sub">Aktuelle Werte der begehrtesten Möbel.</p>
  <div class="d-flex gap-2 flex-wrap mb-3"><?php foreach ($pages as $pg): ?><a class="btn btn-sm <?= (int)$pg['id'] === (int)$pid ? 'btn-pink' : 'btn-dark2' ?>" href="<?= url('/community/rares?page=' . (int)$pg['id']) ?>"><?= e($pg['name']) ?></a><?php endforeach; ?></div>
  <div class="row g-3">
    <?php foreach ($rares as $r): ?>
    <div class="col-6 col-md-4 col-lg-3 reveal"><div class="cardx cardx-b text-center hover"><div style="height:70px;background:url('<?= e($r['image']) ?>') center/contain no-repeat"></div><b class="d-block mt-2"><?= e($r['name']) ?></b>
      <div class="small text-mut"><img src="<?= asset('img/icons/moneybar_icon_coin.png') ?>" height="14" alt=""> <?= num($r['cost_credits']) ?> · <img src="<?= asset('img/icons/moneybar_icon_diamond.png') ?>" height="14" alt=""> <?= num($r['cost_points']) ?></div></div></div>
    <?php endforeach; if (!$rares): ?><p class="text-mut">Keine Einträge.</p><?php endif; ?>
  </div>
</div>
