<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Config, Controller, DB, Request, Setting};

final class HotelController extends Controller
{
    public function client(): void
    {
        $u = Auth::user();
        $ticket = 'LDH-' . bin2hex(random_bytes(20));
        DB::update('users', ['auth_ticket' => $ticket], 'id=?', [$u['id']]);
        $base = (string)(Setting::get('hotel_client_url', '') ?: Config::get('hotel.client_url'));
        $src = $base !== '' ? $base . (str_contains($base, '?') ? '&' : '?') . 'sso=' . rawurlencode($ticket) : '';
        $this->view('home/hotel', ['title' => 'Hotel betreten', 'src' => $src], 'main');
    }

    public function page(string $slug): void
    {
        $allowed = ['rules' => 'Hausregeln', 'privacy' => 'Datenschutz', 'imprint' => 'Impressum'];
        if (!isset($allowed[$slug])) $this->abort(404);
        $this->view('home/page', ['title' => $allowed[$slug], 'slug' => $slug, 'body' => (string)Setting::get('page_' . $slug, '')]);
    }
}
