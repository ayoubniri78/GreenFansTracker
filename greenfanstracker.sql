-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 16, 2025 at 10:13 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `greenfanstracker`
--

-- --------------------------------------------------------

--
-- Table structure for table `Action`
--

CREATE TABLE `Action` (
  `id` int(11) NOT NULL,
  `details` varchar(255) DEFAULT NULL,
  `mediaFileName` varchar(255) DEFAULT NULL,
  `mediaFilePath` varchar(255) DEFAULT NULL,
  `mediaFileType` varchar(255) DEFAULT NULL,
  `points` int(11) NOT NULL,
  `status` enum('PENDING','VALIDATED','REJECTED') DEFAULT NULL,
  `submissionDate` date DEFAULT NULL,
  `supporterId` int(11) NOT NULL,
  `type` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Action`
--

INSERT INTO `Action` (`id`, `details`, `mediaFileName`, `mediaFilePath`, `mediaFileType`, `points`, `status`, `submissionDate`, `supporterId`, `type`) VALUES
(5, 'test', 'Gemini_Generated_Image_u08vqsu08vqsu08v.png', '/home/ayoub/GreenFansTracker/uploads/22_1762677697138.png', 'image/png', 10, 'PENDING', '2025-11-09', 22, 'test'),
(6, 'test', 'Gemini_Generated_Image_vm9i9pvm9i9pvm9i.png', '/home/ayoub/GreenFansTracker/uploads/22_1762679175142.png', 'image/png', 25, 'PENDING', '2025-11-09', 22, 'Covoiturage'),
(7, '3eihfr9eghergh', 'Gemini_Generated_Image_pzsqjfpzsqjfpzsq.png', '/home/ayoub/GreenFansTracker/uploads/20_1762955640606.png', 'image/png', 50, 'VALIDATED', '2025-11-12', 20, 'Recyclage des déchets'),
(8, '132342424524545', 'Gemini_Generated_Image_pzsqjfpzsqjfpzsq.png', '/home/ayoub/GreenFansTracker/uploads/21_1762955795984.png', 'image/png', 50, 'VALIDATED', '2025-11-12', 21, 'Recyclage des déchets'),
(9, 'weihrget-ohjrptjh', 'Gemini_Generated_Image_vm9i9pvm9i9pvm9i.png', '/home/ayoub/GreenFansTracker/uploads/20_1762959949748.png', 'image/png', 25, 'VALIDATED', '2025-11-12', 20, 'Covoiturage'),
(10, 'aodfegneprfnbeotnbeot', 'token.png', '/home/ayoub/GreenFansTracker/uploads/22_1762965475429.png', 'image/png', 30, 'VALIDATED', '2025-11-12', 22, 'Réparation au lieu de jeter'),
(11, 'oih8gtfuygo', 'TEMPO-Logo.width-500.png', '/home/ayoub/GreenFansTracker/uploads/20_1763035308826.png', 'image/png', 50, 'VALIDATED', '2025-11-13', 20, 'Recyclage des déchets'),
(12, 'soadcnadknd', 'token.png', '/home/ayoub/GreenFansTracker/uploads/22_1763048972216.png', 'image/png', 20, 'PENDING', '2025-11-13', 22, 'Réduction de la consommation d\'eau'),
(13, 'lhoiboiboilj j', 'TEMPO-Logo.width-500.png', '/home/ayoub/GreenFansTracker/uploads/22_1763050813574.png', 'image/png', 15, 'VALIDATED', '2025-11-13', 22, 'Utilisation de produits réutilisables'),
(14, 'test test test', 'TEMPO-Logo.width-500.png', '/home/ayoub/GreenFansTracker/uploads/24_1763065266745.png', 'image/png', 40, 'VALIDATED', '2025-11-13', 24, 'Vélo ou marche'),
(15, 'ohdwrgeoirgjerijgoe', 'TEMPO-Logo.width-500.png', '/home/ayoub/GreenFansTracker/uploads/22_1763068498170.png', 'image/png', 30, 'REJECTED', '2025-11-13', 22, 'Utilisation des transports en commun'),
(16, 'Action ecologique 1', 'TEMPO-Logo.width-500.png', '/home/ayoub/GreenFansTracker/uploads/22_1763126997910.png', 'image/png', 15, 'PENDING', '2025-11-14', 22, 'Utilisation de produits réutilisables'),
(17, 'testrgetghbrt', 'token.png', '/home/ayoub/GreenFansTracker/uploads/22_1763127224139.png', 'image/png', 50, 'PENDING', '2025-11-14', 22, 'Recyclage des déchets'),
(18, 'wetryeqwtrhjy', 'TEMPO-Logo.width-500.png', '/home/ayoub/GreenFansTracker/uploads/22_1763127305396.png', 'image/png', 30, 'PENDING', '2025-11-14', 22, 'Utilisation des transports en commun'),
(19, 'ohiguio;py089fiugl', 'TEMPO-Logo.width-500.png', '/home/ayoub/GreenFansTracker/uploads/22_1763133836506.png', 'image/png', 40, 'VALIDATED', '2025-11-14', 22, 'Vélo ou marche'),
(20, 'covoiturage casa agadir', 'covoiturage.png', '/home/ayoub/GreenFansTracker/uploads/25_1763135672751.png', 'image/png', 25, 'PENDING', '2025-11-14', 25, 'Covoiturage'),
(21, 'recyctjyy,ku,u', 'recyclage-dechets-Europe.jpg', '/home/ayoub/GreenFansTracker/uploads/20_1763136412081.jpg', 'image/jpeg', 50, 'PENDING', '2025-11-14', 20, 'Recyclage des déchets'),
(22, 'ousfdbvoskdnzghseuhgorsp', 'plantDemo.jpg', '/home/ayoub/GreenFansTracker/uploads/20_1763137328300.jpg', 'image/jpeg', 100, 'PENDING', '2025-11-14', 20, 'Plantation d\'arbres');

-- --------------------------------------------------------

--
-- Table structure for table `ActionType`
--

CREATE TABLE `ActionType` (
  `id` int(11) NOT NULL,
  `defaultPoints` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ActionType`
--

INSERT INTO `ActionType` (`id`, `defaultPoints`, `name`) VALUES
(1, 50, 'Recyclage des déchets'),
(2, 30, 'Utilisation des transports en commun'),
(3, 25, 'Covoiturage'),
(4, 40, 'Vélo ou marche'),
(5, 35, 'Compostage'),
(6, 20, 'Réduction de la consommation d\'eau'),
(7, 25, 'Réduction de la consommation d\'électricité'),
(8, 15, 'Achat de produits locaux'),
(9, 20, 'Achat de produits bio'),
(10, 10, 'Utilisation de sacs réutilisables'),
(11, 100, 'Plantation d\'arbres'),
(12, 80, 'Nettoyage d\'espace public'),
(13, 15, 'Utilisation de produits réutilisables'),
(14, 30, 'Réparation au lieu de jeter'),
(15, 25, 'Don d\'objets inutilisés');

-- --------------------------------------------------------

--
-- Table structure for table `action_validation_votes`
--

CREATE TABLE `action_validation_votes` (
  `action_id` int(11) NOT NULL,
  `supporter_id` int(11) NOT NULL,
  `vote_value` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `action_validation_votes`
--

INSERT INTO `action_validation_votes` (`action_id`, `supporter_id`, `vote_value`) VALUES
(5, 20, 'valid'),
(5, 21, 'valid'),
(5, 22, 'valid'),
(6, 20, 'nonValid'),
(6, 21, 'valid'),
(6, 22, 'valid'),
(7, 20, 'nonValid'),
(7, 21, 'valid'),
(7, 22, 'nonValid'),
(8, 20, 'nonValid'),
(8, 21, 'valid'),
(9, 20, 'nonValid'),
(9, 21, 'valid'),
(9, 22, 'nonValid'),
(10, 20, 'nonValid'),
(10, 21, 'valid'),
(10, 22, 'valid'),
(11, 20, 'valid'),
(11, 21, 'valid'),
(11, 22, 'valid'),
(12, 22, 'valid'),
(14, 24, 'valid'),
(15, 20, 'nonValid'),
(15, 21, 'nonValid'),
(15, 22, 'valid'),
(19, 22, 'valid'),
(20, 20, 'valid'),
(20, 25, 'valid'),
(21, 20, 'valid'),
(21, 21, 'valid'),
(22, 20, 'valid'),
(22, 22, 'nonValid');

-- --------------------------------------------------------

--
-- Table structure for table `AuthToken`
--

CREATE TABLE `AuthToken` (
  `id` int(11) NOT NULL,
  `expiryDate` datetime(6) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `supporter_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rankings`
--

CREATE TABLE `rankings` (
  `id` int(11) NOT NULL,
  `lastUpdate` date DEFAULT NULL,
  `ranking_position` int(11) DEFAULT NULL,
  `score` int(11) NOT NULL,
  `supporterId` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Score`
--

CREATE TABLE `Score` (
  `id` int(11) NOT NULL,
  `rank` int(11) DEFAULT 0,
  `supporterId` int(11) NOT NULL,
  `lastUpdate` date DEFAULT NULL,
  `totalScore` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Score`
--

INSERT INTO `Score` (`id`, `rank`, `supporterId`, `lastUpdate`, `totalScore`) VALUES
(1, 0, 20, '2025-11-14', 125),
(2, 0, 21, '2025-11-14', 50),
(3, 0, 22, '2025-11-14', 45),
(4, 0, 24, '2025-11-14', 40);

-- --------------------------------------------------------

--
-- Table structure for table `Supporter`
--

CREATE TABLE `Supporter` (
  `id` int(11) NOT NULL,
  `creationDate` date DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `teamFavorite` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Supporter`
--

INSERT INTO `Supporter` (`id`, `creationDate`, `email`, `password`, `phoneNumber`, `teamFavorite`) VALUES
(17, '2025-10-19', 'ayoubniri2@gmail.com', '$2a$10$.Z9Tst2.RJQ8b5T39vIqvuP7EIwS0wI/nXa/ZZG6XcX.pljyVSpma', '065735042', NULL),
(18, '2025-10-19', 'ayoubniri3@gmail.com', '$2a$10$2X217B42hcW5nJe1iDqKcOE2zDz4gomAJkoyXAnnF6QoIx8fP3U02', '065735042', NULL),
(19, '2025-10-19', 'ayoubniri9@gmail.com', '$2a$10$qzT2hqgsEDP1382kubSLRO1YjA4VU.Ph7RGbibekYG/jiDGYqfsiy', '0657350485', NULL),
(20, '2025-10-27', 'oussamabenz23@gmail.com', '$2a$10$GH7VnDixQL21NY4arnTJtuTt5tL.QDctj.zS73ZXsGQoHd/9GsKBS', '+555463403959', NULL),
(21, '2025-10-27', 'ayoubniri1@gmail.com', '$2a$10$j87RtA8oGY43RQgpCreWzu9Y5AZGFQa/gBNrJF2LmVwWlsPNteQCK', '+291567898767890', NULL),
(22, '2025-11-08', 'ayoubniri19@gmail.com', '$2a$10$GI43ONfWmNfUT3lgDL4SYO87qsH0/WNBR0zuW7znPB/BPtlSfeVHG', '+212768909786', NULL),
(23, '2025-11-10', 'ayoubniri190@gmail.com', '$2a$10$MHQtHcjVtOxmTN9YbRHQJuQWXSUbc2FGt3uQqbCTgdMAkYm/bbv/i', '+2123456455', NULL),
(24, '2025-11-13', 'ayoubniri1900@gmail.com', '$2a$10$YPv.fiyA6RcOxe/ripsWK.kCkuo4KaRR0GK5k/Bmf/Tg7HpYooyH.', '+3581823984853489', NULL),
(25, '2025-11-14', 'ayoubniri19086@gmail.com', '$2a$10$41zIY8CVefcFtLSxYM7CZuuQ.uxnDnl0jZpG1pMbbgujLfwST8wky', '+21268798987', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id` int(11) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `nom` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `email`, `nom`) VALUES
(1, 'aya@example.com', 'Aya'),
(2, 'aya@example.com', 'Aya'),
(3, 'aya@example.com', 'ayoub'),
(4, 'aya@example.com', 'Aya'),
(5, 'aya@example.com', 'ayoub');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Action`
--
ALTER TABLE `Action`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ActionType`
--
ALTER TABLE `ActionType`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `action_validation_votes`
--
ALTER TABLE `action_validation_votes`
  ADD PRIMARY KEY (`action_id`,`supporter_id`);

--
-- Indexes for table `AuthToken`
--
ALTER TABLE `AuthToken`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_gfnsh2esvg3oec6ayk8wnbhc` (`supporter_id`);

--
-- Indexes for table `rankings`
--
ALTER TABLE `rankings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Score`
--
ALTER TABLE `Score`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Supporter`
--
ALTER TABLE `Supporter`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Action`
--
ALTER TABLE `Action`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `ActionType`
--
ALTER TABLE `ActionType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `AuthToken`
--
ALTER TABLE `AuthToken`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `rankings`
--
ALTER TABLE `rankings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Score`
--
ALTER TABLE `Score`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Supporter`
--
ALTER TABLE `Supporter`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `action_validation_votes`
--
ALTER TABLE `action_validation_votes`
  ADD CONSTRAINT `action_validation_votes_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `Action` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `AuthToken`
--
ALTER TABLE `AuthToken`
  ADD CONSTRAINT `FKb5nwkl7nt2n6iqp7j3g5ncita` FOREIGN KEY (`supporter_id`) REFERENCES `Supporter` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
