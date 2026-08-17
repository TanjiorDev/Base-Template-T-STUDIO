-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : lun. 17 août 2026 à 20:38
-- Version du serveur : 10.11.18-MariaDB-0+deb12u1
-- Version de PHP : 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `s26_basetemplatev1`
--

-- --------------------------------------------------------

--
-- Structure de la table `addon_account`
--

CREATE TABLE `addon_account` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `addon_account`
--

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('bank_savings', 'Savings account', 0),
('caution', 'caution', 0),
('society_ambulance', 'EMS', 1),
('society_banker', 'Bank', 1),
('society_cardealer', 'Cardealer', 1),
('society_mechanic', 'Mechanic', 1),
('society_police', 'Police', 1),
('society_taxi', 'Taxi', 1);

-- --------------------------------------------------------

--
-- Structure de la table `addon_account_data`
--

CREATE TABLE `addon_account_data` (
  `id` int(11) NOT NULL,
  `account_name` varchar(100) DEFAULT NULL,
  `money` int(11) NOT NULL,
  `owner` varchar(46) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `addon_account_data`
--

INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
(1, 'society_cardealer', 0, NULL),
(2, 'society_police', 0, NULL),
(3, 'society_ambulance', 0, NULL),
(4, 'society_mechanic', 0, NULL),
(5, 'society_taxi', 0, NULL),
(9, 'society_banker', 0, NULL),
(10, 'bank_savings', 0, NULL),
(11, 'caution', 0, NULL),
(12, 'bank_savings', 0, NULL),
(13, 'caution', 0, NULL),
(14, 'bank_savings', 0, NULL),
(15, 'caution', 0, NULL),
(16, 'bank_savings', 0, 'char1:f6cb50aa7cd50fa658599060fe71faef79b4ff6d'),
(17, 'caution', 0, 'char1:f6cb50aa7cd50fa658599060fe71faef79b4ff6d');

-- --------------------------------------------------------

--
-- Structure de la table `addon_inventory`
--

CREATE TABLE `addon_inventory` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `addon_inventory`
--

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_ambulance', 'EMS', 1),
('society_cardealer', 'Cardealer', 1),
('society_mechanic', 'Mechanic', 1),
('society_police', 'Police', 1),
('society_taxi', 'Taxi', 1);

-- --------------------------------------------------------

--
-- Structure de la table `addon_inventory_items`
--

CREATE TABLE `addon_inventory_items` (
  `id` int(11) NOT NULL,
  `inventory_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `count` int(11) NOT NULL,
  `owner` varchar(46) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `banking`
--

CREATE TABLE `banking` (
  `identifier` varchar(46) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `amount` int(64) DEFAULT NULL,
  `time` bigint(20) DEFAULT NULL,
  `ID` int(11) NOT NULL,
  `balance` int(11) DEFAULT 0,
  `label` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `billing`
--

CREATE TABLE `billing` (
  `id` int(11) NOT NULL,
  `identifier` varchar(46) DEFAULT NULL,
  `sender` varchar(60) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target` varchar(40) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `cardealer_vehicles`
--

CREATE TABLE `cardealer_vehicles` (
  `id` int(11) NOT NULL,
  `vehicle` varchar(255) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `darkchat_bans`
--

CREATE TABLE `darkchat_bans` (
  `room_id` varchar(40) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `banned_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `darkchat_members`
--

CREATE TABLE `darkchat_members` (
  `room_id` varchar(40) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `joined_at` bigint(20) NOT NULL,
  `notifications` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `darkchat_messages`
--

CREATE TABLE `darkchat_messages` (
  `id` int(11) NOT NULL,
  `room_id` varchar(40) NOT NULL,
  `citizenid` varchar(60) DEFAULT NULL,
  `author` varchar(40) NOT NULL,
  `body` text NOT NULL,
  `created_at` bigint(20) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `meta` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `darkchat_nicknames`
--

CREATE TABLE `darkchat_nicknames` (
  `citizenid` varchar(60) NOT NULL,
  `nickname` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `darkchat_reactions`
--

CREATE TABLE `darkchat_reactions` (
  `message_id` int(11) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `emoji` varchar(32) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `darkchat_rooms`
--

CREATE TABLE `darkchat_rooms` (
  `id` varchar(40) NOT NULL,
  `code` varchar(16) NOT NULL,
  `name` varchar(60) NOT NULL,
  `owner` varchar(46) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `code_changed_at` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `datastore`
--

CREATE TABLE `datastore` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `datastore`
--

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
('property', 'Property', 0),
('society_ambulance', 'EMS', 1),
('society_mechanic', 'Mechanic', 1),
('society_police', 'Police', 1),
('society_taxi', 'Taxi', 1),
('user_ears', 'Ears', 0),
('user_glasses', 'Glasses', 0),
('user_helmet', 'Helmet', 0),
('user_mask', 'Mask', 0);

-- --------------------------------------------------------

--
-- Structure de la table `datastore_data`
--

CREATE TABLE `datastore_data` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `owner` varchar(46) DEFAULT NULL,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `datastore_data`
--

INSERT INTO `datastore_data` (`id`, `name`, `owner`, `data`) VALUES
(1, 'society_police', NULL, '{}'),
(2, 'society_ambulance', NULL, '{}'),
(3, 'society_mechanic', NULL, '{}'),
(4, 'society_taxi', NULL, '{}'),
(5, 'property', NULL, '{}'),
(6, 'property', NULL, '{}'),
(7, 'property', NULL, '{}'),
(8, 'property', NULL, '{}'),
(9, 'property', NULL, '{}'),
(10, 'property', NULL, '{}'),
(11, 'property', NULL, '{}'),
(12, 'property', NULL, '{}'),
(13, 'property', NULL, '{}'),
(14, 'property', NULL, '{}'),
(15, 'property', NULL, '{}'),
(16, 'property', NULL, '{}'),
(17, 'property', NULL, '{}'),
(18, 'property', NULL, '{}'),
(19, 'property', NULL, '{}'),
(20, 'property', NULL, '{}'),
(21, 'property', NULL, '{}'),
(22, 'property', NULL, '{}'),
(23, 'property', NULL, '{}'),
(24, 'property', NULL, '{}'),
(25, 'property', NULL, '{}'),
(26, 'property', NULL, '{}'),
(27, 'property', NULL, '{}'),
(28, 'property', NULL, '{}'),
(29, 'property', NULL, '{}'),
(30, 'property', NULL, '{}'),
(31, 'property', NULL, '{}'),
(32, 'property', NULL, '{}'),
(33, 'property', NULL, '{}'),
(34, 'property', NULL, '{}'),
(35, 'property', NULL, '{}'),
(36, 'property', NULL, '{}'),
(37, 'property', NULL, '{}'),
(38, 'property', NULL, '{}'),
(39, 'property', 'char1:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(40, 'user_ears', 'char1:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(41, 'user_glasses', 'char1:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(42, 'user_helmet', 'char1:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(43, 'user_mask', 'char1:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(44, 'property', NULL, '{}'),
(45, 'property', NULL, '{}'),
(46, 'property', NULL, '{}'),
(47, 'property', NULL, '{}'),
(48, 'property', NULL, '{}'),
(49, 'property', NULL, '{}'),
(50, 'property', NULL, '{}'),
(51, 'property', NULL, '{}'),
(52, 'property', NULL, '{}'),
(53, 'property', NULL, '{}'),
(54, 'property', NULL, '{}'),
(55, 'property', NULL, '{}'),
(56, 'property', NULL, '{}'),
(57, 'property', NULL, '{}'),
(58, 'property', NULL, '{}'),
(59, 'property', NULL, '{}'),
(60, 'property', NULL, '{}'),
(61, 'property', NULL, '{}'),
(62, 'property', NULL, '{}'),
(63, 'property', NULL, '{}'),
(64, 'property', NULL, '{}'),
(65, 'property', NULL, '{}'),
(66, 'property', NULL, '{}'),
(67, 'property', NULL, '{}'),
(68, 'property', NULL, '{}'),
(69, 'property', NULL, '{}'),
(70, 'property', NULL, '{}'),
(71, 'property', NULL, '{}'),
(72, 'property', NULL, '{}'),
(73, 'property', NULL, '{}'),
(74, 'property', NULL, '{}'),
(75, 'property', NULL, '{}'),
(76, 'property', NULL, '{}'),
(77, 'property', NULL, '{}'),
(78, 'property', NULL, '{}'),
(79, 'property', NULL, '{}'),
(80, 'property', NULL, '{}'),
(81, 'property', NULL, '{}'),
(82, 'property', NULL, '{}'),
(83, 'property', NULL, '{}'),
(84, 'property', 'char2:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(85, 'user_ears', 'char2:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(86, 'user_glasses', 'char2:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(87, 'user_helmet', 'char2:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(88, 'user_mask', 'char2:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(89, 'property', NULL, '{}'),
(90, 'property', NULL, '{}'),
(91, 'property', 'char3:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(92, 'user_ears', 'char3:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(93, 'user_glasses', 'char3:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(94, 'user_helmet', 'char3:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(95, 'user_mask', 'char3:8db633367c6da1920cc7b5703b3732abfb2f794b', '{}'),
(96, 'property', 'char1:f6cb50aa7cd50fa658599060fe71faef79b4ff6d', '{}'),
(97, 'user_ears', 'char1:f6cb50aa7cd50fa658599060fe71faef79b4ff6d', '{}'),
(98, 'user_glasses', 'char1:f6cb50aa7cd50fa658599060fe71faef79b4ff6d', '{}'),
(99, 'user_helmet', 'char1:f6cb50aa7cd50fa658599060fe71faef79b4ff6d', '{}'),
(100, 'user_mask', 'char1:f6cb50aa7cd50fa658599060fe71faef79b4ff6d', '{}');

-- --------------------------------------------------------

--
-- Structure de la table `fine_types`
--

CREATE TABLE `fine_types` (
  `id` int(11) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `fine_types`
--

INSERT INTO `fine_types` (`id`, `label`, `amount`, `category`) VALUES
(1, 'Misuse of a horn', 30, 0),
(2, 'Illegally Crossing a continuous Line', 40, 0),
(3, 'Driving on the wrong side of the road', 250, 0),
(4, 'Illegal U-Turn', 250, 0),
(5, 'Illegally Driving Off-road', 170, 0),
(6, 'Refusing a Lawful Command', 30, 0),
(7, 'Illegally Stopping a Vehicle', 150, 0),
(8, 'Illegal Parking', 70, 0),
(9, 'Failing to Yield to the right', 70, 0),
(10, 'Failure to comply with Vehicle Information', 90, 0),
(11, 'Failing to stop at a Stop Sign ', 105, 0),
(12, 'Failing to stop at a Red Light', 130, 0),
(13, 'Illegal Passing', 100, 0),
(14, 'Driving an illegal Vehicle', 100, 0),
(15, 'Driving without a License', 1500, 0),
(16, 'Hit and Run', 800, 0),
(17, 'Exceeding Speeds Over < 5 mph', 90, 0),
(18, 'Exceeding Speeds Over 5-15 mph', 120, 0),
(19, 'Exceeding Speeds Over 15-30 mph', 180, 0),
(20, 'Exceeding Speeds Over > 30 mph', 300, 0),
(21, 'Impeding traffic flow', 110, 1),
(22, 'Public Intoxication', 90, 1),
(23, 'Disorderly conduct', 90, 1),
(24, 'Obstruction of Justice', 130, 1),
(25, 'Insults towards Civilans', 75, 1),
(26, 'Disrespecting of an LEO', 110, 1),
(27, 'Verbal Threat towards a Civilan', 90, 1),
(28, 'Verbal Threat towards an LEO', 150, 1),
(29, 'Providing False Information', 250, 1),
(30, 'Attempt of Corruption', 1500, 1),
(31, 'Brandishing a weapon in city Limits', 120, 2),
(32, 'Brandishing a Lethal Weapon in city Limits', 300, 2),
(33, 'No Firearms License', 600, 2),
(34, 'Possession of an Illegal Weapon', 700, 2),
(35, 'Possession of Burglary Tools', 300, 2),
(36, 'Grand Theft Auto', 1800, 2),
(37, 'Intent to Sell/Distrube of an illegal Substance', 1500, 2),
(38, 'Frabrication of an Illegal Substance', 1500, 2),
(39, 'Possession of an Illegal Substance ', 650, 2),
(40, 'Kidnapping of a Civilan', 1500, 2),
(41, 'Kidnapping of an LEO', 2000, 2),
(42, 'Robbery', 650, 2),
(43, 'Armed Robbery of a Store', 650, 2),
(44, 'Armed Robbery of a Bank', 1500, 2),
(45, 'Assault on a Civilian', 2000, 3),
(46, 'Assault of an LEO', 2500, 3),
(47, 'Attempt of Murder of a Civilian', 3000, 3),
(48, 'Attempt of Murder of an LEO', 5000, 3),
(49, 'Murder of a Civilian', 10000, 3),
(50, 'Murder of an LEO', 30000, 3),
(51, 'Involuntary manslaughter', 1800, 3),
(52, 'Fraud', 2000, 2);

-- --------------------------------------------------------

--
-- Structure de la table `items`
--

CREATE TABLE `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` int(11) NOT NULL DEFAULT 1,
  `rare` tinyint(4) NOT NULL DEFAULT 0,
  `can_remove` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `items`
--

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('alive_chicken', 'Living chicken', 1, 0, 1),
('bandage', 'Bandage', 2, 0, 1),
('blowpipe', 'Blowtorch', 2, 0, 1),
('bread', 'Bread', 1, 0, 1),
('cannabis', 'Cannabis', 3, 0, 1),
('carokit', 'Body Kit', 3, 0, 1),
('carotool', 'Tools', 2, 0, 1),
('clothe', 'Cloth', 1, 0, 1),
('copper', 'Copper', 1, 0, 1),
('cutted_wood', 'Cut wood', 1, 0, 1),
('diamond', 'Diamond', 1, 0, 1),
('essence', 'Gas', 1, 0, 1),
('fabric', 'Fabric', 1, 0, 1),
('fish', 'Fish', 1, 0, 1),
('fixkit', 'Repair Kit', 3, 0, 1),
('fixtool', 'Repair Tools', 2, 0, 1),
('gazbottle', 'Gas Bottle', 2, 0, 1),
('gold', 'Gold', 1, 0, 1),
('iron', 'Iron', 1, 0, 1),
('marijuana', 'Marijuana', 2, 0, 1),
('medikit', 'Medikit', 2, 0, 1),
('packaged_chicken', 'Chicken fillet', 1, 0, 1),
('packaged_plank', 'Packaged wood', 1, 0, 1),
('petrol', 'Oil', 1, 0, 1),
('petrol_raffin', 'Processed oil', 1, 0, 1),
('phone', 'Phone', 1, 0, 1),
('radio', 'Radio', 1, 0, 1),
('slaughtered_chicken', 'Slaughtered chicken', 1, 0, 1),
('stone', 'Stone', 1, 0, 1),
('washed_stone', 'Washed stone', 1, 0, 1),
('water', 'Water', 1, 0, 1),
('wood', 'Wood', 1, 0, 1),
('wool', 'Wool', 1, 0, 1);

-- --------------------------------------------------------

--
-- Structure de la table `job2_grades`
--

CREATE TABLE `job2_grades` (
  `id` int(11) NOT NULL,
  `job2_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `job2_grades`
--

INSERT INTO `job2_grades` (`id`, `job2_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'unemployed', 0, 'unemployed', 'Unemployed', 200, '{}', '{}'),
(2, 'vagos', 0, 'recruit', 'Recruit', 150, '{}', '{}'),
(3, 'vagos', 1, 'member', 'Member', 250, '{}', '{}'),
(4, 'vagos', 2, 'capo', 'Capo', 400, '{}', '{}'),
(5, 'vagos', 3, 'boss', 'Nexora', 600, '{}', '{}');

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'civ',
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `jobs`
--

INSERT INTO `jobs` (`name`, `label`, `type`, `whitelisted`) VALUES
('ambulance', 'EMS', 'ems', 0),
('banker', 'Banker', 'civ', 0),
('cardealer', 'Cardealer', 'civ', 0),
('fisherman', 'Fisherman', 'civ', 0),
('fueler', 'Fueler', 'civ', 0),
('lumberjack', 'Lumberjack', 'civ', 0),
('mechanic', 'Mechanic', 'mechanic', 0),
('miner', 'Miner', 'civ', 0),
('police', 'LSPD', 'leo', 0),
('reporter', 'Reporter', 'civ', 0),
('slaughterer', 'Butcher', 'civ', 0),
('tailor', 'Tailor', 'civ', 0),
('taxi', 'Taxi', 'civ', 0),
('unemployed', 'Unemployed', 'civ', 0);

-- --------------------------------------------------------

--
-- Structure de la table `jobs2`
--

CREATE TABLE `jobs2` (
  `name` varchar(50) NOT NULL,
  `label` varchar(100) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'gang',
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `jobs2`
--

INSERT INTO `jobs2` (`name`, `label`, `type`, `whitelisted`) VALUES
('unemployed', 'Unemployed', 'civ', 0),
('vagos', 'Vagos', 'gang', 0);

-- --------------------------------------------------------

--
-- Structure de la table `job_grades`
--

CREATE TABLE `job_grades` (
  `id` int(11) NOT NULL,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `job_grades`
--

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'unemployed', 0, 'unemployed', 'Unemployed', 200, '{}', '{}'),
(2, 'police', 0, 'recruit', 'Recruit', 20, '{}', '{}'),
(3, 'police', 1, 'officer', 'Officer', 40, '{}', '{}'),
(4, 'police', 2, 'sergeant', 'Sergeant', 60, '{}', '{}'),
(5, 'police', 3, 'lieutenant', 'Lieutenant', 85, '{}', '{}'),
(6, 'police', 4, 'boss', 'Captain', 100, '{}', '{}'),
(11, 'cardealer', 0, 'recruit', 'Recruit', 10, '{}', '{}'),
(12, 'cardealer', 1, 'novice', 'Novice', 25, '{}', '{}'),
(13, 'cardealer', 2, 'experienced', 'Experienced', 40, '{}', '{}'),
(14, 'cardealer', 3, 'boss', 'Boss', 0, '{}', '{}'),
(15, 'lumberjack', 0, 'employee', 'Employee', 0, '{}', '{}'),
(16, 'fisherman', 0, 'employee', 'Employee', 0, '{}', '{}'),
(17, 'fueler', 0, 'employee', 'Employee', 0, '{}', '{}'),
(18, 'reporter', 0, 'employee', 'Employee', 0, '{}', '{}'),
(19, 'tailor', 0, 'employee', 'Employee', 0, '{\"mask_1\":0,\"arms\":1,\"glasses_1\":0,\"hair_color_2\":4,\"makeup_1\":0,\"face\":19,\"glasses\":0,\"mask_2\":0,\"makeup_3\":0,\"skin\":29,\"helmet_2\":0,\"lipstick_4\":0,\"sex\":0,\"torso_1\":24,\"makeup_2\":0,\"bags_2\":0,\"chain_2\":0,\"ears_1\":-1,\"bags_1\":0,\"bproof_1\":0,\"shoes_2\":0,\"lipstick_2\":0,\"chain_1\":0,\"tshirt_1\":0,\"eyebrows_3\":0,\"pants_2\":0,\"beard_4\":0,\"torso_2\":0,\"beard_2\":6,\"ears_2\":0,\"hair_2\":0,\"shoes_1\":36,\"tshirt_2\":0,\"beard_3\":0,\"hair_1\":2,\"hair_color_1\":0,\"pants_1\":48,\"helmet_1\":-1,\"bproof_2\":0,\"eyebrows_4\":0,\"eyebrows_2\":0,\"decals_1\":0,\"age_2\":0,\"beard_1\":5,\"shoes\":10,\"lipstick_1\":0,\"eyebrows_1\":0,\"glasses_2\":0,\"makeup_4\":0,\"decals_2\":0,\"lipstick_3\":0,\"age_1\":0}', '{\"mask_1\":0,\"arms\":5,\"glasses_1\":5,\"hair_color_2\":4,\"makeup_1\":0,\"face\":19,\"glasses\":0,\"mask_2\":0,\"makeup_3\":0,\"skin\":29,\"helmet_2\":0,\"lipstick_4\":0,\"sex\":1,\"torso_1\":52,\"makeup_2\":0,\"bags_2\":0,\"chain_2\":0,\"ears_1\":-1,\"bags_1\":0,\"bproof_1\":0,\"shoes_2\":1,\"lipstick_2\":0,\"chain_1\":0,\"tshirt_1\":23,\"eyebrows_3\":0,\"pants_2\":0,\"beard_4\":0,\"torso_2\":0,\"beard_2\":6,\"ears_2\":0,\"hair_2\":0,\"shoes_1\":42,\"tshirt_2\":4,\"beard_3\":0,\"hair_1\":2,\"hair_color_1\":0,\"pants_1\":36,\"helmet_1\":-1,\"bproof_2\":0,\"eyebrows_4\":0,\"eyebrows_2\":0,\"decals_1\":0,\"age_2\":0,\"beard_1\":5,\"shoes\":10,\"lipstick_1\":0,\"eyebrows_1\":0,\"glasses_2\":0,\"makeup_4\":0,\"decals_2\":0,\"lipstick_3\":0,\"age_1\":0}'),
(20, 'miner', 0, 'employee', 'Employee', 0, '{\"tshirt_2\":1,\"ears_1\":8,\"glasses_1\":15,\"torso_2\":0,\"ears_2\":2,\"glasses_2\":3,\"shoes_2\":1,\"pants_1\":75,\"shoes_1\":51,\"bags_1\":0,\"helmet_2\":0,\"pants_2\":7,\"torso_1\":71,\"tshirt_1\":59,\"arms\":2,\"bags_2\":0,\"helmet_1\":0}', '{}'),
(21, 'slaughterer', 0, 'employee', 'Employee', 0, '{\"age_1\":0,\"glasses_2\":0,\"beard_1\":5,\"decals_2\":0,\"beard_4\":0,\"shoes_2\":0,\"tshirt_2\":0,\"lipstick_2\":0,\"hair_2\":0,\"arms\":67,\"pants_1\":36,\"skin\":29,\"eyebrows_2\":0,\"shoes\":10,\"helmet_1\":-1,\"lipstick_1\":0,\"helmet_2\":0,\"hair_color_1\":0,\"glasses\":0,\"makeup_4\":0,\"makeup_1\":0,\"hair_1\":2,\"bproof_1\":0,\"bags_1\":0,\"mask_1\":0,\"lipstick_3\":0,\"chain_1\":0,\"eyebrows_4\":0,\"sex\":0,\"torso_1\":56,\"beard_2\":6,\"shoes_1\":12,\"decals_1\":0,\"face\":19,\"lipstick_4\":0,\"tshirt_1\":15,\"mask_2\":0,\"age_2\":0,\"eyebrows_3\":0,\"chain_2\":0,\"glasses_1\":0,\"ears_1\":-1,\"bags_2\":0,\"ears_2\":0,\"torso_2\":0,\"bproof_2\":0,\"makeup_2\":0,\"eyebrows_1\":0,\"makeup_3\":0,\"pants_2\":0,\"beard_3\":0,\"hair_color_2\":4}', '{\"age_1\":0,\"glasses_2\":0,\"beard_1\":5,\"decals_2\":0,\"beard_4\":0,\"shoes_2\":0,\"tshirt_2\":0,\"lipstick_2\":0,\"hair_2\":0,\"arms\":72,\"pants_1\":45,\"skin\":29,\"eyebrows_2\":0,\"shoes\":10,\"helmet_1\":-1,\"lipstick_1\":0,\"helmet_2\":0,\"hair_color_1\":0,\"glasses\":0,\"makeup_4\":0,\"makeup_1\":0,\"hair_1\":2,\"bproof_1\":0,\"bags_1\":0,\"mask_1\":0,\"lipstick_3\":0,\"chain_1\":0,\"eyebrows_4\":0,\"sex\":1,\"torso_1\":49,\"beard_2\":6,\"shoes_1\":24,\"decals_1\":0,\"face\":19,\"lipstick_4\":0,\"tshirt_1\":9,\"mask_2\":0,\"age_2\":0,\"eyebrows_3\":0,\"chain_2\":0,\"glasses_1\":5,\"ears_1\":-1,\"bags_2\":0,\"ears_2\":0,\"torso_2\":0,\"bproof_2\":0,\"makeup_2\":0,\"eyebrows_1\":0,\"makeup_3\":0,\"pants_2\":0,\"beard_3\":0,\"hair_color_2\":4}'),
(22, 'ambulance', 0, 'ambulance', 'Jr. EMT', 20, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(23, 'ambulance', 1, 'doctor', 'EMT', 40, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(24, 'ambulance', 2, 'chief_doctor', 'Sr. EMT', 60, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(25, 'ambulance', 3, 'boss', 'EMT Supervisor', 80, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(26, 'mechanic', 0, 'recrue', 'Recruit', 12, '{}', '{}'),
(27, 'mechanic', 1, 'novice', 'Novice', 24, '{}', '{}'),
(28, 'mechanic', 2, 'experimente', 'Experienced', 36, '{}', '{}'),
(29, 'mechanic', 3, 'chief', 'Leader', 48, '{}', '{}'),
(30, 'mechanic', 4, 'boss', 'Boss', 0, '{}', '{}'),
(31, 'taxi', 0, 'recrue', 'Recruit', 12, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":32,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":31,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":0,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":27,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
(32, 'taxi', 1, 'novice', 'Cabby', 24, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":32,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":31,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":0,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":27,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
(33, 'taxi', 2, 'experimente', 'Experienced', 36, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":26,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":57,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":4,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":11,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":0,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
(34, 'taxi', 3, 'uber', 'Uber Cabby', 48, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":26,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":57,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":4,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":11,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":0,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
(35, 'taxi', 4, 'boss', 'Lead Cabby', 0, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":29,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":31,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":4,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":1,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":0,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":4,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
(36, 'banker', 0, 'advisor', 'Consultant', 10, '{}', '{}'),
(37, 'banker', 1, 'banker', 'Banker', 20, '{}', '{}'),
(38, 'banker', 2, 'business_banker', 'Investment banker', 30, '{}', '{}'),
(39, 'banker', 3, 'trader', 'Broker', 40, '{}', '{}'),
(40, 'banker', 4, 'boss', 'Boss', 0, '{}', '{}');

-- --------------------------------------------------------

--
-- Structure de la table `licenses`
--

CREATE TABLE `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `licenses`
--

INSERT INTO `licenses` (`type`, `label`) VALUES
('boat', 'Boat License'),
('dmv', 'Driving Permit'),
('drive', 'Drivers License'),
('drive_bike', 'Motorcycle License'),
('drive_truck', 'Commercial Drivers License'),
('weapon', 'Weapon License'),
('weed_processing', 'Weed Processing License');

-- --------------------------------------------------------

--
-- Structure de la table `management_outfits`
--

CREATE TABLE `management_outfits` (
  `id` int(11) NOT NULL,
  `job_name` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `minrank` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT 'Cool Outfit',
  `gender` varchar(50) NOT NULL DEFAULT 'male',
  `model` varchar(50) DEFAULT NULL,
  `props` varchar(1000) DEFAULT NULL,
  `components` varchar(1500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `marketplace_listings`
--

CREATE TABLE `marketplace_listings` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `title` varchar(80) NOT NULL,
  `body` text NOT NULL,
  `price` bigint(20) DEFAULT NULL,
  `image` varchar(512) DEFAULT NULL,
  `images` text DEFAULT NULL,
  `number` varchar(20) NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `multicharacter_slots`
--

CREATE TABLE `multicharacter_slots` (
  `identifier` varchar(46) NOT NULL,
  `slots` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `nexora_playtime`
--

CREATE TABLE `nexora_playtime` (
  `identifier` varchar(46) NOT NULL,
  `playtime` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `owned_vehicles`
--

CREATE TABLE `owned_vehicles` (
  `owner` varchar(46) DEFAULT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `job` varchar(20) DEFAULT NULL,
  `stored` tinyint(4) NOT NULL DEFAULT 0,
  `parking` varchar(60) DEFAULT NULL,
  `pound` varchar(60) DEFAULT NULL,
  `mileage` float DEFAULT 0,
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `ox_inventory`
--

CREATE TABLE `ox_inventory` (
  `owner` varchar(46) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `ox_inventory_settings`
--

CREATE TABLE `ox_inventory_settings` (
  `owner` varchar(46) NOT NULL,
  `settings` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `pages_posts`
--

CREATE TABLE `pages_posts` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `title` varchar(80) NOT NULL,
  `body` text NOT NULL,
  `price` bigint(20) DEFAULT NULL,
  `image` varchar(512) DEFAULT NULL,
  `images` text DEFAULT NULL,
  `number` varchar(20) NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_admin_audit`
--

CREATE TABLE `phone_admin_audit` (
  `id` int(10) UNSIGNED NOT NULL,
  `admin_cid` varchar(64) NOT NULL,
  `admin_name` varchar(64) NOT NULL DEFAULT '',
  `action` varchar(48) NOT NULL,
  `target_cid` varchar(64) DEFAULT NULL,
  `detail` varchar(512) NOT NULL DEFAULT '',
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_admin_mutes`
--

CREATE TABLE `phone_admin_mutes` (
  `id` int(10) UNSIGNED NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `scope` varchar(24) NOT NULL,
  `reason` varchar(200) NOT NULL DEFAULT '',
  `admin_cid` varchar(64) NOT NULL,
  `admin_name` varchar(64) NOT NULL DEFAULT '',
  `expires_at` bigint(20) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_alarms`
--

CREATE TABLE `phone_alarms` (
  `citizenid` varchar(60) NOT NULL,
  `id` varchar(40) NOT NULL,
  `hour` tinyint(3) UNSIGNED NOT NULL,
  `minute` tinyint(3) UNSIGNED NOT NULL,
  `label` varchar(60) NOT NULL DEFAULT '',
  `days` varchar(40) NOT NULL DEFAULT '',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `sound` tinyint(1) NOT NULL DEFAULT 1,
  `snooze` tinyint(1) NOT NULL DEFAULT 0,
  `snooze_secs` int(11) NOT NULL DEFAULT 60
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_app_accounts`
--

CREATE TABLE `phone_app_accounts` (
  `id` int(10) UNSIGNED NOT NULL,
  `app` varchar(24) NOT NULL,
  `username` varchar(64) NOT NULL,
  `display_name` varchar(50) NOT NULL DEFAULT '',
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(120) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_app_sessions`
--

CREATE TABLE `phone_app_sessions` (
  `app` varchar(24) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `account_id` int(10) UNSIGNED NOT NULL,
  `last_used` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_bank_transactions`
--

CREATE TABLE `phone_bank_transactions` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `label` varchar(120) NOT NULL,
  `amount` bigint(20) NOT NULL,
  `category` varchar(32) NOT NULL DEFAULT 'transfer',
  `counterparty` varchar(64) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `src_id` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_birdy_dms`
--

CREATE TABLE `phone_birdy_dms` (
  `id` varchar(16) NOT NULL,
  `from_handle` varchar(32) NOT NULL,
  `to_handle` varchar(32) NOT NULL,
  `body` text NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `meta` text DEFAULT NULL,
  `reactions` text DEFAULT NULL,
  `read_flag` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_birdy_follows`
--

CREATE TABLE `phone_birdy_follows` (
  `follower` varchar(32) NOT NULL,
  `target` varchar(32) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_birdy_likes`
--

CREATE TABLE `phone_birdy_likes` (
  `post_id` varchar(16) NOT NULL,
  `handle` varchar(32) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_birdy_notifications`
--

CREATE TABLE `phone_birdy_notifications` (
  `id` varchar(16) NOT NULL,
  `recipient` varchar(32) NOT NULL,
  `kind` varchar(16) NOT NULL,
  `actor` varchar(32) NOT NULL,
  `post_id` varchar(16) DEFAULT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_birdy_posts`
--

CREATE TABLE `phone_birdy_posts` (
  `id` varchar(16) NOT NULL,
  `author` varchar(32) NOT NULL,
  `body` text NOT NULL,
  `parent_id` varchar(16) DEFAULT NULL,
  `images` text DEFAULT NULL,
  `views` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_birdy_profiles`
--

CREATE TABLE `phone_birdy_profiles` (
  `handle` varchar(32) NOT NULL,
  `citizenid` varchar(64) NOT NULL DEFAULT '',
  `display_name` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL DEFAULT '',
  `bio` varchar(200) NOT NULL DEFAULT '',
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `verified_type` varchar(8) DEFAULT NULL,
  `logged_in` tinyint(1) NOT NULL DEFAULT 0,
  `join_label` varchar(32) NOT NULL DEFAULT '',
  `protected` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `avatar` varchar(512) DEFAULT NULL,
  `banner` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_birdy_reposts`
--

CREATE TABLE `phone_birdy_reposts` (
  `post_id` varchar(16) NOT NULL,
  `handle` varchar(32) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_blocked`
--

CREATE TABLE `phone_blocked` (
  `citizenid` varchar(64) NOT NULL,
  `number` varchar(32) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_bluetooth`
--

CREATE TABLE `phone_bluetooth` (
  `citizenid` varchar(64) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `paired` longtext DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_calls`
--

CREATE TABLE `phone_calls` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `number` varchar(32) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `direction` varchar(16) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `called_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_casino_chips`
--

CREATE TABLE `phone_casino_chips` (
  `citizenid` varchar(64) NOT NULL,
  `chips` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_cherry_blocks`
--

CREATE TABLE `phone_cherry_blocks` (
  `blocker` varchar(64) NOT NULL,
  `blocked` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_cherry_matches`
--

CREATE TABLE `phone_cherry_matches` (
  `id` varchar(16) NOT NULL,
  `a` varchar(64) NOT NULL,
  `b` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_cherry_messages`
--

CREATE TABLE `phone_cherry_messages` (
  `id` varchar(16) NOT NULL,
  `match_id` varchar(16) NOT NULL,
  `sender` varchar(64) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `body` text DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `reactions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`reactions`)),
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_cherry_profiles`
--

CREATE TABLE `phone_cherry_profiles` (
  `username` varchar(64) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `age` int(11) NOT NULL DEFAULT 21,
  `about` varchar(300) NOT NULL DEFAULT '',
  `gender` varchar(12) NOT NULL DEFAULT 'Man',
  `interested` varchar(12) NOT NULL DEFAULT 'Everyone',
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `photos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`photos`)),
  `updated_at` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_cherry_swipes`
--

CREATE TABLE `phone_cherry_swipes` (
  `swiper` varchar(64) NOT NULL,
  `target` varchar(64) NOT NULL,
  `liked` tinyint(1) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_contacts`
--

CREATE TABLE `phone_contacts` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `phone` varchar(32) NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL,
  `color` varchar(16) NOT NULL,
  `avatar` varchar(512) DEFAULT NULL,
  `favorite` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_cookie`
--

CREATE TABLE `phone_cookie` (
  `citizenid` varchar(60) NOT NULL,
  `name` varchar(60) DEFAULT NULL,
  `nickname` varchar(40) DEFAULT NULL,
  `cookies` double NOT NULL DEFAULT 0,
  `earned` double NOT NULL DEFAULT 0,
  `owned` text DEFAULT NULL,
  `achievements` text DEFAULT NULL,
  `rain_on` tinyint(1) NOT NULL DEFAULT 1,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_custom_ringtones`
--

CREATE TABLE `phone_custom_ringtones` (
  `citizenid` varchar(64) NOT NULL,
  `id` varchar(32) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'ringtone',
  `name` varchar(64) NOT NULL,
  `url` varchar(512) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_documents`
--

CREATE TABLE `phone_documents` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `folder_id` varchar(16) DEFAULT NULL,
  `name` varchar(80) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `content` mediumtext DEFAULT NULL,
  `url` varchar(1024) DEFAULT NULL,
  `size` int(11) NOT NULL DEFAULT 0,
  `locked` tinyint(1) NOT NULL DEFAULT 0,
  `signable` tinyint(1) NOT NULL DEFAULT 1,
  `deletable` tinyint(1) NOT NULL DEFAULT 1,
  `source` varchar(64) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_document_folders`
--

CREATE TABLE `phone_document_folders` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(60) NOT NULL,
  `parent_id` varchar(16) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_document_signatures`
--

CREATE TABLE `phone_document_signatures` (
  `id` varchar(16) NOT NULL,
  `doc_id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `signer` varchar(64) NOT NULL,
  `image` mediumtext DEFAULT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_friends`
--

CREATE TABLE `phone_friends` (
  `owner` varchar(46) NOT NULL,
  `friend` varchar(60) NOT NULL,
  `share` tinyint(1) NOT NULL DEFAULT 1,
  `pending` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_game_stats`
--

CREATE TABLE `phone_game_stats` (
  `citizenid` varchar(64) NOT NULL,
  `game` varchar(32) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `cpu_wins` int(11) NOT NULL DEFAULT 0,
  `cpu_losses` int(11) NOT NULL DEFAULT 0,
  `cpu_draws` int(11) NOT NULL DEFAULT 0,
  `online_wins` int(11) NOT NULL DEFAULT 0,
  `online_losses` int(11) NOT NULL DEFAULT 0,
  `online_draws` int(11) NOT NULL DEFAULT 0,
  `chips_won` bigint(20) NOT NULL DEFAULT 0,
  `chips_lost` bigint(20) NOT NULL DEFAULT 0,
  `high_score` bigint(20) NOT NULL DEFAULT 0,
  `plays` int(11) NOT NULL DEFAULT 0,
  `last_score` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_groups`
--

CREATE TABLE `phone_groups` (
  `id` varchar(16) NOT NULL,
  `name` varchar(64) NOT NULL,
  `leader_cid` varchar(64) NOT NULL,
  `color` varchar(16) NOT NULL,
  `avatar` varchar(512) DEFAULT NULL,
  `members` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`members`)),
  `invites` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`invites`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_group_invites`
--

CREATE TABLE `phone_group_invites` (
  `id` varchar(16) NOT NULL,
  `group_id` varchar(16) NOT NULL,
  `target_cid` varchar(64) NOT NULL,
  `invited_by` varchar(64) NOT NULL,
  `invited_name` varchar(64) DEFAULT NULL,
  `sent_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_job_fires`
--

CREATE TABLE `phone_job_fires` (
  `citizenid` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_job_invites`
--

CREATE TABLE `phone_job_invites` (
  `id` varchar(48) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  `grade` int(11) NOT NULL DEFAULT 0,
  `invited_by` varchar(128) DEFAULT NULL,
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_mail_accounts`
--

CREATE TABLE `phone_mail_accounts` (
  `email` varchar(64) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `display_name` varchar(64) NOT NULL,
  `messages` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`messages`)),
  `logged_in_citizens` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`logged_in_citizens`)),
  `created_by_cid` varchar(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_mail_saved_emails`
--

CREATE TABLE `phone_mail_saved_emails` (
  `citizenid` varchar(64) NOT NULL,
  `email` varchar(128) NOT NULL,
  `declined` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_mail_sessions`
--

CREATE TABLE `phone_mail_sessions` (
  `citizenid` varchar(64) NOT NULL,
  `email` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_map_markers`
--

CREATE TABLE `phone_map_markers` (
  `citizenid` varchar(60) NOT NULL,
  `markers` mediumtext NOT NULL,
  `updated_at` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_messages`
--

CREATE TABLE `phone_messages` (
  `id` varchar(16) NOT NULL,
  `mid` varchar(16) DEFAULT NULL,
  `citizenid` varchar(64) NOT NULL,
  `conversation` varchar(48) NOT NULL,
  `sender` varchar(32) NOT NULL DEFAULT '',
  `direction` varchar(16) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `body` text DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `withheld` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_message_groups`
--

CREATE TABLE `phone_message_groups` (
  `id` varchar(16) NOT NULL,
  `name` varchar(64) NOT NULL,
  `avatar` varchar(512) DEFAULT NULL,
  `owner_cid` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_message_group_members`
--

CREATE TABLE `phone_message_group_members` (
  `group_id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `number` varchar(32) NOT NULL,
  `name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_message_reactions`
--

CREATE TABLE `phone_message_reactions` (
  `mid` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `emoji` varchar(32) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_migrations`
--

CREATE TABLE `phone_migrations` (
  `name` varchar(64) NOT NULL,
  `applied_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `stats` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`stats`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `phone_migrations`
--

INSERT INTO `phone_migrations` (`name`, `applied_at`, `stats`) VALUES
('accounts_orphan_mail_cleanup', '2026-08-17 16:45:03', '{\"removed\":0}'),
('birdy_handle_rekey', '2026-08-17 16:45:03', '{\"fresh\":true}'),
('documents_unlock_player_rows', '2026-08-17 16:45:03', '{\"repaired\":0}'),
('settings_phone_number_bare_digits', '2026-08-17 16:45:03', '{\"normalized\":0}');

-- --------------------------------------------------------

--
-- Structure de la table `phone_notes`
--

CREATE TABLE `phone_notes` (
  `citizenid` varchar(60) NOT NULL,
  `id` varchar(40) NOT NULL,
  `body` mediumtext NOT NULL,
  `sketches` mediumtext NOT NULL,
  `images` mediumtext DEFAULT NULL,
  `created_at` varchar(40) NOT NULL,
  `updated_at` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_notif_prefs`
--

CREATE TABLE `phone_notif_prefs` (
  `citizenid` varchar(64) NOT NULL,
  `app` varchar(32) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `sounds` tinyint(1) NOT NULL DEFAULT 1,
  `tone` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_passwords`
--

CREATE TABLE `phone_passwords` (
  `id` int(10) UNSIGNED NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `app` varchar(24) NOT NULL,
  `username` varchar(64) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(120) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_payphones`
--

CREATE TABLE `phone_payphones` (
  `location` varchar(64) NOT NULL,
  `number` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_pending_messages`
--

CREATE TABLE `phone_pending_messages` (
  `id` varchar(16) NOT NULL,
  `mid` varchar(16) NOT NULL,
  `number` varchar(48) NOT NULL,
  `sender` varchar(32) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `body` text DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_comments`
--

CREATE TABLE `phone_photogram_comments` (
  `id` varchar(16) NOT NULL,
  `post_id` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `body` varchar(1000) DEFAULT NULL,
  `gif_url` varchar(512) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_comment_likes`
--

CREATE TABLE `phone_photogram_comment_likes` (
  `comment_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_dms`
--

CREATE TABLE `phone_photogram_dms` (
  `id` varchar(16) NOT NULL,
  `from_user` varchar(64) NOT NULL,
  `to_user` varchar(64) NOT NULL,
  `body` text DEFAULT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `reactions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`reactions`)),
  `read_flag` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_follows`
--

CREATE TABLE `phone_photogram_follows` (
  `follower` varchar(64) NOT NULL,
  `target` varchar(64) NOT NULL,
  `status` varchar(12) NOT NULL DEFAULT 'accepted',
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_likes`
--

CREATE TABLE `phone_photogram_likes` (
  `post_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_notifications`
--

CREATE TABLE `phone_photogram_notifications` (
  `id` varchar(16) NOT NULL,
  `recipient` varchar(64) NOT NULL,
  `kind` varchar(16) NOT NULL,
  `actor` varchar(64) NOT NULL,
  `post_id` varchar(16) DEFAULT NULL,
  `preview` varchar(200) DEFAULT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_posts`
--

CREATE TABLE `phone_photogram_posts` (
  `id` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images`)),
  `caption` varchar(2200) NOT NULL DEFAULT '',
  `location` varchar(120) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_profiles`
--

CREATE TABLE `phone_photogram_profiles` (
  `username` varchar(64) NOT NULL,
  `display_name` varchar(64) NOT NULL DEFAULT '',
  `bio` varchar(200) NOT NULL DEFAULT '',
  `avatar` varchar(512) DEFAULT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_saves`
--

CREATE TABLE `phone_photogram_saves` (
  `post_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_stories`
--

CREATE TABLE `phone_photogram_stories` (
  `id` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `image` varchar(512) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photogram_story_views`
--

CREATE TABLE `phone_photogram_story_views` (
  `story_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photos`
--

CREATE TABLE `phone_photos` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `url` varchar(512) NOT NULL,
  `favorite` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photo_albums`
--

CREATE TABLE `phone_photo_albums` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_photo_album_items`
--

CREATE TABLE `phone_photo_album_items` (
  `album_id` varchar(16) NOT NULL,
  `photo_id` varchar(16) NOT NULL,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_racing_profiles`
--

CREATE TABLE `phone_racing_profiles` (
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `alias` varchar(24) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `mmr` int(11) NOT NULL DEFAULT 1000,
  `hud` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_racing_results`
--

CREATE TABLE `phone_racing_results` (
  `id` int(11) NOT NULL,
  `track_id` int(11) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT '',
  `time_ms` int(11) NOT NULL DEFAULT 0,
  `vehicle` varchar(64) DEFAULT NULL,
  `class` varchar(4) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `racers` int(11) DEFAULT NULL,
  `mmr_delta` int(11) DEFAULT NULL,
  `mmr_after` int(11) DEFAULT NULL,
  `best_lap_ms` int(11) DEFAULT NULL,
  `sectors` varchar(64) DEFAULT NULL,
  `dnf` tinyint(1) NOT NULL DEFAULT 0,
  `ranked` tinyint(1) NOT NULL DEFAULT 0,
  `finished_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_racing_tracks`
--

CREATE TABLE `phone_racing_tracks` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `citizenid` varchar(64) DEFAULT NULL,
  `author_name` varchar(64) NOT NULL DEFAULT '',
  `checkpoints` longtext NOT NULL,
  `gate_count` int(11) NOT NULL DEFAULT 0,
  `is_sprint` tinyint(1) NOT NULL DEFAULT 0,
  `published` tinyint(1) NOT NULL DEFAULT 1,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_radio`
--

CREATE TABLE `phone_radio` (
  `citizenid` varchar(64) NOT NULL,
  `frequency` decimal(5,1) NOT NULL DEFAULT 1.0,
  `volume` int(11) NOT NULL DEFAULT 50
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_radio_saved`
--

CREATE TABLE `phone_radio_saved` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `label` varchar(40) NOT NULL,
  `frequency` decimal(5,1) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_review_business_meta`
--

CREATE TABLE `phone_review_business_meta` (
  `business_id` varchar(60) NOT NULL,
  `hours` varchar(64) DEFAULT NULL,
  `blurb` varchar(200) DEFAULT NULL,
  `logo` varchar(16) DEFAULT NULL,
  `updated_by` varchar(60) DEFAULT NULL,
  `updated_at` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_review_helpful`
--

CREATE TABLE `phone_review_helpful` (
  `review_id` int(11) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_review_reviews`
--

CREATE TABLE `phone_review_reviews` (
  `id` int(11) NOT NULL,
  `business_id` varchar(60) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `author` varchar(80) NOT NULL,
  `rating` tinyint(4) NOT NULL,
  `body` text NOT NULL,
  `image` varchar(512) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_ryde_drivers`
--

CREATE TABLE `phone_ryde_drivers` (
  `username` varchar(64) NOT NULL,
  `display_name` varchar(64) NOT NULL DEFAULT '',
  `vehicle` varchar(64) NOT NULL DEFAULT '',
  `plate` varchar(16) NOT NULL DEFAULT '',
  `color` varchar(16) NOT NULL DEFAULT '#111111',
  `rating_sum` int(11) NOT NULL DEFAULT 0,
  `rating_count` int(11) NOT NULL DEFAULT 0,
  `trips` int(11) NOT NULL DEFAULT 0,
  `earnings_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_ryde_rides`
--

CREATE TABLE `phone_ryde_rides` (
  `id` varchar(16) NOT NULL,
  `rider_username` varchar(64) NOT NULL,
  `rider_name` varchar(64) NOT NULL DEFAULT '',
  `driver_username` varchar(64) DEFAULT NULL,
  `driver_name` varchar(64) NOT NULL DEFAULT '',
  `pickup_label` varchar(96) NOT NULL DEFAULT '',
  `pickup_x` float NOT NULL DEFAULT 0,
  `pickup_y` float NOT NULL DEFAULT 0,
  `dropoff_label` varchar(96) NOT NULL DEFAULT '',
  `dropoff_x` float NOT NULL DEFAULT 0,
  `dropoff_y` float NOT NULL DEFAULT 0,
  `distance` float NOT NULL DEFAULT 0,
  `fare` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment` varchar(8) NOT NULL DEFAULT 'cash',
  `paid` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(16) NOT NULL DEFAULT 'completed',
  `rating` tinyint(4) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `completed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_saved_jobs`
--

CREATE TABLE `phone_saved_jobs` (
  `citizenid` varchar(64) NOT NULL,
  `jobs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`jobs`)),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_service_invoices`
--

CREATE TABLE `phone_service_invoices` (
  `id` varchar(48) NOT NULL,
  `job` varchar(64) DEFAULT NULL,
  `label` varchar(128) DEFAULT NULL,
  `sender_cid` varchar(64) NOT NULL,
  `sender_name` varchar(128) DEFAULT NULL,
  `sender_number` varchar(32) DEFAULT NULL,
  `target_cid` varchar(64) NOT NULL,
  `target_name` varchar(128) DEFAULT NULL,
  `target_number` varchar(32) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'pending',
  `created_at` int(11) NOT NULL,
  `paid_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_service_messages`
--

CREATE TABLE `phone_service_messages` (
  `id` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  `citizen_number` varchar(32) NOT NULL,
  `citizen_name` varchar(128) DEFAULT NULL,
  `sender` varchar(8) NOT NULL,
  `staff_cid` varchar(64) DEFAULT NULL,
  `staff_name` varchar(128) DEFAULT NULL,
  `body` text NOT NULL,
  `created_at` int(11) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `meta` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_service_msg_reads`
--

CREATE TABLE `phone_service_msg_reads` (
  `viewer` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  `citizen_number` varchar(32) NOT NULL,
  `last_read` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_service_prefs`
--

CREATE TABLE `phone_service_prefs` (
  `citizenid` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  `duty` tinyint(1) NOT NULL DEFAULT 1,
  `job_calls` tinyint(1) NOT NULL DEFAULT 1,
  `job_messages` tinyint(1) NOT NULL DEFAULT 1,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_settings`
--

CREATE TABLE `phone_settings` (
  `citizenid` varchar(64) NOT NULL,
  `device` varchar(16) NOT NULL DEFAULT 'phone',
  `phone_number` varchar(20) DEFAULT NULL,
  `active_group_id` varchar(16) DEFAULT NULL,
  `ringtone` varchar(64) DEFAULT NULL,
  `notification_tone` varchar(64) DEFAULT NULL,
  `airplane_mode` tinyint(1) NOT NULL DEFAULT 0,
  `card_name` varchar(64) DEFAULT NULL,
  `card_avatar` varchar(512) DEFAULT NULL,
  `card_email` varchar(128) DEFAULT NULL,
  `card_address` varchar(128) DEFAULT NULL,
  `installed_apps` text DEFAULT NULL,
  `home_layout` text DEFAULT NULL,
  `lock_clock` text DEFAULT NULL,
  `wallpaper` varchar(512) DEFAULT NULL,
  `wallpaper_home` varchar(512) DEFAULT NULL,
  `blur_lock` tinyint(1) DEFAULT NULL,
  `blur_home` tinyint(1) DEFAULT NULL,
  `island_pet` varchar(16) DEFAULT NULL,
  `custom_wallpapers` text DEFAULT NULL,
  `passcode` varchar(8) DEFAULT NULL,
  `face_id` tinyint(1) NOT NULL DEFAULT 0,
  `chat_text_scale` decimal(3,2) DEFAULT NULL,
  `reduce_motion` tinyint(4) DEFAULT NULL,
  `bold_text` tinyint(1) DEFAULT NULL,
  `text_scale` decimal(3,2) DEFAULT NULL,
  `app_labels` text DEFAULT NULL,
  `phone_scale` tinyint(3) UNSIGNED DEFAULT NULL,
  `brightness` tinyint(3) UNSIGNED DEFAULT NULL,
  `phone_align` varchar(16) DEFAULT NULL,
  `phone_tilt` varchar(48) DEFAULT NULL,
  `dock_style` varchar(12) DEFAULT NULL,
  `open_anim` varchar(12) DEFAULT NULL,
  `wallpaper_parallax` tinyint(1) DEFAULT NULL,
  `hour24` tinyint(1) DEFAULT NULL,
  `caller_id` tinyint(1) DEFAULT NULL,
  `streamer_mode` tinyint(1) DEFAULT NULL,
  `streamer_hide` varchar(255) DEFAULT NULL,
  `reopen_app` tinyint(1) DEFAULT NULL,
  `setup_done` tinyint(1) DEFAULT NULL,
  `theme` varchar(8) DEFAULT NULL,
  `dark_theme` varchar(16) DEFAULT NULL,
  `light_theme` varchar(16) DEFAULT NULL,
  `accent` varchar(16) DEFAULT NULL,
  `shell` varchar(16) DEFAULT NULL,
  `game_time` tinyint(1) DEFAULT NULL,
  `palette_custom` longtext DEFAULT NULL,
  `icon_theme` varchar(16) DEFAULT NULL,
  `icon_custom` longtext DEFAULT NULL,
  `show_app_names` tinyint(1) NOT NULL DEFAULT 1,
  `home_density` varchar(12) DEFAULT NULL,
  `ringtone_volume` tinyint(3) UNSIGNED DEFAULT NULL,
  `call_volume` tinyint(3) UNSIGNED DEFAULT NULL,
  `locale` varchar(8) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `phone_settings`
--

INSERT INTO `phone_settings` (`citizenid`, `device`, `phone_number`, `active_group_id`, `ringtone`, `notification_tone`, `airplane_mode`, `card_name`, `card_avatar`, `card_email`, `card_address`, `installed_apps`, `home_layout`, `lock_clock`, `wallpaper`, `wallpaper_home`, `blur_lock`, `blur_home`, `island_pet`, `custom_wallpapers`, `passcode`, `face_id`, `chat_text_scale`, `reduce_motion`, `bold_text`, `text_scale`, `app_labels`, `phone_scale`, `brightness`, `phone_align`, `phone_tilt`, `dock_style`, `open_anim`, `wallpaper_parallax`, `hour24`, `caller_id`, `streamer_mode`, `streamer_hide`, `reopen_app`, `setup_done`, `theme`, `dark_theme`, `light_theme`, `accent`, `shell`, `game_time`, `palette_custom`, `icon_theme`, `icon_custom`, `show_app_names`, `home_density`, `ringtone_volume`, `call_volume`, `locale`, `updated_at`) VALUES
('char1:f6cb50aa7cd50fa658599060fe71faef79b4ff6d', 'phone', '9710233543', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-08-17 20:24:19'),
('f6cb50aa7cd50fa658599060fe71faef79b4ff6d', 'phone', '5472763459', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-08-17 16:59:04');

-- --------------------------------------------------------

--
-- Structure de la table `phone_signatures`
--

CREATE TABLE `phone_signatures` (
  `citizenid` varchar(64) NOT NULL,
  `image` mediumtext NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_stock_holdings`
--

CREATE TABLE `phone_stock_holdings` (
  `citizenid` varchar(64) NOT NULL,
  `symbol` varchar(16) NOT NULL,
  `quantity` decimal(24,8) NOT NULL,
  `avg_cost` decimal(18,6) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_stock_prices`
--

CREATE TABLE `phone_stock_prices` (
  `symbol` varchar(16) NOT NULL,
  `price` decimal(24,8) NOT NULL,
  `history` longtext DEFAULT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `phone_stock_prices`
--

INSERT INTO `phone_stock_prices` (`symbol`, `price`, `history`, `updated_at`) VALUES
('AMU', 177.09579929, '[178.76250293898506,178.54259318977069,178.39904183397315,178.60253061908248,178.7143629138559,178.7236960991929,178.73976292035725,178.36508887388468,178.54496632068155,178.39642050533502,178.08724246867195,178.0114035058567,177.72985107640049,177.92048396887376,177.8206728641681,177.50058233684096,177.84911742956829,177.74265659473014,177.59909106280589,177.5088992688931,177.29494857356287,177.11501358486133,177.24083578449064,177.04651531656689,177.0586643689036,176.84850241767905,176.68485184889563,176.74458450656437,176.7116844528037,176.63619235151524,176.34031702453559,176.36172131529293,176.5372625639589,176.52511779346816,176.58662428199808,176.59195919093578,176.504809993014,176.2580543392718,176.30371570350065,176.4114107812645,176.56440734786433,176.78185007929398,176.92406582627673,177.0897045979846,176.84805391550888,176.88101848316084,176.71837202921334,177.09579928977278]', 1786999097),
('BIL', 159.57342028, '[160.12008677258226,160.1997628413338,159.95754434598514,159.91437650549748,159.66180580804687,159.81720929725777,160.01011664805237,159.97819131413017,160.14236937444029,160.2406349552766,160.00348249105037,160.22166497840889,160.35992912947018,160.3067281115563,160.4290422808704,160.01441382080405,160.07146956057577,160.21092131602019,160.14431368915846,160.46041142155179,160.42395588295913,160.25318435199964,160.45009777070286,160.4732408503644,160.52921796722345,160.55561593981589,160.52299657872605,160.40334040295378,160.47855390887208,160.24292677736569,160.30673391027276,160.54384284098988,160.32557793539153,160.44274720681845,160.4856666253512,160.44930877317749,160.1835637623033,159.96405910934318,160.05946113433309,160.07666279533763,159.96087346471124,159.57975140039637,159.60786093329149,159.61915545262299,159.63602846587558,159.5917212213783,159.4387231213709,159.57342027754528]', 1786999097),
('BSH', 22.13754830, '[22.11037916314224,22.10270227523161,22.11382296850965,22.09280914528942,22.09014230441622,22.12582265212506,22.12791661583731,22.13785098801667,22.10041513078623,22.08078350949596,22.02862326893008,22.04023376329517,22.03269712644812,22.02931274668144,22.00729931920489,22.08687206011923,22.03593687742113,22.04989229787026,22.06007408058285,22.07632604847204,22.09094989509233,22.06999245127992,22.08399303885359,22.09719333832643,22.07562452686159,22.07975758594808,22.06117034349784,22.08801598009176,22.10632117926086,22.13733997437257,22.1047441176831,22.1022883135044,22.14143775544891,22.09933575798084,22.10521604845818,22.0945189990857,22.07112263491722,22.08983590655381,22.11294243354678,22.14564980408134,22.13428795843835,22.13502484061965,22.15877525857176,22.16237360783743,22.15846943230365,22.1711116359791,22.18062119751935,22.13754830085733]', 1786999097),
('BTL', 35733.11983641, '[36551.48207306935,36449.442667651,36469.78347155963,36345.354780158414,36321.26978165567,36285.16211799199,36216.101300250266,36266.473310749236,36151.38048943959,36114.74251093134,36132.15838502815,36124.3808126452,36366.33021948209,36441.72080144914,36327.98148948435,36355.44889207305,36418.36868135364,36336.37391932249,36369.737029496064,36232.821411922894,36248.29802469621,36278.53665242515,36375.74507302119,36484.26187579722,36487.43024838515,36388.03898434111,36351.32215463065,36194.04461739764,36193.2556325915,36170.551826461946,36168.53963309793,36153.993900992995,36101.04985457636,36102.15014434908,36109.546090699965,36012.21439021013,36033.27638362115,35933.40786536673,35867.26704628608,35789.528806499606,35774.1477804585,35745.1448142898,35766.1027989342,35684.29182006998,35630.76428915562,35703.558737745996,35661.697802279756,35733.11983641213]', 1786999097),
('CLK', 22.87233165, '[23.31928606235686,23.33756256296815,23.30790874336221,23.24230553334768,23.25335046190592,23.26620547668379,23.23653485185731,23.25113829690382,23.2321911520729,23.20593245346766,23.20442736001775,23.21760015021028,23.21894741277007,23.15366198073583,23.09721534395528,23.10983839248893,23.09903476831984,23.07891183848448,23.06330790530764,23.06705108348512,23.05782755786365,23.06240196028822,23.07935511165631,23.10849185992546,23.10085552830634,23.09921787922546,23.08920011282056,23.08793725233157,23.05016938275393,23.0240875793691,23.0378412599423,23.04596255447965,23.04373864759546,23.04651146867317,23.05596082381745,23.01858559746478,23.06055337768009,23.05948477251166,23.02443363157202,22.99462373644454,22.93284048647708,22.93189121623335,22.94240256506936,22.96932842563165,22.91238878606391,22.90574514774992,22.88944591394631,22.87233165364072]', 1786999097),
('DY8', 224.72566013, '[226.09900307874043,225.98648056688158,226.31042450163475,226.30668187447405,226.22575311741233,226.11163819037899,226.2437928651137,226.3291320811349,226.05402938388557,226.03824915663146,226.00732503070024,225.55592572387989,225.54151720195896,225.89233385530509,225.70630820922916,225.41649747604806,225.44394714592728,225.1323388119359,225.15350618876259,225.23399760281724,225.01113906848148,224.61373044770179,224.62469391705464,224.4131980784926,224.19291024409015,224.1151719500393,224.09076035109588,224.45667728831237,224.7028272398798,224.46707780835534,224.19740277390677,224.45290324371198,224.47305783906777,224.64203969430543,224.7682756222647,224.70768532458966,224.83049187344703,224.6604538567805,224.50369616054847,224.66075698806956,224.60415257180956,224.70692588183503,224.6882668054122,224.53576107996128,224.38220981905409,224.54532762777155,224.71162890593184,224.72566012532813]', 1786999097),
('ECL', 54.73037284, '[55.02345573820385,54.94148892855184,54.9833503377681,54.94386408541017,54.92364168640792,55.00500876855868,55.08703663423092,55.08179668758616,55.08476279026066,55.06874029522554,55.06471327955173,55.12580448310872,55.1414428942056,55.12003166336795,55.07349501658737,55.02101959008345,54.99635413593875,54.98613273323062,54.93022607007963,54.90475077707953,54.88346295946291,54.87971879880906,54.87826849536076,54.93316670776018,54.94408422842835,55.00147354388838,55.05662198004863,55.00657335612924,54.91972750769814,54.90980709203104,54.93275435981763,55.05341704910044,54.9774348533609,55.03650955848103,55.07150781848276,55.00502261974947,54.9836190422364,54.92175387014576,54.81509548606056,54.81812387983507,54.82422596087358,54.87364378759325,54.88776035515585,54.88101023554413,54.84099346991342,54.79554703528819,54.72847620913102,54.73037283731765]', 1786999097),
('ETD', 2687.39090785, '[2702.594132357598,2712.4315489104099,2695.9173043150979,2695.188167291694,2687.4805293632668,2681.874304014902,2687.2140902809867,2700.3655911008074,2695.704744164802,2689.70585536413,2689.1341258714189,2687.3364722290395,2685.5758452946968,2684.7061591940039,2685.933290046256,2687.411882237154,2686.2982528610416,2693.1592590618649,2694.2352604042687,2693.4798985594718,2686.4797810682578,2677.425603140569,2672.224284838845,2662.873637018707,2671.88845779237,2673.364279099739,2674.5878185292588,2680.344089199594,2679.382034754648,2682.9196254372,2686.1313077284914,2680.041914734384,2684.6631876293779,2686.6862519016715,2684.3380908921087,2686.521965339225,2687.4550255433366,2688.021289386935,2695.3224581985,2697.3125332586935,2691.113265031636,2694.2575415313747,2686.856840008244,2696.9787192321975,2691.2638493525635,2690.593868505759,2684.5062778323219,2687.390907847593]', 1786999097),
('FLC', 11.07296135, '[11.17601973080326,11.1325531030723,11.07595422633989,11.06163191650152,11.04013907700924,11.06124785909876,11.03134108890301,11.02248774424057,10.97793594608759,11.00004238918667,11.0801324858248,10.96743419256891,10.94903661495589,10.92052291123067,10.93714903544052,10.94970292339287,10.93852827524778,10.96608420051885,10.93654745460343,10.93409738302199,10.89218888613879,10.8561151049174,10.81531675500432,10.81110875348848,10.82882221262987,10.85112193096299,10.88314821593297,10.90074338172842,10.96100163756727,10.97822682498041,11.01367193852249,11.04362245339903,11.04539700144449,11.01658868292326,11.00465295722317,10.95589037477548,10.93909326854598,10.94411702745706,10.93294785145435,10.93940570769965,10.97293861505279,10.99794811720697,11.06341845287985,11.11809323476406,11.05276885575537,11.12367132778551,11.11728043485874,11.07296134970513]', 1786999097),
('FLY', 12.93632161, '[13.0566109194572,13.04017071782512,13.04067229435864,13.03176179696813,13.05240544005966,13.02179438426383,13.02195646424511,13.03131355852143,13.045309624061,13.03052377296954,13.01784014120654,12.98880491678552,12.99015631286649,12.99173316797735,12.97022602485902,13.00656375186871,12.99944725463145,12.96832183345213,12.95681398630034,12.98945780252423,12.9893919620938,12.99482257694339,13.00049372667441,12.97675295332113,12.99274184448634,12.98728150187995,12.97186215051174,12.95294281695609,12.96444678421711,12.96563271710434,12.96399704298676,12.93587555640146,12.92481723425066,12.94596564451552,12.96279076167264,12.95125593469797,12.93234172955096,12.91356927358273,12.89362577758972,12.88667196280362,12.89100452515535,12.89504051891882,12.90751923101038,12.91875312244185,12.93014137303774,12.91873632952439,12.9221997141634,12.93632161028752]', 1786999097),
('FRT', 335.92278094, '[340.3821058608262,340.8232900774743,340.5774591465219,340.89023231399877,340.7298754550953,340.2427842606431,340.2355492742063,339.96045041268806,339.3682344979351,339.11739612463546,338.41277874513465,337.96193439459696,337.622021213858,337.51505075181879,337.3142425856882,337.4090973579316,337.67459787122888,337.80208898319929,337.94109822395316,338.21289854227839,338.0413245574365,338.2771513987936,338.19433417542629,338.29175372621156,338.2028341094644,338.04066132083508,337.99291909459449,337.97494313341539,338.1046030734346,338.4839295472059,338.5930059363995,338.63597956775018,338.39984032009877,337.9080087240662,337.98094374910888,337.2778235853324,336.4504096008117,336.5235248604777,336.97929642654875,337.1152900262631,336.92118848515659,337.2818350331421,336.817212514501,336.71695062955248,336.61136189232988,336.1373097905322,335.76616518373199,335.9227809405495]', 1786999097),
('GPO', 46.23005894, '[46.50035034510917,46.55344106805494,46.55596039074375,46.57548573100482,46.61093727332065,46.61299450851097,46.57815909058585,46.53173656265368,46.51203839327412,46.53747210108888,46.5164745688683,46.50487823143447,46.4490685503152,46.45341336801808,46.49006276418671,46.44154005688891,46.35636233132126,46.35231502844132,46.3248055959987,46.32008874050145,46.26494338897527,46.29128244919332,46.27399392247968,46.36464941368766,46.36802331679821,46.39625581386823,46.34467967586347,46.33407316247563,46.34061908657461,46.31271684133693,46.36402641670377,46.38202882156101,46.41913737950157,46.44561123152995,46.441324934652,46.41751662708252,46.40606764803614,46.3688060256334,46.36174548534813,46.34165035099895,46.38018588181557,46.388206581893,46.38482753641601,46.41785832429909,46.42739194581015,46.36960327164464,46.29983666504113,46.23005893833432]', 1786999097),
('KIF', 38.37128558, '[37.97924413159948,37.99141590232647,37.86885792915564,37.993692808291,38.02895951716125,38.01140653413569,38.00810623337647,38.09529867969722,38.17250028500788,38.08732662499911,38.2731487442536,38.39550014889025,38.51095404966988,38.39793038916351,38.51425089062113,38.66602741837951,38.7676333919664,38.58647866019528,38.52621811496833,38.6822416340453,38.63745878916815,38.64025356596217,38.63483793669427,38.7345995365148,38.7394298532612,39.03978572757433,38.91505672557176,39.05945424534904,39.14931179232447,39.09913098099188,39.0283686215797,39.0424119506892,38.9164375855109,38.77702080483826,38.66811959017907,38.44544878799476,38.6762617715086,38.67220533703678,38.56357071142396,38.51228817139019,38.54965041452573,38.45718960330877,38.21467010124615,38.41045439185162,38.28698769985861,38.19221335743453,38.36085652786368,38.37128558487405]', 1786999097),
('LFI', 98.75001264, '[97.27351560680752,97.3251394374009,97.32062641392483,97.37244645645866,97.46762851852225,97.4571867678658,97.68491129795192,97.79338196372749,97.63581532246022,97.59529273756503,97.79363204055335,97.86226455736829,97.89655910299835,97.96071915448423,98.00592584964434,98.02413229469306,97.96249012461087,98.09523100876229,98.14641913848409,98.12210998385835,98.16526213379105,98.02909792557326,98.23582487929788,98.16979486446739,98.3791871165864,98.13164705224823,98.1236382221297,98.34132910322477,98.31519356811605,98.27207404479256,98.30225271797062,98.34019966817874,98.28266592876577,98.228931809419,98.17183226181366,98.43431639231123,98.26080097554385,98.33445838899209,98.51433677451219,98.5418491774635,98.38001226947157,98.49530443768272,98.56661177239028,98.49203511133006,98.42037447495098,98.5850074042654,98.61131110344573,98.75001264130556]', 1786999097),
('MAI', 59.92014833, '[60.40534277681085,60.46348687126473,60.54982493465577,60.47313001829956,60.51206527395479,60.48846151420044,60.4701834194508,60.44005515875984,60.51962081090756,60.55368598534206,60.44401935247197,60.38622159123264,60.38628528993814,60.48595506720229,60.39974531738728,60.39297316488854,60.32625497961995,60.32480248423979,60.28699570292768,60.32295952855483,60.30711722767615,60.27918902540045,60.25327970477351,60.23614846666139,60.18349286068163,60.14504402744339,60.15114887142236,60.1009683430536,60.1020076776819,60.05935582816572,60.08317591576172,60.07370554305021,60.0595535666041,60.02196438019644,59.94527515201474,59.91810936119611,59.89641631147327,59.86740351139013,59.9260797112143,59.88883618093715,59.8114468170919,59.86702458274534,59.86206657463061,59.93698716403348,60.01059122471602,59.90888673605443,59.90690404637579,59.9201483334052]', 1786999097),
('MZB', 220.62289428, '[222.25363326818747,222.5094034976129,222.40343175962415,222.41278118797735,222.26909908449793,222.0526791607739,221.85762608850849,221.65694555732819,221.46874715390335,221.45185394216427,221.4833655657011,221.46765613805955,221.3441243108079,221.35000106795185,221.16353850837053,221.0994165791217,221.09208996651916,220.92951175104487,220.99434718526684,221.17867970105949,221.482432142808,221.43028994161566,221.45665827788197,221.3539416900174,221.39110911302496,221.4356812166932,221.48513771777756,221.46092933847064,221.57449943112705,221.70659744968553,221.66981320194805,221.43440475829667,221.43645454599167,221.37807388918334,221.2470455403869,221.46038638300323,221.36522908051686,221.23004715787463,221.15061001693528,221.24629513670875,221.26428641806556,221.17944384542515,221.0163532564796,220.86292183113035,220.6877429752714,220.54380974634925,220.6184547203659,220.62289427970769]', 1786999097),
('MZC', 68.66228416, '[71.28090447521957,70.63779891477916,70.72125803448773,70.57438428841657,70.74128845190889,70.80196366856771,70.80092216960154,70.62342059553485,70.24590472637323,69.83688597909763,69.71134363629642,69.36961348247299,69.25254379596062,69.53332262383597,69.30195414098279,69.06431690768503,68.97300118572319,69.04450333333722,69.2231908708088,69.66702188829733,69.6523016141409,69.49678540358392,69.4286251533873,69.437039990065,69.32499229667877,69.51911241625358,69.5582407955315,69.49041499642942,69.12124218727944,68.98780920942089,68.9638759125031,69.16130866320826,68.93255193685426,68.75515180304386,68.83146516596081,69.00689816644655,69.16467275717261,68.50912982389575,68.56040393591886,68.71698251565947,68.85538356891796,68.682977813709,68.83510182421196,69.1888957380038,69.06374642378418,68.90673882432238,68.9360488112035,68.6622841603185]', 1786999097),
('PIS', 25.87875463, '[25.96295609943823,25.9544754889599,25.97979818501779,26.00383713045276,25.97686645033881,26.01353868269593,25.98601724139972,25.95143094443031,25.9388950561487,25.96456590104629,25.93761894298445,25.95501148542204,25.92815857305206,25.8919985480383,25.90930202352618,25.87076455094286,25.9312779102934,25.91853064430707,25.90806762546159,25.90822896402899,25.92188860416869,25.8911819341248,25.88352018354809,25.90923644315102,25.89440503193624,25.89746321598483,25.91041341075236,25.87792130930031,25.85880797832765,25.83218103139732,25.87633709174258,25.87390732854047,25.88893367105415,25.88036472892411,25.88044323832147,25.87457581255918,25.90358311012812,25.88979200770596,25.89218678462631,25.88301637930691,25.9437698850725,25.99707274221105,25.99374412156987,25.98631719587545,25.97638612186299,25.93570245794787,25.93594192889888,25.87875462574576]', 1786999097),
('POG', 1.95767977, '[1.97209761963351,1.97959778076631,1.97663737022652,1.97232517456516,1.96743485619589,1.97096612245369,1.96091443157252,1.96559997021026,1.96257253879053,1.97018352830522,1.96631490824362,1.96118421462933,1.95570535276105,1.95612567925636,1.96385856130483,1.96759835792235,1.96785186784267,1.97876795111802,1.96287078098442,1.95583119269751,1.9665737857968,1.97142904488427,1.97694521261305,1.96036999051373,1.96789099323906,1.97026232844863,1.97509713367394,1.97407150981516,1.96520452292867,1.96195744806982,1.95838831437178,1.955631554807,1.97037119395802,1.96442260791378,1.95397787452234,1.95010066808952,1.95114540752269,1.94941168842192,1.95873773034663,1.96228665886278,1.96329704492806,1.96036448365356,1.95602375690294,1.95050246035837,1.95433454033964,1.94283771790419,1.94855794442012,1.95767977244622]', 1786999097),
('RON', 135.88819533, '[135.9651298378405,136.11434434760168,136.1237695186518,135.96015121200973,136.11644953969029,136.37181074726093,136.4841655401522,136.55691815956505,136.4411461686641,136.3422621047644,136.43279049450477,136.51715472920214,136.24255669495543,136.3447396494958,136.24185696437113,136.35911099233926,136.50567836504548,136.62242710582468,136.77878233075374,136.91540047845909,136.94996687198216,136.63437434145744,136.69198448098443,136.61213270616933,136.71050721570527,136.55568842235616,136.53123616327094,136.39832148300537,136.6531126107765,136.69798584922138,136.74274316901419,136.82315895929436,136.88874756596028,136.9534757308951,136.93154708581415,137.0714828126414,137.15015182939767,137.13160987144108,136.998325476836,136.73261674646023,136.61017818838034,136.57862995630033,136.5019610878731,136.09861201399003,135.65441867433666,135.8213472206357,135.79201147932106,135.88819533104624]', 1786999097),
('RWD', 40.04880344, '[40.05968325389337,40.08666849742619,40.07574611054042,40.07995456485199,40.06025409936818,40.05353697834836,40.15080694628349,40.15986329834461,40.1590563248562,40.19159404902657,40.18506999569501,40.12187792272986,40.20431279398737,40.22634008049692,40.21926875406803,40.19886352727134,40.19105468835056,40.22998438834735,40.23180007068502,40.17205628658654,40.15374019357573,40.22149974066258,40.24594264989633,40.18197722585081,40.18712407489033,40.2064938064121,40.20262819028428,40.200091909045,40.19604733345256,40.18645050904425,40.07902501184887,40.04233696482319,40.04479035551822,40.02408133079079,40.07292326048577,40.09418623206169,40.06207214284614,40.00984447704881,39.98595689451478,40.03055142396961,40.05717555764912,40.0294627909175,40.05010924988439,40.03018291530225,40.04031555754931,40.05062305789202,40.05658226147438,40.04880343714668]', 1786999097),
('SDC', 91.76874236, '[91.81609835847428,91.7898549451643,91.67894259642545,91.51798211119359,91.61838058289705,91.59569678460399,91.85964781250884,92.06694034832522,92.19295056323114,92.32852583322453,92.51692762600776,92.31698970470943,92.32669010292719,92.13726184450553,92.33863174534302,91.91166466632167,91.66738566109152,91.6208748375651,91.85869520655476,91.92048198208775,91.70300505519468,91.44019532383746,91.88722416866098,92.14881976096877,92.19154892103124,92.29180111333968,91.9703652413414,91.84575168833412,91.60702868268709,91.33790499718386,91.13774867094669,91.44514106661217,91.38359339540037,90.90855278962407,90.80950545191571,90.68729897580936,90.54883885440622,90.69031199628403,90.47945168343796,90.60623477178646,90.75194211575558,90.73629972537477,91.08238785850132,91.15140010802962,91.17440267186272,91.38681598733898,91.7088110138695,91.76874235579055]', 1786999097),
('SPC', 4.75848120, '[4.75241394411342,4.73768975791506,4.74420279060007,4.75674630602747,4.74228941007575,4.74714188293881,4.7866146685877,4.78482631522173,4.81132146702108,4.8379809099327,4.83292006621151,4.82708234682125,4.82034448250588,4.80681532213921,4.80338147547692,4.79898042408618,4.77628991743085,4.77942305275205,4.78076293418503,4.75698403066228,4.73723938277189,4.74942843278209,4.74683839591367,4.75918645919588,4.76932417234989,4.77536749506364,4.74856575767926,4.75148113902089,4.74943902876793,4.71467504154958,4.7059286992789,4.70891224219813,4.68722018362485,4.69676602313096,4.72563180581736,4.69121102079232,4.6983008846219,4.70893006771006,4.70936452929447,4.73786941915899,4.76250865766637,4.76930028571636,4.76408594867339,4.78570779543778,4.8004358540901,4.77574211059591,4.77719706827428,4.75848120377386]', 1786999097),
('SPK', 32.27419309, '[32.02804424710132,32.07748373128369,32.04173069968762,32.06160410515476,32.12899542598894,32.1614963134881,32.17504439367233,32.17978699169445,32.1752901825439,32.13380521365524,32.12354078892019,32.16113169514531,32.12280577216847,32.13381943690798,32.15572925327765,32.17517893115924,32.18083695755817,32.19497983408826,32.21386611106931,32.20276196309794,32.2434687169849,32.21703912484037,32.16913863244138,32.1928808611663,32.26854122679136,32.21585615749479,32.25988067228331,32.19284135783832,32.16896968662566,32.2432038030346,32.1638738336168,32.22589828022757,32.19347649458451,32.16006198767119,32.21635392324921,32.24299140522643,32.29932473469458,32.28490712770907,32.29454066468397,32.25103806052986,32.29570989989548,32.25854882689562,32.29457894364697,32.28120411595303,32.29097642790822,32.29739062185216,32.30228458163895,32.27419308723424]', 1786999097),
('TNK', 87.71960019, '[87.91169263097794,87.84993748246518,87.71536417017366,87.58710920363014,87.58124461106475,87.52070734236446,87.53645411522995,87.59724678298918,87.50763848634796,87.44250025457481,87.31617003778288,87.24216731837748,87.25811081915143,87.23145277408807,87.16856023831849,87.07888048213238,87.18139033781097,87.2488926800151,87.19216633236184,87.35893942981726,87.29548236700275,87.28726550784093,87.24069876260234,87.31828683463906,87.32915239266628,87.46400177099722,87.45441411435192,87.52358381216183,87.50033288790964,87.53669848747004,87.51833173589873,87.62253313053971,87.8029386129563,87.73426116566917,87.69984696132511,87.78226872734973,87.65853812452476,87.53320901006771,87.40490999076806,87.45818332952894,87.49852100851271,87.68064884978642,87.59047619759659,87.7153984113467,87.57168975683851,87.58698178222984,87.6676613076844,87.71960018717967]', 1786999097),
('VAN', 69.28845390, '[68.80211458066195,68.8507997242517,68.89296815050594,68.89044596593293,69.00148491981337,69.06934319737694,69.16841734833784,69.17284424753358,69.14234801406853,69.10211024615905,69.1017004543545,69.15093911108639,69.08728275930996,69.04331926118974,69.06931676831124,68.98851184581025,68.96275311255028,68.94287700608284,68.90129464434944,68.7689426008959,68.7170997779743,68.6956829378422,68.79504160035585,68.74325431393163,68.76092079365407,68.85047381576594,68.81019047703097,68.81778211980846,68.82312707574481,68.80701296534407,68.8443066720738,68.84229375259587,68.84443957890223,68.89157956904202,68.918086109975,68.899670425806,68.8902588232258,68.96963083181181,68.97475730521696,68.95264088406538,68.99705090428737,69.05506708127266,69.15344615933747,69.21616193722118,69.1339190391348,69.19061372210233,69.34574044253634,69.28845390039598]', 1786999097),
('VAP', 131.43018792, '[130.43675416098126,130.38045574406949,130.4837115400848,130.42112767667335,130.48253138091676,130.3793430623711,130.3246075847158,130.41843078526308,130.1326248030719,130.12844750679268,130.2482488657552,130.40027000978905,130.32565351073127,130.32771358680038,130.5056316819369,130.5247876837024,130.5369636798943,130.65373503894888,130.75554718131856,130.72705750184179,130.77911607067905,130.76310602925217,130.88004568475777,130.86153676891173,130.93836808880404,130.98120153079149,131.03470679626688,131.19386750464725,131.38006671565283,131.42034817126993,131.51669871363183,131.58020735390614,131.59215400468828,131.41780625112419,131.50204250605536,131.52150937987623,131.54955787237476,131.7765285271818,131.63958082617268,131.7285338152348,131.695487164913,131.63009918438488,131.63834970457874,131.61532950888339,131.51325378726038,131.46210476106968,131.5425937336547,131.4301879178354]', 1786999097),
('VWC', 413.74322353, '[415.1031908604027,416.81317782747836,418.9209685673966,420.27360436108497,419.2019230456491,417.95268960432557,416.2894529214825,415.8603641931744,414.4862354811649,415.20233774906736,415.14573054097488,415.09782197346518,415.5295145590869,415.3865475898433,415.4771736620893,415.0719476296992,414.89238586335156,415.8919628335072,416.7820481409091,417.20852651376227,417.5499070263155,416.75773869119629,416.5001099529854,416.16289661730226,416.4786831406673,416.51457499925245,414.2941432798646,412.49741224339956,412.33640359836167,412.05206852254318,411.45868388736326,410.9985154426357,410.93074252785979,410.79985283759455,410.807567995538,412.28343764817228,412.67846519035899,412.94447410494987,412.3603216526428,411.9141472640668,410.9233405027347,409.8079701664056,410.996392514717,412.39692382623476,412.33029747646187,412.37765468293017,412.56161445746417,413.74322353038289]', 1786999097),
('WIZ', 59.31437984, '[59.24378039506837,59.28454324036062,59.31214855282415,59.22938980547502,59.28695687926182,59.28912514577553,59.30007586940172,59.30949543284065,59.23881799226393,59.26048422296984,59.25100574309588,59.22542645872095,59.2070247103337,59.21339155692135,59.13798329152782,59.18665788004425,59.32082857650387,59.23292725153477,59.21751473522257,59.19855870395639,59.2211508668782,59.2146539360832,59.28128008579821,59.18635137242483,59.20930440264007,59.1342188294847,59.05973591716837,59.10766429411772,59.11439928580996,59.1991880180723,59.08262520537472,59.0272896597035,59.02805537394024,59.21141094525234,59.23379039648853,59.31585272345477,59.37217652253321,59.34081927478269,59.30840474420858,59.30311771945669,59.27767883424554,59.40178120691225,59.26754393081498,59.21325024844866,59.25150510822521,59.25890233476448,59.32159385111304,59.31437983956469]', 1786999097),
('WZC', 0.57819663, '[0.55944104574921,0.56207648196202,0.56427726854041,0.56503798599427,0.56378903131317,0.5635859649806,0.56575436525853,0.56432908462569,0.56490866929826,0.561262207749,0.56242439696558,0.56351109811137,0.56535232170313,0.56915932428019,0.56874394613374,0.5677497661101,0.56828512427308,0.57177467844536,0.56943503250895,0.57247576489389,0.57363244264616,0.57611801190236,0.57609173597612,0.57474754495213,0.57351825063128,0.57160585356786,0.5723588806737,0.57247306890938,0.5761956926935,0.57640248430198,0.57662556298647,0.57682550971657,0.5808140440105,0.57791926813113,0.58206828582908,0.58056900667769,0.57878949510022,0.58037137993287,0.57677747592756,0.57591579528044,0.57537503053188,0.57602015604547,0.57576868316506,0.57287408201528,0.57351660314394,0.57655425786591,0.57727774411713,0.57819663057054]', 1786999097);

-- --------------------------------------------------------

--
-- Structure de la table `phone_stock_wallet`
--

CREATE TABLE `phone_stock_wallet` (
  `citizenid` varchar(64) NOT NULL,
  `cash` decimal(18,2) NOT NULL DEFAULT 0.00,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_streaks`
--

CREATE TABLE `phone_streaks` (
  `citizenid` varchar(64) NOT NULL,
  `current_streak` int(11) NOT NULL DEFAULT 0,
  `longest_streak` int(11) NOT NULL DEFAULT 0,
  `last_post_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_streak_likes`
--

CREATE TABLE `phone_streak_likes` (
  `post_id` int(11) NOT NULL,
  `citizenid` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_streak_posts`
--

CREATE TABLE `phone_streak_posts` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `author_name` varchar(80) NOT NULL,
  `image_url` varchar(512) NOT NULL,
  `caption` varchar(160) DEFAULT NULL,
  `day_streak` int(11) NOT NULL,
  `post_date` date NOT NULL,
  `like_count` int(11) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_timer_recents`
--

CREATE TABLE `phone_timer_recents` (
  `citizenid` varchar(60) NOT NULL,
  `seconds` int(10) UNSIGNED NOT NULL,
  `used_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_vibez_comments`
--

CREATE TABLE `phone_vibez_comments` (
  `id` varchar(16) NOT NULL,
  `post_id` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `body` varchar(500) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_vibez_comment_likes`
--

CREATE TABLE `phone_vibez_comment_likes` (
  `comment_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_vibez_follows`
--

CREATE TABLE `phone_vibez_follows` (
  `follower` varchar(64) NOT NULL,
  `target` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_vibez_likes`
--

CREATE TABLE `phone_vibez_likes` (
  `post_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_vibez_notifications`
--

CREATE TABLE `phone_vibez_notifications` (
  `id` varchar(16) NOT NULL,
  `recipient` varchar(64) NOT NULL,
  `kind` varchar(16) NOT NULL,
  `actor` varchar(64) NOT NULL,
  `post_id` varchar(16) DEFAULT NULL,
  `preview` varchar(200) DEFAULT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_vibez_posts`
--

CREATE TABLE `phone_vibez_posts` (
  `id` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `video` varchar(512) NOT NULL,
  `thumb` varchar(512) DEFAULT NULL,
  `caption` varchar(300) NOT NULL DEFAULT '',
  `sound` varchar(120) NOT NULL DEFAULT '',
  `views` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_vibez_profiles`
--

CREATE TABLE `phone_vibez_profiles` (
  `username` varchar(64) NOT NULL,
  `display_name` varchar(64) NOT NULL DEFAULT '',
  `bio` varchar(160) NOT NULL DEFAULT '',
  `avatar` varchar(512) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_vibez_saves`
--

CREATE TABLE `phone_vibez_saves` (
  `post_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_voice_memos`
--

CREATE TABLE `phone_voice_memos` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(120) NOT NULL,
  `url` varchar(512) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  `src_id` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_weazel_articles`
--

CREATE TABLE `phone_weazel_articles` (
  `id` int(11) NOT NULL,
  `category` varchar(24) NOT NULL,
  `headline` varchar(160) NOT NULL,
  `dek` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `author` varchar(80) NOT NULL,
  `author_cid` varchar(60) NOT NULL,
  `image` varchar(512) DEFAULT NULL,
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `views` int(11) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_weazel_breaking`
--

CREATE TABLE `phone_weazel_breaking` (
  `id` int(11) NOT NULL,
  `text` varchar(220) NOT NULL,
  `pos` int(11) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `phone_wifi`
--

CREATE TABLE `phone_wifi` (
  `citizenid` varchar(64) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `known` longtext DEFAULT NULL,
  `declined` longtext DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `playerskins`
--

CREATE TABLE `playerskins` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `player_outfits`
--

CREATE TABLE `player_outfits` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL DEFAULT '0',
  `model` varchar(50) DEFAULT NULL,
  `props` varchar(1000) DEFAULT NULL,
  `components` varchar(1500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `player_outfit_codes`
--

CREATE TABLE `player_outfit_codes` (
  `id` int(11) NOT NULL,
  `outfitid` int(11) NOT NULL,
  `code` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `rented_vehicles`
--

CREATE TABLE `rented_vehicles` (
  `vehicle` varchar(60) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `player_name` varchar(255) NOT NULL,
  `base_price` int(11) NOT NULL,
  `rent_price` int(11) NOT NULL,
  `owner` varchar(46) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `society_moneywash`
--

CREATE TABLE `society_moneywash` (
  `id` int(11) NOT NULL,
  `identifier` varchar(46) DEFAULT NULL,
  `society` varchar(60) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `identifier` varchar(46) NOT NULL,
  `ssn` varchar(11) NOT NULL,
  `accounts` longtext DEFAULT NULL,
  `group` varchar(50) DEFAULT 'user',
  `inventory` longtext DEFAULT NULL,
  `job` varchar(20) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `loadout` longtext DEFAULT NULL,
  `metadata` longtext DEFAULT NULL,
  `position` longtext DEFAULT NULL,
  `firstname` varchar(16) DEFAULT NULL,
  `lastname` varchar(16) DEFAULT NULL,
  `dateofbirth` varchar(10) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `skin` longtext DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `is_dead` tinyint(1) DEFAULT 0,
  `id` int(11) NOT NULL,
  `disabled` tinyint(1) DEFAULT 0,
  `last_property` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_seen` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `phone_number` varchar(20) DEFAULT NULL,
  `pincode` int(11) DEFAULT NULL,
  `job2` varchar(50) NOT NULL DEFAULT 'unemployed',
  `job2_grade` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`identifier`, `ssn`, `accounts`, `group`, `inventory`, `job`, `job_grade`, `loadout`, `metadata`, `position`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`, `skin`, `status`, `is_dead`, `id`, `disabled`, `last_property`, `created_at`, `last_seen`, `phone_number`, `pincode`, `job2`, `job2_grade`) VALUES
('char1:f6cb50aa7cd50fa658599060fe71faef79b4ff6d', '876-67-7693', '{\"bank\":50200,\"money\":0,\"black_money\":0}', 'admin', '[]', 'unemployed', 0, '[]', '{\"lastPlaytime\":403,\"health\":200,\"job2Duty\":false,\"jobDuty\":false,\"armor\":0}', '{\"y\":-859.8593139648438,\"z\":30.07177734375,\"heading\":56.69291305541992,\"x\":225.8373565673828}', 'Tanjiro', 'Dev', '14/09/1996', 'm', 172, '{\"headOverlays\":{\"blemishes\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"bodyBlemishes\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"ageing\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"beard\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"chestHair\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"eyebrows\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"complexion\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"makeUp\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"sunDamage\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"lipstick\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"blush\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0},\"moleAndFreckles\":{\"color\":0,\"opacity\":0,\"style\":0,\"secondColor\":0}},\"components\":[{\"component_id\":0,\"drawable\":0,\"texture\":0},{\"component_id\":1,\"drawable\":0,\"texture\":0},{\"component_id\":2,\"drawable\":0,\"texture\":0},{\"component_id\":3,\"drawable\":0,\"texture\":0},{\"component_id\":4,\"drawable\":0,\"texture\":0},{\"component_id\":5,\"drawable\":0,\"texture\":0},{\"component_id\":6,\"drawable\":0,\"texture\":0},{\"component_id\":7,\"drawable\":0,\"texture\":0},{\"component_id\":8,\"drawable\":0,\"texture\":0},{\"component_id\":9,\"drawable\":0,\"texture\":0},{\"component_id\":10,\"drawable\":0,\"texture\":0},{\"component_id\":11,\"drawable\":0,\"texture\":0}],\"hair\":{\"highlight\":0,\"color\":0,\"style\":0,\"texture\":0},\"eyeColor\":0,\"model\":\"mp_m_freemode_01\",\"headBlend\":{\"skinThird\":0,\"skinSecond\":0,\"shapeThird\":0,\"shapeFirst\":0,\"skinMix\":0,\"shapeSecond\":0,\"skinFirst\":0,\"shapeMix\":0,\"thirdMix\":0},\"props\":[{\"drawable\":-1,\"prop_id\":0,\"texture\":-1},{\"drawable\":-1,\"prop_id\":1,\"texture\":-1},{\"drawable\":-1,\"prop_id\":2,\"texture\":-1},{\"drawable\":-1,\"prop_id\":6,\"texture\":-1},{\"drawable\":-1,\"prop_id\":7,\"texture\":-1}],\"tattoos\":[],\"faceFeatures\":{\"chinBoneLowering\":0,\"chinBoneLenght\":0,\"cheeksBoneWidth\":0,\"noseWidth\":0,\"jawBoneBackSize\":0,\"cheeksBoneHigh\":0,\"chinHole\":0,\"eyeBrownForward\":0,\"lipsThickness\":0,\"cheeksWidth\":0,\"nosePeakSize\":0,\"eyeBrownHigh\":0,\"eyesOpening\":0,\"neckThickness\":0,\"jawBoneWidth\":0,\"noseBoneTwist\":0,\"nosePeakHigh\":0,\"noseBoneHigh\":0,\"chinBoneSize\":0,\"nosePeakLowering\":0}}', '[{\"percent\":0.0,\"val\":0,\"name\":\"drunk\"},{\"percent\":99.42,\"val\":994200,\"name\":\"hunger\"},{\"percent\":99.565,\"val\":995650,\"name\":\"thirst\"}]', 0, 12, 0, NULL, '2026-08-17 19:50:11', '2026-08-17 20:24:29', NULL, NULL, 'unemployed', 0),
('f6cb50aa7cd50fa658599060fe71faef79b4ff6d', '067-81-3271', '{\"money\":0,\"black_money\":0,\"bank\":50200}', 'admin', '[]', 'unemployed', 0, '[]', '{\"armor\":0,\"health\":200,\"job2Duty\":false,\"lastPlaytime\":255,\"jobDuty\":false}', '{\"heading\":255.11810302734376,\"x\":27.81099128723144,\"y\":-1347.4945068359376,\"z\":29.4820556640625}', 'Tanjiro', 'Studio', '14/09/1996', 'm', 172, '{\"model\":\"mp_m_freemode_01\",\"eyeColor\":0,\"hair\":{\"highlight\":0,\"style\":0,\"texture\":0,\"color\":0},\"headBlend\":{\"shapeFirst\":0,\"skinFirst\":0,\"skinThird\":0,\"skinSecond\":0,\"shapeThird\":0,\"shapeSecond\":0,\"shapeMix\":0,\"skinMix\":0,\"thirdMix\":0},\"tattoos\":[],\"props\":[{\"prop_id\":0,\"drawable\":-1,\"texture\":-1},{\"prop_id\":1,\"drawable\":-1,\"texture\":-1},{\"prop_id\":2,\"drawable\":-1,\"texture\":-1},{\"prop_id\":6,\"drawable\":-1,\"texture\":-1},{\"prop_id\":7,\"drawable\":-1,\"texture\":-1}],\"headOverlays\":{\"sunDamage\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"eyebrows\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"blush\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"complexion\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"lipstick\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"moleAndFreckles\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"ageing\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"makeUp\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"bodyBlemishes\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"beard\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"blemishes\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0},\"chestHair\":{\"style\":0,\"secondColor\":0,\"opacity\":0,\"color\":0}},\"components\":[{\"drawable\":0,\"component_id\":0,\"texture\":0},{\"drawable\":0,\"component_id\":1,\"texture\":0},{\"drawable\":0,\"component_id\":2,\"texture\":0},{\"drawable\":0,\"component_id\":3,\"texture\":0},{\"drawable\":0,\"component_id\":4,\"texture\":0},{\"drawable\":0,\"component_id\":5,\"texture\":0},{\"drawable\":0,\"component_id\":6,\"texture\":0},{\"drawable\":0,\"component_id\":7,\"texture\":0},{\"drawable\":0,\"component_id\":8,\"texture\":0},{\"drawable\":0,\"component_id\":9,\"texture\":0},{\"drawable\":0,\"component_id\":10,\"texture\":0},{\"drawable\":0,\"component_id\":11,\"texture\":0}],\"faceFeatures\":{\"chinHole\":0,\"chinBoneLowering\":0,\"neckThickness\":0,\"jawBoneWidth\":0,\"nosePeakLowering\":0,\"noseBoneHigh\":0,\"cheeksBoneHigh\":0,\"eyeBrownHigh\":0,\"noseBoneTwist\":0,\"nosePeakSize\":0,\"nosePeakHigh\":0,\"cheeksBoneWidth\":0,\"eyesOpening\":0,\"jawBoneBackSize\":0,\"cheeksWidth\":0,\"noseWidth\":0,\"lipsThickness\":0,\"chinBoneSize\":0,\"chinBoneLenght\":0,\"eyeBrownForward\":0}}', NULL, 0, 11, 0, NULL, '2026-08-17 16:57:46', '2026-08-17 17:01:25', NULL, NULL, 'unemployed', 0);

-- --------------------------------------------------------

--
-- Structure de la table `user_licenses`
--

CREATE TABLE `user_licenses` (
  `id` int(11) NOT NULL,
  `type` varchar(60) NOT NULL,
  `owner` varchar(46) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `vehicles`
--

CREATE TABLE `vehicles` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `vehicles`
--

INSERT INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES
('Adder', 'adder', 900000, 'super'),
('Akuma', 'AKUMA', 7500, 'motorcycles'),
('Alpha', 'alpha', 60000, 'sports'),
('Ardent', 'ardent', 1150000, 'sportsclassics'),
('Asea', 'asea', 5500, 'sedans'),
('Autarch', 'autarch', 1955000, 'super'),
('Avarus', 'avarus', 18000, 'motorcycles'),
('Bagger', 'bagger', 13500, 'motorcycles'),
('Baller', 'baller2', 40000, 'suvs'),
('Baller Sport', 'baller3', 60000, 'suvs'),
('Banshee', 'banshee', 70000, 'sports'),
('Banshee 900R', 'banshee2', 255000, 'super'),
('Bati 801', 'bati', 12000, 'motorcycles'),
('Bati 801RR', 'bati2', 19000, 'motorcycles'),
('Bestia GTS', 'bestiagts', 55000, 'sports'),
('BF400', 'bf400', 6500, 'motorcycles'),
('Bf Injection', 'bfinjection', 16000, 'offroad'),
('Bifta', 'bifta', 12000, 'offroad'),
('Bison', 'bison', 45000, 'vans'),
('Blade', 'blade', 15000, 'muscle'),
('Blazer', 'blazer', 6500, 'offroad'),
('Blazer Sport', 'blazer4', 8500, 'offroad'),
('blazer5', 'blazer5', 1755600, 'offroad'),
('Blista', 'blista', 8000, 'compacts'),
('BMX (velo)', 'bmx', 160, 'motorcycles'),
('Bobcat XL', 'bobcatxl', 32000, 'vans'),
('Brawler', 'brawler', 45000, 'offroad'),
('Brioso R/A', 'brioso', 18000, 'compacts'),
('Btype', 'btype', 62000, 'sportsclassics'),
('Btype Hotroad', 'btype2', 155000, 'sportsclassics'),
('Btype Luxe', 'btype3', 85000, 'sportsclassics'),
('Buccaneer', 'buccaneer', 18000, 'muscle'),
('Buccaneer Rider', 'buccaneer2', 24000, 'muscle'),
('Buffalo', 'buffalo', 12000, 'sports'),
('Buffalo S', 'buffalo2', 20000, 'sports'),
('Bullet', 'bullet', 90000, 'super'),
('Burrito', 'burrito3', 19000, 'vans'),
('Camper', 'camper', 42000, 'vans'),
('Carbonizzare', 'carbonizzare', 75000, 'sports'),
('Carbon RS', 'carbonrs', 18000, 'motorcycles'),
('Casco', 'casco', 30000, 'sportsclassics'),
('Cavalcade', 'cavalcade2', 55000, 'suvs'),
('Cheetah', 'cheetah', 375000, 'super'),
('Chimera', 'chimera', 38000, 'motorcycles'),
('Chino', 'chino', 15000, 'muscle'),
('Chino Luxe', 'chino2', 19000, 'muscle'),
('Cliffhanger', 'cliffhanger', 9500, 'motorcycles'),
('Cognoscenti Cabrio', 'cogcabrio', 55000, 'coupes'),
('Cognoscenti', 'cognoscenti', 55000, 'sedans'),
('Comet', 'comet2', 65000, 'sports'),
('Comet SR', 'comet5', 1145000, 'sports'),
('Contender', 'contender', 70000, 'suvs'),
('Coquette', 'coquette', 65000, 'sports'),
('Coquette Classic', 'coquette2', 40000, 'sportsclassics'),
('Coquette BlackFin', 'coquette3', 55000, 'muscle'),
('Cruiser (velo)', 'cruiser', 510, 'motorcycles'),
('Cyclone', 'cyclone', 1890000, 'super'),
('Daemon', 'daemon', 11500, 'motorcycles'),
('Daemon High', 'daemon2', 13500, 'motorcycles'),
('Defiler', 'defiler', 9800, 'motorcycles'),
('Deluxo', 'deluxo', 4721500, 'sportsclassics'),
('Dominator', 'dominator', 35000, 'muscle'),
('Double T', 'double', 28000, 'motorcycles'),
('Dubsta', 'dubsta', 45000, 'suvs'),
('Dubsta Luxuary', 'dubsta2', 60000, 'suvs'),
('Bubsta 6x6', 'dubsta3', 120000, 'offroad'),
('Dukes', 'dukes', 28000, 'muscle'),
('Dune Buggy', 'dune', 8000, 'offroad'),
('Elegy', 'elegy2', 38500, 'sports'),
('Emperor', 'emperor', 8500, 'sedans'),
('Enduro', 'enduro', 5500, 'motorcycles'),
('Entity XF', 'entityxf', 425000, 'super'),
('Esskey', 'esskey', 4200, 'motorcycles'),
('Exemplar', 'exemplar', 32000, 'coupes'),
('F620', 'f620', 40000, 'coupes'),
('Faction', 'faction', 20000, 'muscle'),
('Faction Rider', 'faction2', 30000, 'muscle'),
('Faction XL', 'faction3', 40000, 'muscle'),
('Faggio', 'faggio', 1900, 'motorcycles'),
('Vespa', 'faggio2', 2800, 'motorcycles'),
('Felon', 'felon', 42000, 'coupes'),
('Felon GT', 'felon2', 55000, 'coupes'),
('Feltzer', 'feltzer2', 55000, 'sports'),
('Stirling GT', 'feltzer3', 65000, 'sportsclassics'),
('Fixter (velo)', 'fixter', 225, 'motorcycles'),
('FMJ', 'fmj', 185000, 'super'),
('Fhantom', 'fq2', 17000, 'suvs'),
('Fugitive', 'fugitive', 12000, 'sedans'),
('Furore GT', 'furoregt', 45000, 'sports'),
('Fusilade', 'fusilade', 40000, 'sports'),
('Gargoyle', 'gargoyle', 16500, 'motorcycles'),
('Gauntlet', 'gauntlet', 30000, 'muscle'),
('Gang Burrito', 'gburrito', 45000, 'vans'),
('Burrito', 'gburrito2', 29000, 'vans'),
('Glendale', 'glendale', 6500, 'sedans'),
('Grabger', 'granger', 50000, 'suvs'),
('Gresley', 'gresley', 47500, 'suvs'),
('GT 500', 'gt500', 785000, 'sportsclassics'),
('Guardian', 'guardian', 45000, 'offroad'),
('Hakuchou', 'hakuchou', 31000, 'motorcycles'),
('Hakuchou Sport', 'hakuchou2', 55000, 'motorcycles'),
('Hermes', 'hermes', 535000, 'muscle'),
('Hexer', 'hexer', 12000, 'motorcycles'),
('Hotknife', 'hotknife', 125000, 'muscle'),
('Huntley S', 'huntley', 40000, 'suvs'),
('Hustler', 'hustler', 625000, 'muscle'),
('Infernus', 'infernus', 180000, 'super'),
('Innovation', 'innovation', 23500, 'motorcycles'),
('Intruder', 'intruder', 7500, 'sedans'),
('Issi', 'issi2', 10000, 'compacts'),
('Jackal', 'jackal', 38000, 'coupes'),
('Jester', 'jester', 65000, 'sports'),
('Jester(Racecar)', 'jester2', 135000, 'sports'),
('Journey', 'journey', 6500, 'vans'),
('Kamacho', 'kamacho', 345000, 'offroad'),
('Khamelion', 'khamelion', 38000, 'sports'),
('Kuruma', 'kuruma', 30000, 'sports'),
('Landstalker', 'landstalker', 35000, 'suvs'),
('RE-7B', 'le7b', 325000, 'super'),
('Lynx', 'lynx', 40000, 'sports'),
('Mamba', 'mamba', 70000, 'sports'),
('Manana', 'manana', 12800, 'sportsclassics'),
('Manchez', 'manchez', 5300, 'motorcycles'),
('Massacro', 'massacro', 65000, 'sports'),
('Massacro(Racecar)', 'massacro2', 130000, 'sports'),
('Mesa', 'mesa', 16000, 'suvs'),
('Mesa Trail', 'mesa3', 40000, 'suvs'),
('Minivan', 'minivan', 13000, 'vans'),
('Monroe', 'monroe', 55000, 'sportsclassics'),
('The Liberator', 'monster', 210000, 'offroad'),
('Moonbeam', 'moonbeam', 18000, 'vans'),
('Moonbeam Rider', 'moonbeam2', 35000, 'vans'),
('Nemesis', 'nemesis', 5800, 'motorcycles'),
('Neon', 'neon', 1500000, 'sports'),
('Nightblade', 'nightblade', 35000, 'motorcycles'),
('Nightshade', 'nightshade', 65000, 'muscle'),
('9F', 'ninef', 65000, 'sports'),
('9F Cabrio', 'ninef2', 80000, 'sports'),
('Omnis', 'omnis', 35000, 'sports'),
('Oppressor', 'oppressor', 3524500, 'super'),
('Oracle XS', 'oracle2', 35000, 'coupes'),
('Osiris', 'osiris', 160000, 'super'),
('Panto', 'panto', 10000, 'compacts'),
('Paradise', 'paradise', 19000, 'vans'),
('Pariah', 'pariah', 1420000, 'sports'),
('Patriot', 'patriot', 55000, 'suvs'),
('PCJ-600', 'pcj', 6200, 'motorcycles'),
('Penumbra', 'penumbra', 28000, 'sports'),
('Pfister', 'pfister811', 85000, 'super'),
('Phoenix', 'phoenix', 12500, 'muscle'),
('Picador', 'picador', 18000, 'muscle'),
('Pigalle', 'pigalle', 20000, 'sportsclassics'),
('Prairie', 'prairie', 12000, 'compacts'),
('Premier', 'premier', 8000, 'sedans'),
('Primo Custom', 'primo2', 14000, 'sedans'),
('X80 Proto', 'prototipo', 2500000, 'super'),
('Radius', 'radi', 29000, 'suvs'),
('raiden', 'raiden', 1375000, 'sports'),
('Rapid GT', 'rapidgt', 35000, 'sports'),
('Rapid GT Convertible', 'rapidgt2', 45000, 'sports'),
('Rapid GT3', 'rapidgt3', 885000, 'sportsclassics'),
('Reaper', 'reaper', 150000, 'super'),
('Rebel', 'rebel2', 35000, 'offroad'),
('Regina', 'regina', 5000, 'sedans'),
('Retinue', 'retinue', 615000, 'sportsclassics'),
('Revolter', 'revolter', 1610000, 'sports'),
('riata', 'riata', 380000, 'offroad'),
('Rocoto', 'rocoto', 45000, 'suvs'),
('Ruffian', 'ruffian', 6800, 'motorcycles'),
('Ruiner 2', 'ruiner2', 5745600, 'muscle'),
('Rumpo', 'rumpo', 15000, 'vans'),
('Rumpo Trail', 'rumpo3', 19500, 'vans'),
('Sabre Turbo', 'sabregt', 20000, 'muscle'),
('Sabre GT', 'sabregt2', 25000, 'muscle'),
('Sanchez', 'sanchez', 5300, 'motorcycles'),
('Sanchez Sport', 'sanchez2', 5300, 'motorcycles'),
('Sanctus', 'sanctus', 25000, 'motorcycles'),
('Sandking', 'sandking', 55000, 'offroad'),
('Savestra', 'savestra', 990000, 'sportsclassics'),
('SC 1', 'sc1', 1603000, 'super'),
('Schafter', 'schafter2', 25000, 'sedans'),
('Schafter V12', 'schafter3', 50000, 'sports'),
('Scorcher (velo)', 'scorcher', 280, 'motorcycles'),
('Seminole', 'seminole', 25000, 'suvs'),
('Sentinel', 'sentinel', 32000, 'coupes'),
('Sentinel XS', 'sentinel2', 40000, 'coupes'),
('Sentinel3', 'sentinel3', 650000, 'sports'),
('Seven 70', 'seven70', 39500, 'sports'),
('ETR1', 'sheava', 220000, 'super'),
('Shotaro Concept', 'shotaro', 320000, 'motorcycles'),
('Slam Van', 'slamvan3', 11500, 'muscle'),
('Sovereign', 'sovereign', 22000, 'motorcycles'),
('Stinger', 'stinger', 80000, 'sportsclassics'),
('Stinger GT', 'stingergt', 75000, 'sportsclassics'),
('Streiter', 'streiter', 500000, 'sports'),
('Stretch', 'stretch', 90000, 'sedans'),
('Stromberg', 'stromberg', 3185350, 'sports'),
('Sultan', 'sultan', 15000, 'sports'),
('Sultan RS', 'sultanrs', 65000, 'super'),
('Super Diamond', 'superd', 130000, 'sedans'),
('Surano', 'surano', 50000, 'sports'),
('Surfer', 'surfer', 12000, 'vans'),
('T20', 't20', 300000, 'super'),
('Tailgater', 'tailgater', 30000, 'sedans'),
('Tampa', 'tampa', 16000, 'muscle'),
('Drift Tampa', 'tampa2', 80000, 'sports'),
('Thrust', 'thrust', 24000, 'motorcycles'),
('Tri bike (velo)', 'tribike3', 520, 'motorcycles'),
('Trophy Truck', 'trophytruck', 60000, 'offroad'),
('Trophy Truck Limited', 'trophytruck2', 80000, 'offroad'),
('Tropos', 'tropos', 40000, 'sports'),
('Turismo R', 'turismor', 350000, 'super'),
('Tyrus', 'tyrus', 600000, 'super'),
('Vacca', 'vacca', 120000, 'super'),
('Vader', 'vader', 7200, 'motorcycles'),
('Verlierer', 'verlierer2', 70000, 'sports'),
('Vigero', 'vigero', 12500, 'muscle'),
('Virgo', 'virgo', 14000, 'muscle'),
('Viseris', 'viseris', 875000, 'sportsclassics'),
('Visione', 'visione', 2250000, 'super'),
('Voltic', 'voltic', 90000, 'super'),
('Voltic 2', 'voltic2', 3830400, 'super'),
('Voodoo', 'voodoo', 7200, 'muscle'),
('Vortex', 'vortex', 9800, 'motorcycles'),
('Warrener', 'warrener', 4000, 'sedans'),
('Washington', 'washington', 9000, 'sedans'),
('Windsor', 'windsor', 95000, 'coupes'),
('Windsor Drop', 'windsor2', 125000, 'coupes'),
('Woflsbane', 'wolfsbane', 9000, 'motorcycles'),
('XLS', 'xls', 32000, 'suvs'),
('Yosemite', 'yosemite', 485000, 'muscle'),
('Youga', 'youga', 10800, 'vans'),
('Youga Luxuary', 'youga2', 14500, 'vans'),
('Z190', 'z190', 900000, 'sportsclassics'),
('Zentorno', 'zentorno', 1500000, 'super'),
('Zion', 'zion', 36000, 'coupes'),
('Zion Cabrio', 'zion2', 45000, 'coupes'),
('Zombie', 'zombiea', 9500, 'motorcycles'),
('Zombie Luxuary', 'zombieb', 12000, 'motorcycles'),
('Z-Type', 'ztype', 220000, 'sportsclassics');

-- --------------------------------------------------------

--
-- Structure de la table `vehicles_category`
--

CREATE TABLE `vehicles_category` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `vehicles_category`
--

INSERT INTO `vehicles_category` (`name`, `label`) VALUES
('commercial', 'Commercial'),
('compacts', 'Compacts'),
('coupes', 'Coupes'),
('cycles', 'Cycles'),
('emergency', 'Urgences'),
('motorcycles', 'Motorcycles'),
('muscle', 'Muscle'),
('offroad', 'Off Road'),
('sedans', 'Sedans'),
('sports', 'Sports'),
('sportsclassics', 'Sports Classics'),
('super', 'Super'),
('suvs', 'SUVs'),
('utility', 'Utility'),
('vans', 'Vans');

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_categories`
--

CREATE TABLE `vehicle_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Déchargement des données de la table `vehicle_categories`
--

INSERT INTO `vehicle_categories` (`name`, `label`) VALUES
('compacts', 'Compacts'),
('coupes', 'Coupés'),
('motorcycles', 'Motos'),
('muscle', 'Muscle'),
('offroad', 'Off Road'),
('sedans', 'Sedans'),
('sports', 'Sports'),
('sportsclassics', 'Sports Classics'),
('super', 'Super'),
('suvs', 'SUVs'),
('vans', 'Vans');

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_sold`
--

CREATE TABLE `vehicle_sold` (
  `id` int(11) NOT NULL,
  `client` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `plate` varchar(50) NOT NULL,
  `soldby` varchar(50) NOT NULL,
  `date` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `whitelist`
--

CREATE TABLE `whitelist` (
  `identifier` varchar(46) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `addon_account`
--
ALTER TABLE `addon_account`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `addon_account_data`
--
ALTER TABLE `addon_account_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_addon_account_data_account_name_owner` (`account_name`,`owner`),
  ADD KEY `index_addon_account_data_account_name` (`account_name`);

--
-- Index pour la table `addon_inventory`
--
ALTER TABLE `addon_inventory`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `index_addon_inventory_items_inventory_name_name` (`inventory_name`,`name`),
  ADD KEY `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`,`name`,`owner`),
  ADD KEY `index_addon_inventory_inventory_name` (`inventory_name`);

--
-- Index pour la table `banking`
--
ALTER TABLE `banking`
  ADD PRIMARY KEY (`ID`);

--
-- Index pour la table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cardealer_vehicles`
--
ALTER TABLE `cardealer_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `darkchat_bans`
--
ALTER TABLE `darkchat_bans`
  ADD PRIMARY KEY (`room_id`,`citizenid`),
  ADD KEY `idx_fk_darkchat_bans_room` (`room_id`);

--
-- Index pour la table `darkchat_members`
--
ALTER TABLE `darkchat_members`
  ADD PRIMARY KEY (`room_id`,`citizenid`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `idx_fk_darkchat_members_room` (`room_id`);

--
-- Index pour la table `darkchat_messages`
--
ALTER TABLE `darkchat_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`,`id`),
  ADD KEY `idx_fk_darkchat_messages_room` (`room_id`);

--
-- Index pour la table `darkchat_nicknames`
--
ALTER TABLE `darkchat_nicknames`
  ADD PRIMARY KEY (`citizenid`);

--
-- Index pour la table `darkchat_reactions`
--
ALTER TABLE `darkchat_reactions`
  ADD PRIMARY KEY (`message_id`,`citizenid`,`emoji`),
  ADD KEY `message_id` (`message_id`),
  ADD KEY `idx_fk_darkchat_reactions_message` (`message_id`);

--
-- Index pour la table `darkchat_rooms`
--
ALTER TABLE `darkchat_rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Index pour la table `datastore`
--
ALTER TABLE `datastore`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `datastore_data`
--
ALTER TABLE `datastore_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_datastore_data_name_owner` (`name`,`owner`),
  ADD KEY `index_datastore_data_name` (`name`);

--
-- Index pour la table `fine_types`
--
ALTER TABLE `fine_types`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `job2_grades`
--
ALTER TABLE `job2_grades`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `jobs2`
--
ALTER TABLE `jobs2`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `job_grades`
--
ALTER TABLE `job_grades`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `licenses`
--
ALTER TABLE `licenses`
  ADD PRIMARY KEY (`type`);

--
-- Index pour la table `management_outfits`
--
ALTER TABLE `management_outfits`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `marketplace_listings`
--
ALTER TABLE `marketplace_listings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `created_at` (`created_at`);

--
-- Index pour la table `multicharacter_slots`
--
ALTER TABLE `multicharacter_slots`
  ADD PRIMARY KEY (`identifier`) USING BTREE,
  ADD KEY `slots` (`slots`) USING BTREE;

--
-- Index pour la table `nexora_playtime`
--
ALTER TABLE `nexora_playtime`
  ADD PRIMARY KEY (`identifier`);

--
-- Index pour la table `owned_vehicles`
--
ALTER TABLE `owned_vehicles`
  ADD PRIMARY KEY (`plate`);

--
-- Index pour la table `ox_inventory_settings`
--
ALTER TABLE `ox_inventory_settings`
  ADD PRIMARY KEY (`owner`);

--
-- Index pour la table `pages_posts`
--
ALTER TABLE `pages_posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `created_at` (`created_at`);

--
-- Index pour la table `phone_admin_audit`
--
ALTER TABLE `phone_admin_audit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_admin_audit_target` (`target_cid`);

--
-- Index pour la table `phone_admin_mutes`
--
ALTER TABLE `phone_admin_mutes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_mute` (`citizenid`,`scope`);

--
-- Index pour la table `phone_alarms`
--
ALTER TABLE `phone_alarms`
  ADD PRIMARY KEY (`citizenid`,`id`),
  ADD KEY `bytime` (`citizenid`,`hour`,`minute`);

--
-- Index pour la table `phone_app_accounts`
--
ALTER TABLE `phone_app_accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_app_username` (`app`,`username`),
  ADD KEY `idx_app_accounts_creator` (`app`,`created_by`);

--
-- Index pour la table `phone_app_sessions`
--
ALTER TABLE `phone_app_sessions`
  ADD PRIMARY KEY (`app`,`citizenid`,`account_id`),
  ADD KEY `idx_app_sessions_active` (`app`,`citizenid`,`last_used`),
  ADD KEY `idx_fk_app_sessions_account` (`account_id`);

--
-- Index pour la table `phone_bank_transactions`
--
ALTER TABLE `phone_bank_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_bank_tx_src` (`src_id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `created_at` (`created_at`);

--
-- Index pour la table `phone_birdy_dms`
--
ALTER TABLE `phone_birdy_dms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_birdy_dms_from` (`from_handle`),
  ADD KEY `idx_birdy_dms_to` (`to_handle`);

--
-- Index pour la table `phone_birdy_follows`
--
ALTER TABLE `phone_birdy_follows`
  ADD PRIMARY KEY (`follower`,`target`),
  ADD KEY `idx_birdy_follows_target` (`target`);

--
-- Index pour la table `phone_birdy_likes`
--
ALTER TABLE `phone_birdy_likes`
  ADD PRIMARY KEY (`post_id`,`handle`),
  ADD KEY `idx_birdy_likes_post` (`post_id`),
  ADD KEY `idx_fk_birdy_likes_post` (`post_id`);

--
-- Index pour la table `phone_birdy_notifications`
--
ALTER TABLE `phone_birdy_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_birdy_notifs_recipient` (`recipient`,`created_at`),
  ADD KEY `idx_birdy_notifs_unseen` (`recipient`,`seen`),
  ADD KEY `idx_birdy_notifs_dedupe` (`recipient`,`kind`,`actor`,`post_id`),
  ADD KEY `idx_fk_birdy_notifications_post` (`post_id`);

--
-- Index pour la table `phone_birdy_posts`
--
ALTER TABLE `phone_birdy_posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_birdy_posts_author` (`author`),
  ADD KEY `idx_birdy_posts_parent` (`parent_id`),
  ADD KEY `idx_birdy_posts_created` (`created_at`);

--
-- Index pour la table `phone_birdy_profiles`
--
ALTER TABLE `phone_birdy_profiles`
  ADD PRIMARY KEY (`handle`),
  ADD KEY `idx_birdy_profiles_creator` (`citizenid`);

--
-- Index pour la table `phone_birdy_reposts`
--
ALTER TABLE `phone_birdy_reposts`
  ADD PRIMARY KEY (`post_id`,`handle`),
  ADD KEY `idx_birdy_reposts_post` (`post_id`),
  ADD KEY `idx_fk_birdy_reposts_post` (`post_id`);

--
-- Index pour la table `phone_blocked`
--
ALTER TABLE `phone_blocked`
  ADD PRIMARY KEY (`citizenid`,`number`);

--
-- Index pour la table `phone_bluetooth`
--
ALTER TABLE `phone_bluetooth`
  ADD PRIMARY KEY (`citizenid`);

--
-- Index pour la table `phone_calls`
--
ALTER TABLE `phone_calls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_calls_cid` (`citizenid`);

--
-- Index pour la table `phone_casino_chips`
--
ALTER TABLE `phone_casino_chips`
  ADD PRIMARY KEY (`citizenid`);

--
-- Index pour la table `phone_cherry_blocks`
--
ALTER TABLE `phone_cherry_blocks`
  ADD PRIMARY KEY (`blocker`,`blocked`);

--
-- Index pour la table `phone_cherry_matches`
--
ALTER TABLE `phone_cherry_matches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cherry_pair` (`a`,`b`),
  ADD KEY `idx_cherry_match_b` (`b`);

--
-- Index pour la table `phone_cherry_messages`
--
ALTER TABLE `phone_cherry_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cherry_msgs_thread` (`match_id`,`created_at`),
  ADD KEY `idx_fk_cherry_messages_match` (`match_id`);

--
-- Index pour la table `phone_cherry_profiles`
--
ALTER TABLE `phone_cherry_profiles`
  ADD PRIMARY KEY (`username`);

--
-- Index pour la table `phone_cherry_swipes`
--
ALTER TABLE `phone_cherry_swipes`
  ADD PRIMARY KEY (`swiper`,`target`),
  ADD KEY `idx_cherry_swipes_target` (`target`,`liked`);

--
-- Index pour la table `phone_contacts`
--
ALTER TABLE `phone_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_contacts_cid` (`citizenid`),
  ADD KEY `idx_phone_contacts_cid_name` (`citizenid`,`name`);

--
-- Index pour la table `phone_cookie`
--
ALTER TABLE `phone_cookie`
  ADD PRIMARY KEY (`citizenid`),
  ADD KEY `earned` (`earned`);

--
-- Index pour la table `phone_custom_ringtones`
--
ALTER TABLE `phone_custom_ringtones`
  ADD PRIMARY KEY (`citizenid`,`id`);

--
-- Index pour la table `phone_documents`
--
ALTER TABLE `phone_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_documents_folder` (`citizenid`,`folder_id`),
  ADD KEY `idx_phone_documents_updated` (`citizenid`,`updated_at`),
  ADD KEY `idx_fk_documents_folder` (`folder_id`);

--
-- Index pour la table `phone_document_folders`
--
ALTER TABLE `phone_document_folders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_document_folders_cid` (`citizenid`);

--
-- Index pour la table `phone_document_signatures`
--
ALTER TABLE `phone_document_signatures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_document_signatures_doc` (`doc_id`);

--
-- Index pour la table `phone_friends`
--
ALTER TABLE `phone_friends`
  ADD PRIMARY KEY (`owner`,`friend`),
  ADD KEY `idx_phone_friends_friend` (`friend`,`share`,`pending`);

--
-- Index pour la table `phone_game_stats`
--
ALTER TABLE `phone_game_stats`
  ADD PRIMARY KEY (`citizenid`,`game`),
  ADD KEY `idx_game_stats_game_high` (`game`,`high_score`),
  ADD KEY `idx_game_stats_game_cpu` (`game`,`cpu_wins`),
  ADD KEY `idx_game_stats_game_online` (`game`,`online_wins`),
  ADD KEY `idx_game_stats_game_chips` (`game`,`chips_won`);

--
-- Index pour la table `phone_groups`
--
ALTER TABLE `phone_groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_groups_leader` (`leader_cid`);

--
-- Index pour la table `phone_group_invites`
--
ALTER TABLE `phone_group_invites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_group_invites_target` (`target_cid`),
  ADD KEY `idx_group_invites_group` (`group_id`),
  ADD KEY `idx_fk_group_invites_group` (`group_id`);

--
-- Index pour la table `phone_job_fires`
--
ALTER TABLE `phone_job_fires`
  ADD PRIMARY KEY (`citizenid`,`job`);

--
-- Index pour la table `phone_job_invites`
--
ALTER TABLE `phone_job_invites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_invite` (`citizenid`,`job`);

--
-- Index pour la table `phone_mail_accounts`
--
ALTER TABLE `phone_mail_accounts`
  ADD PRIMARY KEY (`email`),
  ADD KEY `idx_phone_mail_accounts_creator` (`created_by_cid`);

--
-- Index pour la table `phone_mail_saved_emails`
--
ALTER TABLE `phone_mail_saved_emails`
  ADD PRIMARY KEY (`citizenid`,`email`);

--
-- Index pour la table `phone_mail_sessions`
--
ALTER TABLE `phone_mail_sessions`
  ADD PRIMARY KEY (`citizenid`,`email`),
  ADD KEY `idx_phone_mail_sessions_email` (`email`);

--
-- Index pour la table `phone_map_markers`
--
ALTER TABLE `phone_map_markers`
  ADD PRIMARY KEY (`citizenid`);

--
-- Index pour la table `phone_messages`
--
ALTER TABLE `phone_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_messages_thread` (`citizenid`,`conversation`,`created_at`),
  ADD KEY `idx_phone_messages_mid` (`mid`),
  ADD KEY `idx_phone_messages_unread` (`citizenid`,`is_read`);

--
-- Index pour la table `phone_message_groups`
--
ALTER TABLE `phone_message_groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_message_groups_owner` (`owner_cid`);

--
-- Index pour la table `phone_message_group_members`
--
ALTER TABLE `phone_message_group_members`
  ADD PRIMARY KEY (`group_id`,`citizenid`),
  ADD KEY `idx_pmgm_cid` (`citizenid`),
  ADD KEY `idx_fk_message_group_members_group` (`group_id`);

--
-- Index pour la table `phone_message_reactions`
--
ALTER TABLE `phone_message_reactions`
  ADD PRIMARY KEY (`mid`,`citizenid`,`emoji`),
  ADD KEY `idx_phone_message_reactions_mid` (`mid`);

--
-- Index pour la table `phone_migrations`
--
ALTER TABLE `phone_migrations`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `phone_notes`
--
ALTER TABLE `phone_notes`
  ADD PRIMARY KEY (`citizenid`,`id`),
  ADD KEY `updated` (`citizenid`,`updated_at`);

--
-- Index pour la table `phone_notif_prefs`
--
ALTER TABLE `phone_notif_prefs`
  ADD PRIMARY KEY (`citizenid`,`app`);

--
-- Index pour la table `phone_passwords`
--
ALTER TABLE `phone_passwords`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_vault` (`citizenid`,`app`,`username`);

--
-- Index pour la table `phone_payphones`
--
ALTER TABLE `phone_payphones`
  ADD PRIMARY KEY (`location`),
  ADD UNIQUE KEY `uq_phone_payphones_number` (`number`);

--
-- Index pour la table `phone_pending_messages`
--
ALTER TABLE `phone_pending_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_pending_messages_number` (`number`,`created_at`);

--
-- Index pour la table `phone_photogram_comments`
--
ALTER TABLE `phone_photogram_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_photogram_comments_post` (`post_id`,`created_at`),
  ADD KEY `idx_fk_photogram_comments_post` (`post_id`);

--
-- Index pour la table `phone_photogram_comment_likes`
--
ALTER TABLE `phone_photogram_comment_likes`
  ADD PRIMARY KEY (`comment_id`,`username`),
  ADD KEY `idx_photogram_comment_likes_c` (`comment_id`),
  ADD KEY `idx_fk_photogram_comment_likes_comment` (`comment_id`);

--
-- Index pour la table `phone_photogram_dms`
--
ALTER TABLE `phone_photogram_dms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_photogram_dms_from` (`from_user`,`created_at`),
  ADD KEY `idx_photogram_dms_to` (`to_user`,`created_at`),
  ADD KEY `idx_photogram_dms_unread` (`to_user`,`read_flag`);

--
-- Index pour la table `phone_photogram_follows`
--
ALTER TABLE `phone_photogram_follows`
  ADD PRIMARY KEY (`follower`,`target`),
  ADD KEY `idx_photogram_follows_target` (`target`,`status`);

--
-- Index pour la table `phone_photogram_likes`
--
ALTER TABLE `phone_photogram_likes`
  ADD PRIMARY KEY (`post_id`,`username`),
  ADD KEY `idx_photogram_likes_post` (`post_id`),
  ADD KEY `idx_fk_photogram_likes_post` (`post_id`);

--
-- Index pour la table `phone_photogram_notifications`
--
ALTER TABLE `phone_photogram_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_photogram_notifs_recipient` (`recipient`,`created_at`),
  ADD KEY `idx_photogram_notifs_unseen` (`recipient`,`seen`),
  ADD KEY `idx_photogram_notifs_dedupe` (`recipient`,`kind`,`actor`,`post_id`),
  ADD KEY `idx_fk_photogram_notifications_post` (`post_id`);

--
-- Index pour la table `phone_photogram_posts`
--
ALTER TABLE `phone_photogram_posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_photogram_posts_author` (`author`,`created_at`),
  ADD KEY `idx_photogram_posts_created` (`created_at`);

--
-- Index pour la table `phone_photogram_profiles`
--
ALTER TABLE `phone_photogram_profiles`
  ADD PRIMARY KEY (`username`);

--
-- Index pour la table `phone_photogram_saves`
--
ALTER TABLE `phone_photogram_saves`
  ADD PRIMARY KEY (`username`,`post_id`),
  ADD KEY `idx_photogram_saves_user` (`username`,`created_at`),
  ADD KEY `idx_fk_photogram_saves_post` (`post_id`);

--
-- Index pour la table `phone_photogram_stories`
--
ALTER TABLE `phone_photogram_stories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_photogram_stories_author` (`author`,`created_at`),
  ADD KEY `idx_photogram_stories_created` (`created_at`);

--
-- Index pour la table `phone_photogram_story_views`
--
ALTER TABLE `phone_photogram_story_views`
  ADD PRIMARY KEY (`story_id`,`username`),
  ADD KEY `idx_photogram_story_views_user` (`username`);

--
-- Index pour la table `phone_photos`
--
ALTER TABLE `phone_photos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_photos_owner` (`citizenid`,`created_at`);

--
-- Index pour la table `phone_photo_albums`
--
ALTER TABLE `phone_photo_albums`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_phone_albums_owner` (`citizenid`,`created_at`);

--
-- Index pour la table `phone_photo_album_items`
--
ALTER TABLE `phone_photo_album_items`
  ADD PRIMARY KEY (`album_id`,`photo_id`),
  ADD KEY `idx_album_items_photo` (`photo_id`),
  ADD KEY `idx_fk_photo_album_items_album` (`album_id`),
  ADD KEY `idx_fk_photo_album_items_photo` (`photo_id`);

--
-- Index pour la table `phone_racing_profiles`
--
ALTER TABLE `phone_racing_profiles`
  ADD PRIMARY KEY (`citizenid`),
  ADD KEY `idx_racing_profiles_mmr` (`mmr`);

--
-- Index pour la table `phone_racing_results`
--
ALTER TABLE `phone_racing_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_racing_results_board` (`track_id`,`dnf`,`time_ms`),
  ADD KEY `idx_racing_results_recent` (`track_id`,`dnf`,`finished_at`),
  ADD KEY `idx_racing_results_racer` (`citizenid`,`finished_at`);

--
-- Index pour la table `phone_racing_tracks`
--
ALTER TABLE `phone_racing_tracks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_racing_tracks_live` (`deleted`,`published`,`featured`,`name`),
  ADD KEY `idx_racing_tracks_creator` (`citizenid`);

--
-- Index pour la table `phone_radio`
--
ALTER TABLE `phone_radio`
  ADD PRIMARY KEY (`citizenid`);

--
-- Index pour la table `phone_radio_saved`
--
ALTER TABLE `phone_radio_saved`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Index pour la table `phone_review_business_meta`
--
ALTER TABLE `phone_review_business_meta`
  ADD PRIMARY KEY (`business_id`);

--
-- Index pour la table `phone_review_helpful`
--
ALTER TABLE `phone_review_helpful`
  ADD PRIMARY KEY (`review_id`,`citizenid`),
  ADD KEY `idx_fk_review_helpful_review` (`review_id`);

--
-- Index pour la table `phone_review_reviews`
--
ALTER TABLE `phone_review_reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_biz_cid` (`business_id`,`citizenid`),
  ADD KEY `business_id` (`business_id`);

--
-- Index pour la table `phone_ryde_drivers`
--
ALTER TABLE `phone_ryde_drivers`
  ADD PRIMARY KEY (`username`);

--
-- Index pour la table `phone_ryde_rides`
--
ALTER TABLE `phone_ryde_rides`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ryde_rides_rider` (`rider_username`),
  ADD KEY `idx_ryde_rides_driver` (`driver_username`),
  ADD KEY `idx_ryde_rides_rider_recent` (`rider_username`,`created_at`);

--
-- Index pour la table `phone_saved_jobs`
--
ALTER TABLE `phone_saved_jobs`
  ADD PRIMARY KEY (`citizenid`);

--
-- Index pour la table `phone_service_invoices`
--
ALTER TABLE `phone_service_invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_job` (`job`,`created_at`),
  ADD KEY `idx_target` (`target_cid`,`status`,`created_at`),
  ADD KEY `idx_sender` (`sender_cid`,`status`,`created_at`);

--
-- Index pour la table `phone_service_messages`
--
ALTER TABLE `phone_service_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_job` (`job`,`citizen_number`,`created_at`),
  ADD KEY `idx_cit` (`citizen_number`,`created_at`);

--
-- Index pour la table `phone_service_msg_reads`
--
ALTER TABLE `phone_service_msg_reads`
  ADD PRIMARY KEY (`viewer`,`job`,`citizen_number`);

--
-- Index pour la table `phone_service_prefs`
--
ALTER TABLE `phone_service_prefs`
  ADD PRIMARY KEY (`citizenid`,`job`);

--
-- Index pour la table `phone_settings`
--
ALTER TABLE `phone_settings`
  ADD PRIMARY KEY (`citizenid`,`device`),
  ADD KEY `idx_phone_settings_number` (`phone_number`);

--
-- Index pour la table `phone_signatures`
--
ALTER TABLE `phone_signatures`
  ADD PRIMARY KEY (`citizenid`);

--
-- Index pour la table `phone_stock_holdings`
--
ALTER TABLE `phone_stock_holdings`
  ADD PRIMARY KEY (`citizenid`,`symbol`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `idx_stock_holdings_symbol` (`symbol`,`quantity`);

--
-- Index pour la table `phone_stock_prices`
--
ALTER TABLE `phone_stock_prices`
  ADD PRIMARY KEY (`symbol`);

--
-- Index pour la table `phone_stock_wallet`
--
ALTER TABLE `phone_stock_wallet`
  ADD PRIMARY KEY (`citizenid`);

--
-- Index pour la table `phone_streaks`
--
ALTER TABLE `phone_streaks`
  ADD PRIMARY KEY (`citizenid`);

--
-- Index pour la table `phone_streak_likes`
--
ALTER TABLE `phone_streak_likes`
  ADD UNIQUE KEY `uniq_like` (`post_id`,`citizenid`),
  ADD KEY `idx_fk_streak_likes_post` (`post_id`);

--
-- Index pour la table `phone_streak_posts`
--
ALTER TABLE `phone_streak_posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_day` (`citizenid`,`post_date`),
  ADD KEY `idx_created` (`created_at`),
  ADD KEY `idx_cid` (`citizenid`);

--
-- Index pour la table `phone_timer_recents`
--
ALTER TABLE `phone_timer_recents`
  ADD PRIMARY KEY (`citizenid`,`seconds`),
  ADD KEY `recency` (`citizenid`,`used_at`);

--
-- Index pour la table `phone_vibez_comments`
--
ALTER TABLE `phone_vibez_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vibez_comments_post` (`post_id`,`created_at`),
  ADD KEY `idx_fk_vibez_comments_post` (`post_id`);

--
-- Index pour la table `phone_vibez_comment_likes`
--
ALTER TABLE `phone_vibez_comment_likes`
  ADD PRIMARY KEY (`comment_id`,`username`),
  ADD KEY `idx_vibez_comment_likes_c` (`comment_id`),
  ADD KEY `idx_fk_vibez_comment_likes_comment` (`comment_id`);

--
-- Index pour la table `phone_vibez_follows`
--
ALTER TABLE `phone_vibez_follows`
  ADD PRIMARY KEY (`follower`,`target`),
  ADD KEY `idx_vibez_follows_target` (`target`);

--
-- Index pour la table `phone_vibez_likes`
--
ALTER TABLE `phone_vibez_likes`
  ADD PRIMARY KEY (`post_id`,`username`),
  ADD KEY `idx_vibez_likes_user` (`username`,`created_at`),
  ADD KEY `idx_fk_vibez_likes_post` (`post_id`);

--
-- Index pour la table `phone_vibez_notifications`
--
ALTER TABLE `phone_vibez_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vibez_notifs_recipient` (`recipient`,`created_at`),
  ADD KEY `idx_vibez_notifs_unseen` (`recipient`,`seen`),
  ADD KEY `idx_vibez_notifs_dedupe` (`recipient`,`kind`,`actor`,`post_id`),
  ADD KEY `idx_fk_vibez_notifications_post` (`post_id`);

--
-- Index pour la table `phone_vibez_posts`
--
ALTER TABLE `phone_vibez_posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vibez_posts_author` (`author`,`created_at`),
  ADD KEY `idx_vibez_posts_created` (`created_at`),
  ADD KEY `idx_vibez_posts_views` (`views`);

--
-- Index pour la table `phone_vibez_profiles`
--
ALTER TABLE `phone_vibez_profiles`
  ADD PRIMARY KEY (`username`);

--
-- Index pour la table `phone_vibez_saves`
--
ALTER TABLE `phone_vibez_saves`
  ADD PRIMARY KEY (`username`,`post_id`),
  ADD KEY `idx_vibez_saves_user` (`username`,`created_at`),
  ADD KEY `idx_fk_vibez_saves_post` (`post_id`);

--
-- Index pour la table `phone_voice_memos`
--
ALTER TABLE `phone_voice_memos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_voice_memos_src` (`src_id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `created_at` (`created_at`);

--
-- Index pour la table `phone_weazel_articles`
--
ALTER TABLE `phone_weazel_articles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_at` (`created_at`),
  ADD KEY `featured` (`featured`);

--
-- Index pour la table `phone_weazel_breaking`
--
ALTER TABLE `phone_weazel_breaking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pos` (`pos`);

--
-- Index pour la table `phone_wifi`
--
ALTER TABLE `phone_wifi`
  ADD PRIMARY KEY (`citizenid`);

--
-- Index pour la table `playerskins`
--
ALTER TABLE `playerskins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `active` (`active`);

--
-- Index pour la table `player_outfits`
--
ALTER TABLE `player_outfits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `citizenid_outfitname_model` (`citizenid`,`outfitname`,`model`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Index pour la table `player_outfit_codes`
--
ALTER TABLE `player_outfit_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_player_outfit_codes_player_outfits` (`outfitid`);

--
-- Index pour la table `rented_vehicles`
--
ALTER TABLE `rented_vehicles`
  ADD PRIMARY KEY (`plate`);

--
-- Index pour la table `society_moneywash`
--
ALTER TABLE `society_moneywash`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`identifier`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `unique_ssn` (`ssn`);

--
-- Index pour la table `user_licenses`
--
ALTER TABLE `user_licenses`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`model`);

--
-- Index pour la table `vehicle_categories`
--
ALTER TABLE `vehicle_categories`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `vehicle_sold`
--
ALTER TABLE `vehicle_sold`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `whitelist`
--
ALTER TABLE `whitelist`
  ADD PRIMARY KEY (`identifier`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `addon_account_data`
--
ALTER TABLE `addon_account_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT pour la table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `banking`
--
ALTER TABLE `banking`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `billing`
--
ALTER TABLE `billing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `cardealer_vehicles`
--
ALTER TABLE `cardealer_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `darkchat_messages`
--
ALTER TABLE `darkchat_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `datastore_data`
--
ALTER TABLE `datastore_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT pour la table `fine_types`
--
ALTER TABLE `fine_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT pour la table `job2_grades`
--
ALTER TABLE `job2_grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `job_grades`
--
ALTER TABLE `job_grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT pour la table `management_outfits`
--
ALTER TABLE `management_outfits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `marketplace_listings`
--
ALTER TABLE `marketplace_listings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `pages_posts`
--
ALTER TABLE `pages_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_admin_audit`
--
ALTER TABLE `phone_admin_audit`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_admin_mutes`
--
ALTER TABLE `phone_admin_mutes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_app_accounts`
--
ALTER TABLE `phone_app_accounts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_bank_transactions`
--
ALTER TABLE `phone_bank_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_passwords`
--
ALTER TABLE `phone_passwords`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_racing_results`
--
ALTER TABLE `phone_racing_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_racing_tracks`
--
ALTER TABLE `phone_racing_tracks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_radio_saved`
--
ALTER TABLE `phone_radio_saved`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_review_reviews`
--
ALTER TABLE `phone_review_reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_streak_posts`
--
ALTER TABLE `phone_streak_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_voice_memos`
--
ALTER TABLE `phone_voice_memos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_weazel_articles`
--
ALTER TABLE `phone_weazel_articles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_weazel_breaking`
--
ALTER TABLE `phone_weazel_breaking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `playerskins`
--
ALTER TABLE `playerskins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `player_outfits`
--
ALTER TABLE `player_outfits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `player_outfit_codes`
--
ALTER TABLE `player_outfit_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `society_moneywash`
--
ALTER TABLE `society_moneywash`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `user_licenses`
--
ALTER TABLE `user_licenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `vehicle_sold`
--
ALTER TABLE `vehicle_sold`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `darkchat_bans`
--
ALTER TABLE `darkchat_bans`
  ADD CONSTRAINT `fk_darkchat_bans_room` FOREIGN KEY (`room_id`) REFERENCES `darkchat_rooms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `darkchat_members`
--
ALTER TABLE `darkchat_members`
  ADD CONSTRAINT `fk_darkchat_members_room` FOREIGN KEY (`room_id`) REFERENCES `darkchat_rooms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `darkchat_messages`
--
ALTER TABLE `darkchat_messages`
  ADD CONSTRAINT `fk_darkchat_messages_room` FOREIGN KEY (`room_id`) REFERENCES `darkchat_rooms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `darkchat_reactions`
--
ALTER TABLE `darkchat_reactions`
  ADD CONSTRAINT `fk_darkchat_reactions_message` FOREIGN KEY (`message_id`) REFERENCES `darkchat_messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_app_sessions`
--
ALTER TABLE `phone_app_sessions`
  ADD CONSTRAINT `fk_app_sessions_account` FOREIGN KEY (`account_id`) REFERENCES `phone_app_accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_birdy_likes`
--
ALTER TABLE `phone_birdy_likes`
  ADD CONSTRAINT `fk_birdy_likes_post` FOREIGN KEY (`post_id`) REFERENCES `phone_birdy_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_birdy_notifications`
--
ALTER TABLE `phone_birdy_notifications`
  ADD CONSTRAINT `fk_birdy_notifications_post` FOREIGN KEY (`post_id`) REFERENCES `phone_birdy_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_birdy_reposts`
--
ALTER TABLE `phone_birdy_reposts`
  ADD CONSTRAINT `fk_birdy_reposts_post` FOREIGN KEY (`post_id`) REFERENCES `phone_birdy_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_cherry_messages`
--
ALTER TABLE `phone_cherry_messages`
  ADD CONSTRAINT `fk_cherry_messages_match` FOREIGN KEY (`match_id`) REFERENCES `phone_cherry_matches` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_documents`
--
ALTER TABLE `phone_documents`
  ADD CONSTRAINT `fk_documents_folder` FOREIGN KEY (`folder_id`) REFERENCES `phone_document_folders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_group_invites`
--
ALTER TABLE `phone_group_invites`
  ADD CONSTRAINT `fk_group_invites_group` FOREIGN KEY (`group_id`) REFERENCES `phone_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_message_group_members`
--
ALTER TABLE `phone_message_group_members`
  ADD CONSTRAINT `fk_message_group_members_group` FOREIGN KEY (`group_id`) REFERENCES `phone_message_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_photogram_comments`
--
ALTER TABLE `phone_photogram_comments`
  ADD CONSTRAINT `fk_photogram_comments_post` FOREIGN KEY (`post_id`) REFERENCES `phone_photogram_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_photogram_comment_likes`
--
ALTER TABLE `phone_photogram_comment_likes`
  ADD CONSTRAINT `fk_photogram_comment_likes_comment` FOREIGN KEY (`comment_id`) REFERENCES `phone_photogram_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_photogram_likes`
--
ALTER TABLE `phone_photogram_likes`
  ADD CONSTRAINT `fk_photogram_likes_post` FOREIGN KEY (`post_id`) REFERENCES `phone_photogram_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_photogram_notifications`
--
ALTER TABLE `phone_photogram_notifications`
  ADD CONSTRAINT `fk_photogram_notifications_post` FOREIGN KEY (`post_id`) REFERENCES `phone_photogram_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_photogram_saves`
--
ALTER TABLE `phone_photogram_saves`
  ADD CONSTRAINT `fk_photogram_saves_post` FOREIGN KEY (`post_id`) REFERENCES `phone_photogram_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_photo_album_items`
--
ALTER TABLE `phone_photo_album_items`
  ADD CONSTRAINT `fk_photo_album_items_album` FOREIGN KEY (`album_id`) REFERENCES `phone_photo_albums` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_photo_album_items_photo` FOREIGN KEY (`photo_id`) REFERENCES `phone_photos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_review_helpful`
--
ALTER TABLE `phone_review_helpful`
  ADD CONSTRAINT `fk_review_helpful_review` FOREIGN KEY (`review_id`) REFERENCES `phone_review_reviews` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_streak_likes`
--
ALTER TABLE `phone_streak_likes`
  ADD CONSTRAINT `fk_streak_likes_post` FOREIGN KEY (`post_id`) REFERENCES `phone_streak_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_vibez_comments`
--
ALTER TABLE `phone_vibez_comments`
  ADD CONSTRAINT `fk_vibez_comments_post` FOREIGN KEY (`post_id`) REFERENCES `phone_vibez_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_vibez_comment_likes`
--
ALTER TABLE `phone_vibez_comment_likes`
  ADD CONSTRAINT `fk_vibez_comment_likes_comment` FOREIGN KEY (`comment_id`) REFERENCES `phone_vibez_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_vibez_likes`
--
ALTER TABLE `phone_vibez_likes`
  ADD CONSTRAINT `fk_vibez_likes_post` FOREIGN KEY (`post_id`) REFERENCES `phone_vibez_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_vibez_notifications`
--
ALTER TABLE `phone_vibez_notifications`
  ADD CONSTRAINT `fk_vibez_notifications_post` FOREIGN KEY (`post_id`) REFERENCES `phone_vibez_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `phone_vibez_saves`
--
ALTER TABLE `phone_vibez_saves`
  ADD CONSTRAINT `fk_vibez_saves_post` FOREIGN KEY (`post_id`) REFERENCES `phone_vibez_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
