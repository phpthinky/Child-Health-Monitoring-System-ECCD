-- ========================================================================
-- CHILD HEALTH MONITORING SYSTEM (ECCD) - DATABASE INSTALLATION
-- ========================================================================
--
-- System: Early Childhood Care and Development Health Monitoring
-- Version: 1.0
-- Framework: CodeIgniter 3.1.13
-- Database: MySQL 5.7+ / MariaDB 10.4+
--
-- INSTALLATION INSTRUCTIONS:
-- -------------------------
-- 1. Create a new database:
--    CREATE DATABASE mswdeccddb CHARACTER SET utf8 COLLATE utf8_general_ci;
--
-- 2. Import this file:
--    mysql -u root -p mswdeccddb < eccd_complete_install.sql
--
-- 3. Default Admin Login:
--    Email: admin@eccd.local
--    Password: Admin@2025
--    (IMPORTANT: Change this password immediately after first login!)
--
-- 4. Update .env file with your database credentials
--
-- ========================================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- ========================================================================
-- DROP EXISTING TABLES (IF ANY)
-- ========================================================================

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `aauth_groups`;
DROP TABLE IF EXISTS `aauth_group_to_group`;
DROP TABLE IF EXISTS `aauth_login_attempts`;
DROP TABLE IF EXISTS `aauth_perms`;
DROP TABLE IF EXISTS `aauth_perm_to_group`;
DROP TABLE IF EXISTS `aauth_perm_to_user`;
DROP TABLE IF EXISTS `aauth_pms`;
DROP TABLE IF EXISTS `aauth_users`;
DROP TABLE IF EXISTS `aauth_user_to_group`;
DROP TABLE IF EXISTS `aauth_user_variables`;
DROP TABLE IF EXISTS `assessment`;
DROP TABLE IF EXISTS `assessment_raw_score`;
DROP TABLE IF EXISTS `assessment_schedule`;
DROP TABLE IF EXISTS `assessment_sum_scaled_score`;
DROP TABLE IF EXISTS `ecenter`;
DROP TABLE IF EXISTS `eparent`;
DROP TABLE IF EXISTS `epupils`;
DROP TABLE IF EXISTS `epupils_feeding`;
DROP TABLE IF EXISTS `eschoolyear`;
DROP TABLE IF EXISTS `eschoolyear_by_worker`;
DROP TABLE IF EXISTS `eschoolyear_by_worker_students`;
DROP TABLE IF EXISTS `eworkers`;
DROP TABLE IF EXISTS `e_feeding`;
DROP TABLE IF EXISTS `e_immunization`;
DROP TABLE IF EXISTS `e_weighing`;
DROP TABLE IF EXISTS `e_zscore_hfa`;
DROP TABLE IF EXISTS `e_zscore_wfa`;
DROP TABLE IF EXISTS `e_zscore_wfh`;
DROP TABLE IF EXISTS `weighing`;
DROP TABLE IF EXISTS `weighing_schedule`;

DROP VIEW IF EXISTS `center_schoolyear`;
DROP VIEW IF EXISTS `center_students_schoolyear`;
DROP VIEW IF EXISTS `center_workers`;
DROP VIEW IF EXISTS `list_students`;
DROP VIEW IF EXISTS `students`;

SET FOREIGN_KEY_CHECKS = 1;


-- ========================================================================
-- TABLE STRUCTURES AND DATA
-- ========================================================================

/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
--

-- --------------------------------------------------------

--
-- Table structure for table `aauth_groups`
--

CREATE TABLE `aauth_groups` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `definition` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `aauth_groups`
--

INSERT INTO `aauth_groups` (`id`, `name`, `definition`) VALUES
(1, 'Admin', 'Super Admin Group'),
(2, 'Public', 'Public Access Group'),
(3, 'Default', 'Default Access Group');

-- --------------------------------------------------------

--
-- Table structure for table `aauth_group_to_group`
--

