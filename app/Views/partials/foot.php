<?php use App\Core\Session; ?>
<div id="toasts"></div>
<script>window.__flash = <?= json_encode(array_map(fn($f) => ['t' => $f['t'], 'm' => $f['m']], (array)Session::pull('_flash', [])), JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_UNICODE) ?>;</script>
<script src="<?= asset('vendor/bootstrap/bootstrap.bundle.min.js') ?>"></script>
<script src="<?= asset('js/app.js') ?>"></script>
