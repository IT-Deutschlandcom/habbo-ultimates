<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Controller, DB, Request};

final class HelpController extends Controller
{
    public function index(): void
    {
        $cats = DB::all('SELECT * FROM website_helptool_categories ORDER BY category');
        $q = Request::str('q', 60) ?: trim((string)($_GET['q'] ?? ''));
        $faq = $q !== ''
            ? DB::all('SELECT * FROM website_helptool_faq WHERE title LIKE ? OR `desc` LIKE ? ORDER BY title', ['%' . $q . '%', '%' . $q . '%'])
            : DB::all('SELECT * FROM website_helptool_faq ORDER BY category, title');
        $this->view('help/index', ['title' => 'Hilfe', 'cats' => $cats, 'faq' => $faq, 'q' => $q]);
    }

    public function faq(string $slug): void
    {
        $f = DB::one('SELECT * FROM website_helptool_faq WHERE slug=?', [$slug]);
        if (!$f) $this->abort(404);
        $this->view('help/faq', ['title' => $f['title'], 'f' => $f]);
    }

    public function tickets(): void
    {
        $t = DB::all('SELECT * FROM website_helptool_requests WHERE player_id=? ORDER BY timestamp DESC', [Auth::user()['id']]);
        $this->view('help/tickets', ['title' => 'Meine Tickets', 'tickets' => $t]);
    }

    public function newForm(): void { $this->view('help/new', ['title' => 'Neues Ticket']); }

    public function create(): void
    {
        $subject = Request::str('subject', 255); $msg = Request::str('message', 4000);
        if (mb_strlen($subject) < 4 || mb_strlen($msg) < 10) $this->fail('Betreff oder Nachricht zu kurz.');
        if (!$this->throttle('ticket', 5, 3600)) $this->fail('Du hast zu viele Tickets erstellt. Bitte warte.');
        $this->hit('ticket', 3600);
        $u = Auth::user();
        $id = DB::insert('website_helptool_requests', ['subject' => $subject, 'message' => $msg, 'email' => (string)$u['mail'], 'player_id' => $u['id'], 'ip_address' => Request::ip(), 'timestamp' => time(), 'status' => 'open']);
        flash('success', 'Ticket erstellt.');
        redirect('/help/tickets/' . $id);
    }

    public function ticket(int $id): void
    {
        $t = DB::one('SELECT * FROM website_helptool_requests WHERE id=? AND player_id=?', [$id, Auth::user()['id']]);
        if (!$t) $this->abort(404);
        $replies = DB::all('SELECT r.*, u.username FROM website_helptool_reactions r JOIN users u ON u.id=r.practitioner_id WHERE r.request_id=? ORDER BY r.timestamp', [$id]);
        $this->view('help/ticket', ['title' => 'Ticket #' . $id, 't' => $t, 'replies' => $replies]);
    }

    public function reply(int $id): void
    {
        $t = DB::one('SELECT * FROM website_helptool_requests WHERE id=? AND player_id=?', [$id, Auth::user()['id']]);
        if (!$t || $t['status'] === 'closed') $this->fail('Ticket nicht verfügbar.');
        $msg = Request::str('message', 4000);
        if (mb_strlen($msg) < 2) $this->fail('Nachricht zu kurz.');
        DB::insert('website_helptool_reactions', ['request_id' => $id, 'practitioner_id' => Auth::user()['id'], 'message' => $msg, 'timestamp' => time()]);
        DB::update('website_helptool_requests', ['status' => 'open'], 'id=?', [$id]);
        $this->back();
    }
}
