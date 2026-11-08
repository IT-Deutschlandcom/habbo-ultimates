<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Controller, DB, Request};

final class CommunityController extends Controller
{
    public function index(): void
    {
        $this->view('community/index', [
            'title' => 'Community',
            'topUsers' => DB::all('SELECT username, look, credits FROM users ORDER BY credits DESC LIMIT 5'),
            'forum' => DB::all('SELECT th.title, th.slug, th.created_at, u.username FROM ares_forum_threads th JOIN users u ON u.id=th.user_id ORDER BY th.created_at DESC LIMIT 5'),
            'photos' => DB::all('SELECT * FROM camera_web ORDER BY timestamp DESC LIMIT 4'),
        ]);
    }

    public function staff(): void
    {
        $ranks = DB::all("SELECT p.id, p.rank_name FROM permissions p WHERE p.id > 3 AND NOT EXISTS (SELECT 1 FROM website_permissions_ranks r JOIN website_permissions w ON w.id=r.permission_id WHERE r.rank_id=p.id AND w.permission='website_invisible_staff') ORDER BY p.id DESC");
        foreach ($ranks as &$r) $r['users'] = DB::all('SELECT username, look, motto, online FROM users WHERE `rank` = ? ORDER BY username', [$r['id']]);
        $this->view('community/staff', ['title' => 'Team', 'ranks' => array_filter($ranks, fn($r) => $r['users'])]);
    }

    public function ranking(): void
    {
        $boards = [
            'credits' => ['Credits', 'users', 'credits'], 'pixels' => ['Pixels', 'users', 'pixels'],
            'points' => ['Diamanten', 'users', 'points'], 'online' => ['Online-Zeit', 'users_settings', 'online_time'],
            'achievements' => ['Erfolge', 'users_settings', 'achievement_score'],
        ];
        $key = isset($boards[$_GET['b'] ?? '']) ? $_GET['b'] : 'credits';
        [$label, $table, $col] = $boards[$key];
        $rows = $table === 'users'
            ? DB::all("SELECT username, look, `$col` AS v FROM users WHERE `rank` < 5 ORDER BY `$col` DESC LIMIT 20")
            : DB::all("SELECT u.username, u.look, s.`$col` AS v FROM users_settings s JOIN users u ON u.id=s.user_id WHERE u.`rank` < 5 ORDER BY s.`$col` DESC LIMIT 20");
        $this->view('community/ranking', ['title' => 'Ranking', 'boards' => $boards, 'key' => $key, 'rows' => $rows, 'label' => $label]);
    }

    public function photos(): void
    {
        $pg = paginate((int)DB::val('SELECT COUNT(*) FROM camera_web'), 12, (int)($_GET['page'] ?? 1));
        $photos = DB::all("SELECT c.*, u.username, (SELECT COUNT(*) FROM website_photos_likes l WHERE l.photo_id=c.id) AS likes FROM camera_web c JOIN users u ON u.id=c.user_id ORDER BY c.timestamp DESC LIMIT {$pg['per']} OFFSET {$pg['offset']}");
        $this->view('community/photos', ['title' => 'Fotos', 'photos' => $photos, 'pg' => $pg]);
    }

    public function likePhoto(int $id): void
    {
        $uid = Auth::user()['id'];
        if (DB::val('SELECT 1 FROM camera_web WHERE id=?', [$id]) && !DB::val('SELECT 1 FROM website_photos_likes WHERE user_id=? AND photo_id=?', [$uid, $id]))
            DB::insert('website_photos_likes', ['user_id' => $uid, 'photo_id' => $id]);
        $this->back('/community/photos');
    }

    public function rares(): void
    {
        $pages = DB::all('SELECT * FROM website_rares_pages ORDER BY id');
        $pid = (int)($_GET['page'] ?? ($pages[0]['id'] ?? 0));
        $rares = DB::all('SELECT * FROM website_rares WHERE parent_id=? ORDER BY name', [$pid]);
        $this->view('community/rares', ['title' => 'Rare-Werte', 'pages' => $pages, 'pid' => $pid, 'rares' => $rares]);
    }

    public function guilds(): void
    {
        $g = DB::all('SELECT g.*, u.username, (SELECT COUNT(*) FROM guilds_members m WHERE m.guild_id=g.id) AS members FROM guilds g JOIN users u ON u.id=g.user_id ORDER BY members DESC LIMIT 30');
        $this->view('community/guilds', ['title' => 'Gruppen', 'guilds' => $g]);
    }
}
