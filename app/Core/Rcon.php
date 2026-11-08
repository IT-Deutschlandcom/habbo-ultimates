<?php
declare(strict_types=1);
namespace App\Core;

/** Sendet Befehle an den Emulator (Arcturus-RCON, JSON über TCP). */
final class Rcon
{
    public static function send(string $command, array $data = []): array
    {
        if (!Config::get('rcon.enabled')) return ['ok' => false, 'msg' => 'RCON ist in der config.php deaktiviert.'];
        $c = Config::get('rcon');
        $fp = @fsockopen($c['host'], (int)$c['port'], $errno, $err, (float)$c['timeout']);
        if (!$fp) return ['ok' => false, 'msg' => "Emulator nicht erreichbar ($err)"];
        stream_set_timeout($fp, (int)$c['timeout']);
        fwrite($fp, json_encode(['key' => $command, 'data' => $data]));
        $resp = (string)fread($fp, 4096);
        fclose($fp);
        return ['ok' => true, 'msg' => $resp ?: 'Gesendet'];
    }
}
