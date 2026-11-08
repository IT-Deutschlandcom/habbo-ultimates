<?php
/**
 * Zentrale Konfiguration des Lutscher CMS.
 * Alle Einstellungen, die der Betreiber ändern muss, stehen hier.
 */
return [
    'site' => [
        'name'        => 'Habbo Dream DE',
        'tagline'     => 'Dein Sakura-Hotel',
        'base_url'    => '',            // leer = automatisch erkennen (z. B. https://hotel.example.com)
        'force_https' => false,         // true = HTTP wird per 301 auf HTTPS umgeleitet
        'trust_proxy' => false,         // true, wenn ein Proxy/Load-Balancer X-Forwarded-Proto setzt
        'timezone'    => 'Europe/Berlin',
        'locale'      => 'de',
        'debug'       => false,
    ],
    'db' => [
        'host'     => '127.0.0.1',
        'port'     => 3306,
        'name'     => 'lutscher',
        'user'     => 'lutscher',
        'password' => '',
        'charset'  => 'utf8mb4',
    ],
    'security' => [
        'session_name'     => 'lutscher_sid',
        'session_lifetime' => 86400 * 7,
        'login_max_tries'  => 6,         // pro IP und Zeitfenster
        'login_window'     => 900,       // Sekunden
        'password_min'     => 8,
        'allowed_hosts'    => [],        // optional: ['hotel.example.com'] gegen Host-Header-Angriffe
    ],
    'hotel' => [
        'imager_url'  => 'https://www.habbo.de/habbo-imaging/avatarimage?figure={look}&size={size}&direction=2&head_direction=3&gesture=sml',
        'badge_url'   => '/assets/img/badges/{code}.gif',
        'client_url'  => '',             // URL des Nitro/Flash-Clients (iframe auf /hotel)
        'start_credits' => 2500,
        'default_look'  => 'hr-115-42.hd-195-19.ch-3030-82.lg-275-1408.fa-1201.ca-1804-64',
        'looks' => [
            'M' => ['hr-115-42.hd-195-19.ch-3030-82.lg-275-1408', 'hr-100-61.hd-180-2.ch-210-66.lg-270-82', 'hr-165-45.hd-190-10.ch-3109-62.lg-285-90'],
            'F' => ['hr-515-45.hd-600-1.ch-635-70.lg-716-66', 'hr-545-39.hd-629-8.ch-665-62.lg-710-82', 'hr-890-45.hd-600-3.ch-818-1408.lg-720-110'],
        ],
    ],
    'rcon' => [                          // Verbindung zum Emulator (Arcturus-Rcon)
        'enabled' => false,
        'host'    => '127.0.0.1',
        'port'    => 3001,
        'timeout' => 3,
    ],
    'mail' => [
        'from'      => 'no-reply@localhost',
        'from_name' => 'Habbo Dream DE',
        'smtp_host' => '',               // leer = PHP mail() (unter IIS in php.ini konfigurieren)
        'smtp_port' => 587,
        'smtp_user' => '',
        'smtp_pass' => '',
        'smtp_tls'  => true,
    ],
    'uploads' => [
        'dir'      => __DIR__ . '/public/uploads',
        'url'      => '/uploads',
        'max_size' => 3 * 1024 * 1024,
    ],
    'installed' => false,                // wird vom Installer auf true gesetzt (install.lock)
];
