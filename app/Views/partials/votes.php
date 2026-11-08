<div class="d-flex gap-2" data-entity="<?= (int)$entity ?>" data-id="<?= (int)$id ?>">
  <button class="vote-btn <?= $mine === 1 ? 'on' : '' ?>" data-vote="1"><i class="bi bi-hand-thumbs-up"></i> <span><?= (int)($votes['likes'] ?? $votes[1] ?? 0) ?></span></button>
  <button class="vote-btn <?= $mine === 2 ? 'on' : '' ?>" data-vote="2"><i class="bi bi-hand-thumbs-down"></i> <span><?= (int)($votes['dislikes'] ?? $votes[2] ?? 0) ?></span></button>
</div>