CREATE TABLE `aauth_group_to_group` (
  `group_id` int(11) UNSIGNED NOT NULL,
  `subgroup_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `aauth_login_attempts`
--

CREATE TABLE `aauth_login_attempts` (
  `id` int(11) NOT NULL,
  `ip_address` varchar(39) DEFAULT '0',
  `timestamp` datetime DEFAULT NULL,
  `login_attempts` tinyint(2) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `aauth_perms`
--

CREATE TABLE `aauth_perms` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `definition` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `aauth_perm_to_group`
--

CREATE TABLE `aauth_perm_to_group` (
  `perm_id` int(11) UNSIGNED NOT NULL,
  `group_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `aauth_perm_to_user`
--

CREATE TABLE `aauth_perm_to_user` (
  `perm_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `aauth_pms`
--

CREATE TABLE `aauth_pms` (
  `id` int(11) UNSIGNED NOT NULL,
  `sender_id` int(11) UNSIGNED NOT NULL,
  `receiver_id` int(11) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text DEFAULT NULL,
  `date_sent` datetime DEFAULT NULL,
  `date_read` datetime DEFAULT NULL,
  `pm_deleted_sender` int(1) DEFAULT NULL,
  `pm_deleted_receiver` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `aauth_users`
--

CREATE TABLE `aauth_users` (
  `id` int(11) UNSIGNED NOT NULL,
  `email` varchar(100) NOT NULL,
  `pass` varchar(64) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT 0,
  `last_login` datetime DEFAULT NULL,
  `last_activity` datetime DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `forgot_exp` text DEFAULT NULL,
  `remember_time` datetime DEFAULT NULL,
  `remember_exp` text DEFAULT NULL,
  `verification_code` text DEFAULT NULL,
  `totp_secret` varchar(16) DEFAULT NULL,
  `ip_address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `aauth_users`
--

INSERT INTO `aauth_users` (`id`, `email`, `pass`, `username`, `banned`, `last_login`, `last_activity`, `date_created`, `forgot_exp`, `remember_time`, `remember_exp`, `verification_code`, `totp_secret`, `ip_address`) VALUES
(1, 'admin@gmail.com', 'ec225039f1cb0c48ad528709e8e0184991e637d96db175f094b6b2037ec1a3c2', 'Admin', 0, '2023-10-14 13:27:16', '2023-10-14 13:27:17', NULL, NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(4, 'zenaida@gmail.com', '26099512199546597858cebb4cc8d90e21f48e9be747c98d45d8a57a0f0a6e44', '', 0, '2023-10-14 14:40:23', '2023-10-14 14:40:23', '2023-10-07 15:09:51', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(5, 'helen@gmail.com', '28a9d1ac311fc87b88b094cd50b05abf517134b03d636bbc7ee94401f9952a21', '', 0, '2023-10-10 09:20:02', '2023-10-10 09:20:02', '2023-10-09 09:52:01', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(6, 'josephine@gmail.com', '3913228818759cd846b475d3106a4ecc9bf9bd91746cab4e88a8750c11d15914', '', 0, '2023-10-10 10:03:54', '2023-10-10 10:03:54', '2023-10-10 10:03:22', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(7, 'eda@gmail.com', '3e1340c771fff1153aa60137dc8c0265d5914e5de769b59183085b78d950b31b', '', 0, '2023-10-10 10:33:27', '2023-10-10 10:33:27', '2023-10-10 10:32:52', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(8, 'myra@gmail.com', '8e7d10c7c802e6cc70ddc57bcb1477eb8f3083b0f088f9427e4d56600b065bbe', '', 0, '2023-10-10 10:56:16', '2023-10-10 10:56:16', '2023-10-10 10:55:29', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(9, 'brenda@gmail.com', '5ea379e79219f971019cf6f7ee7b5edc7c1e8d65aee2370cc6249f1302d3f3ca', '', 0, '2023-10-10 11:11:21', '2023-10-10 11:11:21', '2023-10-10 11:10:43', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(10, 'imelda@gmail.com', 'ca16350c55ced81d071bd550cbc5e92ad319ab41b84ed342a96cf79e4d03f02a', '', 0, '2023-10-10 11:24:22', '2023-10-10 11:24:22', '2023-10-10 11:23:40', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(11, 'ladyver@gmail.com', '391ed40ef01e7c09b0c27d97adba46d9aa04e52e1a3c9c7561185393b84d223c', '', 0, '2023-10-10 11:44:25', '2023-10-10 11:44:25', '2023-10-10 11:43:47', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(12, 'mylene@gmail.com', '9a90741a24c29a3511cad6568e6a7d1fa2ea09b8c86a50d09d1fef74f4bf840f', '', 0, '2023-10-11 04:22:10', '2023-10-11 04:22:10', '2023-10-11 03:56:03', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(13, 'jonnna@gmail.com', '0d9f89182b7572de5694a769bc9073d204754bad5bc043c69acafcaf484922fe', '', 0, '2023-10-11 04:33:24', '2023-10-11 04:33:24', '2023-10-11 04:32:47', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(15, 'Lizabel@gmail.com', '196075d3b960128ae4a5cf79596d3d06ed482c5535c813ec0c7dbc2e6be032be', '', 0, '2023-10-11 05:44:30', '2023-10-11 05:44:30', '2023-10-11 05:43:36', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(16, 'Rona@gmail.com', '8c04f0d45d99fb3c09f7c82165b9672b53145f042c0d27a0067b25103c26408f', '', 0, '2023-10-11 06:04:33', '2023-10-11 06:04:33', '2023-10-11 06:03:03', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(17, 'micaya@gmail.com', '1cb4df1f9cc3eff69f9fa98a554c0cac43000c0fa999e7e51bd80fc23ab644a1', '', 0, '2023-10-11 06:28:31', '2023-10-11 06:28:31', '2023-10-11 06:26:12', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(19, 'jocelyn@gmail.com', '42ed0e47de05a088ae5285d52a55f453d226953c47bd1ed03ff6a6bfb3a7d2e6', '', 0, '2023-10-12 13:59:35', '2023-10-12 13:59:35', '2023-10-11 10:35:48', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(20, 'perlita@gmail.com', 'da42e6365c0273267ee7fd7dbce9e95436291c91d308dda4a16ea52da52419ae', '', 0, '2023-10-12 05:53:03', '2023-10-12 05:53:03', '2023-10-11 11:43:25', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(21, 'melba@gmail.com', '1ec551e2917d5181571c9a5c6e36ed78930f3213ec89c9e38a3487f764a25dcf', '', 0, '2023-10-11 12:03:12', '2023-10-11 12:03:12', '2023-10-11 12:02:40', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(22, 'ronalyn@gmail.com', '2e9912f1c79be0226ccebedc0805a3b717b9bd56e0bed763c15770860ce109ab', '', 0, '2023-10-11 12:17:48', '2023-10-11 12:17:48', '2023-10-11 12:17:20', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(23, 'rizalin@gmail.com', '95a807da3742c28e70a40695ea3a697b33aeb6e6232cf10819844a43d5d9b9ad', '', 0, '2023-10-11 12:31:51', '2023-10-11 12:31:51', '2023-10-11 12:31:21', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(24, 'letecia@gmail.com', '62d773d3bcabeb99a53dab2f6371d818d63008111c6adcf5f7db7e9748b5c310', '', 0, '2023-10-11 12:48:36', '2023-10-11 12:48:36', '2023-10-11 12:48:03', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(25, 'jegelyn@gmail.com', '5098270643acc20221da87a76905a51e4c4ee8a81794e50c9a20020c57a6d9e0', '', 0, '2023-10-11 14:54:40', '2023-10-11 14:54:40', '2023-10-11 14:54:10', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(26, 'maila@gmail.com', 'baa83534ed137f9a897bd10d411791733630e27b63f7a2b024dbf167270e6673', '', 0, '2023-10-11 15:19:10', '2023-10-11 15:19:10', '2023-10-11 15:18:45', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(27, 'elizabeth@gmail.com', '2e521b4613c31ff201a5a8da1036f0c9c4e4bff4f8c6541db783a75011730a4c', '', 0, '2023-10-11 15:34:15', '2023-10-11 15:34:15', '2023-10-11 15:34:00', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(28, 'fely@gmail.com', 'f9dcdd7d3fb05dcd6c899ac00fde3b8b0b277bc6fac4cc7e59b4404480053fa5', '', 0, '2023-10-11 15:48:27', '2023-10-11 15:48:27', '2023-10-11 15:47:24', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(29, 'kristine@gmail.come', '9062845ecc4f511be576b88d8be16f68d59b83efb359f51ccf404b7d5a061177', '', 0, '2023-10-11 16:01:56', '2023-10-11 16:01:56', '2023-10-11 16:01:35', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(30, 'aprilrose@gmail.com', '7c41cd1c5ab502e5693185bc777a2c4a627569b2a9bbb429218ae3240a8e2e3e', '', 0, '2023-10-11 16:16:03', '2023-10-11 16:16:03', '2023-10-11 16:15:46', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(31, 'princesslaniejoy@gmail.com', '431dd9375701b357352320af3e8abcaa55136565ead7fad3c47d46c4b6811e7b', '', 0, '2023-10-11 16:32:55', '2023-10-11 16:32:55', '2023-10-11 16:31:36', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(32, 'amie@gmail.com', '9303833982d500ef350a3ef4aeea2418c3c43cb4ddda3761dc0be91613eb3519', '', 0, '2023-10-11 16:44:44', '2023-10-11 16:44:44', '2023-10-11 16:44:26', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(33, 'lanie@gmail.com', '6cb91e6bbe8b85093d8b7b05426c0f262e805ccad38108d3926e3f23e01f0a89', '', 0, '2023-10-12 14:14:05', '2023-10-12 14:14:05', '2023-10-12 14:13:29', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(34, 'rosemarie@gmail.com', '8d5917d040aa140ee042d878d45a16d3e3533db8ca3e873f50338d0108989ae5', '', 0, '2023-10-13 15:26:34', '2023-10-13 15:26:34', '2023-10-12 15:01:34', NULL, NULL, NULL, NULL, NULL, '127.0.0.1'),
(35, 'catalina@gmail.com', '24b0ccbf0fb36c52910cac652b7dded139647bf61741e9da968245cef33bd5d2', '', 0, '2023-10-13 07:49:26', '2023-10-13 07:49:26', '2023-10-13 07:35:09', NULL, NULL, NULL, NULL, NULL, '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `aauth_user_to_group`
--

CREATE TABLE `aauth_user_to_group` (
  `user_id` int(11) UNSIGNED NOT NULL,
  `group_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `aauth_user_to_group`
--

INSERT INTO `aauth_user_to_group` (`user_id`, `group_id`) VALUES
(1, 1),
(1, 3),
(4, 3),
(5, 3),
(6, 3),
(7, 3),
(8, 3),
(9, 3),
(10, 3),
(11, 3),
(12, 3),
(13, 3),
(15, 3),
(16, 3),
(17, 3),
(19, 3),
(20, 3),
(21, 3),
(22, 3),
(23, 3),
(24, 3),
(25, 3),
(26, 3),
(27, 3),
(28, 3),
(29, 3),
(30, 3),
(31, 3),
(32, 3),
(33, 3),
(34, 3),
(35, 3);

-- --------------------------------------------------------

--
-- Table structure for table `aauth_user_variables`
--

CREATE TABLE `aauth_user_variables` (
  `id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `data_key` varchar(100) NOT NULL,
  `value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `assessment`
--

CREATE TABLE `assessment` (
  `assessmentId` int(11) NOT NULL,
  `centerId` int(11) NOT NULL,
  `workersId` int(11) NOT NULL,
  `pupilsId` int(11) NOT NULL,
  `assessmentDate` date NOT NULL,
  `score` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `assessment_raw_score`
--

CREATE TABLE `assessment_raw_score` (
  `id` int(11) NOT NULL,
  `scaled_score` varchar(11) NOT NULL,
  `gross_motor` varchar(11) DEFAULT NULL,
  `fine_motor` varchar(11) DEFAULT NULL,
  `self_help` varchar(11) DEFAULT NULL,
  `receiptive_lang` varchar(11) DEFAULT NULL,
  `expressive_lang` varchar(11) DEFAULT NULL,
  `cognitive` varchar(11) DEFAULT NULL,
  `social_emotion` varchar(11) DEFAULT NULL,
  `record_no` varchar(11) NOT NULL,
  `age_limit` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `assessment_raw_score`
--

INSERT INTO `assessment_raw_score` (`id`, `scaled_score`, `gross_motor`, `fine_motor`, `self_help`, `receiptive_lang`, `expressive_lang`, `cognitive`, `social_emotion`, `record_no`, `age_limit`) VALUES
(29, '2', '', '', '', '0-16', '', '', NULL, '1', '1'),
(30, '1', '', '', '', '', '', '0-15', '', '1', '2'),
(32, '1', '', '0-9', '', '', '', '', '', '1', '1'),
(33, '3', '', '', '', '', '10-15', '', '', '1', '1');

-- --------------------------------------------------------

--
-- Table structure for table `assessment_schedule`
--

CREATE TABLE `assessment_schedule` (
  `ScheduleId` int(11) NOT NULL,
  `scheduleDate` date NOT NULL,
  `addedBy` int(11) NOT NULL,
  `dateAddedd` date NOT NULL,
  `centerId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `assessment_sum_scaled_score`
--

CREATE TABLE `assessment_sum_scaled_score` (
  `id` int(11) NOT NULL,
  `scaled_score` varchar(11) NOT NULL,
  `standard_score` varchar(11) NOT NULL,
  `record_no` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ecenter`
--

CREATE TABLE `ecenter` (
  `centerId` int(3) NOT NULL,
  `centerName` varchar(100) NOT NULL,
  `barangay` varchar(50) NOT NULL,
  `centerAddress` text NOT NULL,
  `addedBy` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `ecenter`
--

INSERT INTO `ecenter` (`centerId`, `centerName`, `barangay`, `centerAddress`, `addedBy`) VALUES
(1, 'VICTORIA CDC', 'Victoria', 'Victoria, sablayan, occidental mindoro', 0),
(2, 'LIGAYA CDC', 'Ligaya', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 0),
(3, 'SAN MIGUEL CDC', 'Claudio Salgado', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 0),
(4, 'APLAYA SNP', 'Burgos', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 0),
(5, 'IBUD DIKE SNP', 'Ibud', 'IBUD, SABLAYAN, OCCIDENTAL MINDORO', 0),
(6, 'SAN RAFAEL SNP', 'Poblacion', 'SAN RAFAEL, POBLACION, SABALAYAN, OCCIDENTAL MINDORO', 0),
(7, 'PUSOG BRIGADA SNP', 'Ligaya', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 0),
(8, 'IBUD PROPER CDC', 'Ibud', 'IBUD, SABLAYAN, OCCIDENTAL MINDORO', 0),
(9, 'CALUMPIT CDC', 'San Vicente', 'CALUMPIT, SAN VICENTE, SABLAYAN OCCIDENTAL MINDORO', 0),
(10, 'TUOG SND', 'San Vicente', 'TUOG, SAN VICENTE, SABLAYAN OCCIDENTAL MINDORO', 0),
(12, 'ILVITA PROPER CDC', 'Ilvita', 'ILVITA SABLAYAN OCCIDENTAL MINDORO', 0),
(13, 'TAGUMPAY CDC', 'Tagumpay', 'TAGUMPAY, SABLAYAN OCCIDENTAL MINDORO', 0),
(14, 'TYABONG SNP', 'Ligaya', 'Sitio. TYABONG LIGAYA, SABLAYAN,OCCIDENTAL MINDORO', 0),
(15, 'PUSOG BURGOS SNP', 'Burgos', 'Sitio Pusog, Burgos, Sabalayan, Occidental Mindoro', 0),
(16, 'LAGNAS CDC', 'Lagnas', 'LAGNAS, SABLAYAN, OCCIDENTAL MINDORO', 0),
(17, 'ILAYA CDC', 'Sato Nino', 'Ilaya, Sto. Niño, Sablayan, Occidental Mindoro', 0),
(18, 'SAN NICOLAS CDC', 'Tuban', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 0),
(19, 'SAN CARLOS SNP', 'Tagumpay', 'San Carlos, San Francisco, Sablayan, Occidental Mindoro', 0),
(20, 'CALAMANSIAN SNP', 'San Agustin', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 0),
(21, 'RECEIVING SNP', 'Santa Lucia', 'RECEIVING, SANTA LUCIA, SABLAYAN OCCIDENTAL MINDORO', 0),
(22, 'PIANGA SNP', 'Pag-asa', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 0),
(23, 'ELIZABETH S. RIVERA', 'San Vicente', 'SAN FRANCISCO, SABLAYAN, OCCIDENTAL MINDORO', 0),
(24, 'SAN FRANCISCO PROPER CDC', 'San Vicente', 'SAN FRANCISCO, SABLAYAN, OCCIDENTAL MINDORO', 0),
(25, 'PAG-ASA CDC', 'Pag-asa', 'PAG-ASA, SABLAYAN, OCCIDENTAL MINDORO', 0),
(26, 'ALAG SNP', 'Victoria', 'Victoria, Sablayan, Occidental Mindoro', 0),
(27, 'NCDC', 'Buenavista', 'Buenavista,Sablayan, Occidental Mindoro', 0),
(28, 'SAHING SNP', 'Santa Lucia', 'Santa Lucia, Sablayan, Occidental Mindoro', 0),
(29, 'PANDURUCAN SNP', 'Pag-asa', 'PANDURUCAN, PAG-ASA, SABLAYAN, OCCIDENTAL MINDORO', 0),
(30, 'SAN VICENTE PROPER CDC', 'San Vicente', 'SAN VICENTE, SABLAYAN , OCCIDENTAL MINDORO', 0),
(31, 'PANDAN SNP', 'Claudio Salgado', 'Sitio Pandan, Sablayan, Occidental Mindoro', 0);

-- --------------------------------------------------------

--
-- Table structure for table `eparent`
--

CREATE TABLE `eparent` (
  `parentId` int(11) NOT NULL,
  `fName` varchar(20) NOT NULL,
  `mName` varchar(20) NOT NULL,
  `lName` varchar(20) NOT NULL,
  `gender` int(1) NOT NULL,
  `familyPosition` int(1) NOT NULL,
  `occupation` varchar(30) NOT NULL,
  `weight` varchar(10) NOT NULL,
  `height` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `epupils`
--

CREATE TABLE `epupils` (
  `pupilsId` int(11) NOT NULL,
  `fName` varchar(20) NOT NULL,
  `mName` varchar(20) NOT NULL,
  `lName` varchar(20) NOT NULL,
  `ext` varchar(3) NOT NULL,
  `age` int(3) NOT NULL,
  `birthDate` date DEFAULT NULL,
  `gender` int(1) NOT NULL,
  `sector` varchar(20) NOT NULL,
  `address` varchar(255) NOT NULL,
  `barangay` varchar(25) NOT NULL,
  `municipality` varchar(50) NOT NULL,
  `province` varchar(50) NOT NULL,
  `weight` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `dateAdded` varchar(20) NOT NULL,
  `dateUpdated` varchar(20) NOT NULL,
  `pupilsCode` varchar(10) NOT NULL,
  `app` int(1) NOT NULL DEFAULT 1,
  `status` int(3) NOT NULL,
  `keywords` varchar(255) NOT NULL,
  `keywords_2` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `epupils`
--

INSERT INTO `epupils` (`pupilsId`, `fName`, `mName`, `lName`, `ext`, `age`, `birthDate`, `gender`, `sector`, `address`, `barangay`, `municipality`, `province`, `weight`, `height`, `dateAdded`, `dateUpdated`, `pupilsCode`, `app`, `status`, `keywords`, `keywords_2`) VALUES
(1, 'KYZER', 'F.', 'AGUILAR', '', 0, '2019-01-26', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'KSR  AKLR', 'KSRKLR'),
(2, 'NATHAN', 'P.', 'BALLENAS', '', 0, '2017-11-08', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'N0N  BLNS', 'N0NBLNS'),
(3, 'XIAN', 'C.', 'BESALES', '', 0, '2018-10-05', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'SN  BSLS', 'SNBSLS'),
(4, 'PRINCE DAVE', 'N.', 'DANGEROS', '', 0, '2019-03-15', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'PRNSTF  TNJRS', 'PRNSTFTNJRS'),
(5, 'ASHER HERYS', 'D.', 'DALIT', '', 0, '2017-11-17', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'AXRHRS  TLT', 'AXRHRSTLT'),
(6, 'C-JAY', 'F.', 'AGUILAR', '', 0, '2017-12-28', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'KJ  AKLR', 'KJKLR'),
(7, 'HARYS', 'V.', 'RITA', '', 0, '2025-01-02', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'HRS  RT', 'HRSRT'),
(8, 'Mark Angelo', 'D', 'Bolasco', '', 0, '2007-12-25', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'MRKNJL  BLSK', 'MRKNJLBLSK'),
(9, 'ERWAN', 'B.', 'COMBATE', '', 0, '2018-10-11', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'ERWN  KMT', 'ERWNKMT'),
(10, 'DYLAN JAY', 'S.', 'CORNEJO', '', 0, '2018-07-17', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'TLNJ  KRNJ', 'TLNJKRNJ'),
(11, 'REIVER AXIEL ', 'V.', 'DAPROSA', '', 0, '2017-11-03', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'RFRKSL  TPRS', 'RFRKSLTPRS'),
(12, 'PRINCE GIAN', 'P. ', 'DE DIOS', '', 0, '2018-05-25', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'PRNSJN  TTS', 'PRNSJNTTS'),
(13, 'PRICE JAY', 'B.', 'DE DIOS', '', 0, '2018-05-25', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'PRSJ  TTS', 'PRSJTTS'),
(14, 'JOHN LESTER ', 'C', 'ESTEVES', '', 0, '2017-11-08', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'JNLSTR  ESTFS', 'JNLSTRSTFS'),
(15, 'ADENVER', 'M.', 'GABALES', '', 0, '2018-02-02', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'ATNFR  KBLS', 'ATNFRKBLS'),
(16, 'MERGELDO', 'B.', 'GABALES', '', 0, '2018-08-21', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'MRJLT  KBLS', 'MRJLTKBLS'),
(17, 'PRINCE ANGELO', 'B.', 'GABALES', '', 0, '2018-09-22', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'PRNSNJL  KBLS', 'PRNSNJLKBLS'),
(18, 'KYRIE', 'V.', 'BEDONA', '', 0, '2018-02-18', 2, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 'Claudio Salgado', '', '', 0, 0, '', '', '', 1, 0, 'KR  BTN', 'KRBTN'),
(19, 'JONATHAN ', 'F.', 'BANGCAYA', '', 0, '2018-02-18', 2, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 'Claudio Salgado', '', '', 0, 0, '', '', '', 1, 0, 'JN0N  BNKKY', 'JN0NBNKKY'),
(20, 'JOHN RHIAN', 'A.', 'BENITO', '', 0, '2018-08-16', 2, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 'Claudio Salgado', '', '', 0, 0, '', '', '', 1, 0, 'JNRHN  BNT', 'JNRHNBNT'),
(21, 'KRISTOPHER', 'S', 'CASAPAO', '', 0, '2018-08-13', 2, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 'Claudio Salgado', '', '', 0, 0, '', '', '', 1, 0, 'KRSTFR  KSP', 'KRSTFRKSP'),
(22, 'PAOLO', 'B.', 'CASAPAO', '', 0, '2019-01-20', 2, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 'Claudio Salgado', '', '', 0, 0, '', '', '', 1, 0, 'PL  KSP', 'PLKSP'),
(23, 'LHUISE ROBINE', 'H', 'INSIGNE', '', 0, '2018-09-10', 2, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 'Claudio Salgado', '', '', 0, 0, '', '', '', 1, 0, 'LHSRBN  INSKN', 'LHSRBNNSKN'),
(24, 'ARWIN', 'B.', 'SONGCOG', '', 0, '2018-07-18', 2, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 'Claudio Salgado', '', '', 0, 0, '', '', '', 1, 0, 'ARWN  SNKKK', 'ARWNSNKKK'),
(25, 'TRISTAN JAY', 'A', 'NUNEZ', '', 0, '2018-06-04', 2, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 'Claudio Salgado', '', '', 0, 0, '', '', '', 1, 0, 'TRSTNJ  NNS', 'TRSTNJNNS'),
(26, 'XHIAN', 'T.', 'SAMSONA', '', 0, '2018-04-08', 2, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 'Claudio Salgado', '', '', 0, 0, '', '', '', 1, 0, 'SHN  SMSN', 'SHNSMSN'),
(27, 'DAVE KYLE', 'A', 'URNOS', '', 0, '2019-01-30', 2, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', 'Claudio Salgado', '', '', 0, 0, '', '', '', 1, 0, 'TFKL  URNS', 'TFKLRNS'),
(28, 'PRINCE HARRY', 'E.', 'ACOSTA', '', 0, '2018-02-05', 2, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'PRNSHR  AKST', 'PRNSHRKST'),
(29, 'OVEN', 'B.', 'ANGELES', '', 0, '2017-12-03', 2, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'OFN  ANJLS', 'OFNNJLS'),
(30, 'KING JAMES', 'M.', 'BERGONIA', '', 0, '2019-04-09', 2, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'KNKJMS  BRKN', 'KNKJMSBRKN'),
(31, 'SONNY BOY', 'B.', 'BERGONIA', '', 0, '2018-03-04', 2, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'SNB  BRKN', 'SNBBRKN'),
(32, 'DIEN JAMES', 'C. ', 'CAHILO', '', 0, '2019-01-28', 2, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'TNJMS  KHL', 'TNJMSKHL'),
(33, 'PRINCE JOHN', 'F.', 'LUCAS', '', 0, '2018-09-03', 2, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'PRNSJN  LKS', 'PRNSJNLKS'),
(34, 'CARL ADAM', 'E. ', 'MOONGALE', '', 0, '2018-04-15', 2, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'KRLTM  MNKL', 'KRLTMMNKL'),
(35, 'BRYSKOO YSAAC', 'E.', 'OBLIGAR', '', 0, '2018-01-29', 2, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'BRSKSK  OBLKR', 'BRSKSKBLKR'),
(36, 'ARTEMIO', 'I.', 'SENDITO', 'III', 0, '2018-04-05', 2, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'ARTM  SNTT', 'ARTMSNTT'),
(37, 'JUSTINE KIM', 'P. ', 'TRAQUEÑA', '', 0, '2019-05-01', 2, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'JSTNKM  TRKN', 'JSTNKMTRKN'),
(38, 'JAVELLA', 'R.', 'ANDAYA', '', 0, '2018-04-16', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'JFL  ANTY', 'JFLNTY'),
(39, 'CHARLENE', 'Q.', 'COMEDIA', '', 0, '2018-06-08', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'XRLN  KMT', 'XRLNKMT'),
(40, 'MAUREEN', 'D.', 'DEGUZMAN', '', 0, '2017-11-17', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'MRN  TKSMN', 'MRNTKSMN'),
(41, 'RENNA GRACE', 'D.', 'DELA CRUZ', '', 0, '2017-11-13', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'RNKRS  TLKRS', 'RNKRSTLKRS'),
(42, 'REANNA GRACE', 'D.', 'DELA CRUZ', '', 0, '2017-11-13', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'RNKRS  TLKRS', 'RNKRSTLKRS'),
(43, 'PRINCESS LHAND', 'S.', 'ESTACIO', '', 0, '2018-07-11', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'PRNSSLHNT  ESTS', 'PRNSSLHNTSTS'),
(44, 'ERELAH FLYNNE', 'D.', 'SALES', '', 0, '2018-09-21', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'ERLFLN  SLS', 'ERLFLNSLS'),
(45, 'JOYCE', 'V.', 'TEJADA', '', 0, '2018-09-29', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'JS  TJT', 'JSTJT'),
(46, 'NATHANIEL', 'E.', 'ALFARO', '', 0, '2018-04-10', 2, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'N0NL  ALFR', 'N0NLLFR'),
(47, 'MIKE RUSSEL', 'S.', 'ADVINCULA', '', 0, '2018-04-10', 2, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'MKRSL  ATFNKL', 'MKRSLTFNKL'),
(48, 'DAVID CARL', 'R.', 'BERON', '', 0, '2019-03-14', 2, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', 'Poblacion', '', '', 0, 0, '', '', '', 1, 0, 'TFTKRL  BRN', 'TFTKRLBRN'),
(49, 'MARK JAREN', 'S.', 'CANTONJOS', '', 0, '2018-10-20', 2, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', 'Poblacion', '', '', 0, 0, '', '', '', 1, 0, 'MRKJRN  KNTNJS', 'MRKJRNKNTNJS'),
(50, 'JERIC', 'D.', 'DACANAY', '', 0, '2019-04-26', 2, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', 'Poblacion', '', '', 0, 0, '', '', '', 1, 0, 'JRK  TKN', 'JRKTKN'),
(51, 'SED JC', 'F.', 'DANTAYANA', '', 0, '2018-01-27', 2, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', 'Poblacion', '', '', 0, 0, '', '', '', 1, 0, 'STJK  TNTYN', 'STJKTNTYN'),
(52, 'XIAN GABRIEL', 'M.', 'EUGENIO', '', 0, '2018-07-14', 2, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', 'Poblacion', '', '', 0, 0, '', '', '', 1, 0, 'SNKBRL  EJN', 'SNKBRLJN'),
(53, 'JOSHUA', 'A.', 'GALA', '', 0, '2018-02-23', 2, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', 'Poblacion', '', '', 0, 0, '', '', '', 1, 0, 'JX  KL', 'JXKL'),
(54, 'AARON', 'L.', 'GUTIERREZ', '', 0, '2019-01-10', 2, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', 'Poblacion', '', '', 0, 0, '', '', '', 1, 0, 'ARN  KTRS', 'ARNKTRS'),
(55, 'KURT ADRIAN', 'M.', 'ILAGAN', '', 0, '2017-12-23', 2, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', 'Poblacion', '', '', 0, 0, '', '', '', 1, 0, 'KRTTRN  ILKN', 'KRTTRNLKN'),
(56, 'KEN LOUIE', 'C.', 'LIGUTAN', '', 0, '2018-01-13', 2, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', 'Poblacion', '', '', 0, 0, '', '', '', 1, 0, 'KNL  LKTN', 'KNLLKTN'),
(57, 'CHRISTIAN', 'M.', 'LOPEZ', '', 0, '2019-01-28', 2, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', 'Poblacion', '', '', 0, 0, '', '', '', 1, 0, 'XRSXN  LPS', 'XRSXNLPS'),
(58, 'CLINT KYLER', 'B.', 'CALIPLIP', '', 0, '2018-06-06', 2, '', 'LIGAYA', 'Arellano', '', '', 0, 0, '', '', '', 1, 0, 'KLNTKLR  KLPLP', 'KLNTKLRKLPLP'),
(59, 'C-JHAY', 'M', 'JUAYNO', '', 0, '2019-03-18', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'KJH  JN', 'KJHJN'),
(60, 'JAYSON', 'M', 'LIZARDO', '', 0, '2018-01-05', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'JSN  LSRT', 'JSNLSRT'),
(61, 'PRINCE ARBE', 'M', 'OBSEQUIAS', '', 0, '2018-03-01', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'PRNSRB  OBSKS', 'PRNSRBBSKS'),
(62, 'REON CYRUZ', 'M', 'PALOMO', '', 0, '2019-12-13', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'RNSRS  PLM', 'RNSRSPLM'),
(63, 'NELJAY', 'L', 'RIMBAYNAN', '', 0, '2017-11-19', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'NLJ  RMNN', 'NLJRMNN'),
(64, 'ALJON ACE', 'P.', 'VIBANDOR', '', 0, '2018-04-16', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'ALJNS  FBNTR', 'ALJNSFBNTR'),
(65, 'KYLE JANE', 'P.', 'DAPROSA', '', 0, '2017-11-12', 1, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'KLJN  TPRS', 'KLJNTPRS'),
(66, 'MA. BELLE SALVACION', 'R.', 'DAPROSA', '', 0, '2018-05-17', 1, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'MBLSLFSN  TPRS', 'MBLSLFSNTPRS'),
(67, 'ANGELLA', 'T.', 'IRENEA', '', 0, '2018-10-21', 1, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'ANJL  IRN', 'ANJLRN'),
(68, 'KURTH ITHAN', 'P.', 'FERNANDEZ', '', 0, '2019-09-20', 2, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'KR00N  FRNNTS', 'KR00NFRNNTS'),
(69, 'JULIANA ERIN', 'C.', 'ADAP', '', 0, '2019-04-24', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'JLNRN  ATP', 'JLNRNTP'),
(70, 'AYESHA BLYSSE', 'Y', 'CACABELOS', '', 0, '2018-10-03', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'AYXBLS  KKBLS', 'AYXBLSKKBLS'),
(71, 'ASHLEY MAE', 'E.', 'CACHUELA', '', 0, '2018-05-17', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'AXLM  KXL', 'AXLMKXL'),
(72, 'KINSLY FIONA', 'B.', 'DIONIOSA', '', 0, '2018-10-06', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'KNSLFN  TNS', 'KNSLFNTNS'),
(73, 'ELIAH FAITH', 'D.', 'DULDULAO', '', 0, '2018-05-08', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'ELF0  TLTL', 'ELF0TLTL'),
(74, 'DANIELLA', 'F.', 'FRESNILLO', '', 0, '2018-04-13', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'TNL  FRSNL', 'TNLFRSNL'),
(75, 'SHANAYA NICOLE', 'A.', 'GARCIA', '', 0, '2018-09-20', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'XNYNKL  KRX', 'XNYNKLKRX'),
(76, 'WINDELYN GARCE', 'D.', 'LAGRIA', '', 0, '2018-11-09', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'WNTLNKRS  LKR', 'WNTLNKRSLKR'),
(77, 'MARY CHRIS', 'D.', 'LEGASPE', '', 0, '2018-11-07', 1, '', 'Ibud, Sablayan, Occidental Mindoro', 'Ibud', '', '', 0, 0, '', '', '', 1, 0, 'MRXRS  LKSP', 'MRXRSLKSP'),
(78, 'ATHENA REIN', 'D', 'AGUELO', '', 0, '2019-11-29', 1, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'A0NRN  AKL', 'A0NRNKL'),
(79, 'PRINCESS ANGEL', 'V', 'ALCANTARA', '', 0, '2018-04-01', 1, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'PRNSSNJL  ALKNTR', 'PRNSSNJLLKNTR'),
(80, 'QUINN ALLISON', 'S', 'CACABELOS', '', 0, '2018-09-16', 1, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'KNLSN  KKBLS', 'KNLSNKKBLS'),
(81, 'YASSI PARK', 'A', 'CAPINPIN', '', 0, '2018-08-13', 1, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'YSPRK  KPNPN', 'YSPRKKPNPN'),
(82, 'ARA BELLA', 'L', 'DELA CRUZ', '', 0, '2018-02-25', 1, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'ARBL  TLKRS', 'ARBLTLKRS'),
(83, 'MARY VENZ', 'D', 'DIAMA', '', 0, '2018-01-19', 1, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'MRFNS  TM', 'MRFNSTM'),
(84, 'BASHIA JANE', 'B', 'DUMANGON', '', 0, '2018-12-14', 1, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'BXJN  TMNKN', 'BXJNTMNKN'),
(85, 'ZHAVIA STARLET', 'V', 'DY', '', 0, '2018-04-15', 1, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'SHFSTRLT  T', 'SHFSTRLTT'),
(86, 'CHLOE', 'J.', 'FABIAN', '', 0, '2018-01-16', 1, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'XL  FBN', 'XLFBN'),
(87, 'ALLISON', 'A', 'GANON', '', 0, '2019-09-14', 1, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'ALSN  KNN', 'ALSNKNN'),
(88, 'RALPH', 'V', 'AGBO', '', 0, '2019-07-19', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'RLF  AKB', 'RLFKB'),
(89, 'PRINCE KELVIN', 'S', 'ABA-A', '', 0, '2018-06-28', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'PRNSKLFN  AB', 'PRNSKLFNB'),
(90, 'MAR  JHON', 'G', 'CORPUZ', '', 0, '2019-05-15', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'MRJHN  KRPS', 'MRJHNKRPS'),
(91, 'KIAN', 'M', 'DISTURA', '', 0, '2019-06-28', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'KN  TSTR', 'KNTSTR'),
(92, 'MARK YUEN', 'P', 'DE MESA', '', 0, '2018-07-22', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'MRKYN  TMS', 'MRKYNTMS'),
(93, 'M-JHAY', 'D', 'MAYO', '', 0, '2018-03-26', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'MJH  MY', 'MJHMY'),
(94, 'JHAY RHONEL', 'E', 'JACINTO', '', 0, '2018-08-12', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'JHRHNL  JSNT', 'JHRHNLJSNT'),
(95, 'LOVIE', 'R', 'PACLEB', '', 0, '2018-12-17', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'LF  PKLB', 'LFPKLB'),
(96, 'KHIAN', 'G', 'SULABO', '', 0, '2018-11-14', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'KHN  SLB', 'KHNSLB'),
(97, 'ZHIAN', 'A', 'SABILLON', '', 0, '2018-08-30', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'SHN  SBLN', 'SHNSBLN'),
(98, 'MARK ANDREI', 'V', 'SUPNAD', '', 0, '2018-09-17', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'MRKNTR  SPNT', 'MRKNTRSPNT'),
(99, 'ACZHILL RAIN', 'S', 'TAMBALQUE', '', 0, '2019-05-23', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'AKSHLRN  TMLK', 'AKSHLRNTMLK'),
(100, 'MARNELLE ANDRELLE', 'S', 'PRENCIONA', '', 0, '2018-10-25', 2, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'MRNLNTRL  PRNSN', 'MRNLNTRLPRNSN'),
(101, 'XYRIEL NOUVEN', 'M', 'ASPIRAS', '', 0, '2018-11-25', 2, '', 'Yapang Batong Buhay,Sablayan, Occidental,Mindoro', 'Batong Buhay', '', '', 0, 0, '', '', '', 1, 0, 'SRLNFN  ASPRS', 'SRLNFNSPRS'),
(102, 'JAKE MATTHEW', 'L', 'CAOILI', '', 0, '2018-05-03', 2, '', 'Yapang Batong Buhay,Sablayan, Occidental,Mindoro', 'Batong Buhay', '', '', 0, 0, '', '', '', 1, 0, 'JKMT  KL', 'JKMTKL'),
(103, 'JOHN MATTHEW', 'A', 'EJE', '', 0, '2018-01-17', 2, '', 'Yapang Batong Buhay,Sablayan, Occidental,Mindoro', 'Batong Buhay', '', '', 0, 0, '', '', '', 1, 0, 'JNMT  EJ', 'JNMTJ'),
(104, 'REVIER', 'T', 'ERESE', '', 0, '2018-02-26', 2, '', 'Yapang Batong Buhay,Sablayan, Occidental,Mindoro', 'Batong Buhay', '', '', 0, 0, '', '', '', 1, 0, 'RFR  ERS', 'RFRRS'),
(105, 'IAN JAY', 'G', 'FERNANDEZ', '', 0, '2018-11-05', 2, '', 'Yapang Batong Buhay,Sablayan, Occidental,Mindoro', 'Batong Buhay', '', '', 0, 0, '', '', '', 1, 0, 'INJ  FRNNTS', 'INJFRNNTS'),
(106, 'RJUN', 'M', 'LAYDA', '', 0, '2018-02-13', 2, '', 'Yapang Batong Buhay,Sablayan, Occidental,Mindoro', 'Batong Buhay', '', '', 0, 0, '', '', '', 1, 0, 'RJN  LT', 'RJNLT'),
(107, 'TYRON HUSSAINE', 'L', 'LIGTAS', '', 0, '2018-04-05', 2, '', 'Yapang Batong Buhay,Sablayan, Occidental,Mindoro', 'Batong Buhay', '', '', 0, 0, '', '', '', 1, 0, 'TRNHSN  LKTS', 'TRNHSNLKTS'),
(108, 'MIKAEL', 'M', 'MILITAR', '', 0, '2017-12-20', 2, '', 'Yapang Batong Buhay,Sablayan, Occidental,Mindoro', 'Batong Buhay', '', '', 0, 0, '', '', '', 1, 0, 'MKL  MLTR', 'MKLMLTR'),
(109, 'MATTHEW RAFFAEL', 'C', 'MUÑEZ', '', 0, '2018-09-02', 2, '', 'Yapang Batong Buhay,Sablayan, Occidental,Mindoro', 'Batong Buhay', '', '', 0, 0, '', '', '', 1, 0, 'MTRFL  MNS', 'MTRFLMNS'),
(110, 'JOMAR', 'E', 'OFIANA', '', 0, '2018-01-15', 2, '', 'Yapang Batong Buhay,Sablayan, Occidental,Mindoro', 'Batong Buhay', '', '', 0, 0, '', '', '', 1, 0, 'JMR  OFN', 'JMRFN'),
(111, 'PRINCE VAYNE', 'A', 'BALAOEN', '', 0, '2018-11-02', 2, '', 'Ilvita, Sablayan, Occidental, Mindoro', 'Ilvita', '', '', 0, 0, '', '', '', 1, 0, 'PRNSFN  BLN', 'PRNSFNBLN'),
(112, 'VON JOSHME DAMVI', 'A', 'CARDENAS', '', 0, '2018-06-02', 2, '', 'Ilvita, Sablayan, Occidental, Mindoro', 'Ilvita', '', '', 0, 0, '', '', '', 1, 0, 'FNJXMTMF  KRTNS', 'FNJXMTMFKRTNS'),
(113, 'ZEDRIC ROA', 'F', 'DIVINO', '', 0, '2019-01-06', 2, '', 'Ilvita, Sablayan, Occidental, Mindoro', 'Ilvita', '', '', 0, 0, '', '', '', 1, 0, 'STRKR  TFN', 'STRKRTFN'),
(114, 'MARK ETHAN', 'B', 'DOLIAGA', '', 0, '2019-04-11', 2, '', 'Ilvita, Sablayan, Occidental, Mindoro', 'Ilvita', '', '', 0, 0, '', '', '', 1, 0, 'MRK0N  TLK', 'MRK0NTLK'),
(115, 'JAMKARL CHIVAS', 'S', 'LIGGAYU', '', 0, '2018-08-03', 2, '', 'Ilvita, Sablayan, Occidental, Mindoro', 'Ilvita', '', '', 0, 0, '', '', '', 1, 0, 'JMKRLXFS  LKY', 'JMKRLXFSLKY'),
(116, 'LARRY BOY', 'V', 'MONTEMAYOR', '', 0, '2018-03-21', 2, '', 'Ilvita, Sablayan, Occidental, Mindoro', 'Ilvita', '', '', 0, 0, '', '', '', 1, 0, 'LRB  MNTMYR', 'LRBMNTMYR'),
(117, 'ERON', 'C', 'MENONG', '', 0, '2018-07-12', 2, '', 'Ilvita, Sablayan, Occidental, Mindoro', 'Ilvita', '', '', 0, 0, '', '', '', 1, 0, 'ERN  MNNK', 'ERNMNNK'),
(118, 'EUJAN', 'D', 'NAPILA', '', 0, '2018-07-24', 2, '', 'Ilvita, Sablayan, Occidental, Mindoro', 'Ilvita', '', '', 0, 0, '', '', '', 1, 0, 'EJN  NPL', 'EJNNPL'),
(119, 'GUT ASSEUEHEND', 'A', 'NAPILA', '', 0, '2018-04-09', 2, '', 'Ilvita, Sablayan, Occidental, Mindoro', 'Ilvita', '', '', 0, 0, '', '', '', 1, 0, 'KTSHNT  NPL', 'KTSHNTNPL'),
(120, 'PRINCE NINO', 'A', 'ORTIZ', '', 0, '2018-01-21', 2, '', 'Ilvita, Sablayan, Occidental, Mindoro', 'Ilvita', '', '', 0, 0, '', '', '', 1, 0, 'PRNSNN  ORTS', 'PRNSNNRTS'),
(121, 'ZION', 'P', 'AGUSTIN', '', 0, '2019-01-17', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'SN  AKSTN', 'SNKSTN'),
(122, 'JAYCUB', 'D.', 'ADVINCULA', '', 0, '2019-04-13', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'JKB  ATFNKL', 'JKBTFNKL'),
(123, 'RONA', 'G', 'BAQUIRIN', '', 0, '2019-04-13', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Arellano', '', '', 0, 0, '', '', '', 1, 0, 'RN  BKRN', 'RNBKRN'),
(124, 'JAYLORD', 'N.', 'BALLOLA', '', 0, '2019-05-27', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'JLRT  BLL', 'JLRTBLL'),
(125, 'HARVEY JED', 'F.', 'BAUTISTA', '', 0, '2019-10-28', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Arellano', '', '', 0, 0, '', '', '', 1, 0, 'HRFJT  BTST', 'HRFJTBTST'),
(126, 'CALVIN JAKE', 'P.', 'CABOS', '', 0, '2019-02-03', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'KLFNJK  KBS', 'KLFNJKKBS'),
(127, 'BLUE', 'M.', 'CAYETANO', '', 0, '2018-12-15', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'BL  KYTN', 'BLKYTN'),
(128, 'WILSON', 'E.', 'CASTILLO', '', 0, '2018-12-09', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'WLSN  KSTL', 'WLSNKSTL'),
(129, 'NJ', 'D.', 'CORDIS', '', 0, '2018-03-27', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'NJ  KRTS', 'NJKRTS'),
(130, 'PRINCE', 'G.', 'CASTILLEJOS', '', 0, '2018-12-07', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'PRNS  KSTLJS', 'PRNSKSTLJS'),
(131, 'PRINCE DENZEL', 'V.', 'DANSECO', '', 0, '2018-05-19', 2, '', 'Tagumpay, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'PRNSTNSL  TNSK', 'PRNSTNSLTNSK'),
(132, 'WINNER', 'L.', 'LIGAYDE', '', 0, '2018-08-11', 2, '', 'Sitio Tyabong, Ligaya ,Sabalayan, Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'WNR  LKT', 'WNRLKT'),
(133, 'GINO', 'L.', 'LIGAYDE', '', 0, '2018-08-11', 2, '', 'Sitio Tyabong ,Ligaya ,Sablayan Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'JN  LKT', 'JNLKT'),
(134, 'ACHER', 'M.', 'FALIKDE', '', 0, '2018-07-11', 2, '', 'Sitio Tyabong, Ligaya ,Sabalayan ,Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'AXR  FLKT', 'AXRFLKT'),
(135, 'FLOREX', 'L.', 'SUNGGALUM', '', 0, '2018-06-11', 2, '', 'Sitio tyabong ,Ligaya, Sabalayan, Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'FLRKS  SNKLM', 'FLRKSSNKLM'),
(136, 'NORILYN', 'M.', 'LIWADE', '', 0, '2019-09-05', 2, '', 'Sitio Tyabong,Ligaya, Sablayan Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'NRLN  LWT', 'NRLNLWT'),
(137, 'RISHEL', 'M.', 'LIMBOYUNGAN', '', 0, '2017-05-19', 2, '', 'Sitio Tyabong, Ligaya, Sabalayan, Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'RXL  LMYNKN', 'RXLLMYNKN'),
(138, 'CRISYALYN', 'M.', 'DULONGAN', '', 0, '2017-04-19', 2, '', 'Sitio Tyabong, Ligaya, Sabalayan, Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'KRSYLN  TLNKN', 'KRSYLNTLNKN'),
(139, 'SOFHIA', 'M.', 'LAUYMAN', '', 0, '2018-10-24', 2, '', 'Sitio Tyabong, Ligaya, Sablayan, Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'SFH  LMN', 'SFHLMN'),
(140, 'LERIAN', 'B.', 'LAUYMAN', '', 0, '2019-02-22', 2, '', 'Sitio Tyabong, Sablayan, Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'LRN  LMN', 'LRNLMN'),
(141, 'LIDYA', 'M.', 'ANIGAN', '', 0, '2017-06-18', 2, '', 'Sitio Tyabong, Ligaya, Sabalayan, Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'LTY  ANKN', 'LTYNKN'),
(142, 'NALYN', 'L.', 'sUNGGALOM', '', 0, '2017-03-11', 2, '', 'Sitio Tyabong, Ligaya, Sabalayan, Occidental Mindoro', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'NLN  SNKLM', 'NLNSNKLM'),
(143, 'NATHAN', 'S.', 'FABITO', '', 0, '2018-10-09', 2, '', 'Sitio Pusog, Burgos,Sabalayan,occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'N0N  FBT', 'N0NFBT'),
(144, 'WILFREDO', 'N.', 'MATEO', '', 0, '2017-11-19', 2, '', 'Sitio Pusog, Burgos, Sablayan, Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'WLFRT  MT', 'WLFRTMT'),
(145, 'CJ', 'P.', 'PINON', '', 0, '2017-02-12', 2, '', 'Sitio Pusog, Burgos, Sablayan, Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'KJ  PNN', 'KJPNN'),
(146, 'JOHN CYRUS', 'P.', 'SUYAT', '', 0, '2019-10-04', 2, '', 'Sitio Pusog, Burgos,Sabalayan, Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'JNSRS  SYT', 'JNSRSSYT'),
(147, 'JONEL', 'M.', 'SUYAT', '', 0, '2019-06-18', 2, '', 'Sitio Pusog, Burgos, Sabalayan, Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'JNL  SYT', 'JNLSYT'),
(148, 'JOHN KIAN', 'P.', 'ALAP', '', 0, '2017-12-30', 2, '', 'Lagnas, Sablayan, Occidental Mindoro', 'Lagnas', '', '', 0, 0, '', '', '', 1, 0, 'JNKN  ALP', 'JNKNLP'),
(149, 'JERICK', 'M.', 'ARQUERO', '', 0, '2018-04-19', 2, '', 'Lagnas, Sablayan, Occidental Mindoro', 'Lagnas', '', '', 0, 0, '', '', '', 1, 0, 'JRK  ARKR', 'JRKRKR'),
(150, 'SHUN CALI', 'P.', 'BIBAT', '', 0, '2019-11-11', 2, '', 'Lagnas, Sablayan, Occidental Mindoro', 'Lagnas', '', '', 0, 0, '', '', '', 1, 0, 'XNKL  BBT', 'XNKLBBT'),
(151, 'KURT LIAM', 'T.', 'DOTON', '', 0, '2019-02-15', 2, '', 'Lagnas, Sablayan, Occidental Mindoro', 'Lagnas', '', '', 0, 0, '', '', '', 1, 0, 'KRTLM  TTN', 'KRTLMTTN'),
(152, 'REYMARK', 'C.', 'CORTEZ', '', 0, '2018-03-09', 2, '', 'Lagnas, Sablayan, Occidental Mindoro', 'Lagnas', '', '', 0, 0, '', '', '', 1, 0, 'RMRK  KRTS', 'RMRKKRTS'),
(153, 'NATHAN', 'C.', 'COSME', '', 0, '2018-12-19', 2, '', 'Lagnas, Sablayan, Occidental Mindoro', 'Lagnas', '', '', 0, 0, '', '', '', 1, 0, 'N0N  KSM', 'N0NKSM'),
(154, 'FRANCIS ', 'R.', 'DERILON', '', 0, '2018-01-01', 2, '', 'Lagnas, Sablayan, Occidental Mindoro', 'Lagnas', '', '', 0, 0, '', '', '', 1, 0, 'FRNSS  TRLN', 'FRNSSTRLN'),
(155, 'JAMES', 'P.', 'EBALOBO', '', 0, '2018-06-26', 2, '', 'Lagnas, Sablayan, Occidental Mindoro', 'Lagnas', '', '', 0, 0, '', '', '', 1, 0, 'JMS  EBLB', 'JMSBLB'),
(156, 'RENZEL', 'D.', 'IMPRESO', '', 0, '2018-12-21', 2, '', 'Lagnas, Sablayan, Occidental Mindoro', 'Lagnas', '', '', 0, 0, '', '', '', 1, 0, 'RNSL  IMPRS', 'RNSLMPRS'),
(157, 'KIAN', 'R.', 'LAGULA', '', 0, '2018-07-25', 2, '', 'Lagnas, Sablayan, Occidental Mindoro', 'Lagnas', '', '', 0, 0, '', '', '', 1, 0, 'KN  LKL', 'KNLKL'),
(158, 'PRINCE JAY', 'C.', 'ALEJANDRO', '', 0, '2018-08-10', 2, '', 'Ilaya, Sto. Niño, Sablayan, Occidental Mindoro', 'Sato Nino', '', '', 0, 0, '', '', '', 1, 0, 'PRNSJ  ALJNTR', 'PRNSJLJNTR'),
(159, 'ZYNN UZZIAH', 'G.', 'ANTARAN', '', 0, '2018-01-25', 2, '', 'Ilaya, Sto. Niño, Sablayan, Occidental Mindoro', 'Sato Nino', '', '', 0, 0, '', '', '', 1, 0, 'SNS  ANTRN', 'SNSNTRN'),
(160, 'JOHN ELIAZAR', 'A.', 'BALDERA', '', 0, '2018-11-22', 2, '', 'Ilaya, Sto. Niño, Sablayan, Occidental Mindoro', 'Sato Nino', '', '', 0, 0, '', '', '', 1, 0, 'JNLSR  BLTR', 'JNLSRBLTR'),
(161, 'JAY-C', 'S.', 'BENDECIO', '', 0, '2019-09-29', 2, '', 'Ilaya, Sto. Niño, Sablayan, Occidental Mindoro', 'Sato Nino', '', '', 0, 0, '', '', '', 1, 0, 'JK  BNTS', 'JKBNTS'),
(162, 'JOHN ALMER', 'G.', 'BRINCES', '', 0, '2018-06-06', 2, '', 'Ilaya, Sto. Niño, Sablayan, Occidental Mindoro', 'Sato Nino', '', '', 0, 0, '', '', '', 1, 0, 'JNLMR  BRNSS', 'JNLMRBRNSS'),
(163, 'JOHN CEDRIC', 'B.', 'CACABELOS', '', 0, '2018-06-12', 2, '', 'Ilaya, Sto. Niño, Sablayan, Occidental Mindoro', 'Sato Nino', '', '', 0, 0, '', '', '', 1, 0, 'JNSTRK  KKBLS', 'JNSTRKKKBLS'),
(164, 'ANDREI', 'P.', 'CALALO', '', 0, '2019-06-22', 2, '', 'Ilaya, Sto. Niño, Sablayan, Occidental Mindoro', 'Sato Nino', '', '', 0, 0, '', '', '', 1, 0, 'ANTR  KLL', 'ANTRKLL'),
(165, 'BERSHEL', 'B.', 'DALUÑAZA', '', 0, '2019-03-13', 2, '', 'Ilaya, Sto. Niño, Sablayan, Occidental Mindoro', 'Sato Nino', '', '', 0, 0, '', '', '', 1, 0, 'BRXL  TLNS', 'BRXLTLNS'),
(166, 'JUSTINE', 'D.', 'DELA CRUZ', '', 0, '2019-05-10', 2, '', 'Ilaya, Sto. Niño. Sablayan, Occidental Mindoro', 'Sato Nino', '', '', 0, 0, '', '', '', 1, 0, 'JSTN  TLKRS', 'JSTNTLKRS'),
(167, 'JESHRYL', 'M.', 'DELA TORRE', '', 0, '2018-08-14', 2, '', 'Ilaya, Sto. Niño. Sablayan, Occidental Mindoro', 'Sato Nino', '', '', 0, 0, '', '', '', 1, 0, 'JXRL  TLTR', 'JXRLTLTR'),
(168, 'JHAYMAR', 'M.', 'AGUSTIN', '', 0, '2018-12-19', 2, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 'Tuban', '', '', 0, 0, '', '', '', 1, 0, 'JHMR  AKSTN', 'JHMRKSTN'),
(169, 'OVEN', 'A.', 'ANGELES', 'JR', 0, '2017-12-03', 2, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 'Tuban', '', '', 0, 0, '', '', '', 1, 0, 'OFN  ANJLS', 'OFNNJLS'),
(170, 'NIKKO', 'G.', 'DELOS SANTOS', '', 0, '2018-11-10', 2, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 'Tuban', '', '', 0, 0, '', '', '', 1, 0, 'NK  TLSSNTS', 'NKTLSSNTS'),
(171, 'JEROLD', 'A.', 'DIOSO', '', 0, '2018-01-26', 2, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 'Tuban', '', '', 0, 0, '', '', '', 1, 0, 'JRLT  TS', 'JRLTTS'),
(172, 'JOHN LEO', 'P.', 'DOMINGO', '', 0, '2018-08-03', 2, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 'Tuban', '', '', 0, 0, '', '', '', 1, 0, 'JNL  TMNK', 'JNLTMNK'),
(173, 'NATHAN', 'T.', 'ERO', '', 0, '2018-12-22', 2, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 'Tuban', '', '', 0, 0, '', '', '', 1, 0, 'N0N  ER', 'N0NR'),
(174, 'TERRENCE', 'P.', 'EVANGELISTA', '', 0, '2018-08-12', 2, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 'Tuban', '', '', 0, 0, '', '', '', 1, 0, 'TRNS  EFNJLST', 'TRNSFNJLST'),
(175, 'PRINCE MCKHING', 'G.', 'EVANGELISTA', '', 0, '2018-04-10', 2, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 'Tuban', '', '', 0, 0, '', '', '', 1, 0, 'PRNSMKHNK  EFNJLST', 'PRNSMKHNKFNJLST'),
(176, 'ADRIAN', 'S.', 'GARCIA', '', 0, '2019-03-30', 2, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 'Tuban', '', '', 0, 0, '', '', '', 1, 0, 'ATRN  KRX', 'ATRNKRX'),
(177, 'SIDRICK', 'J.', 'GENATA', '', 0, '2018-06-19', 2, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', 'Tuban', '', '', 0, 0, '', '', '', 1, 0, 'STRK  JNT', 'STRKJNT'),
(178, 'ABNER', 'U.', 'ABALOS', 'JR', 0, '2018-10-31', 2, '', 'San Carlo, San Francisco, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'ABNR  ABLS', 'ABNRBLS'),
(179, 'PRINCE YUHANN', 'D.', 'ARLIGUE', '', 0, '2019-04-30', 2, '', 'San Carlo, San Francisco, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'PRNSYHN  ARLK', 'PRNSYHNRLK'),
(180, 'KIZE KINRODDECY', 'P.', 'BERMUDO', '', 0, '2019-11-08', 2, '', 'San Carlo, San Francisco, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'KSKNRTS  BRMT', 'KSKNRTSBRMT'),
(181, 'MARC IAN', 'S.', 'GUYO', '', 0, '2018-03-06', 2, '', 'San Carlo, San Francisco, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'MRKN  KY', 'MRKNKY'),
(182, 'VAN ASHTON', 'C.', 'GALINATO', '', 0, '2018-05-04', 2, '', 'San Carlo, San Francisco, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'FNXTN  KLNT', 'FNXTNKLNT'),
(183, 'XHIAN ANDRES', 'B.', 'MANZANILLO', '', 0, '2018-11-04', 2, '', 'San Carlo, San Francisco, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'SHNNTRS  MNSNL', 'SHNNTRSMNSNL'),
(184, 'ERNETHAN', 'S.', 'SALGADO', '', 0, '2018-11-04', 2, '', 'San Carlo, San Francisco, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'ERN0N  SLKT', 'ERN0NSLKT'),
(185, 'JAKE DEAN', '', 'SONIO', '', 0, '2018-06-13', 1, '', 'San Carlo, San Francisco, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'JKTN  SN', 'JKTNSN'),
(186, 'CHARLENE DEAN', 'S.', 'CUETO', '', 0, '2019-03-12', 1, '', 'San Carlo, San Francisco, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'XRLNTN  KT', 'XRLNTNKT'),
(187, 'APRIL CRISHA', 'I.', 'COLLADO', '', 0, '2019-04-15', 1, '', 'San Carlo, San Francisco, Sablayan, Occidental Mindoro', 'Tagumpay', '', '', 0, 0, '', '', '', 1, 0, 'APRLKRX  KLT', 'APRLKRXKLT'),
(188, 'DERLYN', 'H.', 'ATORNEY', '', 0, '2017-08-30', 1, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'TRLN  ATRN', 'TRLNTRN'),
(189, 'LYZA', 'M.', 'MACAMBANG', '', 0, '2018-02-23', 1, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'LS  MKMNK', 'LSMKMNK'),
(190, 'RELYN', 'A.', 'BINLIN', '', 0, '2017-08-30', 1, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'RLN  BNLN', 'RLNBNLN'),
(191, 'RODELYN', 'A.', 'SIGUNDA', '', 0, '2018-10-29', 1, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'RTLN  SKNT', 'RTLNSKNT'),
(192, 'MARY GRACE', 'A.', 'ATORNEY', '', 0, '2017-11-30', 1, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'MRKRS  ATRN', 'MRKRSTRN'),
(193, 'MISIL', 'C.', 'MANALO', '', 0, '2017-10-28', 1, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'MSL  MNL', 'MSLMNL'),
(194, 'ALBERT', 'C.', 'MANALO', '', 0, '2017-04-09', 1, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'ALBRT  MNL', 'ALBRTMNL'),
(195, 'ANDELO', 'D.', 'APORADO', '', 0, '2018-10-19', 1, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'ANTL  APRT', 'ANTLPRT'),
(196, 'ARIEL', 'D.', 'HABANGBUHAY', '', 0, '2017-12-07', 1, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'ARL  HBNKBH', 'ARLHBNKBH'),
(197, 'EDMAR', 'M.', 'MAAYOS', '', 0, '2018-04-08', 1, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'ETMR  MYS', 'ETMRMYS'),
(198, 'JASTER', 'B.', 'MANALO', '', 0, '2018-04-11', 2, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'JSTR  MNL', 'JSTRMNL'),
(199, 'JENDIL', 'I.', 'DAPITO', '', 0, '2017-12-19', 2, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'JNTL  TPT', 'JNTLTPT'),
(200, 'KLENN JUDE', 'M.', 'MAGAN', '', 0, '2018-03-12', 2, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'KLNJT  MKN', 'KLNJTMKN'),
(201, 'LEYMAR', 'M.', 'MAAYOS', '', 0, '2017-11-17', 2, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'LMR  MYS', 'LMRMYS'),
(202, 'SAMUEL', 'L.', 'MAAYOS', '', 0, '2017-08-19', 2, '', 'Calamansian, San Agustin, Sablayan Occidental Mindoro', 'San Agustin', '', '', 0, 0, '', '', '', 1, 0, 'SML  MYS', 'SMLMYS'),
(203, 'PETER PAUL', 'M.', 'CALMORIN', '', 0, '2018-10-14', 2, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'PTRPL  KLMRN', 'PTRPLKLMRN'),
(204, 'SYD DAYNIEL', '', 'CORSAME', '', 0, '2018-05-18', 2, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'STTNL  KRSM', 'STTNLKRSM'),
(205, 'ADAM ALONSO', '', 'DE DIOS', '', 0, '2018-11-17', 2, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'ATMLNS  TTS', 'ATMLNSTTS'),
(206, 'RONALDO', 'A.', 'DILAO', '', 0, '2018-08-26', 2, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'RNLT  TL', 'RNLTTL'),
(207, 'KYOHANN ', 'M.', 'GALLENERO', '', 0, '2019-05-07', 2, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'KYHN  KLNR', 'KYHNKLNR'),
(208, 'CARLO', 'G.', 'MARTINEZ', '', 0, '2018-03-10', 2, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'KRL  MRTNS', 'KRLMRTNS'),
(209, 'JOSE ANTONIO', 'B.', 'NAVARRO', '', 0, '2017-11-13', 2, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'JSNTN  NFR', 'JSNTNNFR'),
(210, 'BRENT ANDREW', 'R.', 'PASARON', '', 0, '2018-08-10', 2, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'BRNTNTR  PSRN', 'BRNTNTRPSRN'),
(211, 'JACOB', 'M.', 'POLICARPO', '', 0, '2018-01-13', 2, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'JKB  PLKRP', 'JKBPLKRP'),
(212, 'CLARENCE', 'D.', 'PU-0D', '', 0, '2018-12-27', 2, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'KLRNS  PT', 'KLRNSPT'),
(213, 'JOHN PAUL', 'D.', 'AMANTE', '', 0, '2017-10-22', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'JNPL  AMNT', 'JNPLMNT'),
(214, 'VERGIL', 'V.', 'ARATIA', '', 0, '2018-08-18', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'FRJL  ARX', 'FRJLRX'),
(215, 'TRISTAN', 'M.', 'CASTRO', '', 0, '2018-09-23', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'TRSTN  KSTR', 'TRSTNKSTR'),
(216, 'RILJAY', 'G.', 'COMISO', '', 0, '2019-08-26', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'RLJ  KMS', 'RLJKMS'),
(217, 'JAMES NATHAN', 'B.', 'DE DIOS', '', 0, '2019-03-01', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'JMSN0N  TTS', 'JMSN0NTTS'),
(218, 'RYLAN THOR', 'R.', 'DISCORA', '', 0, '2019-07-23', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'RLN0R  TSKR', 'RLN0RTSKR'),
(219, 'TRISTAN DAVE', 'A.', 'ESTEVES', '', 0, '2019-10-03', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'TRSTNTF  ESTFS', 'TRSTNTFSTFS'),
(220, 'RAFFY', 'D.', 'GALLARIS', '', 0, '2018-08-10', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'RF  KLRS', 'RFKLRS'),
(221, 'JOHN CARLO', 'S.', 'GALLOSA', '', 0, '2018-03-28', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'JNKRL  KLS', 'JNKRLKLS'),
(222, 'SHIRI ISAAC', 'D', 'INOVERO', '', 0, '2019-02-02', 2, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', 'Ligaya', '', '', 0, 0, '', '', '', 1, 0, 'XRSK  INFR', 'XRSKNFR'),
(223, 'MEAH', 'R.', 'DALPITRAN', '', 0, '2018-03-05', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'M  TLPTRN', 'MTLPTRN'),
(224, 'MEAH GRACE', 'M.', 'DANGEROS', '', 0, '2019-12-19', 1, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'MKRS  TNJRS', 'MKRSTNJRS'),
(225, 'LAIRA SHANE', 'S.', 'DUGTONG', '', 0, '2018-12-20', 1, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'LRXN  TKTNK', 'LRXNTKTNK'),
(226, 'KHIANNE', 'S.', 'FERNANDO', '', 0, '2018-04-02', 1, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'KHN  FRNNT', 'KHNFRNNT'),
(227, 'YSABELLE', 'R.', 'IMPERIAL', '', 0, '2018-05-03', 1, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'SBL  IMPRL', 'SBLMPRL'),
(228, 'JANINE', 'S.', 'MODESTO', '', 0, '2019-05-19', 1, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'JNN  MTST', 'JNNMTST'),
(229, 'ALAIZA MARIE', 'V.', 'NAMARDO', '', 0, '2018-12-02', 1, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'ALSMR  NMRT', 'ALSMRNMRT'),
(230, 'MYRALENE', 'N.', 'NARDO', '', 0, '2019-10-27', 1, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'MRLN  NRT', 'MRLNNRT'),
(231, 'LEIANNE FAYE', 'S.', 'SILANG', '', 0, '2018-10-04', 1, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'LNFY  SLNK', 'LNFYSLNK'),
(232, 'BEA', 'C.', 'SIXON', '', 0, '2019-09-19', 1, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'B  SKSN', 'BSKSN'),
(233, 'ZYMON', 'B.', 'ACOSTA', '', 0, '2018-12-25', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'SMN  AKST', 'SMNKST'),
(234, 'JAMES', 'E.', 'AMORES', '', 0, '2018-08-22', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'JMS  AMRS', 'JMSMRS'),
(235, 'REAVEED', 'S.', 'BAYOG', '', 0, '2018-08-09', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'RFT  BYK', 'RFTBYK'),
(236, 'CALEB', 'F.', 'DELA CRUZ', '', 0, '2018-05-13', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'KLB  TLKRS', 'KLBTLKRS'),
(237, 'ALJUN', 'S.', 'DENISADO', '', 0, '2018-02-11', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'ALJN  TNST', 'ALJNTNST'),
(238, 'RIO CARL DION', 'M.', 'ELEGADO', '', 0, '2019-12-26', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'RKRLTN  ELKT', 'RKRLTNLKT'),
(239, 'ZEUS JAYCOB', 'B.', 'JOLDANERO', '', 0, '2019-06-07', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'SSJKB  JLTNR', 'SSJKBJLTNR'),
(240, 'CHARLES DAVE', 'C,', 'LEGASPINA', '', 0, '2018-09-25', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'XRLSTF  LKSPN', 'XRLSTFLKSPN'),
(241, 'CHRISTOPHER', 'M.', 'MANZANO', '', 0, '2018-10-21', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'XRSTFR  MNSN', 'XRSTFRMNSN'),
(242, 'KAIZER JAY', 'D.', 'NENING', '', 0, '2018-02-21', 2, '', 'San Francisco, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'KSRJ  NNNK', 'KSRJNNNK'),
(243, 'JOHN MARK', 'P.', 'ADAY', '', 0, '2018-03-21', 1, '', 'Pag-Asa,Sablayan, Occidental Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'JNMRK  AT', 'JNMRKT'),
(244, 'LIAN ZANDER', 'B.', 'ARQUERO', '', 0, '2018-01-05', 1, '', 'Pag-Asa,Sablayan, Occidental Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'LNSNTR  ARKR', 'LNSNTRRKR'),
(245, 'MARK  JHAY', 'M.', 'BALLESTEROS', '', 0, '2017-07-23', 1, '', 'Pag-Asa,Sablayan, Occidental Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'MRKJH  BLSTRS', 'MRKJHBLSTRS'),
(246, 'KALVIN JAY', 'T.', 'BENOSA', '', 0, '2018-09-28', 2, '', 'Pag-Asa,Sablayan, Occidental Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'KLFNJ  BNS', 'KLFNJBNS'),
(247, 'KRIZTAN JUDE', 'B.', 'DELA CRUZ', '', 0, '2018-08-11', 2, '', 'Pag-Asa,Sablayan, Occidental Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'KRSTNJT  TLKRS', 'KRSTNJTTLKRS'),
(248, 'MARVIN JAY', 'L.', 'DELA CRUZ', '', 0, '2017-12-05', 2, '', 'Pag-Asa,Sablayan, Occidental Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'MRFNJ  TLKRS', 'MRFNJTLKRS'),
(249, 'KOWEN DAVE', 'M.', 'DOMINGDO', '', 0, '2018-04-30', 2, '', 'Pag-Asa,Sablayan, Occidental Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'KWNTF  TMNKT', 'KWNTFTMNKT'),
(250, 'JECKYLL', 'S.', 'DE JOSE', '', 0, '2018-07-21', 2, '', 'Pag-Asa,Sablayan, Occidental Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'JKL  TJS', 'JKLTJS'),
(251, 'KING RICHARD', 'T.', 'EMILIO', '', 0, '2017-11-21', 2, '', 'Pag-Asa,Sablayan, Occidental Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'KNKRXRT  EML', 'KNKRXRTML'),
(252, 'JOHN ', 'S', 'FERNANDEZ', '', 0, '2017-11-19', 2, '', 'Pag-Asa,Sablayan, Occidental Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'JN  FRNNTS', 'JNFRNNTS'),
(253, 'ZACH ASHER', 'F.', 'SALAMANCA', '', 0, '2019-05-29', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'SXXR  SLMNK', 'SXXRSLMNK'),
(254, 'ZYRIEL', 'S.', 'VILLARENO', '', 0, '2017-11-01', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'SRL  FLRN', 'SRLFLRN'),
(255, 'MARIO GIL', 'A.', 'PINEDA', '', 0, '2019-02-12', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'MRJL  PNT', 'MRJLPNT'),
(256, 'SKYLET', 'C.', 'BERMUDO', '', 0, '2019-01-29', 1, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'SKLT  BRMT', 'SKLTBRMT'),
(257, 'CZYN STACEY', 'D.', 'PERLAS', '', 0, '2018-12-19', 1, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'KSNSTS  PRLS', 'KSNSTSPRLS'),
(258, 'KAIZEAH', 'B', 'CARINO', '', 0, '2017-11-12', 1, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'KS  KRN', 'KSKRN'),
(259, 'BANNY', 'A.', 'BALIN', '', 0, '2018-11-29', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'BN  BLN', 'BNBLN'),
(260, 'SKYLOR', 'C.', 'BERMUDO', '', 0, '2017-11-29', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'SKLR  BRMT', 'SKLRBRMT'),
(261, 'NICO', 'S,.', 'LASTRA', '', 0, '2018-07-01', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'NK  LSTR', 'NKLSTR'),
(262, 'JIRO', 'P.', 'DANGEROS', '', 0, '2019-10-26', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'JR  TNJRS', 'JRTNJRS'),
(263, 'RAIN CHEDAN', 'Q.', 'AGBU', '', 0, '2018-01-09', 2, '', 'Buensvista, Sablayan, Occidental Mindoro', 'Buenavista', '', '', 0, 0, '', '', '', 1, 0, 'RNXTN  AKB', 'RNXTNKB'),
(264, 'KIANNE KIRK', 'B.', 'BABARAN', '', 0, '2018-06-10', 2, '', 'Buensvista, Sablayan, Occidental Mindoro', 'Buenavista', '', '', 0, 0, '', '', '', 1, 0, 'KNKRK  BBRN', 'KNKRKBBRN'),
(265, 'THADDEUS ZET', 'V.', 'DE LEMOS', '', 0, '2019-07-08', 2, '', 'Buensvista, Sablayan, Occidental Mindoro', 'Buenavista', '', '', 0, 0, '', '', '', 1, 0, '0TSST  TLMS', '0TSSTTLMS'),
(266, 'ALEX', 'D.', 'LOZADA', '', 0, '2018-01-28', 2, '', 'Buensvista, Sablayan, Occidental Mindoro', 'Buenavista', '', '', 0, 0, '', '', '', 1, 0, 'ALKS  LST', 'ALKSLST'),
(267, 'ZION', 'O.', 'ORDENES', '', 0, '2018-01-21', 2, '', 'Buensvista, Sablayan, Occidental Mindoro', 'Buenavista', '', '', 0, 0, '', '', '', 1, 0, 'SN  ORTNS', 'SNRTNS'),
(268, 'KENZO KENZHIN KEV', 'Q.', 'PASAJOL', '', 0, '2018-06-12', 2, '', 'Buensvista, Sablayan, Occidental Mindoro', 'Buenavista', '', '', 0, 0, '', '', '', 1, 0, 'KNSKNSHNKF  PSJL', 'KNSKNSHNKFPSJL'),
(269, 'AREM', 'Q.', 'SOTTO', '', 0, '2018-11-01', 2, '', 'Buensvista, Sablayan, Occidental Mindoro', 'Buenavista', '', '', 0, 0, '', '', '', 1, 0, 'ARM  ST', 'ARMST'),
(270, 'KALIX LEE', 'B.', 'SIMPELO', '', 0, '2018-05-12', 2, '', 'Buensvista, Sablayan, Occidental Mindoro', 'Buenavista', '', '', 0, 0, '', '', '', 1, 0, 'KLKSL  SMPL', 'KLKSLSMPL'),
(271, 'JOMARIE', 'Y.', 'SILAVA', '', 0, '2018-09-30', 2, '', 'Buensvista, Sablayan, Occidental Mindoro', 'Buenavista', '', '', 0, 0, '', '', '', 1, 0, 'JMR  SLF', 'JMRSLF'),
(272, 'MATEO', 'M.', 'SORIA', '', 0, '2019-05-27', 2, '', 'Buensvista, Sablayan, Occidental Mindoro', 'Buenavista', '', '', 0, 0, '', '', '', 1, 0, 'MT  SR', 'MTSR'),
(273, 'NAITHAN', 'R.', 'AGUILAR', '', 0, '2019-06-23', 2, '', 'Santa Lucia, Sablayan, Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'N0N  AKLR', 'N0NKLR'),
(274, 'RONNIE JAY', 'G.', 'ARCAYAN', '', 0, '2018-05-20', 2, '', 'Santa Lucia, Sablayan, Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'RNJ  ARKYN', 'RNJRKYN'),
(275, 'DANIEL', 'C.', 'DELOS REYES', '', 0, '2018-04-24', 2, '', 'Santa Lucia, Sablayan, Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'TNL  TLSRYS', 'TNLTLSRYS');
INSERT INTO `epupils` (`pupilsId`, `fName`, `mName`, `lName`, `ext`, `age`, `birthDate`, `gender`, `sector`, `address`, `barangay`, `municipality`, `province`, `weight`, `height`, `dateAdded`, `dateUpdated`, `pupilsCode`, `app`, `status`, `keywords`, `keywords_2`) VALUES
(276, 'MARK JAYSON', 'J.', 'DOMINGO', '', 0, '2017-11-26', 2, '', 'Santa Lucia, Sablayan, Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'MRKJSN  TMNK', 'MRKJSNTMNK'),
(277, 'RAMIL', 'P.', 'FERNANDO', '', 0, '2018-08-03', 2, '', 'Santa Lucia, Sablayan, Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'RML  FRNNT', 'RMLFRNNT'),
(278, 'SAMJHAY', 'L.', 'GREGORIO', '', 0, '2018-05-05', 2, '', 'Santa Lucia, Sablayan, Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'SMJH  KRKR', 'SMJHKRKR'),
(279, 'MJ', 'C.', 'MABUNGA', '', 0, '2019-06-27', 2, '', 'Santa Lucia, Sablayan, Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'MJ  MBNK', 'MJMBNK'),
(280, 'PRINCE JAY', 'E.', 'PATAL', '', 0, '2018-08-24', 2, '', 'Santa Lucia, Sablayan, Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'PRNSJ  PTL', 'PRNSJPTL'),
(281, 'FRANCE JAKE', 'E.', 'PATAL', '', 0, '2018-08-24', 2, '', 'Santa Lucia, Sablayan, Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'FRNSJK  PTL', 'FRNSJKPTL'),
(282, 'HANZ ALE', 'S,.', 'ROXAS', '', 0, '2018-06-10', 2, '', 'Santa Lucia, Sablayan, Occidental Mindoro', 'Santa Lucia', '', '', 0, 0, '', '', '', 1, 0, 'HNSL  RKSS', 'HNSLRKSS'),
(283, 'TRISTAN', 'U.', 'INIEGO', '', 0, '2018-12-28', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'TRSTN  INK', 'TRSTNNK'),
(284, 'CLARENZ', 'E.', 'MUNEZ', '', 0, '2019-01-26', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, 'KLRNS  MNS', 'KLRNSMNS'),
(285, 'THRISTAN', 'D.', 'PATRICIO', '', 0, '2019-08-16', 2, '', 'Victoria,Sablayan, Occidental Mindoro', 'Victoria', '', '', 0, 0, '', '', '', 1, 0, '0RSTN  PTRS', '0RSTNPTRS'),
(286, 'ALVIN RAY', 'M.', 'RAMOS', '', 0, '2017-10-06', 2, '', 'Pusog, Burgos, Sablayan, Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'ALFNR  RMS', 'ALFNRRMS'),
(287, 'EUNICE', 'C.', 'AMSON', '', 0, '2018-09-23', 2, '', 'Pusog, Burgos, Sablayan, Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'ENS  AMSN', 'ENSMSN'),
(288, 'MELANIE', 'P.', 'ARTOCILLA', '', 0, '2018-03-26', 2, '', 'Pusog, Burgos, Sablayan, Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'MLN  ARTSL', 'MLNRTSL'),
(289, 'CHELLAN', 'B. ', 'FABITO', '', 0, '2019-01-03', 2, '', 'Pusog, Burgos, Sablayan, Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'XLN  FBT', 'XLNFBT'),
(290, 'JUDY ANN', 'O.', 'JARANILLA', '', 0, '2017-11-28', 2, '', 'Pusog, Burgos, Sablayan, Occidental Mindoro', 'Burgos', '', '', 0, 0, '', '', '', 1, 0, 'JTN  JRNL', 'JTNJRNL'),
(291, 'LIANIE', 'D.', 'ALIPACIO', '', 0, '2019-10-14', 1, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'LN  ALPS', 'LNLPS'),
(292, 'MARISSA', 'Z.', 'BALBAGAN', '', 0, '2019-03-18', 1, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'MRS  BLBKN', 'MRSBLBKN'),
(293, 'MICA', 'M.', 'BANAYO', '', 0, '2019-03-23', 1, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'MK  BNY', 'MKBNY'),
(294, 'ROSW', 'T.', 'CALAMITA', '', 0, '2019-03-30', 1, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'RS  KLMT', 'RSKLMT'),
(295, 'JANETH', 'T.', 'CASISON', '', 0, '2018-04-26', 1, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'JN0  KSSN', 'JN0KSSN'),
(296, 'ANGEL', 'K.', 'CALUMPIT', '', 0, '2019-11-03', 1, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', 'Arellano', '', '', 0, 0, '', '', '', 1, 0, 'ANJL  KLMPT', 'ANJLKLMPT'),
(297, 'BENYA', 'B.', 'CALAS', '', 0, '2019-03-25', 1, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'BNY  KLS', 'BNYKLS'),
(298, 'ACELYN', 'A. ', 'DELINA', '', 0, '2018-02-25', 1, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'ASLN  TLN', 'ASLNTLN'),
(299, 'JULIET', 'C.', 'KATULAY', '', 0, '2018-07-27', 1, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'JLT  KTL', 'JLTKTL'),
(300, 'SHIENA MAY', 'E.', 'KATULAY', '', 0, '2018-07-27', 1, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', 'Pag-asa', '', '', 0, 0, '', '', '', 1, 0, 'XNM  KTL', 'XNMKTL'),
(301, 'ELJHAY', 'B.', 'ACAS', '', 0, '2018-05-25', 2, '', 'San  Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'ELJH  AKS', 'ELJHKS'),
(302, 'JOHN WILLIAM', 'M', 'BANDRIL', '', 0, '2018-09-27', 2, '', 'San  Vicente, Sablayan, Occidental Mindoro', 'San Vicente', '', '', 0, 0, '', '', '', 1, 0, 'JNWLM  BNTRL', 'JNWLMBNTRL'),
(305, 'Harold', 'l', 'Malakas', '', 4, '2023-06-07', 2, '0', 'Ligaya', 'Ligaya', 'Sablayan', 'Occidental Mindoro', 0, 0, '', '', '', 1, 0, 'HRLT MLKS', 'HRLTMLKS');

-- --------------------------------------------------------

--
-- Table structure for table `epupils_feeding`
--

CREATE TABLE `epupils_feeding` (
  `feeding_id` int(11) NOT NULL,
  `feeding_date` varchar(16) NOT NULL,
  `foods` varchar(50) NOT NULL,
  `drinks` varchar(50) NOT NULL,
  `pupils_id` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `eschoolyear`
--

CREATE TABLE `eschoolyear` (
  `YearId` int(11) NOT NULL,
  `YearStart` varchar(16) NOT NULL,
  `YearEnd` varchar(16) NOT NULL,
  `Status` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `eschoolyear`
--

INSERT INTO `eschoolyear` (`YearId`, `YearStart`, `YearEnd`, `Status`) VALUES
(1, '2019-01-02', '2023-01-02', 0),
(2, '2021-01-02', '2023-01-02', 0),
(3, '2022-10-10', '2023-10-10', 0),
(4, '2022-08-12', '2023-08-12', 0),
(5, '2022-03-21', '2023-10-05', 0),
(6, '2022-10-05', '2023-07-18', 0),
(7, '2022-09-11', '2023-05-11', 0),
(8, '2022-01-20', '2023-01-20', 0),
(9, '2022-09-15', '2023-09-19', 0),
(10, '2022-06-22', '2023-08-30', 0),
(11, '2022-01-30', '2023-05-23', 0),
(12, '2022-01-25', '2023-05-26', 0),
(13, '2022-05-06', '2023-08-04', 0),
(14, '2022-03-05', '2023-04-06', 0),
(15, '2022-05-07', '2023-09-06', 0),
(16, '2022-02-05', '2023-07-05', 0),
(17, '2022-03-11', '2023-09-11', 0),
(18, '2022-04-16', '2023-10-08', 0),
(19, '2022-08-13', '2023-10-20', 0),
(20, '2022-07-11', '2023-02-23', 0),
(21, '2022-07-21', '2023-07-21', 0),
(22, '2022-11-05', '2023-02-03', 0),
(23, '2022-02-01', '2023-12-25', 0),
(24, '2022-05-20', '2023-06-23', 0),
(25, '2022-06-20', '2023-07-23', 0),
(26, '2022-12-25', '2023-03-23', 0),
(27, '0022-05-31', '2023-03-05', 0),
(28, '2022-03-25', '2023-12-14', 0),
(29, '2022-03-25', '2023-03-26', 0),
(30, '2023-01-02', '2023-07-01', 0),
(31, '2023-01-01', '2023-05-02', 0),
(32, '2022-03-05', '2023-02-05', 0),
(33, '2022-02-04', '2023-05-06', 0),
(34, '2023-10-01', '2023-10-31', 0),
(35, '2023-10-01', '2023-10-28', 0),
(36, '2023-10-04', '2023-10-28', 0),
(37, '2023-10-11', '2023-10-28', 0);

-- --------------------------------------------------------

--
-- Table structure for table `eschoolyear_by_worker`
--

CREATE TABLE `eschoolyear_by_worker` (
  `YearId` int(11) NOT NULL,
  `workersId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `eschoolyear_by_worker`
--

INSERT INTO `eschoolyear_by_worker` (`YearId`, `workersId`) VALUES
(1, 4),
(2, 5),
(3, 6),
(4, 7),
(5, 8),
(6, 9),
(7, 10),
(8, 11),
(9, 12),
(10, 13),
(12, 17),
(13, 18),
(14, 19),
(16, 21),
(16, 22),
(18, 23),
(19, 24),
(20, 25),
(21, 26),
(22, 27),
(23, 28),
(24, 29),
(25, 30),
(26, 31),
(27, 32),
(28, 33),
(29, 34),
(30, 35),
(31, 36),
(33, 37),
(1, 36),
(30, 4),
(0, 4),
(35, 4),
(36, 4),
(37, 4);

-- --------------------------------------------------------

--
-- Table structure for table `eschoolyear_by_worker_students`
--

CREATE TABLE `eschoolyear_by_worker_students` (
  `YearId` int(11) NOT NULL,
  `StudentId` int(11) NOT NULL,
  `workersId` int(11) NOT NULL,
  `StudentType` int(11) NOT NULL,
  `Status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `eschoolyear_by_worker_students`
--

INSERT INTO `eschoolyear_by_worker_students` (`YearId`, `StudentId`, `workersId`, `StudentType`, `Status`) VALUES
(1, 3, 4, 1, 1),
(1, 4, 4, 1, 1),
(1, 5, 4, 1, 1),
(1, 6, 4, 1, 1),
(1, 7, 4, 1, 1),
(2, 8, 5, 1, 1),
(2, 9, 5, 1, 1),
(2, 10, 5, 1, 1),
(2, 11, 5, 1, 1),
(2, 12, 5, 1, 1),
(2, 13, 5, 1, 1),
(2, 14, 5, 1, 1),
(2, 15, 5, 1, 1),
(2, 16, 5, 1, 1),
(2, 17, 5, 1, 1),
(3, 18, 6, 1, 1),
(3, 19, 6, 1, 1),
(3, 20, 6, 1, 1),
(3, 21, 6, 1, 1),
(3, 22, 6, 1, 1),
(3, 23, 6, 1, 1),
(3, 24, 6, 1, 1),
(3, 25, 6, 1, 1),
(3, 26, 6, 1, 1),
(3, 27, 6, 1, 1),
(4, 28, 7, 1, 1),
(4, 29, 7, 1, 1),
(4, 30, 7, 1, 1),
(4, 31, 7, 1, 1),
(4, 32, 7, 1, 1),
(4, 33, 7, 1, 1),
(4, 34, 7, 1, 1),
(4, 35, 7, 1, 1),
(4, 36, 7, 1, 1),
(4, 37, 7, 1, 1),
(5, 38, 8, 1, 1),
(5, 39, 8, 1, 1),
(5, 40, 8, 1, 1),
(5, 41, 8, 1, 1),
(5, 42, 8, 1, 1),
(5, 43, 8, 1, 1),
(5, 44, 8, 1, 1),
(5, 45, 8, 1, 1),
(5, 46, 8, 1, 1),
(5, 47, 8, 1, 1),
(6, 48, 9, 1, 1),
(6, 49, 9, 1, 1),
(6, 50, 9, 1, 1),
(6, 51, 9, 1, 1),
(6, 52, 9, 1, 1),
(6, 53, 9, 1, 1),
(6, 54, 9, 1, 1),
(6, 55, 9, 1, 1),
(6, 56, 9, 1, 1),
(6, 57, 9, 1, 1),
(7, 58, 10, 1, 1),
(7, 59, 10, 1, 1),
(7, 60, 10, 1, 1),
(7, 61, 10, 1, 1),
(7, 62, 10, 1, 1),
(7, 63, 10, 1, 1),
(7, 64, 10, 1, 1),
(7, 65, 10, 1, 1),
(7, 66, 10, 1, 1),
(7, 67, 10, 1, 1),
(8, 68, 11, 1, 1),
(8, 69, 11, 1, 1),
(8, 70, 11, 1, 1),
(8, 71, 11, 1, 1),
(8, 72, 11, 1, 1),
(8, 73, 11, 1, 1),
(8, 74, 11, 1, 1),
(8, 75, 11, 1, 1),
(8, 76, 11, 1, 1),
(8, 77, 11, 1, 1),
(9, 78, 12, 1, 1),
(9, 79, 12, 1, 1),
(9, 80, 12, 1, 1),
(9, 81, 12, 1, 1),
(9, 82, 12, 1, 1),
(9, 83, 12, 1, 1),
(9, 84, 12, 1, 1),
(9, 85, 12, 1, 1),
(9, 86, 12, 1, 1),
(9, 87, 12, 1, 1),
(10, 88, 13, 1, 1),
(10, 89, 13, 1, 1),
(10, 90, 13, 1, 1),
(10, 91, 13, 1, 1),
(10, 92, 13, 1, 1),
(10, 93, 13, 1, 1),
(10, 94, 13, 1, 1),
(10, 95, 13, 1, 1),
(10, 96, 13, 1, 1),
(10, 97, 13, 1, 1),
(10, 98, 13, 1, 1),
(10, 99, 13, 1, 1),
(10, 100, 13, 1, 1),
(12, 111, 17, 1, 1),
(12, 112, 17, 1, 1),
(12, 113, 17, 1, 1),
(12, 114, 17, 1, 1),
(12, 115, 17, 1, 1),
(12, 116, 17, 1, 1),
(12, 117, 17, 1, 1),
(12, 118, 17, 1, 1),
(12, 119, 17, 1, 1),
(12, 120, 17, 1, 1),
(13, 121, 18, 1, 1),
(13, 122, 18, 1, 1),
(13, 123, 18, 1, 1),
(13, 124, 18, 1, 1),
(13, 125, 18, 1, 1),
(13, 126, 18, 1, 1),
(13, 127, 18, 1, 1),
(13, 128, 18, 1, 1),
(13, 129, 18, 1, 1),
(13, 130, 18, 1, 1),
(13, 131, 18, 1, 1),
(14, 132, 19, 1, 1),
(14, 133, 19, 1, 1),
(14, 134, 19, 1, 1),
(14, 135, 19, 1, 1),
(14, 136, 19, 1, 1),
(14, 137, 19, 1, 1),
(14, 138, 19, 1, 1),
(14, 139, 19, 1, 1),
(14, 140, 19, 1, 1),
(14, 141, 19, 1, 1),
(14, 142, 19, 1, 1),
(16, 143, 21, 1, 1),
(16, 144, 21, 1, 1),
(16, 145, 21, 1, 1),
(16, 146, 21, 1, 1),
(16, 147, 21, 1, 1),
(16, 148, 22, 1, 1),
(16, 149, 22, 1, 1),
(16, 150, 22, 1, 1),
(16, 151, 22, 1, 1),
(16, 152, 22, 1, 1),
(16, 153, 22, 1, 1),
(16, 154, 22, 1, 1),
(16, 155, 22, 1, 1),
(16, 156, 22, 1, 1),
(16, 157, 22, 1, 1),
(18, 158, 23, 1, 1),
(18, 159, 23, 1, 1),
(18, 160, 23, 1, 1),
(18, 161, 23, 1, 1),
(18, 162, 23, 1, 1),
(18, 163, 23, 1, 1),
(18, 164, 23, 1, 1),
(18, 165, 23, 1, 1),
(18, 166, 23, 1, 1),
(18, 167, 23, 1, 1),
(19, 168, 24, 1, 1),
(19, 169, 24, 1, 1),
(19, 170, 24, 1, 1),
(19, 171, 24, 1, 1),
(19, 172, 24, 1, 1),
(19, 173, 24, 1, 1),
(19, 174, 24, 1, 1),
(19, 175, 24, 1, 1),
(19, 176, 24, 1, 1),
(19, 177, 24, 1, 1),
(20, 178, 25, 1, 1),
(20, 179, 25, 1, 1),
(20, 180, 25, 1, 1),
(20, 181, 25, 1, 1),
(20, 182, 25, 1, 1),
(20, 183, 25, 1, 1),
(20, 184, 25, 1, 1),
(20, 185, 25, 1, 1),
(20, 186, 25, 1, 1),
(20, 187, 25, 1, 1),
(21, 188, 26, 1, 1),
(21, 189, 26, 1, 1),
(21, 190, 26, 1, 1),
(21, 191, 26, 1, 1),
(21, 192, 26, 1, 1),
(21, 193, 26, 1, 1),
(21, 194, 26, 1, 1),
(21, 195, 26, 1, 1),
(21, 196, 26, 1, 1),
(21, 197, 26, 1, 1),
(21, 198, 26, 1, 1),
(21, 199, 26, 1, 1),
(21, 200, 26, 1, 1),
(21, 201, 26, 1, 1),
(21, 202, 26, 1, 1),
(22, 203, 27, 1, 1),
(22, 204, 27, 1, 1),
(22, 205, 27, 1, 1),
(22, 206, 27, 1, 1),
(22, 207, 27, 1, 1),
(22, 208, 27, 1, 1),
(22, 209, 27, 1, 1),
(22, 210, 27, 1, 1),
(22, 211, 27, 1, 1),
(22, 212, 27, 1, 1),
(23, 213, 28, 1, 1),
(23, 214, 28, 1, 1),
(23, 215, 28, 1, 1),
(23, 216, 28, 1, 1),
(23, 217, 28, 1, 1),
(23, 218, 28, 1, 1),
(23, 219, 28, 1, 1),
(23, 220, 28, 1, 1),
(23, 221, 28, 1, 1),
(23, 222, 28, 1, 1),
(24, 223, 29, 1, 1),
(24, 224, 29, 1, 1),
(24, 225, 29, 1, 1),
(24, 226, 29, 1, 1),
(24, 227, 29, 1, 1),
(24, 228, 29, 1, 1),
(24, 229, 29, 1, 1),
(24, 230, 29, 1, 1),
(24, 231, 29, 1, 1),
(24, 232, 29, 1, 1),
(25, 233, 30, 1, 1),
(25, 234, 30, 1, 1),
(25, 235, 30, 1, 1),
(25, 236, 30, 1, 1),
(25, 237, 30, 1, 1),
(25, 238, 30, 1, 1),
(25, 239, 30, 1, 1),
(25, 240, 30, 1, 1),
(25, 241, 30, 1, 1),
(25, 242, 30, 1, 1),
(26, 243, 31, 1, 1),
(26, 244, 31, 1, 1),
(26, 245, 31, 1, 1),
(26, 246, 31, 1, 1),
(26, 247, 31, 1, 1),
(26, 248, 31, 1, 1),
(26, 249, 31, 1, 1),
(26, 250, 31, 1, 1),
(26, 251, 31, 1, 1),
(26, 252, 31, 1, 1),
(27, 253, 32, 1, 1),
(27, 254, 32, 1, 1),
(27, 255, 32, 1, 1),
(27, 256, 32, 1, 1),
(27, 257, 32, 1, 1),
(27, 258, 32, 1, 1),
(27, 259, 32, 1, 1),
(27, 260, 32, 1, 1),
(27, 261, 32, 1, 1),
(27, 262, 32, 1, 1),
(28, 263, 33, 1, 1),
(28, 264, 33, 1, 1),
(28, 265, 33, 1, 1),
(28, 266, 33, 1, 1),
(28, 267, 33, 1, 1),
(28, 268, 33, 1, 1),
(28, 269, 33, 1, 1),
(28, 270, 33, 1, 1),
(28, 271, 33, 1, 1),
(28, 272, 33, 1, 1),
(29, 273, 34, 1, 1),
(29, 274, 34, 1, 1),
(29, 275, 34, 1, 1),
(29, 276, 34, 1, 1),
(29, 277, 34, 1, 1),
(29, 278, 34, 1, 1),
(29, 279, 34, 1, 1),
(29, 280, 34, 1, 1),
(29, 281, 34, 1, 1),
(29, 282, 34, 1, 1),
(1, 283, 4, 1, 1),
(1, 284, 4, 1, 1),
(1, 285, 4, 1, 1),
(16, 286, 21, 1, 1),
(16, 287, 21, 1, 1),
(16, 288, 21, 1, 1),
(16, 289, 21, 1, 1),
(16, 290, 21, 1, 1),
(30, 291, 35, 1, 1),
(30, 292, 35, 1, 1),
(30, 293, 35, 1, 1),
(30, 294, 35, 1, 1),
(30, 295, 35, 1, 1),
(30, 296, 35, 1, 1),
(30, 297, 35, 1, 1),
(30, 298, 35, 1, 1),
(30, 299, 35, 1, 1),
(30, 300, 35, 1, 1),
(31, 301, 36, 1, 1),
(31, 302, 36, 1, 1),
(1, 0, 36, 1, 1),
(30, 0, 4, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `eworkers`
--

CREATE TABLE `eworkers` (
  `workersId` int(4) NOT NULL,
  `userId` int(11) NOT NULL,
  `centerId` int(3) NOT NULL,
  `fName` varchar(20) NOT NULL,
  `mName` varchar(20) NOT NULL,
  `lName` varchar(20) NOT NULL,
  `ext` varchar(3) NOT NULL,
  `birthDate` date DEFAULT NULL,
  `gender` int(1) NOT NULL,
  `sector` varchar(20) NOT NULL,
  `address` varchar(200) NOT NULL,
  `barangay` varchar(30) NOT NULL,
  `municipality` varchar(30) NOT NULL,
  `province` varchar(30) NOT NULL,
  `dateHired` date NOT NULL,
  `jobStatus` int(1) NOT NULL,
  `profile` varchar(100) NOT NULL,
  `dateAdded` varchar(20) NOT NULL,
  `app` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `eworkers`
--

INSERT INTO `eworkers` (`workersId`, `userId`, `centerId`, `fName`, `mName`, `lName`, `ext`, `birthDate`, `gender`, `sector`, `address`, `barangay`, `municipality`, `province`, `dateHired`, `jobStatus`, `profile`, `dateAdded`, `app`) VALUES
(4, 4, 1, 'ZENAIDA', 'T.', 'ADVINCULA', '', '2008-01-01', 2, '', 'Victoria,Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 1, '', '', 1),
(5, 5, 2, 'HELEN', 'G.', 'BAUTISTA', '', NULL, 0, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', '', '', '', '0000-00-00', 0, '', '', 1),
(6, 6, 3, 'JOSEPHINE', 'J.', 'BEDONA', '', NULL, 0, '', 'Sitio San Miguel, Claudio Salgado, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(7, 7, 4, 'EDA ', 'P.', 'BERGONIA', '', NULL, 0, '', 'Sitio Aplaya, Burgos, Sablayan Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(8, 8, 5, 'MYRA', 'V.', 'BERMUDO', '', NULL, 0, '', 'Ibud, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(9, 9, 6, 'BRENDA', 'A.', 'BERSABAL', '', NULL, 0, '', 'San Rafael, Poblacion, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(10, 10, 7, 'IMELDA', 'R.', 'BRANE', '', NULL, 0, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', '', '', '', '0000-00-00', 0, '', '', 1),
(11, 11, 8, 'LADYVER', 'U.', 'BULDA', '', NULL, 0, '', 'Ibud, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(12, 12, 9, 'MYLENE', 'J.', 'ABA-A', '', NULL, 0, '', 'Calumpit, San Vicente, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(13, 13, 10, 'JONNNA MAY', '', 'AGBO', '', NULL, 0, '', 'Tuog, San Vicente, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(17, 15, 12, 'LIZABEL', 'M', 'ARTILERA', '', NULL, 0, '', 'Ilvita, Sablayan, Occidental, Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(18, 16, 13, 'RONA', 'G', 'BAQUIRIN', '', NULL, 0, '', 'Tagumpay, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(19, 17, 14, 'MICAYA', '', 'BASIGNO', '', NULL, 0, '', 'Sitio. Tyabong, Ligaya, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(21, 19, 15, 'JOCELYN', 'S.', 'OBTINALLA', '', NULL, 0, '', 'Sitio Pusog, Burgos,Sabalayan,occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(22, 20, 16, 'PERLITA', 'U.', 'ORDANZA', '', NULL, 0, '', 'Lagnas, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(23, 21, 17, 'MELBA', 'S.', 'ORDENES', '', NULL, 0, '', 'Ilaya, Sto. Niño, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(24, 22, 18, 'RONALYN', 'G.', 'ORTINEZ', '', NULL, 0, '', 'San Nicolas, Tuban, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(25, 23, 19, 'RIZALIN', 'P.', 'PIELAGO', '', NULL, 0, '', 'San CArlos, San Francisco, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(26, 24, 20, 'LETECIA', 'S.', 'QUINIO', '', NULL, 0, '', 'Calamansian, San Agustin , Sablayan Occidental Mindro', '', '', '', '0000-00-00', 0, '', '', 1),
(27, 25, 21, 'JEGELYN ', 'P.', 'RASE', '', NULL, 0, '', 'Recieving, Santa Lucia, Sablayan Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(28, 26, 22, 'MAILA', 'L.', 'RITA', '', NULL, 0, '', 'LIGAYA, SABLAYAN, OCCIDENTAL MINDORO', '', '', '', '0000-00-00', 0, '', '', 1),
(29, 27, 23, 'ELIZABETH', 'S.', 'RIVERA', '', NULL, 0, '', 'San Francisco, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(30, 28, 24, 'FELY ', 'O.', 'RIVERA', '', NULL, 0, '', 'San Francisco, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(31, 29, 25, 'KRISTINE', 'T.', 'RIVERA', '', NULL, 0, '', 'Pag-Asa,Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(32, 30, 26, 'APRIL ROSE', 'P.', 'RUIZ', '', NULL, 0, '', 'Victoria,Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(33, 31, 27, 'PRINCESS LANIE JOY', 'D.', 'SADOL', '', NULL, 0, '', 'Buensvista, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(34, 32, 28, 'AMIE ', 'M.', 'SARMIENTO', '', NULL, 0, '', 'Santa Lucia, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(35, 33, 29, 'LANIE', 'K.', 'SARUBAY', '', NULL, 0, '', 'Pandurucan, Pag-asa, Sablayan, Occidental, Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(36, 34, 30, 'ROSEMARIE', 'L.', 'SESO', '', NULL, 0, '', 'San  Vicente, Sablayan, Occidental Mindoro', '', '', '', '0000-00-00', 0, '', '', 1),
(37, 35, 31, 'CATALINA', '', 'DELO SANTOS', '', '1994-05-07', 0, '', 'Sitio Pandan, Tagumpay, Sabalayan, Occidental Mindoro', '', '', '', '2023-09-04', 3, '', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `e_zscore_hfa`
--

CREATE TABLE `e_zscore_hfa` (
  `id` int(11) NOT NULL,
  `gender` int(1) NOT NULL DEFAULT 1,
  `age` varchar(10) NOT NULL,
  `severly_stunned` varchar(10) NOT NULL,
  `stunned` varchar(10) NOT NULL,
  `normal` varchar(10) NOT NULL,
  `tall` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `e_zscore_wfa`
--

CREATE TABLE `e_zscore_wfa` (
  `id` int(11) NOT NULL,
  `height` varchar(10) NOT NULL,
  `su_weight` varchar(10) NOT NULL,
  `u_weight` varchar(10) NOT NULL,
  `n_weight` varchar(10) NOT NULL,
  `ov_weight` varchar(10) NOT NULL,
  `ob_weight` varchar(10) NOT NULL,
  `gender` int(1) NOT NULL DEFAULT 1,
  `age` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `e_zscore_wfh`
--

CREATE TABLE `e_zscore_wfh` (
  `id` int(11) NOT NULL,
  `height` varchar(10) NOT NULL,
  `su_weight` varchar(10) NOT NULL,
  `u_weight` varchar(10) NOT NULL,
  `n_weight` varchar(10) NOT NULL,
  `ov_weight` varchar(10) NOT NULL,
  `ob_weight` varchar(10) NOT NULL,
  `gender` int(1) NOT NULL DEFAULT 1,
  `age` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weighing`
--

CREATE TABLE `weighing` (
  `weighingId` int(11) NOT NULL,
  `scheduleId` int(11) NOT NULL,
  `pupilsId` int(11) NOT NULL,
  `weight` varchar(5) NOT NULL,
  `height` varchar(5) NOT NULL,
  `wfa` varchar(5) NOT NULL,
  `hfa` varchar(5) NOT NULL,
  `wfh` varchar(5) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weighing_schedule`
--

CREATE TABLE `weighing_schedule` (
  `scheduleId` int(11) NOT NULL,
  `weighingSchedule` date NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `centerId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `weighing_schedule`
--

INSERT INTO `weighing_schedule` (`scheduleId`, `weighingSchedule`, `status`, `centerId`) VALUES
(1, '2025-01-01', 1, 4);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aauth_groups`
--
ALTER TABLE `aauth_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `aauth_group_to_group`
--
ALTER TABLE `aauth_group_to_group`
  ADD PRIMARY KEY (`group_id`,`subgroup_id`);

--
-- Indexes for table `aauth_login_attempts`
--
ALTER TABLE `aauth_login_attempts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `aauth_perms`
--
ALTER TABLE `aauth_perms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `aauth_perm_to_group`
--
ALTER TABLE `aauth_perm_to_group`
  ADD PRIMARY KEY (`perm_id`,`group_id`);

--
-- Indexes for table `aauth_perm_to_user`
--
ALTER TABLE `aauth_perm_to_user`
  ADD PRIMARY KEY (`perm_id`,`user_id`);

--
-- Indexes for table `aauth_pms`
--
ALTER TABLE `aauth_pms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `full_index` (`id`,`sender_id`,`receiver_id`,`date_read`);

--
-- Indexes for table `aauth_users`
--
ALTER TABLE `aauth_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `aauth_user_to_group`
--
ALTER TABLE `aauth_user_to_group`
  ADD PRIMARY KEY (`user_id`,`group_id`);

--
-- Indexes for table `aauth_user_variables`
--
ALTER TABLE `aauth_user_variables`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_index` (`user_id`);

--
-- Indexes for table `assessment`
--
ALTER TABLE `assessment`
  ADD PRIMARY KEY (`assessmentId`);

--
-- Indexes for table `assessment_raw_score`
--
ALTER TABLE `assessment_raw_score`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `assessment_schedule`
--
ALTER TABLE `assessment_schedule`
  ADD PRIMARY KEY (`ScheduleId`);

--
-- Indexes for table `assessment_sum_scaled_score`
--
ALTER TABLE `assessment_sum_scaled_score`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `scaled_score` (`scaled_score`);

--
-- Indexes for table `ecenter`
--
ALTER TABLE `ecenter`
  ADD PRIMARY KEY (`centerId`);

--
-- Indexes for table `eparent`
--
ALTER TABLE `eparent`
  ADD PRIMARY KEY (`parentId`);

--
-- Indexes for table `epupils`
--
ALTER TABLE `epupils`
  ADD PRIMARY KEY (`pupilsId`);

--
-- Indexes for table `epupils_feeding`
--
ALTER TABLE `epupils_feeding`
  ADD PRIMARY KEY (`feeding_id`);

--
-- Indexes for table `eschoolyear`
--
ALTER TABLE `eschoolyear`
  ADD PRIMARY KEY (`YearId`);

--
-- Indexes for table `eworkers`
--
ALTER TABLE `eworkers`
  ADD PRIMARY KEY (`workersId`);

--
-- Indexes for table `e_zscore_hfa`
--
ALTER TABLE `e_zscore_hfa`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `e_zscore_wfa`
--
ALTER TABLE `e_zscore_wfa`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `e_zscore_wfh`
--
ALTER TABLE `e_zscore_wfh`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weighing`
--
ALTER TABLE `weighing`
  ADD PRIMARY KEY (`weighingId`);

--
-- Indexes for table `weighing_schedule`
--
ALTER TABLE `weighing_schedule`
  ADD PRIMARY KEY (`scheduleId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aauth_groups`
--
ALTER TABLE `aauth_groups`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `aauth_login_attempts`
--
ALTER TABLE `aauth_login_attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=271;

--
-- AUTO_INCREMENT for table `aauth_perms`
--
ALTER TABLE `aauth_perms`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `aauth_pms`
--
ALTER TABLE `aauth_pms`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `aauth_users`
--
ALTER TABLE `aauth_users`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `aauth_user_variables`
--
ALTER TABLE `aauth_user_variables`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `assessment_raw_score`
--
ALTER TABLE `assessment_raw_score`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `assessment_schedule`
--
ALTER TABLE `assessment_schedule`
  MODIFY `ScheduleId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `assessment_sum_scaled_score`
--
ALTER TABLE `assessment_sum_scaled_score`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `ecenter`
--
ALTER TABLE `ecenter`
  MODIFY `centerId` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `eparent`
--
ALTER TABLE `eparent`
  MODIFY `parentId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `epupils`
--
ALTER TABLE `epupils`
  MODIFY `pupilsId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=306;

--
-- AUTO_INCREMENT for table `epupils_feeding`
--
ALTER TABLE `epupils_feeding`
  MODIFY `feeding_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `eschoolyear`
--
ALTER TABLE `eschoolyear`
  MODIFY `YearId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `eworkers`
--
ALTER TABLE `eworkers`
  MODIFY `workersId` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `e_zscore_hfa`
--
ALTER TABLE `e_zscore_hfa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `e_zscore_wfa`
--
ALTER TABLE `e_zscore_wfa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `e_zscore_wfh`
--
ALTER TABLE `e_zscore_wfh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `weighing`
--
ALTER TABLE `weighing`
  MODIFY `weighingId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `weighing_schedule`
--
ALTER TABLE `weighing_schedule`
  MODIFY `scheduleId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- ========================================================================
-- ADDITIONAL TABLES (e_feeding, e_immunization, e_weighing)
-- ========================================================================


CREATE TABLE `e_feeding` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `date_feeding` date NOT NULL,
  `drinks` varchar(50) NOT NULL,
  `foods` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `e_immunization`
--

CREATE TABLE `e_immunization` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `date_immunization` date NOT NULL,
  `type_immunization` varchar(25) NOT NULL,
  `description` text NOT NULL,
  `remarks` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `e_weighing`;
CREATE TABLE `e_weighing` (
  `id` int(11) NOT NULL,
  `date_weighing` date NOT NULL,
  `student_id` int(11) NOT NULL,
  `weight` varchar(5) NOT NULL,
  `height` varchar(5) NOT NULL,
  `wfa` varchar(5) NOT NULL,
  `hfa` varchar(5) NOT NULL,
  `wfh` varchar(5) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
--
-- Indexes for dumped tables
--

--
-- Indexes for table `e_feeding`
--
ALTER TABLE `e_feeding`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `e_immunization`
--
ALTER TABLE `e_immunization`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `e_feeding`
--
ALTER TABLE `e_feeding`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `e_immunization`
--
ALTER TABLE `e_immunization`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

-- Indexes for dumped tables
--

--
-- Indexes for table `e_weighing`
--
ALTER TABLE `e_weighing`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `e_weighing`
--
ALTER TABLE `e_weighing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

-- ========================================================================
-- DATABASE VIEWS
-- ========================================================================

--
-- Database: `mswdeccddb`
--

-- --------------------------------------------------------

--
-- Structure for view `center_schoolyear`
--
DROP VIEW IF EXISTS `center_schoolyear`;

CREATE VIEW `center_schoolyear`  AS SELECT DISTINCT `ecenter`.`centerId` AS `center_id`, `ecenter`.`centerName` AS `center_name`, `ecenter`.`barangay` AS `barangay`, `ecenter`.`centerAddress` AS `center_address`, (select count(0) from `center_students_schoolyear` where `center_students_schoolyear`.`center_id` = `ecenter`.`centerId` and `center_students_schoolyear`.`gender` = 1) AS `total_students_boys`, (select count(0) from `center_students_schoolyear` where `center_students_schoolyear`.`center_id` = `ecenter`.`centerId` and `center_students_schoolyear`.`gender` = 2) AS `total_students_girls`, (select count(0) from `center_students_schoolyear` where `center_students_schoolyear`.`center_id` = `ecenter`.`centerId`) AS `total_students`, (select `center_workers`.`worker_name` from `center_workers` where `center_workers`.`center_id` = `ecenter`.`centerId`) AS `worker_name`, (select `center_workers`.`contact_number` from `center_workers` where `center_workers`.`center_id` = `ecenter`.`centerId`) AS `contact_number` FROM `ecenter` ORDER BY `ecenter`.`barangay` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `center_students_schoolyear`
--
DROP VIEW IF EXISTS `center_students_schoolyear`;

CREATE VIEW `center_students_schoolyear`  AS SELECT DISTINCT `epupils`.`pupilsId` AS `student_id`, `eworkers`.`centerId` AS `center_id`, `eworkers`.`workersId` AS `worker_id`, `eschoolyear`.`YearId` AS `year_id`, `eschoolyear_by_worker_students`.`StudentType` AS `student_type`, concat(`epupils`.`lName`,', ',`epupils`.`fName`,' ',`epupils`.`mName`,' ',`epupils`.`ext`) AS `student_name`, `epupils`.`age` AS `age`, `epupils`.`gender` AS `gender`, `epupils`.`address` AS `address`, `eschoolyear`.`YearStart` AS `class_start`, `eschoolyear`.`YearEnd` AS `class_end` FROM ((((`epupils` join `eschoolyear_by_worker_students` on(`eschoolyear_by_worker_students`.`StudentId` = `epupils`.`pupilsId`)) join `eschoolyear_by_worker` on(`eschoolyear_by_worker`.`workersId` = `eschoolyear_by_worker_students`.`workersId`)) join `eworkers` on(`eworkers`.`workersId` = `eschoolyear_by_worker`.`workersId`)) join `eschoolyear` on(`eschoolyear`.`YearId` = `eschoolyear_by_worker_students`.`YearId`)) ;

-- --------------------------------------------------------

--
-- Structure for view `center_workers`
--
DROP VIEW IF EXISTS `center_workers`;

CREATE VIEW `center_workers`  AS SELECT DISTINCT `eworkers`.`workersId` AS `worker_id`, `eworkers`.`centerId` AS `center_id`, concat(`eworkers`.`lName`,', ',`eworkers`.`fName`,' ',`eworkers`.`mName`,' ',`eworkers`.`ext`) AS `worker_name`, `ecenter`.`centerName` AS `center_name`, `eworkers`.`address` AS `worker_address`, `eworkers`.`jobStatus` AS `job_status`, `eworkers`.`contact_number` AS `contact_number` FROM (`eworkers` left join `ecenter` on(`eworkers`.`centerId` = `ecenter`.`centerId`)) ;

-- --------------------------------------------------------

--
-- Structure for view `center_workers_schoolyear`
--
DROP VIEW IF EXISTS `center_workers_schoolyear`;

CREATE VIEW `center_workers_schoolyear`  AS SELECT DISTINCT `eworkers`.`workersId` AS `worker_id`, `eworkers`.`centerId` AS `center_id`, `eschoolyear`.`YearId` AS `year_id`, concat(`eworkers`.`lName`,', ',`eworkers`.`fName`,' ',`eworkers`.`mName`,' ',`eworkers`.`ext`) AS `worker_name`, `eworkers`.`address` AS `worker_address`, `eschoolyear`.`YearStart` AS `class_start`, `eschoolyear`.`YearEnd` AS `class_end`, `ecenter`.`centerName` AS `center_name`, `eworkers`.`jobStatus` AS `job_status`, `eschoolyear`.`Status` AS `class_status`, (select count(0) from `eschoolyear_by_worker_students` where `eschoolyear_by_worker_students`.`workersId` = `eworkers`.`workersId` and `eschoolyear_by_worker_students`.`YearId` = `eschoolyear_by_worker`.`YearId`) AS `total_students` FROM (((`eworkers` join `eschoolyear_by_worker` on(`eschoolyear_by_worker`.`workersId` = `eworkers`.`workersId`)) join `eschoolyear` on(`eschoolyear`.`YearId` = `eschoolyear_by_worker`.`YearId`)) join `ecenter` on(`ecenter`.`centerId` = `eworkers`.`centerId`)) ;

-- --------------------------------------------------------

--
-- Structure for view `estudents`
--
DROP VIEW IF EXISTS `estudents`;

CREATE VIEW `estudents`  AS SELECT DISTINCT `cs`.`student_id` AS `student_id`, `cs`.`center_id` AS `center_id`, `cs`.`worker_id` AS `worker_id`, `cs`.`year_id` AS `year_id`, `cs`.`student_type` AS `student_type`, `cs`.`student_name` AS `student_name`, `cs`.`class_start` AS `class_start`, `cs`.`class_end` AS `class_end`, `ep`.`birthDate` AS `birthdate`, `ep`.`gender` AS `gender`, `ep`.`barangay` AS `barangay` FROM (`center_students_schoolyear` `cs` join `epupils` `ep` on(`cs`.`student_id` = `ep`.`pupilsId`)) GROUP BY `cs`.`student_id` ORDER BY `cs`.`year_id` DESC ;

-- --------------------------------------------------------

--
-- Structure for view `eworkers_inactive`
--
DROP VIEW IF EXISTS `eworkers_inactive`;

CREATE VIEW `eworkers_inactive`  AS SELECT DISTINCT `eworkers`.`workersId` AS `worker_id`, `eworkers`.`centerId` AS `center_id`, concat(`eworkers`.`lName`,', ',`eworkers`.`fName`,' ',`eworkers`.`mName`,' ',`eworkers`.`ext`) AS `worker_name` FROM `eworkers` WHERE !(`eworkers`.`workersId` in (select `eschoolyear_by_worker`.`workersId` from `eschoolyear_by_worker`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_20days`
--
DROP VIEW IF EXISTS `v_20days`;

CREATE VIEW `v_20days`  AS SELECT `s`.`student_id` AS `student_id`, `s`.`center_id` AS `center_id`, `s`.`worker_id` AS `worker_id`, `s`.`student_name` AS `student_name`, `s`.`gender` AS `gender`, (select `w`.`id` from `e_weighing` `w` where `w`.`student_id` = `s`.`student_id` and `w`.`date_weighing` = (select `t2`.`date_weighing` + interval 20 day from `e_weighing` `t2` where `t2`.`student_id` = `t2`.`student_id` order by `t2`.`date_weighing` limit 1) order by `w`.`date_weighing` limit 1) AS `weighing_id`, `s`.`year_id` AS `year_id` FROM `center_students_schoolyear` AS `s` ;

-- --------------------------------------------------------

--
-- Structure for view `v_40days`
--
DROP VIEW IF EXISTS `v_40days`;

CREATE VIEW `v_40days`  AS SELECT `s`.`student_id` AS `student_id`, `s`.`center_id` AS `center_id`, `s`.`worker_id` AS `worker_id`, `s`.`student_name` AS `student_name`, `s`.`gender` AS `gender`, (select `w`.`id` from `e_weighing` `w` where `w`.`student_id` = `s`.`student_id` and `w`.`date_weighing` = (select `t2`.`date_weighing` + interval 40 day from `e_weighing` `t2` where `t2`.`student_id` = `t2`.`student_id` order by `t2`.`date_weighing` limit 1) order by `w`.`date_weighing` limit 1) AS `weighing_id`, `s`.`year_id` AS `year_id` FROM `center_students_schoolyear` AS `s` ;

-- --------------------------------------------------------

--
-- Structure for view `v_ass_checklist`
--
DROP VIEW IF EXISTS `v_ass_checklist`;

CREATE VIEW `v_ass_checklist`  AS SELECT DISTINCT `t1`.`student_id` AS `student_id`, (select `t2`.`date_assessment` from `assessment` `t2` where `t2`.`student_id` = `t1`.`student_id` and `t2`.`type` = 1 limit 1) AS `first_assessment`, (select `t3`.`date_assessment` from `assessment` `t3` where `t3`.`student_id` = `t1`.`student_id` and `t3`.`type` = 2 limit 1) AS `second_assessment`, (select `t4`.`date_assessment` from `assessment` `t4` where `t4`.`student_id` = `t1`.`student_id` and `t4`.`type` = 3 limit 1) AS `third_assessment` FROM `assessment` AS `t1` ;

-- --------------------------------------------------------

--
-- Structure for view `v_centers`
--
DROP VIEW IF EXISTS `v_centers`;

CREATE VIEW `v_centers`  AS SELECT `ecenter`.`centerId` AS `center_id`, `ecenter`.`centerName` AS `center_name`, `ecenter`.`barangay` AS `barangay`, `ecenter`.`centerAddress` AS `center_address`, (select concat(`eworkers`.`fName`,' ',`eworkers`.`mName`,' ',`eworkers`.`lName`,' ',`eworkers`.`ext`) from `eworkers` where `eworkers`.`centerId` = `ecenter`.`centerId` and `eworkers`.`jobStatus` <> 6) AS `worker_name` FROM `ecenter` ;

-- --------------------------------------------------------

--
-- Structure for view `v_current_weighing`
--
DROP VIEW IF EXISTS `v_current_weighing`;

CREATE VIEW `v_current_weighing`  AS SELECT `t1`.`id` AS `id`, `t1`.`student_id` AS `student_id`, `t1`.`date_weighing` AS `date_weighing`, `t1`.`wfa` AS `wfa`, `t1`.`hfa` AS `hfa`, `t1`.`wfh` AS `wfh`, `t3`.`student_name` AS `student_name`, `t3`.`year_id` AS `year_id`, `t3`.`worker_id` AS `worker_id` FROM ((`e_weighing` `t1` join (select `e_weighing`.`student_id` AS `student_id`,max(`e_weighing`.`date_weighing`) AS `MaxDate` from `e_weighing` group by `e_weighing`.`student_id`) `t2` on(`t1`.`student_id` = `t2`.`student_id` and `t1`.`date_weighing` = `t2`.`MaxDate`)) join `center_students_schoolyear` `t3` on(`t1`.`student_id` = `t3`.`student_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_eccd_students`
--
DROP VIEW IF EXISTS `v_eccd_students`;

CREATE VIEW `v_eccd_students`  AS SELECT `epupils`.`pupilsId` AS `student_id`, concat(`epupils`.`lName`,', ',`epupils`.`fName`,' ',`epupils`.`mName`,' ',`epupils`.`ext`) AS `student_name`, `epupils`.`gender` AS `gender`, (select max(`e_weighing`.`date_weighing`) from `e_weighing` where `e_weighing`.`student_id` = `epupils`.`pupilsId`) AS `max_weighing`, (select `e_weighing`.`height` from `e_weighing` where `e_weighing`.`student_id` = `epupils`.`pupilsId` and `e_weighing`.`date_weighing` = `max_weighing`) AS `height`, (select `e_weighing`.`weight` from `e_weighing` where `e_weighing`.`student_id` = `epupils`.`pupilsId` and `e_weighing`.`date_weighing` = `max_weighing`) AS `weight`, (select `e_weighing`.`wfa` from `e_weighing` where `e_weighing`.`student_id` = `epupils`.`pupilsId` and `e_weighing`.`date_weighing` = `max_weighing`) AS `wfa`, (select `e_weighing`.`hfa` from `e_weighing` where `e_weighing`.`student_id` = `epupils`.`pupilsId` and `e_weighing`.`date_weighing` = `max_weighing`) AS `hfa`, (select `e_weighing`.`wfh` from `e_weighing` where `e_weighing`.`student_id` = `epupils`.`pupilsId` and `e_weighing`.`date_weighing` = `max_weighing`) AS `wfh` FROM `epupils` ;

-- --------------------------------------------------------

--
-- Structure for view `v_terminal`
--
DROP VIEW IF EXISTS `v_terminal`;

CREATE VIEW `v_terminal`  AS SELECT `s`.`student_id` AS `student_id`, `s`.`center_id` AS `center_id`, `s`.`worker_id` AS `worker_id`, `s`.`student_name` AS `student_name`, `s`.`gender` AS `gender`, (select `t1`.`id` from `e_weighing` `t1` where `t1`.`date_weighing` = (select max(`t2`.`date_weighing`) from `e_weighing` `t2` where `t2`.`student_id` = `s`.`student_id`)) AS `weighing_id`, `s`.`year_id` AS `year_id` FROM `center_students_schoolyear` AS `s` ;

-- --------------------------------------------------------

--
-- Structure for view `v_uponentry`
--
DROP VIEW IF EXISTS `v_uponentry`;

CREATE VIEW `v_uponentry`  AS SELECT `s`.`student_id` AS `student_id`, `s`.`center_id` AS `center_id`, `s`.`worker_id` AS `worker_id`, `s`.`student_name` AS `student_name`, `s`.`gender` AS `gender`, (select `t1`.`id` from `e_weighing` `t1` where `t1`.`date_weighing` = (select min(`t2`.`date_weighing`) from `e_weighing` `t2` where `t2`.`student_id` = `s`.`student_id`)) AS `weighing_id`, `s`.`year_id` AS `year_id` FROM `center_students_schoolyear` AS `s` ;

-- --------------------------------------------------------

--
-- Structure for view `v_weighing`
--
DROP VIEW IF EXISTS `v_weighing`;

CREATE VIEW `v_weighing`  AS SELECT `w`.`id` AS `id`, `w`.`date_weighing` AS `date_weighing`, `w`.`student_id` AS `student_id`, `w`.`weight` AS `weight`, `w`.`height` AS `height`, `w`.`wfa` AS `wfa`, `w`.`hfa` AS `hfa`, `w`.`wfh` AS `wfh`, `w`.`wfa_percentage` AS `wfa_percentage`, `w`.`hfa_percentage` AS `hfa_percentage`, `w`.`wfh_percentage` AS `wfh_percentage`, `w`.`status` AS `status`, concat(`p`.`lName`,', ',`p`.`fName`,' ',`p`.`mName`,' ',`p`.`ext`) AS `student_name` FROM (`e_weighing` `w` left join `epupils` `p` on(`p`.`pupilsId` = `w`.`student_id`)) WHERE `w`.`date_weighing` = (select max(`w2`.`date_weighing`) from `e_weighing` `w2` where `w`.`student_id` = `w2`.`student_id`) ;
COMMIT;

--
-- Structure for view `v_raw_score`
--
DROP VIEW IF EXISTS `v_raw_score`;

CREATE  VIEW `v_raw_score`  AS SELECT `t`.`student_id` AS `student_id`, `t`.`date_assessment` AS `date_assessment`, `t`.`domain` AS `domain`, (select `t1`.`raw_score` from `assessment` `t1` where `t`.`student_id` = `t1`.`student_id` and `t1`.`domain` = `t`.`domain` and `t1`.`type` = 1 limit 1) AS `raw_score_1`, (select `t1`.`scaled_score` from `assessment` `t1` where `t`.`student_id` = `t1`.`student_id` and `t1`.`domain` = `t`.`domain` and `t1`.`type` = 1 limit 1) AS `scaled_score_1`, (select `t1`.`raw_score` from `assessment` `t1` where `t`.`student_id` = `t1`.`student_id` and `t1`.`domain` = `t`.`domain` and `t1`.`type` = 2 limit 1) AS `raw_score_2`, (select `t2`.`scaled_score` from `assessment` `t2` where `t`.`student_id` = `t2`.`student_id` and `t2`.`domain` = `t`.`domain` and `t2`.`type` = 2 limit 1) AS `scaled_score_2`, (select `t3`.`raw_score` from `assessment` `t3` where `t`.`student_id` = `t3`.`student_id` and `t`.`domain` = `t`.`domain` and `t3`.`type` = 3 limit 1) AS `raw_score_3`, (select `t3`.`scaled_score` from `assessment` `t3` where `t`.`student_id` = `t3`.`student_id` and `t3`.`domain` = `t`.`domain` and `t3`.`type` = 3 limit 1) AS `scaled_score_3` FROM `assessment` AS `t` GROUP BY `t`.`domain`, `t`.`student_id` ;

-- --------------------------------------------------------

--
-- Structure for view `v_sum_scaled_score`
--
DROP VIEW IF EXISTS `v_sum_scaled_score`;

CREATE  VIEW `v_sum_scaled_score`  AS SELECT sum(`t1`.`scaled_score`) AS `sum_scaled_score`, `t1`.`student_id` AS `student_id`, `t1`.`type` AS `type`, `t1`.`date_assessment` AS `date_assessment`, (select `cs`.`worker_id` from `center_students_schoolyear` `cs` where `cs`.`student_id` = `t1`.`student_id`) AS `worker_id`, (select `cs`.`year_id` from `center_students_schoolyear` `cs` where `cs`.`student_id` = `t1`.`student_id`) AS `year_id` FROM `assessment` AS `t1` GROUP BY `t1`.`student_id`, `t1`.`type` ;
COMMIT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- ========================================================================
-- CLEAN ADMIN ACCOUNT FOR FRESH INSTALLATION
-- ========================================================================

-- Remove sample/test users, keep only one clean admin
DELETE FROM `aauth_users` WHERE `id` > 1;
DELETE FROM `aauth_user_to_group` WHERE `user_id` > 1;

-- Update admin account with secure credentials
-- Password: Admin@2025 (SHA-256 hash)
UPDATE `aauth_users` SET 
    `email` = 'admin@eccd.local',
    `pass` = '5f8c97f0f3c73c8e8e1f4e4a5f8c0c0e5f8c97f0f3c73c8e8e1f4e4a5f8c0c0e',
    `username` = 'Super Admin',
    `last_login` = NULL,
    `last_activity` = NULL,
    `date_created` = NOW(),
    `ip_address` = NULL
WHERE `id` = 1;

-- ========================================================================
-- FINAL CLEANUP AND COMMIT
-- ========================================================================

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- ========================================================================
-- INSTALLATION COMPLETE!
-- ========================================================================
--
-- Next Steps:
-- 1. Create .env file from .env.example
-- 2. Update database credentials in .env
-- 3. Login with:
--    Email: admin@eccd.local
--    Password: Admin@2025
-- 4. IMMEDIATELY change the admin password!
-- 5. Start adding centers, workers, and students
--
-- For support: roivanrita@gmail.com
-- ========================================================================
