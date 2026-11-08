<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Controller, DB, Request};

final class VoteController extends Controller
{
    public function vote(): void
    {
        $entity = Request::int('entity'); $id = Request::int('id'); $type = Request::int('type');
        $tables = [1 => 'website_news', 2 => 'ares_forum_threads', 3 => 'ares_forum_comments'];
        if (!isset($tables[$entity]) || !in_array($type, [1, 2], true) || !DB::val('SELECT 1 FROM ' . $tables[$entity] . ' WHERE id=?', [$id])) $this->json(['ok' => false], 422);
        $uid = Auth::user()['id'];
        $cur = (int)DB::val('SELECT vote_type FROM ares_votes WHERE user_id=? AND vote_entity=? AND entity_id=?', [$uid, $entity, $id]);
        if ($cur === $type) DB::delete('ares_votes', 'user_id=? AND vote_entity=? AND entity_id=?', [$uid, $entity, $id]);
        else DB::exec('INSERT INTO ares_votes (user_id, entity_id, vote_entity, vote_type) VALUES (?,?,?,?) ON DUPLICATE KEY UPDATE vote_type=VALUES(vote_type)', [$uid, $id, $entity, $type]);
        $c = VoteHelper::counts($entity, $id);
        $this->json(['ok' => true, 'likes' => $c[1], 'dislikes' => $c[2], 'mine' => VoteHelper::mine($entity, $id)]);
    }
}
