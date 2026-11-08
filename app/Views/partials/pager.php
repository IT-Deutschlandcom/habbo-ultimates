<?php if (($pg['pages'] ?? 1) > 1): $q = fn($p) => url($base . '?' . ($qs ? $qs . '&' : '') . 'page=' . $p); ?>
<nav class="mt-4"><ul class="pagination justify-content-center">
  <?php for ($i = 1; $i <= $pg['pages']; $i++): ?><li class="page-item <?= $i === $pg['page'] ? 'active' : '' ?>"><a class="page-link" href="<?= $q($i) ?>"><?= $i ?></a></li><?php endfor; ?>
</ul></nav>
<?php endif; ?>
