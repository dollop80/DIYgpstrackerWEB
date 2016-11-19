-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 19, 2016 at 08:51 AM
-- Server version: 5.5.53-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `gpstracker`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`user`@`localhost` PROCEDURE `prcDeleteRoute`(
_sessionID VARCHAR(50))
BEGIN
  DELETE FROM gpslocations
  WHERE sessionID = _sessionID;
END$$

CREATE DEFINER=`user`@`localhost` PROCEDURE `prcGetAllRoutesForMap`(IN `_username` VARCHAR(20))
BEGIN
SELECT sessionId, gpsTime, CONCAT('{ "latitude":"', CAST(latitude AS CHAR),'", "longitude":"', CAST(longitude AS CHAR), '", "speed":"', CAST(speed AS CHAR), '", "direction":"', CAST(direction AS CHAR), '", "distance":"', CAST(distance AS CHAR), '", "locationMethod":"', locationMethod, '", "gpsTime":"', DATE_FORMAT(gpsTime, '%b %e %Y %h:%i%p'), '", "userName":"', userName, '", "phoneNumber":"', phoneNumber, '", "sessionID":"', CAST(sessionID AS CHAR), '", "accuracy":"', CAST(accuracy AS CHAR), '", "extraInfo":"', extraInfo, '" }') json
FROM (SELECT MAX(GPSLocationID) ID
      FROM gpslocations
      WHERE sessionID != '0' && CHAR_LENGTH(sessionID) != 0 && gpstime != '0000-00-00 00:00:00'
      AND userName = _username
      GROUP BY sessionID) AS MaxID
JOIN gpslocations ON gpslocations.GPSLocationID = MaxID.ID
ORDER BY gpsTime;
END$$

CREATE DEFINER=`user`@`localhost` PROCEDURE `prcGetRouteForMap`(IN `_sessionID` VARCHAR(50))
BEGIN
  SELECT CONCAT('{ "latitude":"', CAST(latitude AS CHAR),'", "longitude":"', CAST(longitude AS CHAR), '", "speed":"', CAST(speed AS CHAR), '", "direction":"', CAST(direction AS CHAR), '", "distance":"', CAST(distance AS CHAR), '", "locationMethod":"', locationMethod, '", "gpsTime":"', DATE_FORMAT(gpsTime, '%b %e %Y %h:%i%p'), '", "userName":"', userName, '", "phoneNumber":"', phoneNumber, '", "sessionID":"', CAST(sessionID AS CHAR), '", "accuracy":"', CAST(accuracy AS CHAR), '", "extraInfo":"', extraInfo, '" }') json
  FROM gpslocations
  WHERE sessionID = _sessionID
  ORDER BY lastupdate;
END$$

CREATE DEFINER=`user`@`localhost` PROCEDURE `prcGetRoutes`(IN `_username` VARCHAR(20))
BEGIN
  CREATE TEMPORARY TABLE tempRoutes (
    sessionID VARCHAR(50),
    userName VARCHAR(50),
    startTime DATETIME,
    endTime DATETIME)
  ENGINE = MEMORY;

  INSERT INTO tempRoutes (sessionID, userName)
  SELECT DISTINCT sessionID, userName
  FROM gpslocations
  WHERE userName = _username;

  UPDATE tempRoutes tr
  SET startTime = (SELECT MIN(gpsTime) FROM gpslocations gl
  WHERE gl.sessionID = tr.sessionID
  AND gl.userName = tr.userName);

  UPDATE tempRoutes tr
  SET endTime = (SELECT MAX(gpsTime) FROM gpslocations gl
  WHERE gl.sessionID = tr.sessionID
  AND gl.userName = tr.userName);

  SELECT

  CONCAT('{ "sessionID": "', CAST(sessionID AS CHAR),  '", "userName": "', userName, '", "times": "(', DATE_FORMAT(startTime, '%b %e %Y %h:%i%p'), ' - ', DATE_FORMAT(endTime, '%b %e %Y %h:%i%p'), ')" }') json
  FROM tempRoutes
  ORDER BY startTime DESC;

  DROP TABLE tempRoutes;
END$$

CREATE DEFINER=`user`@`localhost` PROCEDURE `prcSaveGPSLocation`(
_latitude DECIMAL(10,7),
_longitude DECIMAL(10,7),
_speed INT(10),
_direction INT(10),
_distance DECIMAL(10,1),
_date TIMESTAMP,
_locationMethod VARCHAR(50),
_userName VARCHAR(50),
_phoneNumber VARCHAR(50),
_sessionID VARCHAR(50),
_accuracy INT(10),
_extraInfo VARCHAR(255),
_eventType VARCHAR(50)
)
BEGIN
   INSERT INTO gpslocations (latitude, longitude, speed, direction, distance, gpsTime, locationMethod, userName, phoneNumber,  sessionID, accuracy, extraInfo, eventType)
   VALUES (_latitude, _longitude, _speed, _direction, _distance, _date, _locationMethod, _userName, _phoneNumber, _sessionID, _accuracy, _extraInfo, _eventType);
   SELECT NOW();
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `gpslocations`
--

