<?php
declare(strict_types=1);
namespace App\Controllers\Admin;

use App\Core\{Auth, Controller, DB, Rcon, Request, Setting};

final class AdminController extends Controller
{
    private function v(string $tpl, array $d): void { $this->view('admin/' . $tpl, $d, 'admin'); }
    private function need(string $perm): void { if (!Auth::can($perm)) $this->abort(403); }

    public function dashboard(): void
    {
        $today = strtotime('today');
        $s = [
            'users' => (int)DB::val('SELECT COUNT(*) FROM users'),
            'online' => (int)DB::val("SELECT COUNT(*) FROM users WHERE online='1'"),
            'new_today' => (int)DB::val('SELECT COUNT(*) FROM users WHERE account_created >= ?', [$today]),
            'tickets' => (int)DB::val("SELECT COUNT(*) FROM website_helptool_requests WHERE status IN ('open','wait_reply')"),
            'bans' => (int)DB::val('SELECT COUNT(*) FROM bans WHERE ban_expire > ?', [time()]),
            'apps' => (int)DB::val("SELECT COUNT(*) FROM website_jobs_applys WHERE status='open'"),
            'threads' => (int)DB::val('SELECT COUNT(*) FROM ares_forum_threads'),
            'news' => (int)DB::val('SELECT COUNT(*) FROM website_news'),
        ];
        $chart = [];
        for ($i = 6; $i >= 0; $i--) {
            $from = strtotime("-$i day 00:00"); $to = $from + 86400;
            $chart[] = ['d' => date('d.m.', $from), 'v' => (int)DB::val('SELECT COUNT(*) FROM users WHERE account_created >= ? AND account_created < ?', [$from, $to])];
        }
        $this->v('dashboard', ['title' => 'Dashboard', 's' => $s, 'chart' => $chart,
            'newUsers' => DB::all('SELECT id, username, look, account_created FROM users ORDER BY id DESC LIMIT 6'),
            'logs' => DB::all('SELECT l.*, u.username FROM website_staff_logs l LEFT JOIN users u ON u.id=l.player_id ORDER BY l.id DESC LIMIT 6')]);
    }

    // ---- Nutzer
    public function users(): void
    {
        $this->need('housekeeping_remote_control');
        $q = trim((string)($_GET['q'] ?? ''));
        $esc = str_replace(['%', '_'], ['\%', '\_'], $q);
        $w = $q !== '' ? 'WHERE u.username LIKE ? OR u.mail LIKE ?' : '';
        $p = $q !== '' ? ["%$esc%", "%$esc%"] : [];
        $pg = paginate((int)DB::val("SELECT COUNT(*) FROM users u $w", $p), 25, (int)($_GET['page'] ?? 1));
        $rows = DB::all("SELECT u.id, u.username, u.mail, u.look, u.`rank`, u.credits, u.online, u.account_created, p.rank_name FROM users u LEFT JOIN permissions p ON p.id=u.`rank` $w ORDER BY u.id DESC LIMIT {$pg['per']} OFFSET {$pg['offset']}", $p);
        $this->v('users', ['title' => 'Nutzer', 'rows' => $rows, 'pg' => $pg, 'q' => $q]);
    }

    public function userEdit(string $id): void
    {
        $this->need('housekeeping_remote_control');
        $u = DB::one('SELECT u.*, p.rank_name FROM users u LEFT JOIN permissions p ON p.id=u.`rank` WHERE u.id=?', [(int)$id]);
        if (!$u) $this->abort(404);
        $cur = DB::all('SELECT c.type, c.amount FROM users_currency c WHERE c.user_id=?', [$u['id']]);
        $this->v('user_edit', ['title' => 'Nutzer: ' . $u['username'], 'u' => $u, 'ranks' => DB::all('SELECT id, rank_name FROM permissions ORDER BY id'), 'cur' => array_column($cur, 'amount', 'type'),
            'bans' => DB::all('SELECT b.*, s.username AS staff FROM bans b LEFT JOIN users s ON s.id=b.user_staff_id WHERE b.user_id=? ORDER BY b.timestamp DESC LIMIT 10', [$u['id']]),
            'banTypes' => DB::all('SELECT * FROM website_ban_types WHERE min_rank <= ? ORDER BY seconds', [(int)Auth::user()['rank']])]);
    }

