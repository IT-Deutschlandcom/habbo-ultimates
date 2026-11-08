-- Lutscher CMS – Basis-Schema (Struktur aus dem Jan-d/Cosmic-Dump, ohne Nutzerdaten und Zugangsdaten)
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `real_name` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'KREWS DEV',
  `password` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `mail` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `mail_verified` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `account_created` int NOT NULL,
  `account_day_of_birth` int NOT NULL DEFAULT 0,
  `last_login` int NOT NULL DEFAULT 0,
  `last_online` int NOT NULL DEFAULT 0,
  `motto` varchar(127) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `look` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'hr-115-42.hd-195-19.ch-3030-82.lg-275-1408.fa-1201.ca-1804-64',
  `gender` enum('M','F') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'M',
  `rank` int NOT NULL DEFAULT 1,
  `credits` int NOT NULL DEFAULT 2500,
  `pixels` int NOT NULL DEFAULT 500,
  `points` int NOT NULL DEFAULT 10,
  `online` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `auth_ticket` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `ip_register` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ip_current` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'Have your CMS update this IP. If you do not do this IP banning won\'t work!',
  `machine_id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `home_room` int NULL DEFAULT NULL,
  `secret_key` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `pincode` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `extra_rank` int NULL DEFAULT NULL,
  `team_id` bigint UNSIGNED NULL DEFAULT NULL,
  `banner_id` int NULL DEFAULT 0,
  `ls_experience` int NOT NULL DEFAULT 0,
  `ls_prefix_id` int NOT NULL DEFAULT 0,
  `ls_name_color_id` int NOT NULL DEFAULT 0,
  `ls_show_level` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `namechanges` int NOT NULL DEFAULT 0,
  `events_won` int NOT NULL DEFAULT 0,
  `template` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'light',
  `lang` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'de',
  `event_alert` enum('true','false') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'true',
  `sex_enabled` enum('true','false') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'true',
  `discord_id` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '',
  `auth_cms` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE,
  UNIQUE INDEX `id_2`(`id` ASC) USING BTREE,
  UNIQUE INDEX `id_3`(`id` ASC) USING BTREE,
  INDEX `account_created`(`account_created` ASC) USING BTREE,
  INDEX `last_login`(`last_login` ASC) USING BTREE,
  INDEX `last_online`(`last_online` ASC) USING BTREE,
  INDEX `figure`(`motto` ASC, `look` ASC, `gender` ASC) USING BTREE,
  INDEX `auth_ticket`(`auth_ticket` ASC) USING BTREE,
  INDEX `users_team_id_foreign`(`team_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `users_settings`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL DEFAULT 0 COMMENT 'WARNING: DONT HAVE YOUR CMS INSERT ANYTHING IN HERE. THE EMULATOR DOES THIS FOR YOU!',
  `credits` int NOT NULL DEFAULT 0,
  `achievement_score` int NOT NULL DEFAULT 0,
  `daily_respect_points` int NOT NULL DEFAULT 3,
  `daily_pet_respect_points` int NOT NULL DEFAULT 3,
  `respects_given` int NOT NULL DEFAULT 0,
  `respects_received` int NOT NULL DEFAULT 0,
  `guild_id` int NOT NULL DEFAULT 0,
  `can_change_name` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `can_trade` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '1',
  `is_citizen` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
  `citizen_level` int NOT NULL DEFAULT 0,
  `helper_level` int NOT NULL DEFAULT 0,
  `tradelock_amount` int NOT NULL DEFAULT 0,
  `cfh_send` int NOT NULL DEFAULT 0 COMMENT 'Amount of CFHs been send. Not include abusive.',
  `cfh_abusive` int NOT NULL DEFAULT 0 COMMENT 'Amount of abusive CFHs have been send.',
  `cfh_warnings` int NOT NULL DEFAULT 0 COMMENT 'Amount of warnings a user has received.',
  `cfh_bans` int NOT NULL DEFAULT 0 COMMENT 'Amount of bans a user has received.',
  `block_following` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `block_friendrequests` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `block_roominvites` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
  `volume_system` int NOT NULL DEFAULT 100,
  `volume_furni` int NOT NULL DEFAULT 100,
  `volume_trax` int NOT NULL DEFAULT 100,
  `old_chat` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
  `block_camera_follow` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
  `chat_color` int NOT NULL DEFAULT 0,
  `home_room` int NOT NULL DEFAULT 0,
  `online_time` int NOT NULL DEFAULT 0 COMMENT 'Total online time in seconds.',
  `tags` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'Arcturus Emulator;',
  `club_expire_timestamp` int NOT NULL DEFAULT 0,
  `login_streak` int NOT NULL DEFAULT 0,
  `rent_space_id` int NOT NULL DEFAULT 0,
  `rent_space_endtime` int NOT NULL DEFAULT 0,
  `hof_points` int NOT NULL DEFAULT 0,
  `block_alerts` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
  `talent_track_citizenship_level` int NOT NULL DEFAULT -1,
  `talent_track_helpers_level` int NOT NULL DEFAULT -1,
  `ignore_bots` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
  `ignore_pets` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
  `nux` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
  `mute_end_timestamp` int NOT NULL DEFAULT 0,
  `allow_name_change` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
  `perk_trade` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0' COMMENT 'Defines if a player has obtained the perk TRADE. When hotel.trading.requires.perk is set to 1, this perk is required in order to trade. Perk is obtained from the talen track.',
  `forums_post_count` int NULL DEFAULT 0,
  `ui_flags` int NOT NULL DEFAULT 1,
  `has_gotten_default_saved_searches` tinyint(1) NOT NULL DEFAULT 0,
  `hc_gifts_claimed` int NULL DEFAULT 0,
  `last_hc_payday` int NULL DEFAULT 0,
  `max_rooms` int NULL DEFAULT 50,
  `max_friends` int NULL DEFAULT 300,
  `shadowban` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '0',
  `mod_bubble` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '1',
  `bank_amount` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `achievement_score`(`achievement_score` ASC) USING BTREE,
  INDEX `guild_id`(`guild_id` ASC) USING BTREE,
  INDEX `can_trade`(`can_trade` ASC) USING BTREE,
  INDEX `online_time`(`online_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `users_currency`  (
  `user_id` int NOT NULL,
  `type` int NOT NULL,
  `amount` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`, `type`) USING BTREE,
  UNIQUE INDEX `userdata`(`user_id`, `type`) USING BTREE,
  INDEX `amount`(`amount`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = FIXED;

CREATE TABLE IF NOT EXISTS `users_badges`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL DEFAULT 0,
  `slot_id` int NOT NULL DEFAULT 0,
  `badge_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `guilds`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL DEFAULT 0,
  `name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `description` varchar(250) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `room_id` int NOT NULL DEFAULT 0,
  `state` int NOT NULL DEFAULT 0,
  `rights` enum('0','1') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0',
  `color_one` int NOT NULL DEFAULT 0,
  `color_two` int NOT NULL DEFAULT 0,
  `badge` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `date_created` int NOT NULL,
  `forum` enum('0','1') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0',
  `read_forum` enum('EVERYONE','MEMBERS','ADMINS') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'EVERYONE',
  `post_messages` enum('EVERYONE','MEMBERS','ADMINS','OWNER') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'EVERYONE',
  `post_threads` enum('EVERYONE','MEMBERS','ADMINS','OWNER') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'EVERYONE',
  `mod_forum` enum('ADMINS','OWNER') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'ADMINS',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE,
  INDEX `data`(`room_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `name`(`name` ASC) USING BTREE,
  INDEX `description`(`description` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `guilds_members`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `guild_id` int NOT NULL DEFAULT 0,
  `user_id` int NOT NULL DEFAULT 0,
  `level_id` int NOT NULL DEFAULT 0,
  `member_since` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `guild_id`(`guild_id` ASC) USING BTREE,
  INDEX `userdata`(`user_id` ASC, `guild_id` ASC) USING BTREE,
  INDEX `level_id`(`level_id` ASC) USING BTREE,
  INDEX `member_since`(`member_since` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `rooms`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL DEFAULT 0,
  `owner_name` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `description` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `model` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'model_a',
  `password` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `state` enum('open','locked','password','invisible') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'open',
  `users` int NOT NULL DEFAULT 0,
  `users_max` int NOT NULL DEFAULT 25,
  `guild_id` int NOT NULL DEFAULT 0,
  `category` int NOT NULL DEFAULT 1,
  `score` int NOT NULL DEFAULT 0,
  `paper_floor` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `paper_wall` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `paper_landscape` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `thickness_wall` int NOT NULL DEFAULT 0,
  `wall_height` int NOT NULL DEFAULT -1,
  `thickness_floor` int NOT NULL DEFAULT 0,
  `moodlight_data` varchar(254) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2,1,1,#000000,255;2,3,1,#000000,255;2,3,1,#000000,255;',
  `tags` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `is_public` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `is_staff_picked` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `allow_other_pets` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `allow_other_pets_eat` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `allow_walkthrough` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `allow_hidewall` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `chat_mode` int NOT NULL DEFAULT 0,
  `chat_weight` int NOT NULL DEFAULT 1,
  `chat_speed` int NOT NULL DEFAULT 1,
  `chat_hearing_distance` int NOT NULL DEFAULT 50,
  `chat_protection` int NOT NULL DEFAULT 2,
  `override_model` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `who_can_mute` int NOT NULL DEFAULT 0,
  `who_can_kick` int NOT NULL DEFAULT 0,
  `who_can_ban` int NOT NULL DEFAULT 0,
  `poll_id` int NOT NULL DEFAULT 0,
  `roller_speed` int NOT NULL DEFAULT 4,
  `promoted` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `trade_mode` int NOT NULL DEFAULT 2,
  `move_diagonally` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `jukebox_active` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `hidewired` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `is_forsale` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `hidepyramid` enum('1','0') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `name`(`name` ASC) USING BTREE,
  INDEX `owner_name`(`owner_name` ASC) USING BTREE,
  INDEX `owner_id`(`owner_id` ASC) USING BTREE,
  INDEX `guild_id`(`guild_id` ASC) USING BTREE,
  INDEX `category`(`category` ASC) USING BTREE,
  INDEX `public_status`(`is_public` ASC, `is_staff_picked` ASC) USING BTREE,
  INDEX `togehter_data`(`name` ASC, `owner_name` ASC, `guild_id` ASC) USING BTREE,
  INDEX `tags`(`tags` ASC) USING BTREE,
  INDEX `state`(`state` ASC) USING BTREE,
  INDEX `description`(`description` ASC) USING BTREE,
  INDEX `users`(`users` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `camera_web`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `room_id` int NOT NULL DEFAULT 0,
  `timestamp` int NOT NULL,
  `url` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `bans`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `ip` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `machine_id` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `user_staff_id` int NOT NULL,
  `timestamp` int NOT NULL,
  `ban_expire` int NOT NULL DEFAULT 0,
  `ban_reason` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `type` enum('account','ip','machine','super') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'account' COMMENT 'Account is the entry in the users table banned.\nIP is any client that connects with that IP.\nMachine is the computer that logged in.\nSuper is all of the above.',
  `cfh_topic` int NOT NULL DEFAULT -1,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_data`(`user_id` ASC, `ip` ASC, `machine_id` ASC, `ban_expire` ASC, `timestamp` ASC, `ban_reason` ASC) USING BTREE,
  INDEX `general`(`id` ASC, `type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `namechange_log`  (
  `user_id` int NOT NULL,
  `old_name` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `new_name` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `timestamp` int NOT NULL
) ENGINE = MyISAM CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `permissions`  (
  `rank_name` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `badge` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `level` int NOT NULL DEFAULT 1,
  `cooldown_rob_user` int NOT NULL DEFAULT 0,
  `room_effect` int NOT NULL DEFAULT 0,
  `log_commands` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `prefix` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `prefix_color` varchar(7) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `cmd_about` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_alert` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_allow_trading` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_badge` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ban` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_blockalert` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_bots` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_bundle` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_calendar` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_changename` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_chatcolor` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_close_room` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_commands` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_connect_camera` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_control` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_coords` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_credits` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_subscription` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '0',
  `cmd_danceall` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_diagonal` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_disconnect` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_discord_auth` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_duckets` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ejectall` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_empty` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_empty_bots` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_empty_pets` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_enable` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_event` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_eha` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_explain_event` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_event_reward` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_faceless` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_fastwalk` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_filterword` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_freeze` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_freeze_bots` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_gift` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_give_rank` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ha` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_can_stalk` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_hal` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_invisible` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ip_ban` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_machine_ban` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_hand_item` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_happyhour` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_hidewired` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_kickall` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_softkick` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_massbadge` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roombadge` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_masscredits` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_massduckets` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_massgift` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_masspoints` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_moonwalk` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_mimic` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_multi` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_mute` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_open_room` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_pet_info` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_pickall` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_plugins` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_points` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_promote_offer` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_pull` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_push` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_redeem` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_reload_room` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_roomalert` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roomcredits` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roomeffect` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roomgift` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roomitem` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roommute` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roompixels` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roompoints` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_say` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_say_all` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_setmax` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_set_poll` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_setpublic` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_setspeed` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_shout` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_shout_all` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_shutdown` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_sitdown` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_staffalert` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_staffonline` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_summon` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_summonrank` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_super_ban` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_stalk` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_superpull` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_take_badge` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_talk` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_teleport` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_trash` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_transform` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_unban` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_unload` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_unmute` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_achievements` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_bots` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_catalogue` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_config` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_guildparts` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_hotel_view` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_items` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_navigator` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_permissions` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_pet_data` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_plugins` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_polls` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_texts` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_wordfilter` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_userinfo` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_word_quiz` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_warp` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_anychatcolor` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_anyroomowner` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_empty_others` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_enable_others` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_see_whispers` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_see_tentchat` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_superwired` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_supporttool` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_unkickable` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_guildgate` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_moverotate` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_placefurni` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_unlimited_bots` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0' COMMENT 'Overrides the bot restriction to the inventory and room.',
  `acc_unlimited_pets` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0' COMMENT 'Overrides the pet restriction to the inventory and room.',
  `acc_hide_ip` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_hide_mail` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_not_mimiced` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_chat_no_flood` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_staff_chat` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_staff_pick` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_enteranyroom` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_fullrooms` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_infinite_credits` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_infinite_pixels` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_infinite_points` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_ambassador` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_debug` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_chat_no_limit` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0' COMMENT 'People with this permission node are always heard and can see all chat in the room regarding of maximum hearing distance in the room settings (In game)',
  `acc_chat_no_filter` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_nomute` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_guild_admin` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_catalog_ids` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_modtool_ticket_q` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_modtool_user_logs` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_modtool_user_alert` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_modtool_user_kick` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_modtool_user_ban` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_modtool_room_info` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_modtool_room_logs` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_trade_anywhere` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_update_notifications` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_helper_use_guide_tool` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_helper_give_guide_tours` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_helper_judge_chat_reviews` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_floorplan_editor` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_camera` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_ads_background` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_wordquiz` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_room_staff_tags` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_infinite_friends` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_mimic_unredeemed` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_youtube_playlists` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_add_youtube_playlist` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `auto_credits_amount` int NULL DEFAULT 0,
  `auto_pixels_amount` int NULL DEFAULT 0,
  `auto_gotw_amount` int NULL DEFAULT 0,
  `auto_points_amount` int NULL DEFAULT 0,
  `acc_mention` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_setstate` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_buildheight` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_setrotation` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_sellroom` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_buyroom` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_pay` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_kill` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_hoverboard` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_kiss` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_hug` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_welcome` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_disable_effects` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_brb` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_nuke` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_slime` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_explain` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_closedice` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `acc_closedice_room` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_set` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_furnidata` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `kiss_cmd` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_collector_park` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_giveaway` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_giveaway_clear_blocks` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_set_giveaway_furnis` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_manager_giveaway` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_set_currency_giveaway` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_rob_user` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_tptome` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_leaderboard` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_afk` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_superpush` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_pickup_own_furnis` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_roompublic` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_commandsc` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_update_categories` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_ignore_vpn_blocker` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_track_discord` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_help` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_update_commands` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_buy` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_calc` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_update_all` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_snow` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_sand` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_warpdoor` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_findfurni` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_furnifix` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_maxfloor` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_autofloor` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `acc_mention_friends` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_mention_room` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_blockmention` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_slapass` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_pyramid` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_rig` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_youtube` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_bet` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_deposit` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_withdraw` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_depositall` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_withdrawall` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_pee` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_shag` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_kiss1` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_suicide` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_finger` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_weed` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_update_looks` enum('1','0') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_prefix` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_prefixcolor` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_namecolor` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_textcolor` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_blockcmd` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_builder` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_cataltd` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roomowner` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_closeroom` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_dj` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_emptyphb` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_flaguser` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_randomuser` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roomrandomuser` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_giveachievement` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_givecredits` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_givepoints` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_goto` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_hit` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_invisiblephb` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_layphb` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_loginstaff` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_openroom` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_rankalert` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_reward` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_rewardpromo` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_rolldice` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_online` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_sit` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_staffson` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_tproom` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_tie` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_catalog_phb` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_userson` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_viewfakes` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_whereisit` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `acc_override_blockcmd` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `respects` int NOT NULL DEFAULT 3,
  `respectspet` int NOT NULL DEFAULT 3,
  `cmd_reward_credits` int NOT NULL DEFAULT 100,
  `cmd_reward_duckets` int NOT NULL DEFAULT 100,
  `cmd_reward_diamonds` int NOT NULL DEFAULT 10,
  `cmd_reward_gotw` int NOT NULL DEFAULT 0,
  `cmd_reward_achievement` int NOT NULL DEFAULT 3,
  `cmd_rewardpromo_achievement` int NOT NULL DEFAULT 3,
  `cmd_eventalert` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roomvideo` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_hotelvideo` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_disablealertevent` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_hotelimage` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_roomimage` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_coloradd` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_edititem` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_addvideo_youtubetv` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_manage_youtubetv` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `acc_mention_everyone` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_mention_staff` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_mention_user` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_youtubemusic` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_roomiframe` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `premiar_moedas` int NOT NULL DEFAULT 100,
  `premiar_duckets` int NOT NULL DEFAULT 100,
  `premiar_diamantes` int NOT NULL DEFAULT 10,
  `premiar_gotw` int NOT NULL DEFAULT 0,
  `premiar_conquistas` int NOT NULL DEFAULT 3,
  `promo_conquistas` int NOT NULL DEFAULT 3,
  `acc_override_sex` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_disablesex` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_fish` enum('2','1','0') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_inventory` enum('2','1','0') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_update_config_collector_park` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_rob_user_credits` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_rob_user_diamonds` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_rob_user_duckets` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_rob_user_gotw` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `auto_duckets_amount` int NULL DEFAULT NULL,
  `cmd_update_ls_rewards` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_ls_name_colors` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_ls_prefixes` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ls_toggle_level` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ls_name_color` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_ls_prefix` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_prison` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_random_word` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_update_random_word` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_shadowban` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_unshadowban` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_see_shadowbans` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_login_streak_rewards` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_config_farming` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_ignore_required_badge_commands` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_required_badges` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_required_activity_points` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_ignore_required_activity_points_commands` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_bubbleall` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_shank` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `bubbleall_cooldown` int NOT NULL DEFAULT 60,
  `cmd_update_bubble_ranks` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_new_push` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_rotate` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_blockfollow` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_blockfriendrequests` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_blocktrade` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_blockmimic` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_facepalm` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ipshadowban` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_ticket_alert` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_privatelogs` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_add_word_filter` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_remove_word_filter` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_word_filter` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_send_ws` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_received_ws` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_new_user_login` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_back` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `acc_execute_through_afk` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ep_start` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ep` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_copyroom` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_takeroom` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_addwhisper` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_delwhisper` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_groupwhisper` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_invite` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_set_homeroom` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_alerts` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_casino_alert` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ambcmd` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_lotto` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_toggle_start_typing` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_stats` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_ice` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_airkiss` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_love` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_like` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_airhug` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_tie1` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `respect_daily` int NOT NULL DEFAULT 0,
  `petrespect_daily` int NOT NULL DEFAULT 0,
  `cmd_habbowil` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `acc_notify_wordfilter` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_habboshoot` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_shit` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_shoot` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_sex` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_takeoff` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_honor` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_cry` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_peitsche` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_noose` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_nezukochan` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `acc_calendar_force` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '0',
  `cmd_update_calendar` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_global_whisper_ha` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_global_whisper_sa` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_blizzard_reload` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_give_prize` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_reload_colors` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_give_color_name` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_blizzard_override_logger` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `acc_mod_alert` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_enable_mod_alert` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_disable_mod_alert` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_testing` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '0',
  `cmd_setcolor` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_setborder` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_setmodifier` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_seticon` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_commands_alpha` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_last_warn_command` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_rule_warn_command` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_discord_link` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_catapage` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_closealldice` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_rollalldice` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_kicking` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_game` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_copystack` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_placestack` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_undostack` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_movestack` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_pickupstack` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2',
  `cmd_points_type1` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_points_type2` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_look` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_savelook` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_looks` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_deletelook` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `wardrobe_max_looks` int NOT NULL DEFAULT 10,
  `cmd_pickup` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_redeemitems` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_transform_user` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_points1` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_in` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_off` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_autofill` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_bank_deposit` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_bank_withdraw` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_bank_balance` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `bank_interest_percentage` int NOT NULL DEFAULT 1,
  `cmd_update_emoji` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_peitsch` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_spit` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_boobs` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_foot` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_farmingitems` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_give_pack` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_packs` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `7` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_naruto` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_pimmel` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_31er` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_snitch` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_schwanz` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_joint` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_huso` enum('0','1','2') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `acc_start_typing_show` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1',
  `cmd_give_role` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_update_vending_cases` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `cmd_hoteliframe` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `premiar_moedas`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `cms_news`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `posted_by` int NOT NULL,
  `category` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `notice` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `cms_news_comments`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `notice_id` int NOT NULL,
  `user_id` int NOT NULL,
  `comment` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `website_alert_messages`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `message` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Unacceptable for the Hotel Management',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_badge_requests`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `badge_imaging` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` enum('open','accept','decline') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'open',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_ban_messages`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `message` varchar(75) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Unacceptable for the Hotel Management',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_ban_types`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `seconds` int NOT NULL DEFAULT 7200,
  `message` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `min_rank` int NOT NULL DEFAULT 6,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE,
  INDEX `min_rank`(`min_rank` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_bans_asn`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `asn` int NOT NULL,
  `host` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `added_by` varchar(75) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `timestamp` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `asn`(`asn` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_extra_ranks`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `rank_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `rank_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_feeds`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `to_user_id` int NOT NULL,
  `message` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `timestamp` int NOT NULL,
  `from_user_id` int NOT NULL,
  `is_hidden` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_feeds_likes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `feed_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_feeds_reactions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `feed_id` int NOT NULL,
  `message` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `timestamp` int NOT NULL DEFAULT 0,
  `user_id` int NOT NULL DEFAULT 0,
  `is_hidden` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_forum_likes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `post_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_helptool_categories`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_helptool_faq`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `slug` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `desc` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `category` int NOT NULL DEFAULT 0,
  `timestamp` int NOT NULL DEFAULT 0,
  `author` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category`(`category` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_helptool_logs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL DEFAULT 0,
  `target` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `value` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT '',
  `timestamp` int NOT NULL DEFAULT 0,
  `type` enum('CHANGE','SEND') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `player_id`(`player_id` ASC) USING BTREE,
  INDEX `target`(`target` ASC) USING BTREE,
  INDEX `type`(`type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_helptool_reactions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NULL DEFAULT NULL,
  `practitioner_id` int NOT NULL,
  `message` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `timestamp` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_helptool_requests`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `message` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `email` varchar(72) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `player_id` int NULL DEFAULT 0,
  `ip_address` varchar(75) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `timestamp` int NOT NULL DEFAULT 0,
  `status` enum('closed','open','in_treatment','wait_reply') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'open',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_jobs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `job` varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `small_description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `full_description` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_jobs_applys`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `job_id` int NULL DEFAULT NULL,
  `user_id` int NULL DEFAULT NULL,
  `firstname` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `message` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `available_monday` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `available_tuesday` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `available_wednesday` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `available_thursday` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `available_friday` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `available_saturday` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `available_sunday` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `status` enum('open','closed') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_membership`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `old_rank` int NULL DEFAULT NULL,
  `expires_at` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_news`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `short_story` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `full_story` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `images` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `author` int NOT NULL DEFAULT 0,
  `header` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `category` int NOT NULL DEFAULT 0,
  `form` enum('none','photo','badge','look','word') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'none',
  `timestamp` int NOT NULL DEFAULT 0,
  `hidden` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE,
  INDEX `slug`(`slug` ASC) USING BTREE,
  INDEX `timestamp`(`timestamp` ASC) USING BTREE,
  INDEX `hidden`(`hidden` ASC) USING BTREE,
  INDEX `category`(`category` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_news_categories`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE,
  INDEX `category`(`category` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_news_reactions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` int NOT NULL DEFAULT 0,
  `news_id` int NULL DEFAULT NULL,
  `player_id` int NULL DEFAULT NULL,
  `message` varchar(250) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `hidden` int NULL DEFAULT 0,
  `timestamp` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_password_reset`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `email` varchar(75) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `ip_address` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0.0.0',
  `token` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `timestamp` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_paypal_offers`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `price` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_permissions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `permission` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'housekeeping_',
  `description` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_permissions_ranks`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `permission_id` int NOT NULL,
  `rank_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `rank_id`(`rank_id` ASC) USING BTREE,
  INDEX `permission_id`(`permission_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_photos_likes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `photo_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_profile_catalogues`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 's',
  `data` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `category` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_profile_catalogues_cats`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 's',
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_profile_homes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `z` int NULL DEFAULT NULL,
  `x` int NULL DEFAULT NULL,
  `y` int NULL DEFAULT NULL,
  `skin` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `data` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_rares`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int NOT NULL DEFAULT 1,
  `name` varchar(108) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `item_id` int NOT NULL DEFAULT 0,
  `image` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cost_credits` int NOT NULL DEFAULT 0,
  `cost_points` int NOT NULL DEFAULT 0,
  `points_type` int NOT NULL DEFAULT 5,
  `last_edited` timestamp NOT NULL DEFAULT current_timestamp,
  `last_editor` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_rares_pages`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_referrals`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `referral_user_id` int NULL DEFAULT NULL,
  `ip_address` varchar(56) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `timestamp` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_settings`  (
  `key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `value` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_settings_currencys`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `currency` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `type` int NULL DEFAULT NULL,
  `amount` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `website_staff_logs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(25) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `value` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `player_id` int NULL DEFAULT NULL,
  `target` int NULL DEFAULT NULL,
  `timestamp` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_user_logs_email`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `old_mail` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `new_mail` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `ip_address` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `timestamp` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `website_paypal_payments`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `offer_id` int NULL DEFAULT NULL,
  `order_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `payer_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'pending',
  `delivered` enum('NO','YES') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'NO',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

SET FOREIGN_KEY_CHECKS=1;

-- Seed-Daten

INSERT IGNORE INTO `website_settings_currencys` VALUES (1, 'Duckets', 0, 500);
INSERT IGNORE INTO `website_settings_currencys` VALUES (2, 'Diamanten', 5, 0);
INSERT IGNORE INTO `website_settings_currencys` VALUES (3, 'Flammen', 103, 0);
INSERT IGNORE INTO `website_news_categories` VALUES (8, 'Eventticker');
INSERT IGNORE INTO `website_news_categories` VALUES (10, 'News');
INSERT IGNORE INTO `website_news_categories` VALUES (7, 'RdW');
INSERT IGNORE INTO `website_news_categories` VALUES (6, 'Update');
INSERT IGNORE INTO `website_news_categories` VALUES (9, 'Wichtig');
INSERT IGNORE INTO `website_helptool_categories` VALUES (1, 'Anmeldedaten');
INSERT IGNORE INTO `website_helptool_categories` VALUES (2, 'Beleidigung');
INSERT IGNORE INTO `website_helptool_categories` VALUES (4, 'Missbrauch');
INSERT IGNORE INTO `website_helptool_categories` VALUES (5, 'Sonstiges');
INSERT IGNORE INTO `website_helptool_categories` VALUES (6, 'Betrug');
INSERT IGNORE INTO `website_helptool_categories` VALUES (7, 'Sicherheit & Hinweise');
INSERT IGNORE INTO `website_helptool_faq` VALUES (1, 'jemand-ist-auffllig', 'Jemand ist Auffällig?', '<p>Hallo lieber Nubba User,</p>\r\n<p>Falls du mitbekommen solltest, dass ein User Multiaccounts erstellt um Vorteile daraus zu ziehen kannst du dass machen:</p>\r\n<p>&nbsp;</p>\r\n<ul>\r\n<li><strong>Melde</strong> den User bei der <strong>Test-Moderation</strong> oder bei den <strong>Moderatoren</strong> die momentan Online sind.</li>\r\n<li>Sollte kein<strong> Test-Moderator</strong> oder <strong>Moderator</strong> zu diesem Zeitpunkt Online sein, kannst du dich auch an die <strong>anderen Staffs</strong> wenden.</li>\r\n<li>Auf unserem <strong>Discord Server</strong> kannst du gerne auch ein <strong>Ticket erstellen</strong> und den Fall ausf&uuml;hrlich schildern.</li>\r\n</ul>\r\n<p>&nbsp;</p>\r\n<p>Falls du merken solltest, dass jemand <strong>Hacks / Cheats</strong> benutzt um sich dadurch Vorteile zu verschaffen oder anderen Usern damit dass Spielen versaut, sollst du auch sofort einen <strong>Staff kontaktieren</strong> und den Sachverhalt genau schildern.</p>\r\n<p>&nbsp;</p>\r\n<p><strong>Beweise</strong> sind immer gerne erw&uuml;nscht, dass hei&szlig;t wenn du ein <strong>Screenshot </strong>davon machen kannst, z&ouml;gere nicht!</p>\r\n<p>&nbsp;</p>\r\n<p>Beste Gr&uuml;&szlig;e,</p>\r\n<p>&nbsp;</p>\r\n<p>Dein Nubba.eu Team! <strong>[Community Management Ninoo]</strong></p>', 4, 1664133084, 375);
INSERT IGNORE INTO `website_helptool_faq` VALUES (3, 'jemand-wird-beleidigend', 'Jemand wird beleidigend?', '<p>Hallo Lieber Nubba User,</p>\r\n<p>&nbsp;</p>\r\n<p>Falls ein anderer User ausfallend oder beleidigend werden sollte, kannst du diese Schritte einleiten:&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<ul>\r\n<li>Ein <strong>Ticket </strong>oder <strong>Report</strong> &uuml;ber den <strong>Client</strong> erstellen.</li>\r\n<li>Dich bei den <strong>Test-Moderatoren</strong>,<strong> Moderatoren</strong> melden</li>\r\n<li>Im <strong>Notfall</strong> kannst du dich auch gerne an <strong>die h&ouml;heren R&auml;nge</strong> melden.</li>\r\n<li>Falls deine Anfrage &uuml;bersehen wird, kannst du auch auf unserem <strong>Discord Server</strong> ein <strong>Ticket</strong> erstellen. Da meldet sich dann sofort einfach der <strong>zust&auml;ndigen Mitarbeiter</strong>.</li>\r\n<li>Im besten Fall, <strong>nicht</strong> auf die Beleidigende Person <strong>eingehen</strong>. Einfach still schweigen und im besten Fall ein <strong>Screenshot erstellen</strong>, damit man die Aktion besser nachvollziehen kann. <strong>Beweise sind Gold wert.</strong></li>\r\n</ul>\r\n<p>&nbsp;</p>\r\n<p>Falls du zu diesem Thema noch weitere Fragen hast, kannst du dich gerne bei dem Infocenter informieren.</p>\r\n<p>&nbsp;</p>\r\n<p>Beste Gr&uuml;&szlig;e,</p>\r\n<p>&nbsp;</p>\r\n<p>Dein Nubba.eu Team! <strong>[Community Management Ninoo]</strong></p>\r\n<p>&nbsp;</p>', 2, 1664133015, 375);
INSERT IGNORE INTO `website_helptool_faq` VALUES (4, 'nubba-eu-kostenfrei', 'Nubba.eu kostenfrei?', '<p>Hallo lieber Nubba.eu User,</p>\r\n<p>&nbsp;</p>\r\n<p>Unser Hotel ist f&uuml;r dich im gesamten kostenfrei! Das hei&szlig;t du kannst M&ouml;bel mit der Ingame W&auml;hrung Taler kaufen und damit deine R&auml;ume bauen, ohne irgendwelche kosten zu generieren.</p>\r\n<p>&nbsp;</p>\r\n<p>M&ouml;chtest du jedoch bestimmt Commands freischalten die ein normaler User nicht benutzen kann, kannst du dir gerne den VIP Status kaufen, damit du mehr Spielerfahrungen sammeln kannst!</p>\r\n<p>&nbsp;</p>\r\n<p>Es werden aber bestimmt auch Giveaways stattfinden, indem man den VIP Status gewinnen kann...&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>Bei weiteren Fragen, melde dich gerne bei den Staffs die Online sind.</p>\r\n<p>&nbsp;</p>\r\n<p>Beste Gr&uuml;&szlig;e,</p>\r\n<p>&nbsp;</p>\r\n<p>Dein Nubba.eu Team! <strong>[Community Management Ninoo]</strong></p>', 1, 1664133343, 375);
INSERT IGNORE INTO `website_helptool_faq` VALUES (5, 'anmeldedaten-vergessen', 'Anmeldedaten vergessen?', '<p>Hallo lieber Nubba.eu User,</p>\r\n<p>&nbsp;</p>\r\n<p>Sollte es der Fall sein, dass du deine Anmeldedaten vergessen solltest, kannst du dies tun:</p>\r\n<p>&nbsp;</p>\r\n<ul>\r\n<li>Falls du dein <strong>Passwort vergessen</strong> hast, kannst du bei dem Login <strong>\'Passwort vergessen?\'</strong> anklicken.&nbsp;</li>\r\n<li>Um dein Passwort zur&uuml;cksetzen zu lassen, musst du deinen Anzeigenamen und deine Email adresse wissen, mit der du dich bei uns im Hotel registriert hast.</li>\r\n</ul>\r\n<p>&nbsp;</p>\r\n<p>Du kannst auf unserm Discord Server auch ein Ticket erstellen und sagen das du dein Passwort vergessen hast. Sobald ein Staff Zeit hat um dein Anliegen zu bearbeiten meldet er sich sofort bei dir. <strong>Du musst jedoch die Email adresse bereit halten.</strong></p>\r\n<p>&nbsp;</p>\r\n<p>*Falls jemand eine nicht <strong>Existierende Email Adresse angeben sollte,</strong> selber Schuld! Wir haften f&uuml;r keine Accounts mit falschen Email Adressen!*</p>\r\n<p>&nbsp;</p>\r\n<p>Beste Gr&uuml;&szlig;e,</p>\r\n<p>&nbsp;</p>\r\n<p>Dein Nubba.eu Team! <strong>[Community Management Ninoo]</strong></p>', 1, 1664133641, 375);
INSERT IGNORE INTO `website_helptool_faq` VALUES (6, 'grndung-des-hotels', 'Gründung des Hotels?', '<p>Hallo lieber Nubba.eu User,</p>\r\n<p>&nbsp;</p>\r\n<p>Unser Hotel wurde am <strong>20. September. 2022</strong> gegr&uuml;ndet.</p>\r\n<p>Wir sind ein neues Hotel und freuen uns &uuml;ber jeden User der bei uns mit seinen Freunden abh&auml;ngt.</p>\r\n<p>Unsere oberste Priorit&auml;t liegt dabei, <strong>den Spielspa&szlig;</strong> f&uuml;r die User immer weiter zu <strong>Upgraden</strong> und neue Dinge einzustellen, damit den Usern <strong>nie</strong> langweilig wird.</p>\r\n<p>&nbsp;</p>\r\n<p>Deine W&uuml;nsche kannst du auch gerne auf unserem Discord Server unter dem Kanal \'W&uuml;nsche\' erw&auml;hnen!</p>\r\n<p>&nbsp;</p>\r\n<p>Dein Nubba.eu Team! <strong>[Community Management Ninoo]</strong></p>', 1, 1664133834, 375);
INSERT IGNORE INTO `website_helptool_faq` VALUES (7, 'unsere-cms-theme-illegal-oder-legal', 'Unsere CMS / Theme Illegal oder Legal?', '<p>Hallo lieber Nubba.eu User,</p>\r\n<p>&nbsp;</p>\r\n<p>Leider muss ich euch entt&auml;uschen und euch sagen, dass dieses CMS / Theme eine geklaute Kopie des Orig....&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p><strong>NEIN!!...</strong></p>\r\n<p>&nbsp;</p>\r\n<p>Nat&uuml;rlich haben wir diese CMS / Theme bei dem Besitzer ( Raizer ) legitim erworben und haben somit dass Nutzungsrecht und das Bearbeitungsrecht der CMS / Theme. Bei jeglichen &Auml;nderungen der CMS / Theme wird Raizer informiert.</p>\r\n<p>&nbsp;</p>\r\n<p>...&nbsp; &nbsp;<em>hust&nbsp; &nbsp;</em> <strong>nicht so wie andere unserer Art...&nbsp; </strong>&nbsp; <em>hust</em>&nbsp;<br /><br /></p>\r\n<p>&nbsp;</p>\r\n<p>Falls ihr noch Fragen habt, meldet euch gerne bei den Staffs die momentan Online sind.</p>\r\n<p>Auf unserem Discord k&ouml;nnt ihr uns auch gerne eure Fragen stellen.</p>\r\n<p>&nbsp;</p>\r\n<p>Beste Gr&uuml;&szlig;e,</p>\r\n<p>&nbsp;</p>\r\n<p>Dein Nubba.eu Team! <strong>[Community Management Ninoo]</strong></p>', 7, 1664994113, 375);
INSERT IGNORE INTO `website_ban_types` VALUES (1, 7200, '2 hours', 4);
INSERT IGNORE INTO `website_ban_types` VALUES (2, 14400, '4 hours', 4);
INSERT IGNORE INTO `website_ban_types` VALUES (3, 28800, '8 hours', 4);
INSERT IGNORE INTO `website_ban_types` VALUES (4, 43200, '12 hours', 4);
INSERT IGNORE INTO `website_ban_types` VALUES (5, 86400, '1 day', 6);
INSERT IGNORE INTO `website_ban_types` VALUES (6, 259200, '3 days', 6);
INSERT IGNORE INTO `website_ban_types` VALUES (7, 604800, '1 week', 6);
INSERT IGNORE INTO `website_ban_types` VALUES (8, 2629743, '1 month', 6);
INSERT IGNORE INTO `website_ban_types` VALUES (9, 7889231, '3 months', 6);
INSERT IGNORE INTO `website_ban_types` VALUES (10, 946707780, 'permanent', 6);
INSERT IGNORE INTO `website_permissions` VALUES (1, 'housekeeping', 'Zugriff aufs Adminpanel');
INSERT IGNORE INTO `website_permissions` VALUES (2, 'housekeeping_remote_control', 'Player is able to nd may adjust other players account information, except the ranks.');
INSERT IGNORE INTO `website_permissions` VALUES (3, 'housekeeping_ban_user', 'Player is able to ban users from the control panel. A rank system is included in this permission.');
INSERT IGNORE INTO `website_permissions` VALUES (4, 'housekeeping_ban_logs', 'Player is able to view which players have been denied access to the hotel');
INSERT IGNORE INTO `website_permissions` VALUES (5, 'housekeeping_staff_logs', 'Player is able to view all loggings that staffs have committed in the cms');
INSERT IGNORE INTO `website_permissions` VALUES (6, 'housekeeping_chat_logs', 'Player is able to read chat logs from other players');
INSERT IGNORE INTO `website_permissions` VALUES (7, 'housekeeping_website', '\r\nPlayer has access to the website category');
INSERT IGNORE INTO `website_permissions` VALUES (8, 'housekeeping_website_news', 'Player is able to manage news items');
INSERT IGNORE INTO `website_permissions` VALUES (9, 'housekeeping_ranks', 'Player is able to change ranks of other players');
INSERT IGNORE INTO `website_permissions` VALUES (10, 'housekeeping_permissions', 'Player can add/remove permissions for other players who have access to housekeeping');
INSERT IGNORE INTO `website_permissions` VALUES (11, 'housekeeping_ip_display', 'Player is able to see IP addresses of other players');
INSERT IGNORE INTO `website_permissions` VALUES (12, 'housekeeping_reset_user', 'Player is able to reset the player (motto, look, relationships)');
INSERT IGNORE INTO `website_permissions` VALUES (13, 'housekeeping_alert_user', 'Player is able to send warn the player');
INSERT IGNORE INTO `website_permissions` VALUES (14, 'housekeeping_room_control', 'Player is able to see rooms but not able to edit the room');
INSERT IGNORE INTO `website_permissions` VALUES (15, 'housekeeping_moderation_tools', 'Player is able to use the moderation tools on the website');
INSERT IGNORE INTO `website_permissions` VALUES (16, 'housekeeping_website_helptool', 'Player is able to handle the helptool');
INSERT IGNORE INTO `website_permissions` VALUES (17, 'housekeeping_change_email', 'Player is able to change mail adresses');
INSERT IGNORE INTO `website_permissions` VALUES (18, 'housekeeping_website_feeds', 'Player is able to remove feeds from the website');
INSERT IGNORE INTO `website_permissions` VALUES (19, 'housekeeping_vpn_control', 'Player is able to ban of unban AS numbers');
INSERT IGNORE INTO `website_permissions` VALUES (20, 'housekeeping_wordfilter_control', 'Player is able to manage the word filter');
INSERT IGNORE INTO `website_permissions` VALUES (21, 'housekeeping_website_rarevalue', 'Player is able to change rare values');
INSERT IGNORE INTO `website_permissions` VALUES (22, 'housekeeping_website_faq', 'Player is able to manage the FAQ');
INSERT IGNORE INTO `website_permissions` VALUES (23, 'housekeeping_shop_control', 'Player is able to handle and see purchase logs');
INSERT IGNORE INTO `website_permissions` VALUES (24, 'housekeeping_ranks_extra', 'Player is able to edit the extra rank');
INSERT IGNORE INTO `website_permissions` VALUES (25, 'housekeeping_staff_logs_menu', 'Player is able to see logs in menu');
INSERT IGNORE INTO `website_permissions` VALUES (26, 'housekeeping_config', 'Player can manage all the config settings');
INSERT IGNORE INTO `website_permissions` VALUES (27, 'website_invisible_staff', 'Hide rank from staff page at website');
INSERT IGNORE INTO `website_permissions` VALUES (28, 'website_extra_rank', '');
INSERT IGNORE INTO `website_permissions` VALUES (29, 'housekeeping_website_badgerequest', 'Player is able to accept new badge requests');
INSERT IGNORE INTO `website_permissions` VALUES (30, 'housekeeping_server_catalog', 'Player is able to manage catalog');
INSERT IGNORE INTO `website_permissions` VALUES (31, 'housekeeping_rarevalue_control', 'Player is able to manage rare value control');
INSERT IGNORE INTO `website_permissions` VALUES (32, 'maintenance_login', 'Player is able to manage rare value control');
INSERT IGNORE INTO `website_permissions_ranks` VALUES (1, 1, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (2, 2, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (3, 3, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (4, 4, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (5, 5, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (6, 6, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (7, 7, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (8, 8, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (9, 9, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (11, 11, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (12, 12, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (13, 13, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (14, 14, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (15, 15, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (16, 16, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (17, 17, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (18, 18, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (19, 19, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (20, 20, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (22, 22, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (24, 24, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (25, 25, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (27, 27, 1);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (32, 32, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (33, 27, 2);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (35, 32, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (36, 28, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (37, 1, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (38, 29, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (39, 25, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (40, 24, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (41, 13, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (42, 6, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (43, 9, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (44, 12, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (45, 4, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (46, 5, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (47, 17, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (48, 3, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (49, 7, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (50, 8, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (51, 16, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (52, 14, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (53, 18, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (55, 15, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (56, 10, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (57, 2, 6);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (58, 28, 7);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (60, 23, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (61, 28, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (62, 32, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (64, 22, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (65, 21, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (66, 20, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (68, 18, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (71, 15, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (72, 14, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (73, 17, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (74, 13, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (78, 8, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (79, 9, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (80, 7, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (81, 5, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (82, 6, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (83, 4, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (85, 3, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (86, 2, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (88, 16, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (89, 1, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (90, 31, 8);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (91, 28, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (92, 26, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (93, 24, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (94, 25, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (95, 32, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (96, 31, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (97, 29, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (98, 22, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (99, 30, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (100, 23, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (101, 21, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (102, 19, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (103, 20, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (104, 18, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (105, 17, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (106, 32, 5);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (107, 32, 4);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (108, 16, 5);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (109, 7, 5);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (110, 8, 5);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (111, 1, 5);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (112, 6, 5);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (113, 1, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (114, 16, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (116, 2, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (117, 10, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (118, 15, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (119, 14, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (120, 13, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (121, 8, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (122, 9, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (123, 6, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (124, 3, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (125, 12, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (126, 11, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (127, 4, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (128, 5, 9);
INSERT IGNORE INTO `website_permissions_ranks` VALUES (129, 7, 9);
INSERT IGNORE INTO `website_rares_pages` VALUES (1626, 'Golden Dragon', 'Golden Dragonlamp', 'https://nitro.habbo.vin/gamedata/swfs/dcr/hof_furni/icons/rare_dragonlamp_6_icon.png');
INSERT IGNORE INTO `permissions` VALUES ('User', 1, '0', 1, 30, 0, '0', ' ', ' ', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1', '1', '1', '0', '2', '0', '0', '0', '1', '0', '1', '0', '2', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '2', '2', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '2', '1', '1', '0', '0', '0', '0', '0', '2', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', 500, 0, 0, 0, '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '2', '1', '1', '1', '1', '1', '2', '1', '0', '0', '1', '1', '0', '0', '0', '0', '1', '0', '1', '1', '0', '1', '0', '1', '0', '0', '1', '1', '0', '1', '1', '0', '1', '1', '2', '1', '0', '2', '2', '0', '0', '0', '1', '2', '0', '2', '1', '2', '2', '2', '2', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '0', '2', '0', '0', '2', '0', '1', '0', '0', '2', '0', '0', '0', '1', '1', '0', '1', '0', '2', '0', '0', '0', '1', '1', '1', '0', '2', '0', '0', '1', '0', '1', '0', 6, 6, 100, 100, 10, 0, 3, 3, '0', '1', '0', '1', '0', '1', '1', '0', '1', '1', '0', '0', '1', '2', '2', 100, 100, 10, 0, 3, 3, '0', '2', '1', '1', '0', '1', '0', '0', '0', NULL, '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', 60, '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '1', 0, 0, '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '2', '1', '2', '1', '2', '2', '2', '2', '2', '0', '0', '1', '1', '1', '1', 10, '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', 1, '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0');
INSERT IGNORE INTO `permissions` VALUES ('VIP', 2, 'VIP', 2, 15, 0, '0', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '1', '1', '1', '1', '0', '1', '0', '0', '2', '1', '0', '1', '0', '1', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '1', '0', '2', '2', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '2', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '1', '0', '2', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '1', '1', '0', '0', 500, 0, 0, 0, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '0', '0', '0', '1', '1', '0', '0', '0', '0', '1', '0', '1', '1', '1', '1', '0', '1', '0', '0', '1', '1', '0', '1', '1', '0', '1', '1', '2', '1', '0', '2', '0', '1', '1', '1', '1', '2', '0', '2', '1', '2', '2', '2', '2', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '0', '2', '0', '0', '2', '0', '1', '0', '0', '2', '0', '0', '0', '1', '1', '0', '1', '0', '2', '0', '0', '0', '1', '1', '1', '0', '2', '0', '0', '1', '0', '1', '0', 10, 10, 100, 100, 10, 0, 3, 3, '0', '1', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0', '2', 0, 0, 0, 0, 3, 3, '0', '2', '1', '1', '0', '1', '1', '1', '1', NULL, '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', 7200, '0', '1', '0', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0', '1', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0', '1', '1', '1', '1', '1', '1', 10, 10, '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '2', '1', '2', '1', '2', '2', '2', '2', '2', '0', '0', '1', '1', '1', '1', 10, '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', 1, '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0');
INSERT IGNORE INTO `permissions` VALUES ('Game\'X', 3, '', 3, 10, 0, '0', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '1', '1', '1', '1', '0', '1', '0', '0', '1', '1', '0', '1', '0', '1', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '1', '0', '2', '2', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '2', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '1', '0', '2', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '1', '1', '0', '0', 750, 0, 0, 0, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '0', '0', '1', '1', '0', '0', '0', '0', '1', '0', '1', '1', '1', '1', '0', '1', '0', '0', '1', '1', '0', '1', '1', '0', '1', '1', '2', '1', '0', '2', '0', '1', '1', '1', '1', '2', '0', '2', '1', '2', '2', '2', '2', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '0', '2', '0', '0', '2', '0', '1', '0', '0', '2', '0', '0', '0', '1', '1', '0', '1', '0', '2', '0', '0', '0', '1', '1', '1', '0', '2', '0', '0', '1', '0', '1', '0', 12, 12, 100, 100, 10, 0, 3, 3, '1', '1', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0', '2', 0, 0, 0, 0, 3, 3, '0', '2', '1', '1', '0', '1', '1', '1', '1', NULL, '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', 3600, '0', '1', '0', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '1', '0', '0', '1', '1', '1', '1', '1', '0', '0', '0', '1', '1', '0', '1', '1', '1', '1', '1', '1', 12, 12, '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '2', '1', '2', '1', '2', '2', '2', '2', '2', '0', '0', '1', '1', '1', '1', 10, '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', 1, '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0');
INSERT IGNORE INTO `permissions` VALUES ('Botschafter', 4, 'AMB', 4, 10, 178, '0', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1', '1', '1', '1', '1', '0', '1', '0', '0', '1', '1', '0', '1', '0', '1', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0', '1', '1', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '2', '2', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '1', '1', '0', '1', '0', '0', '0', '1', '1', '0', '2', '1', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '1', '1', '0', '1', '1', '0', '0', '0', '0', '0', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0', '1', '1', '0', '0', 750, 0, 0, 0, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '1', '1', '1', '1', '0', '1', '0', '0', '1', '1', '0', '1', '1', '0', '1', '1', '2', '1', '0', '2', '0', '1', '1', '1', '1', '2', '0', '2', '1', '2', '2', '2', '2', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '0', '2', '0', '0', '2', '0', '1', '0', '0', '2', '0', '0', '0', '1', '1', '0', '1', '0', '2', '0', '0', '0', '1', '1', '1', '0', '2', '0', '0', '1', '0', '1', '0', 12, 12, 100, 100, 10, 0, 3, 3, '0', '1', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0', '2', 0, 0, 0, 0, 3, 3, '0', '2', '1', '1', '0', '1', '1', '1', '1', NULL, '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', 0, '0', '1', '0', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '1', '0', '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', 12, 2, '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '2', '1', '2', '1', '2', '2', '2', '2', '2', '0', '0', '1', '1', '1', '1', 10, '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', 1, '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0');
INSERT IGNORE INTO `permissions` VALUES ('Moderator', 5, 'MOD', 5, 10, 178, '0', 'TEST', '0', '1', '1', '1', '0', '0', '0', '1', '0', '0', '1', '1', '1', '1', '1', '0', '1', '0', '0', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '2', '2', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '2', '1', '0', '0', '0', '1', '1', '0', '2', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1', '1', '1', '1', '0', '1', '1', '1', '0', '0', '0', '0', '1', '1', '1', '0', '0', '1', '1', '0', '0', 752, 300, 0, 0, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '2', '1', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '1', '1', '1', '1', '0', '1', '0', '0', '1', '1', '0', '1', '1', '0', '1', '1', '2', '1', '0', '2', '2', '1', '1', '1', '1', '2', '0', '2', '1', '2', '2', '2', '2', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '0', '2', '0', '0', '2', '0', '1', '0', '0', '2', '0', '0', '0', '1', '1', '0', '1', '1', '2', '0', '0', '0', '1', '1', '1', '0', '2', '0', '0', '1', '0', '1', '0', 15, 15, 100, 100, 10, 0, 3, 3, '1', '1', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0', '2', 0, 0, 10, 0, 3, 3, '0', '2', '1', '1', '0', '1', '1', '1', '1', NULL, '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', 60, '0', '1', '0', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', 15, 15, '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '2', '1', '2', '1', '2', '2', '2', '2', '2', '0', '0', '1', '1', '1', '1', 10, '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', 1, '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0');
INSERT IGNORE INTO `permissions` VALUES ('Eventmanagement', 6, 'MOD', 6, 10, 102, '0', 'MOD', '', '1', '1', '1', '0', '1', '0', '1', '0', '0', '1', '1', '1', '1', '1', '0', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '0', '2', '2', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '1', '1', '0', '1', '0', '0', '0', '1', '1', '0', '2', '1', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1', '0', '1', '0', '1', '1', '1', '0', '0', '1', '0', '1', '0', '1', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '1', '0', '1', '1', '0', '0', '1', '1', '0', '1', '1', '0', '0', '0', '0', '0', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '1', '0', '0', '1', '1', '0', '0', 750, 300, 0, 0, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '2', '1', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '1', '1', '1', '1', '0', '1', '0', '0', '1', '1', '0', '1', '1', '0', '1', '1', '2', '1', '0', '2', '0', '1', '1', '1', '1', '2', '0', '2', '1', '2', '2', '2', '2', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '0', '2', '0', '0', '2', '0', '1', '0', '0', '2', '0', '0', '0', '1', '1', '0', '1', '1', '2', '1', '0', '0', '1', '1', '1', '0', '2', '0', '0', '1', '0', '1', '0', 20, 20, 100, 100, 10, 0, 3, 3, '1', '1', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0', '2', 0, 0, 0, 0, 3, 3, '0', '2', '1', '1', '0', '1', '1', '1', '1', NULL, '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', 0, '1', '1', '0', '1', '1', '1', '1', '1', '0', '1', '1', '0', '0', '0', '1', '1', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', 20, 20, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '2', '1', '2', '1', '2', '2', '2', '2', '2', '0', '0', '1', '1', '1', '1', 10, '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', 1, '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0');
INSERT IGNORE INTO `permissions` VALUES ('Communitymanagement', 7, 'ADM', 7, 0, 102, '0', '', '', '1', '1', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '2', '1', '0', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '0', '0', '0', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '2', '2', '0', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '2', '1', '0', '1', '0', '1', '1', '0', '2', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '0', '1', '1', '1', '1', '0', '0', '1', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '0', '0', '0', '0', '1', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', 750, 300, 0, 0, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '2', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '2', '0', '1', '1', '1', '1', '2', '1', '2', '1', '2', '2', '2', '2', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '2', '0', '0', '2', '0', '1', '0', '0', '2', '0', '0', '0', '1', '1', '0', '1', '1', '2', '1', '0', '0', '1', '1', '1', '0', '2', '0', '0', '1', '0', '1', '0', 25, 25, 100, 100, 10, 0, 3, 3, '1', '1', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0', '2', 0, 0, 0, 0, 3, 3, '0', '2', '1', '1', '0', '1', '1', '1', '1', NULL, '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '1', '1', 0, '1', '1', '0', '1', '1', '1', '1', '1', '0', '1', '1', '0', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '1', '0', '1', '0', '1', '1', '1', '1', '1', '1', 25, 25, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '2', '1', '2', '1', '2', '2', '2', '2', '2', '0', '0', '1', '1', '1', '1', 10, '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', 1, '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0');
INSERT IGNORE INTO `permissions` VALUES ('Hotelmanagement', 8, 'ADM', 8, 0, 102, '0', '', '', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '2', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', 750, 300, 0, 0, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '2', '1', '1', '1', '1', '1', '2', '1', '2', '1', '2', '2', '2', '2', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '2', '1', '0', '2', '1', '1', '0', '1', '2', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '0', '0', '2', '1', '1', '1', '2', '1', '1', '1', '1', '1', '1', 400, 50, 100, 100, 10, 0, 3, 3, '1', '1', '0', '1', '0', '1', '1', '0', '0', '0', '1', '1', '1', '1', '2', 0, 0, 0, 0, 3, 3, '0', '2', '1', '1', '0', '1', '1', '1', '1', NULL, '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '1', '1', 0, '1', '1', '0', '1', '1', '1', '1', '1', '0', '1', '1', '0', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', 400, 50, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '1', '1', '0', '0', '1', '0', '2', '2', '2', '1', '2', '2', '2', '2', '2', '0', '0', '1', '1', '1', '1', 10, '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', 1, '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '1');
INSERT IGNORE INTO `permissions` VALUES ('Gründer', 9, 'ADM', 9, 0, 102, '0', '', '', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '2', '1', '0', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '0', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '2', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '2', '1', '1', '1', '0', '1', '1', '1', '2', '1', '0', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '0', '1', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '1', 750, 300, 0, 0, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '1', '1', '1', '2', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '1', '1', '2', '0', '1', '1', '1', '1', '2', '1', '2', '1', '2', '2', '2', '2', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '2', '0', '0', '2', '1', '1', '0', '1', '2', '1', '0', '0', '1', '1', '0', '1', '0', '2', '1', '0', '0', '1', '1', '1', '0', '2', '0', '0', '1', '0', '1', '0', 100, 100, 100, 100, 10, 0, 3, 3, '1', '1', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0', '2', 0, 0, 0, 0, 3, 3, '1', '2', '1', '1', '0', '1', '1', '1', '1', NULL, '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '1', '1', '0', '1', '0', '0', '0', '0', '1', '1', 0, '1', '1', '0', '1', '1', '1', '1', '1', '0', '1', '1', '0', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', 40, 40, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '1', '0', '1', '1', '0', '1', '1', '1', '1', '1', '1', '0', '0', '1', '0', '2', '1', '2', '1', '2', '2', '2', '2', '2', '0', '0', '1', '1', '1', '1', 10, '0', '1', '0', '0', '1', '1', '1', '1', '1', '1', 1, '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '1');
INSERT IGNORE INTO `permissions` VALUES ('User HC', 10, '0', 1, 30, 0, '0', ' ', ' ', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1', '1', '1', '0', '2', '0', '0', '0', '1', '0', '1', '0', '2', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '2', '2', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '2', '1', '1', '0', '0', '0', '0', '0', '2', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', 500, 250, 0, 0, '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '2', '1', '1', '1', '1', '1', '2', '1', '0', '0', '1', '1', '0', '0', '0', '0', '1', '0', '1', '1', '0', '1', '0', '1', '0', '0', '1', '1', '0', '1', '1', '0', '1', '1', '2', '1', '0', '2', '2', '0', '0', '0', '1', '2', '0', '2', '1', '2', '2', '2', '2', '1', '1', '1', '1', '1', '1', '0', '1', '1', '1', '1', '0', '2', '0', '0', '2', '0', '1', '0', '0', '2', '0', '0', '0', '1', '1', '0', '1', '0', '2', '0', '0', '0', '1', '1', '1', '0', '2', '0', '0', '1', '0', '1', '0', 6, 6, 100, 100, 10, 0, 3, 3, '0', '1', '0', '1', '0', '1', '1', '0', '1', '1', '0', '0', '1', '2', '2', 100, 100, 10, 0, 3, 3, '0', '2', '1', '1', '0', '1', '0', '0', '0', NULL, '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', 60, '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '1', 0, 0, '1', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '2', '1', '2', '1', '2', '2', '2', '2', '2', '0', '0', '1', '1', '1', '1', 10, '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', 1, '0', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0');
INSERT IGNORE INTO `website_extra_ranks` VALUES (10, 'Pixler', 'Pixler erstellen neue Möbelstücke, Rares oder Kleidungen fürs Hotel');
INSERT IGNORE INTO `website_extra_ranks` VALUES (11, 'GameX', 'GameX erstellen neue Events fürs Hotel um dien Hype im Hotel aufrecht zu erhalten');
INSERT IGNORE INTO `website_extra_ranks` VALUES (12, 'DJ', 'DeeJays kümmern sich um die Musik im Hotel und halten die Stimmung aufrecht.');