<div class="wrap"><h1 class="page-title">Club</h1><p class="page-sub">Exklusive Vorteile für <?= num($price) ?> <?= $type === 5 ? 'Diamanten' : 'Währung' ?> – <?= (int)$days ?> Tage.</p>
  <div class="cardx cardx-b text-center py-5 reveal"><i class="bi bi-star-fill" style="font-size:3rem;color:var(--pink)"></i>
    <?php if ($is_vip): ?><h3 class="mt-2">Du bist bereits im Club 🌸</h3>
    <?php else: ?><h3 class="mt-2">Werde Club-Mitglied</h3><p class="text-mut">Dein Guthaben: <?= num((int)(user()['points'] ?? 0)) ?> Diamanten</p>
    <form method="post" action="<?= url('/shop/club') ?>" data-confirm="Club für <?= (int)$price ?> kaufen?"><?= csrf_field() ?><button class="btn btn-pink btn-lg">Jetzt kaufen</button></form><?php endif; ?></div></div>
