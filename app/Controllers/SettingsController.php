<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Config, Controller, DB, Request, Setting};

final class SettingsController extends Controller
{
    public function index(): void { $this->view('settings/index', ['title' => 'Einstellungen', 'price' => (int)Setting::get('namechange_price', 500)]); }

    public function profile(): void
    {
        DB::update('users', ['motto' => Request::str('motto', 38)], 'id=?', [Auth::user()['id']]);
        flash('success', 'Motto gespeichert.');
        redirect('/settings');
    }

    public function password(): void
    {
        $u = Auth::user();
        if (!password_verify((string)($_POST['current'] ?? ''), $u['password'])) $this->fail('Aktuelles Passwort falsch.');
        $n = (string)($_POST['password'] ?? '');
        if (mb_strlen($n) < (int)Config::get('security.password_min') || $n !== (string)($_POST['password2'] ?? '')) $this->fail('Neues Passwort zu kurz oder nicht identisch.');
        DB::update('users', ['password' => password_hash($n, PASSWORD_DEFAULT)], 'id=?', [$u['id']]);
        flash('success', 'Passwort geändert.');
        redirect('/settings');
    }

    public function email(): void
    {
        $u = Auth::user();
        $mail = mb_strtolower(Request::str('mail', 120));
        if (!password_verify((string)($_POST['current'] ?? ''), $u['password'])) $this->fail('Passwort falsch.');
        if (!filter_var($mail, FILTER_VALIDATE_EMAIL)) $this->fail('Ungültige E-Mail.');
        if (DB::val('SELECT 1 FROM users WHERE mail=? AND id<>?', [$mail, $u['id']])) $this->fail('E-Mail bereits vergeben.');
        DB::insert('website_user_logs_email', ['user_id' => $u['id'], 'old_mail' => (string)$u['mail'], 'new_mail' => $mail, 'ip_address' => Request::ip(), 'timestamp' => time()]);
        DB::update('users', ['mail' => $mail, 'mail_verified' => '0'], 'id=?', [$u['id']]);
        flash('success', 'E-Mail geändert.');
        redirect('/settings');
    }

    public function namechange(): void
    {
        $u = Auth::user();
        $new = Request::str('username', 15);
        $price = (int)Setting::get('namechange_price', 500); $type = (int)Setting::get('namechange_currency_type', 5);
        if (!preg_match('/^[A-Za-z0-9\-=?!@:.]{3,15}$/', $new)) $this->fail('Ungültiger Name.');
        if (DB::val('SELECT 1 FROM users WHERE username=?', [$new])) $this->fail('Name bereits vergeben.');
        $pdo = DB::pdo(); $pdo->beginTransaction();
        $bal = (int)DB::val('SELECT amount FROM users_currency WHERE user_id=? AND type=? FOR UPDATE', [$u['id'], $type]);
        if ($bal < $price) { $pdo->rollBack(); $this->fail('Nicht genug Währung.'); }
        DB::exec('UPDATE users_currency SET amount = amount - ? WHERE user_id=? AND type=?', [$price, $u['id'], $type]);
        DB::update('users', ['username' => $new], 'id=?', [$u['id']]);
        $pdo->commit();
        flash('success', 'Name geändert.');
        redirect('/settings');
    }
}