    public function userSave(string $id): void
    {
        $this->need('housekeeping_remote_control');
        $u = DB::one('SELECT * FROM users WHERE id=?', [(int)$id]);
        if (!$u) $this->abort(404);
        $d = ['motto' => Request::str('motto', 127), 'credits' => max(0, Request::int('credits')), 'pixels' => max(0, Request::int('pixels')), 'points' => max(0, Request::int('points'))];
        $newRank = Request::int('rank', (int)$u['rank']);
        if ($newRank !== (int)$u['rank']) {
            if (!Auth::can('housekeeping_ranks')) $this->fail('Keine Berechtigung für Rangänderungen.');
            if ($newRank >= (int)Auth::user()['rank'] && (int)Auth::user()['id'] !== 1) $this->fail('Du kannst keinen Rang vergeben, der gleich oder höher als dein eigener ist.');
            $d['rank'] = $newRank;
        }
        if ((int)$u['rank'] >= (int)Auth::user()['rank'] && (int)$u['id'] !== (int)Auth::user()['id']) $this->fail('Du darfst Nutzer mit gleichem oder höherem Rang nicht bearbeiten.');
        if (($m = Request::str('mail', 120)) !== '' && Auth::can('housekeeping_change_email') && filter_var($m, FILTER_VALIDATE_EMAIL)) $d['mail'] = mb_strtolower($m);
        if (($pw = (string)($_POST['new_password'] ?? '')) !== '') { if (mb_strlen($pw) < 8) $this->fail('Passwort zu kurz.'); $d['password'] = password_hash($pw, PASSWORD_DEFAULT); }
        DB::update('users', $d, 'id=?', [$u['id']]);
        DB::exec('UPDATE users_settings SET credits=? WHERE user_id=?', [$d['credits'], $u['id']]);
        DB::exec('INSERT INTO users_currency (user_id,type,amount) VALUES (?,5,?) ON DUPLICATE KEY UPDATE amount=VALUES(amount)', [$u['id'], $d['points']]);
        log_staff('USER_EDIT', 'Nutzer ' . $u['username'] . ' bearbeitet', (int)$u['id']);
        flash('success', 'Nutzer gespeichert.');
        redirect('/admin/users/' . $u['id']);
    }

    public function ban(string $id): void
    {
        $this->need('housekeeping_ban_user');
        $u = DB::one('SELECT * FROM users WHERE id=?', [(int)$id]);
        $t = DB::one('SELECT * FROM website_ban_types WHERE id=? AND min_rank <= ?', [Request::int('type'), (int)Auth::user()['rank']]);
        if (!$u || !$t) $this->fail('Ungültige Angaben.');
        if ((int)$u['rank'] >= (int)Auth::user()['rank']) $this->fail('Du darfst diesen Nutzer nicht bannen.');
        $reason = Request::str('reason', 200) ?: 'Verstoß gegen die Regeln';
        $kind = in_array($_POST['kind'] ?? '', ['account', 'ip', 'super'], true) ? $_POST['kind'] : 'account';
        DB::insert('bans', ['user_id' => $u['id'], 'ip' => $u['ip_current'], 'machine_id' => (string)$u['machine_id'], 'user_staff_id' => Auth::user()['id'], 'timestamp' => time(), 'ban_expire' => time() + (int)$t['seconds'], 'ban_reason' => $reason, 'type' => $kind, 'cfh_topic' => -1]);
        Rcon::send('disconnect', ['user_id' => (int)$u['id']]);
        log_staff('BAN', $u['username'] . ': ' . $reason, (int)$u['id']);
        flash('success', 'Nutzer gebannt.');
        redirect('/admin/users/' . $u['id']);
    }

