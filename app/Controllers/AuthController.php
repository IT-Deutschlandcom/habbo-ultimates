<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Controller, DB, Mailer, Request, Session, Setting, Config};

final class AuthController extends Controller
{
    public function loginForm(): void { $this->view('auth/login', ['title' => 'Einloggen']); }

    public function login(): void
    {
        $max = (int)Config::get('security.login_max_tries'); $win = (int)Config::get('security.login_window');
        if (!$this->throttle('login', $max, $win)) $this->fail('Zu viele Versuche. Bitte warte einige Minuten.');
        $name = Request::str('username', 60);
        $pass = (string)($_POST['password'] ?? '');
        $u = DB::one('SELECT * FROM users WHERE username = ? OR mail = ? LIMIT 1', [$name, $name]);
        // gleiche Laufzeit, egal ob Nutzer existiert
        $hash = $u['password'] ?? '$2y$10$abcdefghijklmnopqrstuuYbS7cX3a1D5x0m1sQ2wzY4q1Qf5n8e6';
        if (!$u || !password_verify($pass, $hash)) { $this->hit('login', $win); $this->fail('Benutzername oder Passwort falsch.'); }
        if ($b = Auth::isBanned($u)) $this->fail('Dein Account ist gesperrt: ' . ($b['ban_reason'] ?: 'ohne Angabe') . ' (bis ' . date('d.m.Y H:i', (int)$b['ban_expire']) . ')');
        if (Setting::get('maintenance') === '1' && !$this->hasMaintenanceAccess((int)$u['rank'])) $this->fail('Das Hotel befindet sich im Wartungsmodus.');
        if (password_needs_rehash($u['password'], PASSWORD_DEFAULT)) DB::update('users', ['password' => password_hash($pass, PASSWORD_DEFAULT)], 'id=?', [$u['id']]);
        Auth::login($u);
        flash('success', 'Willkommen zurück, ' . $u['username'] . '!');
        redirect('/');
    }

    private function hasMaintenanceAccess(int $rank): bool
    {
        return (bool)DB::val("SELECT 1 FROM website_permissions_ranks r JOIN website_permissions p ON p.id=r.permission_id WHERE r.rank_id=? AND p.permission='maintenance_login'", [$rank]);
    }

    public function registerForm(): void
    {
        if (Setting::get('registration_open', '1') !== '1') { flash('warning', 'Die Registrierung ist derzeit geschlossen.'); redirect('/'); }
        $a = random_int(1, 9); $b = random_int(1, 9);
        Session::set('captcha', $a + $b);
        $this->view('auth/register', ['title' => 'Account erstellen', 'captcha' => "$a + $b", 'looks' => Config::get('hotel.looks')]);
    }

    public function register(): void
    {
        if (Setting::get('registration_open', '1') !== '1') $this->fail('Registrierung geschlossen.');
        if (Request::str('website', 50) !== '') redirect('/'); // Honeypot
        if (!$this->throttle('register', 5, 3600)) $this->fail('Zu viele Registrierungen von deiner IP.');
        $name = Request::str('username', 15); $mail = mb_strtolower(Request::str('mail', 120));
        $p1 = (string)($_POST['password'] ?? ''); $p2 = (string)($_POST['password2'] ?? '');
        $gender = Request::str('gender', 1) === 'F' ? 'F' : 'M';
        $lookIdx = Request::int('look');
        $looks = Config::get('hotel.looks')[$gender];
        $look = ($looks[$lookIdx] ?? $looks[0]) . '.fa-1201.ca-1804-64';
        if ((int)Request::str('captcha', 3) !== (int)Session::get('captcha', -1)) $this->fail('Sicherheitsfrage falsch.');
        if (!preg_match('/^[A-Za-z0-9\-=?!@:.]{3,15}$/', $name)) $this->fail('Benutzername: 3–15 Zeichen (Buchstaben, Zahlen, - = ? ! @ : .).');
        if (!filter_var($mail, FILTER_VALIDATE_EMAIL)) $this->fail('Bitte gib eine gültige E-Mail-Adresse an.');
        if (mb_strlen($p1) < (int)Config::get('security.password_min')) $this->fail('Das Passwort muss mindestens ' . Config::get('security.password_min') . ' Zeichen haben.');
        if ($p1 !== $p2) $this->fail('Die Passwörter stimmen nicht überein.');
        if (empty($_POST['agb'])) $this->fail('Bitte akzeptiere die Regeln.');
        if (DB::val('SELECT 1 FROM users WHERE username = ?', [$name])) $this->fail('Dieser Benutzername ist bereits vergeben.');
        if (DB::val('SELECT 1 FROM users WHERE mail = ?', [$mail])) $this->fail('Diese E-Mail-Adresse wird bereits verwendet.');
        $ip = Request::ip();
        if ((int)DB::val('SELECT COUNT(*) FROM users WHERE ip_register = ?', [$ip]) >= (int)Setting::get('registration_max_ip', 3)) $this->fail('Von dieser IP wurden bereits zu viele Accounts erstellt.');
        if (!$this->recaptcha()) $this->fail('Captcha-Prüfung fehlgeschlagen.');

        $this->hit('register', 3600);
        $credits = (int)Setting::get('start_credits', Config::get('hotel.start_credits'));
        $id = DB::insert('users', [
            'username' => $name, 'real_name' => $name, 'password' => password_hash($p1, PASSWORD_DEFAULT), 'mail' => $mail,
            'account_created' => time(), 'last_login' => time(), 'last_online' => time(), 'motto' => 'Neu im Hotel', 'look' => $look,
            'gender' => $gender, 'rank' => 1, 'credits' => $credits, 'ip_register' => $ip, 'ip_current' => $ip,
        ]);
        DB::exec('INSERT IGNORE INTO users_settings (user_id, credits) VALUES (?, ?)', [$id, $credits]);
        Session::forget('captcha');
        Auth::login(DB::one('SELECT * FROM users WHERE id=?', [$id]));
        flash('success', 'Account erstellt – willkommen im Hotel!');
        redirect('/');
    }

