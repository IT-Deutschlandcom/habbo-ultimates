<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Controller, DB, Request};

final class ProfileController extends Controller
{
    public function show(string $name): void
    {
        $p = DB::one('SELECT u.id, u.username, u.look, u.motto, u.online, u.account_created, u.last_online, u.`rank`, u.gender, pm.rank_name FROM users u LEFT JOIN permissions pm ON pm.id=u.`rank` WHERE u.username = ?', [$name]);
        if (!$p) $this->abort(404);
        $badges = DB::all('SELECT badge_code FROM users_badges WHERE user_id=? AND slot_id > 0 ORDER BY slot_id LIMIT 5', [$p['id']]);
        $rooms = DB::all('SELECT id, name, users FROM rooms WHERE owner_id=? ORDER BY users DESC LIMIT 6', [$p['id']]);
        $guestbook = DB::all('SELECT g.*, u.username, u.look FROM ares_guestbook g JOIN users u ON u.id=g.user_id WHERE g.profile_id=? ORDER BY g.created_at DESC LIMIT 30', [$p['id']]);
        $photos = DB::all('SELECT * FROM camera_web WHERE user_id=? ORDER BY timestamp DESC LIMIT 6', [$p['id']]);
        $this->view('profile/show', ['title' => $p['username'], 'p' => $p, 'badges' => $badges, 'rooms' => $rooms, 'guestbook' => $guestbook, 'photos' => $photos]);
    }

    public function me(): void { redirect('/profile/' . rawurlencode(Auth::user()['username'])); }

    public function guestbook(string $name): void
    {
        $p = DB::one('SELECT id FROM users WHERE username=?', [$name]);
        if (!$p) $this->abort(404);
        $msg = Request::str('content', 500);
        if (mb_strlen($msg) < 2) $this->fail('Nachricht zu kurz.');
        if (!$this->throttle('gb', 8, 300)) $this->fail('Bitte warte kurz.');
        $this->hit('gb', 300);
        DB::insert('ares_guestbook', ['user_id' => Auth::user()['id'], 'profile_id' => $p['id'], 'content' => $msg, 'created_at' => time()]);
        flash('success', 'Eintrag gespeichert.');
        redirect('/profile/' . rawurlencode($name));
    }

    public function guestbookDelete(int $id): void
    {
        $g = DB::one('SELECT * FROM ares_guestbook WHERE id=?', [$id]);
        $me = Auth::user();
        if ($g && ((int)$g['user_id'] === (int)$me['id'] || (int)$g['profile_id'] === (int)$me['id'] || Auth::can('housekeeping_website'))) DB::delete('ares_guestbook', 'id=?', [$id]);
        $this->back();
    }
}