    public function bans(): void
    {
        $this->need('housekeeping_ban_logs');
        $rows = DB::all('SELECT b.*, u.username, s.username AS staff FROM bans b LEFT JOIN users u ON u.id=b.user_id LEFT JOIN users s ON s.id=b.user_staff_id ORDER BY b.timestamp DESC LIMIT 200');
        $this->v('bans', ['title' => 'Banns', 'rows' => $rows]);
    }

    public function unban(string $id): void
    {
        $this->need('housekeeping_ban_user');
        DB::update('bans', ['ban_expire' => time()], 'id=?', [(int)$id]);
        log_staff('UNBAN', "Bann #$id aufgehoben");
        $this->back('/admin/bans');
    }

    // ---- Tickets
    public function tickets(): void
    {
        $this->need('housekeeping_website_helptool');
        $st = in_array($_GET['status'] ?? '', ['open', 'in_treatment', 'wait_reply', 'closed'], true) ? $_GET['status'] : '';
        $rows = DB::all('SELECT r.*, u.username FROM website_helptool_requests r LEFT JOIN users u ON u.id=r.player_id ' . ($st ? 'WHERE r.status=? ' : '') . 'ORDER BY r.timestamp DESC LIMIT 200', $st ? [$st] : []);
        $this->v('tickets', ['title' => 'Support-Tickets', 'rows' => $rows, 'st' => $st]);
    }

    public function ticket(string $id): void
    {
        $this->need('housekeeping_website_helptool');
        $t = DB::one('SELECT r.*, u.username, u.look FROM website_helptool_requests r LEFT JOIN users u ON u.id=r.player_id WHERE r.id=?', [(int)$id]);
        if (!$t) $this->abort(404);
        $rep = DB::all('SELECT x.*, u.username FROM website_helptool_reactions x JOIN users u ON u.id=x.practitioner_id WHERE x.request_id=? ORDER BY x.timestamp', [$t['id']]);
        $this->v('ticket', ['title' => 'Ticket #' . $t['id'], 't' => $t, 'replies' => $rep]);
    }

    public function ticketReply(string $id): void
    {
        $this->need('housekeeping_website_helptool');
        $msg = Request::str('message', 4000);
        $st = in_array($_POST['status'] ?? '', ['open', 'in_treatment', 'wait_reply', 'closed'], true) ? $_POST['status'] : 'wait_reply';
        if ($msg !== '') DB::insert('website_helptool_reactions', ['request_id' => (int)$id, 'practitioner_id' => Auth::user()['id'], 'message' => $msg, 'timestamp' => time()]);
        DB::update('website_helptool_requests', ['status' => $st], 'id=?', [(int)$id]);
        log_staff('TICKET', "Ticket #$id → $st");
        redirect('/admin/tickets/' . (int)$id);
    }

    // ---- Bewerbungen
    public function applications(): void
    {
        $this->need('housekeeping_jobs');
        $rows = DB::all('SELECT a.*, j.job, u.username FROM website_jobs_applys a JOIN website_jobs j ON j.id=a.job_id JOIN users u ON u.id=a.user_id ORDER BY a.status, a.id DESC LIMIT 200');
        $this->v('applications', ['title' => 'Bewerbungen', 'rows' => $rows]);
    }

    public function applicationClose(string $id): void
    {
        $this->need('housekeeping_jobs');
        DB::update('website_jobs_applys', ['status' => 'closed'], 'id=?', [(int)$id]);
        $this->back('/admin/applications');
    }

    // ---- Berechtigungen
    public function permissions(): void
    {
        $this->need('housekeeping_permissions');
        $ranks = DB::all('SELECT id, rank_name FROM permissions ORDER BY id');
        $perms = DB::all('SELECT * FROM website_permissions ORDER BY permission');
        $map = [];
        foreach (DB::all('SELECT permission_id, rank_id FROM website_permissions_ranks') as $r) $map[$r['permission_id']][$r['rank_id']] = true;
        $this->v('permissions', ['title' => 'Berechtigungen', 'ranks' => $ranks, 'perms' => $perms, 'map' => $map]);
    }

