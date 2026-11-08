<?php
declare(strict_types=1);
namespace App\Core;

final class Auth
{
    private static ?array $user = null;
    private static bool $loaded = false;
    private static ?array $perms = null;

    public static function user(): ?array
    {
        if (!self::$loaded) {
            self::$loaded = true;
            $id = (int)Session::get('uid', 0);
            if ($id > 0) {
                $u = DB::one('SELECT u.*, p.rank_name FROM users u LEFT JOIN permissions p ON p.id = u.`rank` WHERE u.id = ?', [$id]);
                if ($u && !self::isBanned($u)) self::$user = $u; else Session::forget('uid');
            }
        }
        return self::$user;
    }
    public static function check(): bool { return self::user() !== null; }

    public static function isBanned(array $u): ?array
    {
        return DB::one("SELECT * FROM bans WHERE ban_expire > ? AND (user_id = ? OR (type IN ('ip','super') AND ip = ?)) ORDER BY ban_expire DESC LIMIT 1", [time(), $u['id'], Request::ip()]);
    }
    public static function login(array $u): void
    {
        Session::regenerate();
        Session::set('uid', (int)$u['id']);
        Session::forget('_csrf');
        DB::update('users', ['last_login' => time(), 'ip_current' => Request::ip()], 'id=?', [$u['id']]);
        self::$loaded = false;
        self::$perms = null;
    }
    public static function logout(): void { Session::destroy(); self::$user = null; self::$loaded = true; self::$perms = null; }

    public static function permissions(): array
    {
        if (self::$perms === null) {
            self::$perms = [];
            if ($u = self::user()) {
                $rows = DB::all('SELECT wp.permission FROM website_permissions_ranks r JOIN website_permissions wp ON wp.id = r.permission_id WHERE r.rank_id = ?', [$u['rank']]);
                self::$perms = array_column($rows, 'permission');
            }
        }
        return self::$perms;
    }
    public static function can(string $perm): bool { return in_array($perm, self::permissions(), true); }
}
