-- ============================================================
--  BLOODADMIN — DATABASE SCHEMA
-- ============================================================

CREATE TABLE IF NOT EXISTS `bl_bans` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(100) DEFAULT '',
    `license` VARCHAR(100) DEFAULT '',
    `ip` VARCHAR(50) DEFAULT '',
    `name` VARCHAR(100) DEFAULT 'Inconnu',
    `reason` TEXT,
    `admin` VARCHAR(100) DEFAULT 'Système',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `expires_at` INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `bl_warns` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(100) NOT NULL,
    `player_name` VARCHAR(100) DEFAULT 'Inconnu',
    `reason` VARCHAR(255) NOT NULL,
    `admin` VARCHAR(100) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `bl_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `category` VARCHAR(50) NOT NULL,
    `action` VARCHAR(100) NOT NULL,
    `admin_name` VARCHAR(100) NOT NULL,
    `admin_id` VARCHAR(100) NOT NULL,
    `target_name` VARCHAR(100) DEFAULT NULL,
    `target_id` VARCHAR(100) DEFAULT NULL,
    `details` TEXT DEFAULT NULL,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `bl_grades` (
    `name` VARCHAR(50) NOT NULL,
    `level` INT NOT NULL DEFAULT 0,
    `color` VARCHAR(20) NOT NULL DEFAULT '#3b82f6',
    `icon` VARCHAR(50) DEFAULT NULL,
    `permissions` LONGTEXT NOT NULL,
    PRIMARY KEY (`name`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `bl_staff` (
    `identifier` VARCHAR(100) PRIMARY KEY,
    `grade` VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS `bl_staff_chat` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `sender_name` VARCHAR(100) NOT NULL,
    `grade` VARCHAR(50) NOT NULL,
    `message` TEXT NOT NULL,
    `timestamp` INT NOT NULL,
    `reply_to` TEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `bl_reports` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `reporter_license` VARCHAR(100) NOT NULL,
    `reporter_name` VARCHAR(100) NOT NULL,
    `reason` TEXT NOT NULL,
    `status` VARCHAR(20) DEFAULT 'open',
    `admin_name` VARCHAR(100) DEFAULT NULL,
    `closed_by` VARCHAR(100) DEFAULT NULL,
    `coords` TEXT DEFAULT NULL,
    `created_at` BIGINT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `bl_jails` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(100) NOT NULL,
    `name` VARCHAR(100) DEFAULT 'Inconnu',
    `admin` VARCHAR(100) NOT NULL,
    `expires_at` INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `bl_ghosts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(100) NOT NULL,
    `name` VARCHAR(100) DEFAULT 'Inconnu',
    `admin` VARCHAR(100) NOT NULL,
    `created_at` INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `bl_players_seen` (
    `identifier` VARCHAR(100) PRIMARY KEY,
    `first_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
