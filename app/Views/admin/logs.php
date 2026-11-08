<h1 class="page-title">Staff-Logs</h1>
<div class="cardx"><div class="table-responsive"><table class="table table-sm table-hover mb-0"><thead><tr><th>Zeit</th><th>Staff</th><th>Typ</th><th>Details</th></tr></thead><tbody>
<?php foreach ($rows as $r): ?><tr><td><?= date('d.m.Y H:i', (int)$r['timestamp']) ?></td><td><?= e($r['username'] ?? '?') ?></td><td><span class="tag"><?= e($r['type']) ?></span></td><td><?= e($r['value']) ?></td></tr><?php endforeach; ?></tbody></table></div></div>