    private function recaptcha(): bool
    {
        $secret = (string)Setting::get('recaptcha_secretkey', '');
        if ($secret === '') return true;
        $resp = (string)($_POST['g-recaptcha-response'] ?? '');
        if ($resp === '') return false;
        $ctx = stream_context_create(['http' => ['method' => 'POST', 'timeout' => 5, 'header' => 'Content-Type: application/x-www-form-urlencoded', 'content' => http_build_query(['secret' => $secret, 'response' => $resp, 'remoteip' => Request::ip()])]]);
        $r = @file_get_contents('https://www.google.com/recaptcha/api/siteverify', false, $ctx);
        return $r && (json_decode($r, true)['success'] ?? false);
    }

    public function logout(): void { Auth::logout(); Session::start(); redirect('/'); }

    public function forgotForm(): void { $this->view('auth/forgot', ['title' => 'Passwort vergessen']); }

    public function forgot(): void
    {
        if (!$this->throttle('forgot', 3, 3600)) $this->fail('Zu viele Anfragen. Versuche es später erneut.');
        $this->hit('forgot', 3600);
        $mail = mb_strtolower(Request::str('mail', 120));
        if ($u = DB::one('SELECT id, username, mail FROM users WHERE mail = ?', [$mail])) {
            $token = bin2hex(random_bytes(32));
            DB::delete('website_password_reset', 'player_id = ?', [$u['id']]);
            DB::insert('website_password_reset', ['player_id' => $u['id'], 'email' => $u['mail'], 'ip_address' => Request::ip(), 'token' => hash('sha256', $token), 'timestamp' => time()]);
            Mailer::send($u['mail'], 'Passwort zurücksetzen', "Hallo {$u['username']},\n\nzum Zurücksetzen deines Passworts öffne (1 Stunde gültig):\n" . url('password/reset/' . $token) . "\n\nWar das nicht du? Ignoriere diese E-Mail.");
        }
        flash('success', 'Falls die Adresse existiert, wurde eine E-Mail mit weiteren Schritten gesendet.');
        redirect('/login');
    }

    public function resetForm(string $token): void
    {
        if (!$this->resetRow($token)) { flash('danger', 'Der Link ist ungültig oder abgelaufen.'); redirect('/password/forgot'); }
        $this->view('auth/reset', ['title' => 'Neues Passwort', 'token' => $token]);
    }

    private function resetRow(string $token): ?array
    {
        return DB::one('SELECT * FROM website_password_reset WHERE token = ? AND timestamp > ?', [hash('sha256', $token), time() - 3600]);
    }

    public function reset(string $token): void
    {
        $r = $this->resetRow($token);
        if (!$r) $this->fail('Der Link ist ungültig oder abgelaufen.', '/password/forgot');
        $p1 = (string)($_POST['password'] ?? '');
        if (mb_strlen($p1) < (int)Config::get('security.password_min') || $p1 !== (string)($_POST['password2'] ?? '')) $this->fail('Passwörter ungültig oder nicht identisch (mind. ' . Config::get('security.password_min') . ' Zeichen).');
        DB::update('users', ['password' => password_hash($p1, PASSWORD_DEFAULT)], 'id=?', [$r['player_id']]);
        DB::delete('website_password_reset', 'player_id = ?', [$r['player_id']]);
        flash('success', 'Passwort geändert. Du kannst dich jetzt einloggen.');
        redirect('/login');
    }
}
