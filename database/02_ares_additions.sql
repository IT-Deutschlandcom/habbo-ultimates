-- Lutscher CMS – Erweiterungen aus dem Ares-CMS (Forum, Gästebuch, Votes, Tägliches Geschenk, User of the Hotel, RCON)
-- sowie CMS-eigene Tabellen. Wird nach 01_base_jan-d.sql eingespielt.
SET NAMES utf8mb4;

-- Einstellungen eindeutig machen (Ares: ares_settings wird hier mit website_settings zusammengeführt)
ALTER TABLE `website_settings` MODIFY `key` varchar(50) NOT NULL, MODIFY `value` text NULL, ADD PRIMARY KEY (`key`);
ALTER TABLE `website_permissions_ranks` ADD UNIQUE KEY `uniq_perm_rank` (`permission_id`, `rank_id`);
ALTER TABLE `website_news` ADD UNIQUE KEY `uniq_slug` (`slug`);
ALTER TABLE `users` ADD UNIQUE KEY `uniq_mail` (`mail`(190));

CREATE TABLE IF NOT EXISTS `cms_throttle` (
  `key` varchar(120) NOT NULL,
  `hits` int NOT NULL DEFAULT 1,
  `expires` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `expires` (`expires`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ares_forum_topics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT 0,
  `min_rank` int NOT NULL DEFAULT 1,
  `created_at` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ares_forum_threads` (
  `id` int NOT NULL AUTO_INCREMENT,
  `topic_id` int NOT NULL,
  `user_id` int NOT NULL,
  `slug` varchar(120) NOT NULL,
  `title` varchar(120) NOT NULL,
  `content` text NOT NULL,
  `pinned` tinyint NOT NULL DEFAULT 0,
  `locked` tinyint NOT NULL DEFAULT 0,
  `views` int NOT NULL DEFAULT 0,
  `created_at` int NOT NULL,
  `updated_at` int NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `topic_id` (`topic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ares_forum_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `thread_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text NOT NULL,
  `is_edited` tinyint NOT NULL DEFAULT 0,
  `created_at` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `thread_id` (`thread_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ares_guestbook` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `profile_id` int NOT NULL,
  `content` varchar(500) NOT NULL,
  `created_at` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ares_gifts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `amount` int NOT NULL,
  `pick_time` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ares_votes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `entity_id` int NOT NULL,
  `vote_entity` tinyint NOT NULL COMMENT '1=News, 2=Forum-Thread, 3=Forum-Kommentar',
  `vote_type` tinyint NOT NULL COMMENT '1=Like, 2=Dislike',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_vote` (`user_id`, `entity_id`, `vote_entity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ares_uoth` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `to_timestamp` int NOT NULL,
  `created_at` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ares_payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `code` varchar(40) NOT NULL,
  `processed` tinyint NOT NULL DEFAULT 0,
  `type` int NOT NULL DEFAULT 0,
  `amount` int NOT NULL DEFAULT 0,
  `created_at` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ares_rcon_commands` (
  `id` int NOT NULL AUTO_INCREMENT,
  `command` varchar(50) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `fields` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `command` (`command`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO `ares_rcon_commands` (`command`,`title`,`description`,`fields`) VALUES
('alertuser','Nutzer-Alert','Zeigt einem Nutzer eine Nachricht','user_id,message'),
('disconnect','Disconnect','Trennt einen Nutzer vom Hotel','user_id'),
('forwarduser','Weiterleiten','Schickt einen Nutzer in einen Raum','user_id,room_id'),
('givebadge','Badge geben','Gibt einem Nutzer ein Badge','user_id,badge'),
('givecredits','Credits geben','Gibt Credits','user_id,credits'),
('givepixels','Pixels geben','Gibt Pixels','user_id,pixels'),
('givepoints','Punkte geben','Gibt Punkte','user_id,points,type'),
('hotelalert','Hotel-Alert','Nachricht an alle Online-Nutzer','message'),
('setrank','Rang setzen','Setzt den Rang eines Nutzers','user_id,rank'),
('updatewordfilter','Wordfilter aktualisieren','Lädt den Wordfilter neu',''),
('updatecatalog','Katalog aktualisieren','Lädt den Katalog neu','');

-- Berechtigungen: Ränge 7-9 alles, 5-6 Basis-Moderation
INSERT IGNORE INTO `website_permissions_ranks` (`permission_id`,`rank_id`) SELECT p.id, r.r FROM `website_permissions` p JOIN (SELECT 7 r UNION SELECT 8 UNION SELECT 9) r WHERE p.permission <> 'maintenance_login' OR r.r >= 8;
INSERT IGNORE INTO `website_permissions_ranks` (`permission_id`,`rank_id`) SELECT p.id, r.r FROM `website_permissions` p JOIN (SELECT 5 r UNION SELECT 6) r WHERE p.permission IN ('housekeeping','housekeeping_ban_user','housekeeping_ban_logs','housekeeping_website_helptool','housekeeping_alert_user','housekeeping_moderation_tools');
INSERT IGNORE INTO `website_permissions` (`permission`,`description`) VALUES
('housekeeping_forum','Forum verwalten'),('housekeeping_jobs','Jobs & Bewerbungen verwalten'),('housekeeping_shop_offers','Shop-Angebote verwalten'),('housekeeping_rcon','RCON-Konsole nutzen');
INSERT IGNORE INTO `website_permissions_ranks` (`permission_id`,`rank_id`) SELECT p.id, r.r FROM `website_permissions` p JOIN (SELECT 7 r UNION SELECT 8 UNION SELECT 9) r WHERE p.permission IN ('housekeeping_forum','housekeeping_jobs','housekeeping_shop_offers','housekeeping_rcon');

-- Standard-Einstellungen (keine Geheimnisse)
INSERT IGNORE INTO `website_settings` (`key`,`value`) VALUES
('maintenance','0'),('start_credits','2500'),('registration_max_ip','3'),('registration_open','1'),
('daily_gift_amount','50'),('daily_gift_hours','24'),('discord_invite',''),('user_of_the_week',''),
('hero_title','Habbo Dream DE'),('hero_text','Dein virtuelles Zuhause für Freunde, Räume, Events und jede Menge Pixel-Spaß.'),
('club_page_content','<ul><li>Exklusive Badges</li><li>Mehr Credits & Diamanten</li><li>VIP-Rang im Hotel</li></ul>'),
('vip_rank','2'),('vip_price','1000'),('vip_currency_type','5'),('vip_membership_days','31'),
('namechange_price','500'),('namechange_currency_type','5'),
('recaptcha_publickey',''),('recaptcha_secretkey','');

INSERT IGNORE INTO `ares_forum_topics` (`title`,`slug`,`description`,`sort`,`created_at`) VALUES
('Allgemein','allgemein','Alles rund ums Hotel',1,UNIX_TIMESTAMP()),
('Events & Spiele','events-spiele','Veranstaltungen, Wettbewerbe und Spiele',2,UNIX_TIMESTAMP()),
('Vorstellung','vorstellung','Stell dich der Community vor',3,UNIX_TIMESTAMP());

INSERT IGNORE INTO `website_jobs` (`id`,`job`,`small_description`,`full_description`) VALUES
(1,'Botschafter','Hilf neuen Spielern beim Start','Du beantwortest Fragen und sorgst für gute Stimmung im Hotel.'),
(2,'Eventmanager','Plane und leite Events','Du organisierst Veranstaltungen und Wettbewerbe.');

INSERT IGNORE INTO `website_news` (`id`,`slug`,`title`,`short_story`,`full_story`,`images`,`author`,`header`,`category`,`form`,`timestamp`,`hidden`) VALUES
(1,'willkommen-im-hotel','Willkommen im Hotel','Das Hotel ist geöffnet. Komm vorbei und entdecke deine neue Pixel-Welt.','Das Hotel ist geöffnet! Komm vorbei, triff andere Spieler, erkunde Räume und erlebe gemeinsame Events.\n\nViel Spaß wünscht das Team.','[]',0,'/assets/img/news/hero_article.png',10,'none',UNIX_TIMESTAMP(),'0'),
(2,'neue-raeume-entdecken','Neue Räume entdecken','Triff andere Spieler, erkunde Räume und erlebe gemeinsame Events.','Neue Räume warten auf dich – schau in der Navigation vorbei und entdecke die besten Räume der Community.','[]',0,'/assets/img/news/topstory.gif',6,'none',UNIX_TIMESTAMP()-3600,'0');
