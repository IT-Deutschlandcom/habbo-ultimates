<?php
declare(strict_types=1);
namespace App\Core;

final class Mailer
{
    public static function send(string $to, string $subject, string $body): bool
    {
        if (!filter_var($to, FILTER_VALIDATE_EMAIL)) return false;
        $m = Config::get('mail');
        $from = $m['from'];
        $headers = ['From: ' . self::clean($m['from_name']) . ' <' . self::clean($from) . '>', 'MIME-Version: 1.0', 'Content-Type: text/plain; charset=UTF-8'];
        $subject = '=?UTF-8?B?' . base64_encode(self::clean($subject)) . '?=';
        if (empty($m['smtp_host'])) return @mail($to, $subject, $body, implode("\r\n", $headers));
        return self::smtp($m, $to, $subject, $body, $headers);
    }
    private static function clean(string $s): string { return str_replace(["\r", "\n"], '', $s); }

    private static function smtp(array $m, string $to, string $subject, string $body, array $headers): bool
    {
        $fp = @stream_socket_client(($m['smtp_port'] == 465 ? 'ssl://' : '') . $m['smtp_host'] . ':' . $m['smtp_port'], $en, $es, 10);
        if (!$fp) return false;
        $rd = function () use ($fp) { $r = ''; while (($l = fgets($fp, 512)) !== false) { $r .= $l; if (($l[3] ?? ' ') === ' ') break; } return $r; };
        $cmd = function (string $c) use ($fp, $rd) { fwrite($fp, $c . "\r\n"); return $rd(); };
        $rd();
        $cmd('EHLO ' . Request::host());
        if ($m['smtp_tls'] && $m['smtp_port'] != 465) { $cmd('STARTTLS'); stream_socket_enable_crypto($fp, true, STREAM_CRYPTO_METHOD_TLS_CLIENT); $cmd('EHLO ' . Request::host()); }
        if ($m['smtp_user'] !== '') { $cmd('AUTH LOGIN'); $cmd(base64_encode($m['smtp_user'])); $cmd(base64_encode($m['smtp_pass'])); }
        $cmd('MAIL FROM:<' . self::clean($m['from']) . '>');
        $cmd('RCPT TO:<' . self::clean($to) . '>');
        $cmd('DATA');
        $msg = implode("\r\n", array_merge($headers, ['To: ' . $to, 'Subject: ' . $subject])) . "\r\n\r\n" . preg_replace('/^\./m', '..', $body);
        $r = $cmd($msg . "\r\n.");
        $cmd('QUIT');
        fclose($fp);
        return str_starts_with($r, '250');
    }
}
