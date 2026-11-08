<!doctype html>
<html lang="de"><head><?= \App\Core\View::partial('partials/head', get_defined_vars()) ?></head>
<body>
<canvas id="petals"></canvas>
<div class="auth-wrap"><?= $content ?></div>
<?= \App\Core\View::partial('partials/foot') ?>
</body></html>
