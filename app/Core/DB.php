<?php
declare(strict_types=1);
namespace App\Core;

use PDO;

final class DB
{
    private static ?PDO $pdo = null;

    public static function pdo(): PDO
    {
        if (!self::$pdo) {
            $c = Config::get('db');
            $dsn = "mysql:host={$c['host']};port={$c['port']};dbname={$c['name']};charset={$c['charset']}";
            self::$pdo = new PDO($dsn, $c['user'], $c['password'], [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ]);
        }
        return self::$pdo;
    }
    public static function run(string $sql, array $p = []): \PDOStatement
    {
        $st = self::pdo()->prepare($sql);
        $st->execute($p);
        return $st;
    }
    public static function all(string $sql, array $p = []): array { return self::run($sql, $p)->fetchAll(); }
    public static function one(string $sql, array $p = []): ?array { $r = self::run($sql, $p)->fetch(); return $r ?: null; }
    public static function val(string $sql, array $p = []): mixed { $r = self::run($sql, $p)->fetchColumn(); return $r === false ? null : $r; }
    public static function exec(string $sql, array $p = []): int { return self::run($sql, $p)->rowCount(); }
    private static function ident(string $n): string
    {
        if (!preg_match('/^[A-Za-z0-9_]+$/', $n)) throw new \InvalidArgumentException('Ungültiger Bezeichner');
        return '`' . $n . '`';
    }
    public static function insert(string $table, array $data): int
    {
        $cols = implode(',', array_map([self::class, 'ident'], array_keys($data)));
        $ph = implode(',', array_fill(0, count($data), '?'));
        self::run('INSERT INTO ' . self::ident($table) . " ($cols) VALUES ($ph)", array_values($data));
        return (int)self::pdo()->lastInsertId();
    }
    public static function update(string $table, array $data, string $where, array $wp = []): int
    {
        $set = implode(',', array_map(fn($k) => self::ident($k) . '=?', array_keys($data)));
        return self::exec('UPDATE ' . self::ident($table) . " SET $set WHERE $where", array_merge(array_values($data), $wp));
    }
    public static function delete(string $table, string $where, array $p = []): int
    {
        return self::exec('DELETE FROM ' . self::ident($table) . " WHERE $where", $p);
    }
}