    public function permissionsSave(): void
    {
        $this->need('housekeeping_permissions');
        $my = (int)Auth::user()['rank'];
        $pdo = DB::pdo(); $pdo->beginTransaction();
        $valid = array_column(DB::all('SELECT id FROM website_permissions'), 'id');
        foreach (DB::all('SELECT id FROM permissions') as $r) {
            $rid = (int)$r['id'];
            if ($rid >= $my && (int)Auth::user()['id'] !== 1) continue; // nur niedrigere Ränge verwaltbar
            DB::delete('website_permissions_ranks', 'rank_id=?', [$rid]);
            foreach ((array)($_POST['p'][$rid] ?? []) as $pid) if (in_array((int)$pid, $valid, true)) DB::exec('INSERT IGNORE INTO website_permissions_ranks (permission_id, rank_id) VALUES (?,?)', [(int)$pid, $rid]);
        }
        $pdo->commit();
        log_staff('PERMISSIONS', 'Berechtigungen aktualisiert');
        flash('success', 'Berechtigungen gespeichert (nur Ränge unter deinem eigenen).');
        redirect('/admin/permissions');
    }

    // ---- Einstellungen
    private const SETTINGS = [
        'Allgemein' => ['maintenance' => ['Wartungsmodus (1 = an)', 'text'], 'registration_open' => ['Registrierung offen (1/0)', 'text'], 'registration_max_ip' => ['Max. Accounts pro IP', 'text'], 'start_credits' => ['Start-Credits', 'text'], 'discord_invite' => ['Discord-Einladung', 'text'], 'hotel_client_url' => ['Client-URL (Nitro/Flash)', 'text'], 'user_of_the_week' => ['Nutzer der Woche (Name)', 'text']],
        'Startseite' => ['hero_title' => ['Hero-Titel', 'text'], 'hero_text' => ['Hero-Text', 'textarea']],
        'Tagesgeschenk' => ['daily_gift_amount' => ['Credits pro Geschenk', 'text'], 'daily_gift_hours' => ['Wartezeit in Stunden', 'text']],
        'Club / Shop' => ['vip_rank' => ['VIP-Rang-ID', 'text'], 'vip_price' => ['VIP-Preis', 'text'], 'vip_currency_type' => ['VIP-Währungs-Typ', 'text'], 'vip_membership_days' => ['VIP-Dauer (Tage)', 'text'], 'namechange_price' => ['Namenswechsel-Preis', 'text'], 'namechange_currency_type' => ['Namenswechsel-Währung', 'text'], 'club_page_content' => ['Club-Seite (HTML-frei, Text)', 'textarea']],
        'Seiten' => ['page_rules' => ['Hausregeln', 'textarea'], 'page_privacy' => ['Datenschutz', 'textarea'], 'page_imprint' => ['Impressum', 'textarea']],
        'Sicherheit' => ['recaptcha_publickey' => ['reCAPTCHA Site-Key', 'text'], 'recaptcha_secretkey' => ['reCAPTCHA Secret', 'text']],
    ];

    public function settings(): void
    {
        $this->need('housekeeping_config');
        $this->v('settings', ['title' => 'Einstellungen', 'groups' => self::SETTINGS]);
    }

    public function settingsSave(): void
    {
        $this->need('housekeeping_config');
        foreach (self::SETTINGS as $g) foreach ($g as $k => $_) if (isset($_POST['s'][$k])) Setting::set($k, mb_substr(trim((string)$_POST['s'][$k]), 0, 20000));
        log_staff('SETTINGS', 'Einstellungen geändert');
        flash('success', 'Einstellungen gespeichert.');
        redirect('/admin/settings');
    }

