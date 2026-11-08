<?php
declare(strict_types=1);

use App\Core\{Config, Request, Session, Csrf, Auth, Setting};

function e(mixed $v): string { return htmlspecialchars((string)$v, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'); }
function cfg(string $k, mixed $d = null): mixed { return Config::get($k, $d); }
function url(string $path = ''): string { return Request::baseUrl() . '/' . ltrim($path, '/'); }
function asset(string $p): string {
    $f = ROOT . '/public/assets/' . ltrim($p, '/');
    return url('assets/' . ltrim($p, '/')) . (is_file($f) ? '?v=' . filemtime($f) : '');
}
function ui_icon(string $name): string {
    $standalone = match ($name) {
        'speedometer2' => ['dashboard', 29, 30],
        'newspaper', 'journal-text' => ['news', 30, 36],
        'shield-check', 'shield-lock' => ['employees', 23, 32],
        'gear', 'sliders', 'key' => ['settings', 23, 28],
        'box-arrow-left' => ['logout', 34, 36],
        default => null,
    };
    if ($standalone !== null) {
        [$file, $width, $height] = $standalone;
        return '<span class="pixel-icon" aria-hidden="true"><img src="' . e(asset('img/ares/icons/' . $file . '.png'))
            . '" width="' . $width . '" height="' . $height . '" alt=""></span>';
    }
    // Clip the atlas before fitting it into the icon slot; never enlarge the source art.
    $rect = match ($name) {
        'door-open' => [180, 156, 78, 73],
        'people', 'person-plus', 'broadcast', 'flag' => [121, 0, 40, 52],
        'chat-square-text', 'chat-dots' => [165, 0, 40, 52],
        'camera' => [209, 0, 38, 45],
        'gem', 'stars', 'diamonds' => [292, 0, 87, 78],
        'coin', 'credits', 'bag-heart', 'bag' => [382, 0, 80, 65],
        'duckets' => [253, 0, 40, 44],
        'star' => [123, 70, 37, 41],
        'life-preserver', 'question-circle' => [235, 69, 41, 38],
        'trophy', 'award' => [123, 155, 57, 58],
        'briefcase', 'ticket-detailed' => [94, 154, 25, 38],
        'gift', 'patch-check' => [54, 154, 36, 55],
        default => null,
    };
    if ($rect === null) return '<i aria-hidden="true" class="bi bi-' . e($name) . '"></i>';
    [, , $width, $height] = $rect;
    return '<span class="pixel-icon" aria-hidden="true"><svg viewBox="0 0 ' . $width . ' ' . $height
        . '" width="' . $width . '" height="' . $height . '" focusable="false"><svg viewBox="' . implode(' ', $rect)
        . '" width="' . $width . '" height="' . $height . '" overflow="hidden"><image href="'
        . e(asset('img/ares/sprites.png')) . '" width="462" height="2200"/></svg></svg></span>';
}
function csrf_field(): string { return '<input type="hidden" name="_token" value="' . e(Csrf::token()) . '">'; }
function redirect(string $to, int $code = 302): never {
    if (!preg_match('~^https?://~i', $to)) $to = url($to);
    header('Location: ' . $to, true, $code);
    exit;
}
function flash(string $type, string $msg): void { Session::push('_flash', ['t' => $type, 'm' => $msg]); }
function old(string $k, string $d = ''): string { return e(Session::peekOld($k) ?? $d); }
function setting(string $k, mixed $d = null): mixed { return Setting::get($k, $d); }
function user(): ?array { return Auth::user(); }
function can(string $perm): bool { return Auth::can($perm); }
function look_url(string $look, string $size = 'l', string $extra = ''): string {
    $u = str_replace(['{look}', '{size}'], [rawurlencode($look), $size], (string)cfg('hotel.imager_url'));
    return $u . $extra;
}
function head_url(string $look): string { return look_url($look, 'm', '&headonly=1'); }
function ago(int $ts): string {
    $d = time() - $ts;
    if ($d < 60) return 'gerade eben';
    if ($d < 3600) return 'vor ' . intdiv($d, 60) . ' Min.';
    if ($d < 86400) return 'vor ' . intdiv($d, 3600) . ' Std.';
    if ($d < 86400 * 30) return 'vor ' . intdiv($d, 86400) . ' Tg.';
    return date('d.m.Y', $ts);
}
function slugify(string $s): string {
    $s = strtr(mb_strtolower($s), ['ä' => 'ae', 'ö' => 'oe', 'ü' => 'ue', 'ß' => 'ss']);
    $s = trim(preg_replace('~[^a-z0-9]+~', '-', $s) ?? '', '-');
    return $s !== '' ? $s : 'eintrag';
}
function client_ip(): string { return Request::ip(); }
function num(int|float|string $n): string { return number_format((float)$n, 0, ',', '.'); }
function paginate(int $total, int $per, int $page): array {
    $pages = max(1, (int)ceil($total / $per));
    $page = min(max(1, $page), $pages);
    return ['page' => $page, 'pages' => $pages, 'offset' => ($page - 1) * $per, 'per' => $per, 'total' => $total];
}
/** Sicheres BBCode/Text → HTML (alles wird zuerst escaped). */
function render_text(string $s): string {
    $s = e($s);
    $s = preg_replace('~\[b\](.*?)\[/b\]~is', '<strong>$1</strong>', $s);
    $s = preg_replace('~\[i\](.*?)\[/i\]~is', '<em>$1</em>', $s);
    $s = preg_replace('~\[u\](.*?)\[/u\]~is', '<u>$1</u>', $s);
    $s = preg_replace_callback('~\[url=(https?://[^\]\s"\'<>]+)\](.*?)\[/url\]~is', fn($m) => '<a href="' . $m[1] . '" rel="nofollow noopener" target="_blank">' . $m[2] . '</a>', $s);
    $s = preg_replace_callback('~\[img\](https?://[^\s"\'<>\[\]]+)\[/img\]~i', fn($m) => '<img src="' . $m[1] . '" class="img-fluid rounded" alt="" loading="lazy">', $s);
    return nl2br($s, false);
}
function log_staff(string $type, string $value, ?int $target = null): void {
    \App\Core\DB::insert('website_staff_logs', ['type' => $type, 'value' => mb_substr($value, 0, 255), 'player_id' => (int)(user()['id'] ?? 0), 'target' => (int)$target, 'timestamp' => time()]);
}
