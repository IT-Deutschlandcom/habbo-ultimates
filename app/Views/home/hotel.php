<div class="wrap-wide"><h1 class="page-title">Hotel</h1>
  <?php if ($src): ?><div class="cardx" style="height:calc(100vh - 200px);min-height:480px"><iframe src="<?= e($src) ?>" style="width:100%;height:100%;border:0" allow="fullscreen" title="Hotel"></iframe></div>
  <?php else: ?><div class="cardx cardx-b text-center py-5"><i class="bi bi-controller fs-1" style="color:var(--pink)"></i><h4 class="mt-2">Client noch nicht konfiguriert</h4><p class="text-mut">Trage in <code>config.php</code> unter <code>hotel.client_url</code> die Adresse deines Clients ein.</p></div><?php endif; ?></div>