CREATE TABLE IF NOT EXISTS `gpslocations` (
  `GPSLocationID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lastUpdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `latitude` decimal(10,7) NOT NULL DEFAULT '0.0000000',
  `longitude` decimal(10,7) NOT NULL DEFAULT '0.0000000',
  `phoneNumber` varchar(50) NOT NULL DEFAULT '',
  `userName` varchar(50) NOT NULL DEFAULT '',
  `sessionID` varchar(50) NOT NULL DEFAULT '',
  `speed` int(10) unsigned NOT NULL DEFAULT '0',
  `direction` int(10) unsigned NOT NULL DEFAULT '0',
  `distance` decimal(10,1) NOT NULL DEFAULT '0.0',
  `gpsTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `locationMethod` varchar(50) NOT NULL DEFAULT '',
  `accuracy` int(10) unsigned NOT NULL DEFAULT '0',
  `extraInfo` varchar(255) NOT NULL DEFAULT '',
  `eventType` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`GPSLocationID`),
  KEY `sessionIDIndex` (`sessionID`),
  KEY `phoneNumberIndex` (`phoneNumber`),
  KEY `userNameIndex` (`userName`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=241 ;

--
-- Dumping data for table `gpslocations`
--

INSERT INTO `gpslocations` (`GPSLocationID`, `lastUpdate`, `latitude`, `longitude`, `phoneNumber`, `userName`, `sessionID`, `speed`, `direction`, `distance`, `gpsTime`, `locationMethod`, `accuracy`, `extraInfo`, `eventType`) VALUES
(73, '2016-11-19 04:41:59', 32.2510000, 35.1510204, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:58', '', 14, '', 'test'),
(74, '2016-11-19 04:41:59', 32.2520000, 35.1520408, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(75, '2016-11-19 04:41:59', 32.2530000, 35.1530612, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(76, '2016-11-19 04:41:59', 32.2540000, 35.1540816, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(77, '2016-11-19 04:41:59', 32.2550000, 35.1551020, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(78, '2016-11-19 04:41:59', 32.2560000, 35.1561224, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(79, '2016-11-19 04:41:59', 32.2570000, 35.1571429, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(80, '2016-11-19 04:41:59', 32.2580000, 35.1581633, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(81, '2016-11-19 04:41:59', 32.2590000, 35.1591837, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(82, '2016-11-19 04:41:59', 32.2600000, 35.1602041, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(83, '2016-11-19 04:41:59', 32.2610000, 35.1612245, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(84, '2016-11-19 04:41:59', 32.2620000, 35.1622449, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(85, '2016-11-19 04:41:59', 32.2630000, 35.1632653, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(86, '2016-11-19 04:41:59', 32.2640000, 35.1642857, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(87, '2016-11-19 04:41:59', 32.2650000, 35.1653061, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(88, '2016-11-19 04:41:59', 32.2660000, 35.1663265, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(89, '2016-11-19 04:41:59', 32.2670000, 35.1673469, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(90, '2016-11-19 04:41:59', 32.2680000, 35.1683673, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(91, '2016-11-19 04:41:59', 32.2690000, 35.1693878, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:41:59', '', 14, '', 'test'),
(92, '2016-11-19 04:45:38', 32.2510000, 35.1510204, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:38', '', 14, '', 'test'),
(93, '2016-11-19 04:45:38', 32.2520000, 35.1520408, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:38', '', 14, '', 'test'),
(94, '2016-11-19 04:45:38', 32.2530000, 35.1530612, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:38', '', 14, '', 'test'),
(95, '2016-11-19 04:45:38', 32.2540000, 35.1540816, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:38', '', 14, '', 'test'),
(96, '2016-11-19 04:45:38', 32.2550000, 35.1551020, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:38', '', 14, '', 'test'),
(97, '2016-11-19 04:45:38', 32.2560000, 35.1561224, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:38', '', 14, '', 'test'),
(98, '2016-11-19 04:45:39', 32.2570000, 35.1571429, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(99, '2016-11-19 04:45:39', 32.2580000, 35.1581633, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(100, '2016-11-19 04:45:39', 32.2590000, 35.1591837, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(101, '2016-11-19 04:45:39', 32.2600000, 35.1602041, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(102, '2016-11-19 04:45:39', 32.2610000, 35.1612245, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(103, '2016-11-19 04:45:39', 32.2620000, 35.1622449, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(104, '2016-11-19 04:45:39', 32.2630000, 35.1632653, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(105, '2016-11-19 04:45:39', 32.2640000, 35.1642857, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(106, '2016-11-19 04:45:39', 32.2650000, 35.1653061, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(107, '2016-11-19 04:45:39', 32.2660000, 35.1663265, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(108, '2016-11-19 04:45:39', 32.2670000, 35.1673469, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(109, '2016-11-19 04:45:39', 32.2680000, 35.1683673, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(110, '2016-11-19 04:45:39', 32.2690000, 35.1693878, '0587794458', 'python', '13', 11, 230, 0.0, '2016-11-19 04:45:39', '', 14, '', 'test'),
(149, '2016-11-19 05:04:23', 48.7487890, 39.1893160, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:04:23', '', 14, '', 'test'),
(150, '2016-11-19 05:04:28', 48.7487691, 39.1897133, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:04:28', '', 14, '', 'test'),
(151, '2016-11-19 05:04:33', 48.7487101, 39.1900948, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:04:33', '', 14, '', 'test'),
(152, '2016-11-19 05:04:39', 48.7486143, 39.1904453, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:04:39', '', 14, '', 'test'),
(153, '2016-11-19 05:04:44', 48.7484857, 39.1907507, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:04:44', '', 14, '', 'test'),
(154, '2016-11-19 05:04:49', 48.7483293, 39.1909989, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:04:49', '', 14, '', 'test'),
(155, '2016-11-19 05:04:54', 48.7481514, 39.1911801, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:04:54', '', 14, '', 'test'),
(156, '2016-11-19 05:04:59', 48.7479590, 39.1912869, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:04:59', '', 14, '', 'test'),
(157, '2016-11-19 05:05:04', 48.7477598, 39.1913151, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:04', '', 14, '', 'test'),
(158, '2016-11-19 05:05:09', 48.7475618, 39.1912637, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:09', '', 14, '', 'test'),
(159, '2016-11-19 05:05:14', 48.7473729, 39.1911346, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:14', '', 14, '', 'test'),
(160, '2016-11-19 05:05:19', 48.7472005, 39.1909330, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:19', '', 14, '', 'test'),
(161, '2016-11-19 05:05:24', 48.7470516, 39.1906669, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:24', '', 14, '', 'test'),
(162, '2016-11-19 05:05:29', 48.7469321, 39.1903470, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:29', '', 14, '', 'test'),
(163, '2016-11-19 05:05:34', 48.7468468, 39.1899860, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:34', '', 14, '', 'test'),
(164, '2016-11-19 05:05:39', 48.7467990, 39.1895982, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:39', '', 14, '', 'test'),
(165, '2016-11-19 05:05:45', 48.7467907, 39.1891993, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:45', '', 14, '', 'test'),
(166, '2016-11-19 05:05:50', 48.7468222, 39.1888049, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:50', '', 14, '', 'test'),
(167, '2016-11-19 05:05:55', 48.7468922, 39.1884310, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:05:55', '', 14, '', 'test'),
(168, '2016-11-19 05:06:00', 48.7469980, 39.1880923, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:00', '', 14, '', 'test'),
(169, '2016-11-19 05:06:05', 48.7471354, 39.1878024, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:05', '', 14, '', 'test'),
(170, '2016-11-19 05:06:10', 48.7472987, 39.1875728, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:10', '', 14, '', 'test'),
(171, '2016-11-19 05:06:15', 48.7474817, 39.1874128, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:15', '', 14, '', 'test'),
(172, '2016-11-19 05:06:20', 48.7476768, 39.1873286, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:20', '', 14, '', 'test'),
(173, '2016-11-19 05:06:25', 48.7478765, 39.1873237, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:25', '', 14, '', 'test'),
(174, '2016-11-19 05:06:30', 48.7480727, 39.1873982, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:30', '', 14, '', 'test'),
(175, '2016-11-19 05:06:35', 48.7482575, 39.1875491, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:35', '', 14, '', 'test'),
(176, '2016-11-19 05:06:40', 48.7484237, 39.1877705, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:40', '', 14, '', 'test'),
(177, '2016-11-19 05:06:46', 48.7485646, 39.1880535, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:46', '', 14, '', 'test'),
(178, '2016-11-19 05:06:51', 48.7486745, 39.1883868, '12345678900987654321', 'python', '75-535-942', 11, 230, 0.0, '2016-11-19 05:06:51', '', 14, '', 'test');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `login` varchar(30) NOT NULL,
  `password` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login` (`login`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `login`, `password`) VALUES
(3, 'python', '23eeeb4347bdd26bfc6b7ee9a3b755dd');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
