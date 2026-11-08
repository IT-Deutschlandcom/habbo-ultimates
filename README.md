# Habbo Dream DE – PHP-CMS

Eigenständiges CMS (PHP 8.3+, MySQL/MariaDB, Bootstrap 5, Vanilla-JS). Vereint die Funktionen von **Jan-d (Cosmic)** und **Ares** in einer Codebasis. Kein Node.js, kein Docker, kein Build-Schritt.

## Installation (Windows Server / IIS)
1. PHP 8.3+ (FastCGI/NTS) mit Erweiterungen `pdo_mysql`, `mbstring`, `fileinfo`, `gd`, `openssl` aktivieren; IIS **URL Rewrite** installieren.
2. Ordner `public/` als Website-Wurzel verwenden (alternativ den Projektordner – die Root-`web.config` leitet nach `public/` um und sperrt `app/`, `database/`, `storage/`).
3. Schreibrechte für den IIS-App-Pool-Benutzer auf `storage/`, `public/uploads/` und (nur während der Installation) `config.php`.
4. `http(s)://deine-domain/install.php` aufrufen: DB-Zugang + Admin-Account eintragen. Der Installer importiert `database/01_*.sql` und `02_*.sql`, schreibt die DB-Daten in `config.php` und sperrt sich danach über `storage/install.lock`.
5. Optional HTTPS erzwingen: `site.force_https => true` in `config.php` **oder** die Regel „HTTPS erzwingen“ in `public/web.config` aktivieren. Hinter einem Proxy: `trust_proxy => true`.

## Konfiguration
Alles Wichtige steht in `config.php` (Seitenname, Basis-URL, HTTPS, DB, Sicherheit, Habbo-Imager/Looks, Client-URL, RCON, Mail, Uploads). Laufzeit-Einstellungen (Wartungsmodus, Registrierung, Tagesgeschenk, Club, Seitentexte, reCAPTCHA) pflegst du im Admin-Panel unter *Einstellungen*.

## Struktur
```
config.php            zentrale Konfiguration
app/Core              Framework (Router, DB, Auth, Session, CSRF, View, Rcon, Mailer)
app/Controllers       Frontend- & Admin-Logik
app/Views             Templates (layout, auth, home, news, forum, admin, …)
database/             01 Basis (Jan-d, bereinigt) + 02 Ares-Erweiterungen
public/               Web-Root: index.php, install.php, web.config, assets, uploads
storage/              Logs, Cache, install.lock
```

## Funktionen
- **Aus Jan-d:** News + Kommentare, Hilfe/FAQ + Tickets, Jobs + Bewerbungen, Rare-Werte, Team, Ranking, Fotos, Gruppen, Shop/Club, Rang-/Berechtigungssystem, Bann-System, Staff-Logs, Namensänderung.
- **Aus Ares:** Forum (Bereiche, Themen, Antworten, Moderation), Gästebuch, Likes/Votes, Tagesgeschenk, Habbo der Woche, RCON-Konsole, Profile.
- **Sicherheit:** CSRF auf allen POSTs, bcrypt-Passwörter, Prepared Statements, Login-/Registrierungs-Throttling, Honeypot + Rechenfrage (+ optional reCAPTCHA), sichere Cookies, Security-Header, XSS-sicheres BBCode, Upload-Prüfung, Rang-Hierarchie im Admin.

Die Original-Repositories werden für den Betrieb **nicht** benötigt.

## Ares-Frontend und Gestaltung

Die PHP-Oberfläche orientiert sich jetzt am Frontend `necm1/ares-habbo-frontend`
(Branch `develop`, Stand `61370212bf8f5688173ef680909f194c00905865`):
gruppierte Sidebar, zweigeteilte Start-/Loginbox mit Raumillustration und persönlicher
Dashboard-Hero. Gäste können sich direkt auf der Startseite anmelden.
Startseite und `/login` teilen dasselbe Template: zentriertes Logo und Begrüßung
über dem Formular links, Raumillustration und Einführung rechts. Erst unter
768 Pixeln stehen die Bereiche untereinander.
`/me` öffnet das Dashboard; das Profil bleibt unter
`/profile/{name}` erreichbar. Die zusätzlichen Jan-d-Seiten bleiben erhalten.
Das Angular-Projekt läuft nicht parallel: Templates und Navigation sind in PHP
integriert, ohne Angular- oder Node-Abhängigkeit.

Oberflächen sind deckend dunkelgrau, Akzente rosa; auch Admin, Formulare und
Ladebildschirm verwenden diese Palette. Die Navigation nutzt die originalen
Einzel-Icons für Dashboard, News, Team, Einstellungen und Abmelden;
weitere Icons in Navigation, Guthaben und Dashboard stammen aus `sprites.png`.
Die Einzel-Icons werden nicht vergrößert. Die 40-Pixel-Slots der Sidebar
geben den Motiven mehr Platz, Sprite-Verkleinerungen werden geglättet statt
per `image-rendering: pixelated` grob heruntergerechnet.
`ui_icon()` in `app/helpers.php` enthält Asset-Zuordnung und Ausschnitte in Originalpixeln,
`public/assets/css/app.css` die Palette und responsive Darstellung.

Die lokal mitgelieferten Ares-Dateien liegen unter `public/assets/img/ares/`.
Herkunft und Lizenz stehen in `NOTICE.txt` und `LICENSE`; Rechte an
Habbo-/Sulake-Grafiken sind vor einer Veröffentlichung separat zu klären.
Rendering-Prüfung ohne Datenbank: `php tests/frontend.php`.

## Repository und lokale Daten

`storage/`-Inhalte, Sessions, Logs und Nutzer-Uploads sind vom Git-Stand
ausgeschlossen. Die mitgelieferte `config.php` enthält nur Vorgabewerte:
Zugangsdaten nach der Installation niemals committen. Lizenz- und
Herkunftshinweise stehen in `licenses/NOTICE.txt` und bei den jeweiligen Assets.
