<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Controller, DB, Request};

final class ForumController extends Controller
{
    public function index(): void
    {
        $rank = (int)(Auth::user()['rank'] ?? 0);
        $topics = DB::all('SELECT t.*, (SELECT COUNT(*) FROM ares_forum_threads x WHERE x.topic_id=t.id) AS threads, (SELECT COUNT(*) FROM ares_forum_comments c JOIN ares_forum_threads x ON x.id=c.thread_id WHERE x.topic_id=t.id) AS posts FROM ares_forum_topics t WHERE t.min_rank <= ? ORDER BY t.sort, t.id', [max(1, $rank)]);
        $this->view('forum/index', ['title' => 'Forum', 'topics' => $topics]);
    }

    private function topic(string $slug): array
    {
        $t = DB::one('SELECT * FROM ares_forum_topics WHERE slug=?', [$slug]);
        if (!$t || (int)$t['min_rank'] > max(1, (int)(Auth::user()['rank'] ?? 0))) $this->abort(404);
        return $t;
    }

    public function topicView(string $slug): void
    {
        $t = $this->topic($slug);
        $pg = paginate((int)DB::val('SELECT COUNT(*) FROM ares_forum_threads WHERE topic_id=?', [$t['id']]), 15, (int)($_GET['page'] ?? 1));
        $threads = DB::all("SELECT th.*, u.username, u.look, (SELECT COUNT(*) FROM ares_forum_comments c WHERE c.thread_id=th.id) AS replies FROM ares_forum_threads th JOIN users u ON u.id=th.user_id WHERE th.topic_id=? ORDER BY th.pinned DESC, COALESCE(th.updated_at, th.created_at) DESC LIMIT {$pg['per']} OFFSET {$pg['offset']}", [$t['id']]);
        $this->view('forum/topic', ['title' => $t['title'], 't' => $t, 'threads' => $threads, 'pg' => $pg]);
    }

    public function create(string $slug): void
    {
        $t = $this->topic($slug);
        $title = Request::str('title', 120); $content = Request::str('content', 8000);
        if (mb_strlen($title) < 3 || mb_strlen($content) < 5) $this->fail('Titel und Inhalt sind zu kurz.');
        if (!$this->throttle('thread', 5, 600)) $this->fail('Bitte warte kurz, bevor du erneut postest.');
        $this->hit('thread', 600);
        $s = slugify($title); $base = $s; $i = 1;
        while (DB::val('SELECT 1 FROM ares_forum_threads WHERE slug=?', [$s])) $s = $base . '-' . (++$i);
        DB::insert('ares_forum_threads', ['topic_id' => $t['id'], 'user_id' => Auth::user()['id'], 'slug' => $s, 'title' => $title, 'content' => $content, 'created_at' => time()]);
        redirect('/forum/thread/' . $s);
    }

    public function thread(string $slug): void
    {
        $th = DB::one('SELECT th.*, u.username, u.look, u.motto, t.title AS topic_title, t.slug AS topic_slug, t.min_rank FROM ares_forum_threads th JOIN users u ON u.id=th.user_id JOIN ares_forum_topics t ON t.id=th.topic_id WHERE th.slug=?', [$slug]);
        if (!$th || (int)$th['min_rank'] > max(1, (int)(Auth::user()['rank'] ?? 0))) $this->abort(404);
        DB::exec('UPDATE ares_forum_threads SET views = views + 1 WHERE id=?', [$th['id']]);
        $comments = DB::all('SELECT c.*, u.username, u.look FROM ares_forum_comments c JOIN users u ON u.id=c.user_id WHERE c.thread_id=? ORDER BY c.created_at', [$th['id']]);
        $this->view('forum/thread', ['title' => $th['title'], 'th' => $th, 'comments' => $comments, 'votes' => VoteHelper::counts(2, (int)$th['id']), 'mine' => VoteHelper::mine(2, (int)$th['id'])]);
    }

    public function reply(string $slug): void
    {
        $th = DB::one('SELECT id, locked FROM ares_forum_threads WHERE slug=?', [$slug]);
        if (!$th) $this->abort(404);
        if ($th['locked']) $this->fail('Dieses Thema ist geschlossen.');
        $content = Request::str('content', 4000);
        if (mb_strlen($content) < 2) $this->fail('Antwort zu kurz.');
        if (!$this->throttle('reply', 15, 300)) $this->fail('Bitte warte kurz.');
        $this->hit('reply', 300);
        DB::insert('ares_forum_comments', ['thread_id' => $th['id'], 'user_id' => Auth::user()['id'], 'content' => $content, 'created_at' => time()]);
        DB::update('ares_forum_threads', ['updated_at' => time()], 'id=?', [$th['id']]);
        redirect('/forum/thread/' . $slug . '#bottom');
    }
}
