<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, DB};

final class VoteHelper
{
    public static function counts(int $entity, int $id): array
    {
        $r = DB::all('SELECT vote_type, COUNT(*) c FROM ares_votes WHERE vote_entity=? AND entity_id=? GROUP BY vote_type', [$entity, $id]);
        $o = [1 => 0, 2 => 0];
        foreach ($r as $x) $o[(int)$x['vote_type']] = (int)$x['c'];
        return $o;
    }
    public static function mine(int $entity, int $id): int
    {
        $u = Auth::user();
        return $u ? (int)DB::val('SELECT vote_type FROM ares_votes WHERE user_id=? AND vote_entity=? AND entity_id=?', [$u['id'], $entity, $id]) : 0;
    }
}
