<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Controller, DB, Request};

final class NewsController extends Controller
{
    public function index(): void
    {
        $cat = (int)($_GET['cat'] ?? 0);
        $where = "n.hidden='0'" . ($cat ? ' AND n.category = ' . $cat : '');
        $pg = paginate((int)DB::val("SELECT COUNT(*) FROM website_news n WHERE $where"), 9, (int)($_GET['page'] ?? 1));
        $items = DB::all("SELECT n.*, c.category AS cat, (SELECT COUNT(*) FROM website_news_reactions r WHERE r.news_id=n.id AND r.hidden=0) AS comments FROM website_news n LEFT JOIN website_news_categories c ON c.id=n.category WHERE $where ORDER BY n.timestamp DESC LIMIT {$pg['per']} OFFSET {$pg['offset']}");
        $this->view('news/index', ['title' => 'News', 'items' => $items, 'pg' => $pg, 'cats' => DB::all('SELECT * FROM website_news_categories ORDER BY category'), 'cat' => $cat]);
    }

    public function show(string $slug): void
    {
        $n = DB::one("SELECT n.*, c.category AS cat, u.username AS author_name FROM website_news n LEFT JOIN website_news_categories c ON c.id=n.category LEFT JOIN users u ON u.id=n.author WHERE n.slug=? AND n.hidden='0'", [$slug]);
        if (!$n) $this->abort(404);
        $comments = DB::all('SELECT r.*, u.username, u.look FROM website_news_reactions r JOIN users u ON u.id=r.player_id WHERE r.news_id=? AND r.hidden=0 ORDER BY r.timestamp ASC', [$n['id']]);
        $this->view('news/show', ['title' => $n['title'], 'n' => $n, 'comments' => $comments, 'votes' => VoteHelper::counts(1, (int)$n['id']), 'mine' => VoteHelper::mine(1, (int)$n['id'])]);
    }

    public function comment(string $slug): void
    {
        $n = DB::one("SELECT id FROM website_news WHERE slug=? AND hidden='0'", [$slug]);
        if (!$n) $this->abort(404);
        $msg = Request::str('message', 250);
        if (mb_strlen($msg) < 2) $this->fail('Kommentar zu kurz.');
        if (!$this->throttle('comment', 10, 300)) $this->fail('Bitte warte kurz.');
        $this->hit('comment', 300);
        DB::insert('website_news_reactions', ['date' => time(), 'news_id' => $n['id'], 'player_id' => Auth::user()['id'], 'message' => $msg, 'hidden' => 0, 'timestamp' => time()]);
        flash('success', 'Kommentar gespeichert.');
        redirect('/news/' . $slug . '#comments');
    }
}
