<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Controller, DB, Rcon, Request, Setting};

final class ShopController extends Controller
{
    public function index(): void
    {
        $this->view('shop/index', ['title' => 'Shop', 'offers' => DB::all('SELECT * FROM website_paypal_offers ORDER BY id'), 'currencies' => DB::all('SELECT * FROM website_settings_currencys ORDER BY id')]);
    }

    public function club(): void
    {
        $u = Auth::user();
        $this->view('shop/club', ['title' => 'Club', 'is_vip' => (int)$u['rank'] >= (int)Setting::get('vip_rank', 2), 'price' => (int)Setting::get('vip_price', 1000), 'type' => (int)Setting::get('vip_currency_type', 5), 'days' => (int)Setting::get('vip_membership_days', 31)]);
    }

    public function buyClub(): void
    {
        $u = Auth::user();
        $type = (int)Setting::get('vip_currency_type', 5); $price = (int)Setting::get('vip_price', 1000); $rank = (int)Setting::get('vip_rank', 2);
        if ((int)$u['rank'] >= $rank) $this->fail('Du hast bereits einen Rang mit Club-Vorteilen.');
        $pdo = DB::pdo(); $pdo->beginTransaction();
        $bal = (int)DB::val('SELECT amount FROM users_currency WHERE user_id=? AND type=? FOR UPDATE', [$u['id'], $type]);
        if ($bal < $price) { $pdo->rollBack(); $this->fail('Nicht genug Währung.'); }
        DB::exec('UPDATE users_currency SET amount = amount - ? WHERE user_id=? AND type=?', [$price, $u['id'], $type]);
        DB::update('users', ['rank' => $rank], 'id=?', [$u['id']]);
        DB::insert('website_membership', ['user_id' => $u['id'], 'old_rank' => $u['rank'], 'expires_at' => time() + (int)Setting::get('vip_membership_days', 31) * 86400]);
        $pdo->commit();
        Rcon::send('setrank', ['user_id' => (int)$u['id'], 'rank' => $rank]);
        flash('success', 'Willkommen im Club!');
        redirect('/shop/club');
    }
}
