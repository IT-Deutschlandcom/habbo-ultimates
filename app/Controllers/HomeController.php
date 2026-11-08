<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Controller, DB, Request, Setting};

final class HomeController extends Controller
{
    public function index(): void
    {
        $news = DB::all("SELECT n.*, c.category AS cat FROM website_news n LEFT JOIN website_news_categories c ON c.id=n.category WHERE n.hidden='0' ORDER BY n.timestamp DESC LIMIT 2");
        $stats = [
            'online'  => (int)DB::val("SELECT COUNT(*) FROM users WHERE online = '1'"),
            'members' => (int)DB::val('SELECT COUNT(*) FROM users'),
            'rooms'   => (int)DB::val('SELECT COUNT(*) FROM rooms'),
        ];
        $uoth = null;
        if ($name = (string)Setting::get('user_of_the_week', '')) $uoth = DB::one('SELECT username, look, motto FROM users WHERE username = ?', [$name]);
        $gift = null;
        if ($u = Auth::user()) {
            $last = (int)DB::val('SELECT MAX(pick_time) FROM ares_gifts WHERE user_id = ?', [$u['id']]);
            $wait = (int)Setting::get('daily_gift_hours', 24) * 3600;
            $gift = ['amount' => (int)Setting::get('daily_gift_amount', 50), 'ready' => time() - $last >= $wait, 'next' => $last + $wait];
        }
        $this->view('home/index', ['title' => 'Home', 'news' => $news, 'stats' => $stats, 'uoth' => $uoth, 'gift' => $gift, 'bodyClass' => 'is-home']);
    }

    public function gift(): void
    {
        $u = Auth::user();
        $wait = (int)Setting::get('daily_gift_hours', 24) * 3600;
        $amount = (int)Setting::get('daily_gift_amount', 50);
        $ok = DB::pdo()->beginTransaction();
        $last = (int)DB::val('SELECT MAX(pick_time) FROM ares_gifts WHERE user_id = ? FOR UPDATE', [$u['id']]);
        if (time() - $last < $wait) { DB::pdo()->rollBack(); $this->fail('Dein Geschenk ist noch nicht bereit.'); }
        DB::insert('ares_gifts', ['user_id' => $u['id'], 'amount' => $amount, 'pick_time' => time()]);
        DB::exec('UPDATE users SET credits = credits + ? WHERE id = ?', [$amount, $u['id']]);
        DB::pdo()->commit();
        flash('success', "Du hast $amount Credits als Tagesgeschenk erhalten!");
        redirect('/');
    }

    public function online(): void
    {
        $this->json(['online' => (int)DB::val("SELECT COUNT(*) FROM users WHERE online = '1'")]);
    }

    public function search(): void
    {
        $q = Request::str('q', 15);
        $rows = strlen($q) < 2 ? [] : DB::all('SELECT username, look FROM users WHERE username LIKE ? ORDER BY username LIMIT 8', [str_replace(['%', '_'], ['\%', '\_'], $q) . '%']);
        $this->json(['users' => $rows]);
    }
}