    // ---- Logs, Forum, Kommentare, Badges, RCON
    public function logs(): void
    {
        $this->need('housekeeping_staff_logs');
        $this->v('logs', ['title' => 'Staff-Logs', 'rows' => DB::all('SELECT l.*, u.username FROM website_staff_logs l LEFT JOIN users u ON u.id=l.player_id ORDER BY l.id DESC LIMIT 300')]);
    }

    public function forum(): void
    {
        $this->need('housekeeping_forum');
        $this->v('forum', ['title' => 'Forum-Moderation', 'rows' => DB::all('SELECT th.*, u.username, t.title AS topic, (SELECT COUNT(*) FROM ares_forum_comments c WHERE c.thread_id=th.id) AS replies FROM ares_forum_threads th JOIN users u ON u.id=th.user_id JOIN ares_forum_topics t ON t.id=th.topic_id ORDER BY th.created_at DESC LIMIT 100')]);
    }

    public function forumAction(string $id, string $act): void
    {
        $this->need('housekeeping_forum');
        $id = (int)$id;
        match ($act) {
            'pin' => DB::exec('UPDATE ares_forum_threads SET pinned = 1 - pinned WHERE id=?', [$id]),
            'lock' => DB::exec('UPDATE ares_forum_threads SET locked = 1 - locked WHERE id=?', [$id]),
            'delete' => (function () use ($id) { DB::delete('ares_forum_comments', 'thread_id=?', [$id]); DB::delete('ares_forum_threads', 'id=?', [$id]); })(),
            default => null,
        };
        log_staff('FORUM', "Thread #$id: $act");
        $this->back('/admin/forum');
    }

    public function comments(): void
    {
        $this->need('housekeeping_website_news');
        $this->v('comments', ['title' => 'Kommentare', 'rows' => DB::all('SELECT r.*, u.username, n.title AS news FROM website_news_reactions r JOIN users u ON u.id=r.player_id JOIN website_news n ON n.id=r.news_id ORDER BY r.timestamp DESC LIMIT 100')]);
    }

    public function commentToggle(string $id): void
    {
        $this->need('housekeeping_website_news');
        DB::exec('UPDATE website_news_reactions SET hidden = 1 - hidden WHERE id=?', [(int)$id]);
        $this->back('/admin/comments');
    }

    public function badges(): void
    {
        $this->need('housekeeping_website_badgerequest');
        $this->v('badges', ['title' => 'Badge-Anfragen', 'rows' => DB::all('SELECT b.*, u.username FROM website_badge_requests b JOIN users u ON u.id=b.user_id ORDER BY b.status, b.id DESC LIMIT 100')]);
    }

    public function badgeDecide(string $id, string $act): void
    {
        $this->need('housekeeping_website_badgerequest');
        DB::update('website_badge_requests', ['status' => $act === 'accept' ? 'accept' : 'decline'], 'id=?', [(int)$id]);
        $this->back('/admin/badges');
    }

    public function rcon(): void
    {
        $this->need('housekeeping_rcon');
        $this->v('rcon', ['title' => 'RCON-Konsole', 'cmds' => DB::all('SELECT * FROM ares_rcon_commands ORDER BY title'), 'enabled' => (bool)\App\Core\Config::get('rcon.enabled')]);
    }

    public function rconSend(): void
    {
        $this->need('housekeeping_rcon');
        $c = DB::one('SELECT * FROM ares_rcon_commands WHERE command=?', [Request::str('command', 50)]);
        if (!$c) $this->json(['ok' => false, 'msg' => 'Unbekannter Befehl'], 422);
        $data = [];
        foreach (array_filter(explode(',', $c['fields'])) as $f) {
            $val = Request::str('f_' . $f, 500);
            $data[$f] = ctype_digit($val) && $f !== 'message' && $f !== 'badge' ? (int)$val : $val;
        }
        $res = Rcon::send($c['command'], $data);
        log_staff('RCON', $c['command'] . ' ' . json_encode($data, JSON_UNESCAPED_UNICODE));
        $this->json($res);
    }
}
