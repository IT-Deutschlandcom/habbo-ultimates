<?php
declare(strict_types=1);
namespace App\Core;

abstract class Controller
{
    protected function view(string $tpl, array $data = [], string $layout = 'main'): void { View::render($tpl, $data, $layout); }
    protected function json(array $d, int $code = 200): never
    {
        http_response_code($code);
        header('Content-Type: application/json; charset=utf-8');
        exit(json_encode($d, JSON_UNESCAPED_UNICODE));
    }
    protected function back(?string $fallback = '/'): never
    {
        $ref = $_SERVER['HTTP_REFERER'] ?? '';
        $host = parse_url($ref, PHP_URL_HOST);
        redirect($ref !== '' && $host === preg_replace('/:\d+$/', '', Request::host()) ? $ref : (string)$fallback);
    }
    protected function fail(string $msg, string $to = ''): never
    {
        flash('danger', $msg);
        Session::flashOld($_POST);
        $to === '' ? $this->back() : redirect($to);
    }
    protected function abort(int $code = 404): never
    {
        http_response_code($code);
        View::render('errors/' . $code, ['title' => 'Fehler']);
        exit;
    }
    protected function throttle(string $action, int $max, int $window): bool
    {
        $key = $action . ':' . Request::ip();
        DB::exec('DELETE FROM cms_throttle WHERE expires < ?', [time()]);
        $row = DB::one('SELECT hits FROM cms_throttle WHERE `key` = ?', [$key]);
        return !$row || (int)$row['hits'] < $max;
    }
    protected function hit(string $action, int $window): void
    {
        DB::exec('INSERT INTO cms_throttle (`key`, hits, expires) VALUES (?,1,?) ON DUPLICATE KEY UPDATE hits = hits + 1', [$action . ':' . Request::ip(), time() + $window]);
    }
    protected function upload(string $field, string $subdir = 'misc'): ?string
    {
        $f = $_FILES[$field] ?? null;
        if (!$f || $f['error'] === UPLOAD_ERR_NO_FILE) return null;
        if ($f['error'] !== UPLOAD_ERR_OK || $f['size'] > (int)Config::get('uploads.max_size')) $this->fail('Upload fehlgeschlagen (zu groß?).');
        $mime = (new \finfo(FILEINFO_MIME_TYPE))->file($f['tmp_name']);
        $ext = ['image/png' => 'png', 'image/jpeg' => 'jpg', 'image/gif' => 'gif', 'image/webp' => 'webp'][$mime] ?? null;
        if (!$ext) $this->fail('Nur PNG, JPG, GIF oder WEBP erlaubt.');
        $dir = rtrim((string)Config::get('uploads.dir'), '/\\') . '/' . preg_replace('~[^a-z0-9_]~', '', $subdir);
        if (!is_dir($dir)) mkdir($dir, 0775, true);
        $name = bin2hex(random_bytes(12)) . '.' . $ext;
        if (!move_uploaded_file($f['tmp_name'], $dir . '/' . $name)) $this->fail('Datei konnte nicht gespeichert werden.');
        return rtrim((string)Config::get('uploads.url'), '/') . '/' . basename($dir) . '/' . $name;
    }
}
