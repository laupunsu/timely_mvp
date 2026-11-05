-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: occupancy_list
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `occupancy_list`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `occupancy_list` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `occupancy_list`;

--
-- Table structure for table `location_information`
--

DROP TABLE IF EXISTS `location_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location_information` (
  `id` int NOT NULL AUTO_INCREMENT,
  `location_name` varchar(100) NOT NULL,
  `recorded_time` time NOT NULL,
  `number_entering` int unsigned NOT NULL DEFAULT '0',
  `number_leaving` int unsigned NOT NULL DEFAULT '0',
  `number_now` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_location_time` (`location_name`,`recorded_time`),
  CONSTRAINT `chk_non_negative_occupancy` CHECK ((`number_now` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=291 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location_information`
--

LOCK TABLES `location_information` WRITE;
/*!40000 ALTER TABLE `location_information` DISABLE KEYS */;
INSERT INTO `location_information` VALUES (1,'Gardens By The Bay flower dome','08:00:00',8,3,5,'2026-10-30 02:52:12'),(2,'Gardens By The Bay flower dome','08:10:00',19,1,23,'2026-10-30 02:52:12'),(3,'Serangoon Library','08:10:00',16,1,15,'2026-10-30 02:52:12'),(4,'Gardens By The Bay flower dome','08:20:00',17,6,34,'2026-10-30 02:52:12'),(5,'Serangoon Library','08:20:00',18,3,30,'2026-10-30 02:52:12'),(6,'Sentosa, Universal Studios','08:20:00',19,0,19,'2026-10-30 02:52:12'),(7,'Gardens By The Bay flower dome','08:30:00',6,3,37,'2026-10-30 02:52:12'),(8,'Serangoon Library','08:30:00',19,6,43,'2026-10-30 02:52:12'),(9,'Sentosa, Universal Studios','08:30:00',5,4,20,'2026-10-30 02:52:12'),(10,'Lolas Cafe','08:30:00',16,2,14,'2026-10-30 02:52:12'),(11,'Gardens By The Bay flower dome','08:40:00',20,5,52,'2026-10-30 02:52:12'),(12,'Serangoon Library','08:40:00',8,7,44,'2026-10-30 02:52:12'),(13,'Sentosa, Universal Studios','08:40:00',15,5,30,'2026-10-30 02:52:12'),(14,'Lolas Cafe','08:40:00',10,5,19,'2026-10-30 02:52:12'),(15,'Gardens By The Bay flower dome','08:50:00',15,9,58,'2026-10-30 02:52:12'),(16,'Serangoon Library','08:50:00',17,6,55,'2026-10-30 02:52:12'),(17,'Sentosa, Universal Studios','08:50:00',17,8,39,'2026-10-30 02:52:12'),(18,'Lolas Cafe','08:50:00',7,4,22,'2026-10-30 02:52:12'),(19,'Gardens By The Bay flower dome','09:00:00',17,8,67,'2026-10-30 02:52:12'),(20,'Serangoon Library','09:00:00',14,10,59,'2026-10-30 02:52:12'),(21,'Sentosa, Universal Studios','09:00:00',14,10,43,'2026-10-30 02:52:12'),(22,'Lolas Cafe','09:00:00',16,5,33,'2026-10-30 02:52:12'),(23,'Gardens By The Bay flower dome','09:10:00',12,19,60,'2026-10-30 02:52:12'),(24,'Serangoon Library','09:10:00',20,6,73,'2026-10-30 02:52:12'),(25,'Sentosa, Universal Studios','09:10:00',6,11,38,'2026-10-30 02:52:12'),(26,'Lolas Cafe','09:10:00',19,8,44,'2026-10-30 02:52:12'),(27,'Gardens By The Bay flower dome','09:20:00',20,13,67,'2026-10-30 02:52:12'),(28,'Serangoon Library','09:20:00',20,16,77,'2026-10-30 02:52:12'),(29,'Sentosa, Universal Studios','09:20:00',9,7,40,'2026-10-30 02:52:12'),(30,'Lolas Cafe','09:20:00',16,5,55,'2026-10-30 02:52:12'),(31,'Gardens By The Bay flower dome','09:30:00',15,17,65,'2026-10-30 02:52:12'),(32,'Serangoon Library','09:30:00',14,18,73,'2026-10-30 02:52:12'),(33,'Sentosa, Universal Studios','09:30:00',10,10,40,'2026-10-30 02:52:12'),(34,'Lolas Cafe','09:30:00',7,11,51,'2026-10-30 02:52:12'),(35,'Gardens By The Bay flower dome','09:40:00',9,8,66,'2026-10-30 02:52:12'),(36,'Serangoon Library','09:40:00',16,14,75,'2026-10-30 02:52:12'),(37,'Sentosa, Universal Studios','09:40:00',17,11,46,'2026-10-30 02:52:12'),(38,'Lolas Cafe','09:40:00',9,16,44,'2026-10-30 02:52:12'),(39,'Gardens By The Bay flower dome','09:50:00',20,7,79,'2026-10-30 02:52:12'),(40,'Serangoon Library','09:50:00',13,13,75,'2026-10-30 02:52:12'),(41,'Sentosa, Universal Studios','09:50:00',11,6,51,'2026-10-30 02:52:12'),(42,'Lolas Cafe','09:50:00',6,12,38,'2026-10-30 02:52:12'),(43,'Gardens By The Bay flower dome','10:00:00',17,21,75,'2026-10-30 02:52:12'),(44,'Serangoon Library','10:00:00',16,9,82,'2026-10-30 02:52:12'),(45,'Sentosa, Universal Studios','10:00:00',9,8,52,'2026-10-30 02:52:12'),(46,'Lolas Cafe','10:00:00',8,9,37,'2026-10-30 02:52:12'),(47,'Gardens By The Bay flower dome','10:10:00',20,10,85,'2026-10-30 02:52:12'),(48,'Serangoon Library','10:10:00',16,15,83,'2026-10-30 02:52:12'),(49,'Sentosa, Universal Studios','10:10:00',5,7,50,'2026-10-30 02:52:12'),(50,'Lolas Cafe','10:10:00',11,6,42,'2026-10-30 02:52:12'),(51,'Gardens By The Bay flower dome','10:20:00',20,16,89,'2026-10-30 02:52:12'),(52,'Serangoon Library','10:20:00',9,23,69,'2026-10-30 02:52:12'),(53,'Sentosa, Universal Studios','10:20:00',7,12,45,'2026-10-30 02:52:12'),(54,'Lolas Cafe','10:20:00',11,13,40,'2026-10-30 02:52:12'),(55,'Gardens By The Bay flower dome','10:30:00',20,17,92,'2026-10-30 02:52:12'),(56,'Serangoon Library','10:30:00',7,13,63,'2026-10-30 02:52:12'),(57,'Sentosa, Universal Studios','10:30:00',16,11,50,'2026-10-30 02:52:12'),(58,'Lolas Cafe','10:30:00',8,10,38,'2026-10-30 02:52:12'),(59,'Gardens By The Bay flower dome','10:40:00',12,16,88,'2026-10-30 02:52:12'),(60,'Serangoon Library','10:40:00',19,15,67,'2026-10-30 02:52:12'),(61,'Sentosa, Universal Studios','10:40:00',13,10,53,'2026-10-30 02:52:12'),(62,'Lolas Cafe','10:40:00',19,9,48,'2026-10-30 02:52:12'),(63,'Gardens By The Bay flower dome','10:50:00',19,22,85,'2026-10-30 02:52:12'),(64,'Serangoon Library','10:50:00',8,15,60,'2026-10-30 02:52:12'),(65,'Sentosa, Universal Studios','10:50:00',15,13,55,'2026-10-30 02:52:12'),(66,'Lolas Cafe','10:50:00',20,11,57,'2026-10-30 02:52:12'),(67,'Gardens By The Bay flower dome','11:00:00',11,19,77,'2026-10-30 02:52:12'),(68,'Serangoon Library','11:00:00',5,17,48,'2026-10-30 02:52:12'),(69,'Sentosa, Universal Studios','11:00:00',12,11,56,'2026-10-30 02:52:12'),(70,'Lolas Cafe','11:00:00',18,11,64,'2026-10-30 02:52:12'),(71,'Gardens By The Bay flower dome','11:10:00',7,13,71,'2026-10-30 02:52:12'),(72,'Serangoon Library','11:10:00',7,8,47,'2026-10-30 02:52:12'),(73,'Sentosa, Universal Studios','11:10:00',16,11,61,'2026-10-30 02:52:12'),(74,'Lolas Cafe','11:10:00',11,16,59,'2026-10-30 02:52:12'),(75,'Gardens By The Bay flower dome','11:20:00',5,11,65,'2026-10-30 02:52:12'),(76,'Serangoon Library','11:20:00',15,10,52,'2026-10-30 02:52:12'),(77,'Sentosa, Universal Studios','11:20:00',7,12,56,'2026-10-30 02:52:12'),(78,'Lolas Cafe','11:20:00',17,9,67,'2026-10-30 02:52:12'),(79,'Gardens By The Bay flower dome','11:30:00',7,11,61,'2026-10-30 02:52:12'),(80,'Serangoon Library','11:30:00',11,9,54,'2026-10-30 02:52:12'),(81,'Sentosa, Universal Studios','11:30:00',16,14,58,'2026-10-30 02:52:12'),(82,'Lolas Cafe','11:30:00',16,18,65,'2026-10-30 02:52:12'),(83,'Gardens By The Bay flower dome','11:40:00',5,14,52,'2026-10-30 02:52:12'),(84,'Serangoon Library','11:40:00',19,11,62,'2026-10-30 02:52:12'),(85,'Sentosa, Universal Studios','11:40:00',7,12,53,'2026-10-30 02:52:12'),(86,'Lolas Cafe','11:40:00',7,13,59,'2026-10-30 02:52:12'),(87,'Gardens By The Bay flower dome','11:50:00',6,12,46,'2026-10-30 02:52:12'),(88,'Serangoon Library','11:50:00',20,11,71,'2026-10-30 02:52:12'),(89,'Sentosa, Universal Studios','11:50:00',7,14,46,'2026-10-30 02:52:12'),(90,'Lolas Cafe','11:50:00',8,14,53,'2026-10-30 02:52:12'),(91,'Gardens By The Bay flower dome','12:00:00',14,12,48,'2026-10-30 02:52:12'),(92,'Serangoon Library','12:00:00',15,7,79,'2026-10-30 02:52:12'),(93,'Sentosa, Universal Studios','12:00:00',9,8,47,'2026-10-30 02:52:12'),(94,'Lolas Cafe','12:00:00',10,11,52,'2026-10-30 02:52:12'),(95,'Gardens By The Bay flower dome','12:10:00',9,11,46,'2026-10-30 02:52:12'),(96,'Serangoon Library','12:10:00',15,16,78,'2026-10-30 02:52:12'),(97,'Sentosa, Universal Studios','12:10:00',9,12,44,'2026-10-30 02:52:12'),(98,'Lolas Cafe','12:10:00',7,12,47,'2026-10-30 02:52:12'),(99,'Gardens By The Bay flower dome','12:20:00',17,10,53,'2026-10-30 02:52:12'),(100,'Serangoon Library','12:20:00',12,11,79,'2026-10-30 02:52:12'),(101,'Sentosa, Universal Studios','12:20:00',17,8,53,'2026-10-30 02:52:12'),(102,'Lolas Cafe','12:20:00',12,12,47,'2026-10-30 02:52:12'),(103,'Gardens By The Bay flower dome','12:30:00',12,14,51,'2026-10-30 02:52:12'),(104,'Serangoon Library','12:30:00',11,12,78,'2026-10-30 02:52:12'),(105,'Sentosa, Universal Studios','12:30:00',13,14,52,'2026-10-30 02:52:12'),(106,'Lolas Cafe','12:30:00',18,8,57,'2026-10-30 02:52:12'),(107,'Gardens By The Bay flower dome','12:40:00',17,11,57,'2026-10-30 02:52:12'),(108,'Serangoon Library','12:40:00',16,12,82,'2026-10-30 02:52:12'),(109,'Sentosa, Universal Studios','12:40:00',8,13,47,'2026-10-30 02:52:12'),(110,'Lolas Cafe','12:40:00',16,12,61,'2026-10-30 02:52:12'),(111,'Gardens By The Bay flower dome','12:50:00',7,8,56,'2026-10-30 02:52:12'),(112,'Serangoon Library','12:50:00',6,19,69,'2026-10-30 02:52:12'),(113,'Sentosa, Universal Studios','12:50:00',8,10,45,'2026-10-30 02:52:12'),(114,'Lolas Cafe','12:50:00',18,12,67,'2026-10-30 02:52:12'),(115,'Gardens By The Bay flower dome','13:00:00',12,11,57,'2026-10-30 02:52:12'),(116,'Serangoon Library','13:00:00',20,20,69,'2026-10-30 02:52:12'),(117,'Sentosa, Universal Studios','13:00:00',9,10,44,'2026-10-30 02:52:12'),(118,'Lolas Cafe','13:00:00',13,10,70,'2026-10-30 02:52:12'),(119,'Gardens By The Bay flower dome','13:10:00',10,14,53,'2026-10-30 02:52:12'),(120,'Serangoon Library','13:10:00',6,16,59,'2026-10-30 02:52:12'),(121,'Sentosa, Universal Studios','13:10:00',16,7,53,'2026-10-30 02:52:12'),(122,'Lolas Cafe','13:10:00',7,12,65,'2026-10-30 02:52:12'),(123,'Gardens By The Bay flower dome','13:20:00',17,11,59,'2026-10-30 02:52:12'),(124,'Serangoon Library','13:20:00',16,10,65,'2026-10-30 02:52:12'),(125,'Sentosa, Universal Studios','13:20:00',18,6,65,'2026-10-30 02:52:12'),(126,'Lolas Cafe','13:20:00',11,16,60,'2026-10-30 02:52:12'),(127,'Gardens By The Bay flower dome','13:30:00',5,7,57,'2026-10-30 02:52:12'),(128,'Serangoon Library','13:30:00',5,13,57,'2026-10-30 02:52:12'),(129,'Sentosa, Universal Studios','13:30:00',16,10,71,'2026-10-30 02:52:12'),(130,'Lolas Cafe','13:30:00',13,15,58,'2026-10-30 02:52:12'),(131,'Gardens By The Bay flower dome','13:40:00',12,10,59,'2026-10-30 02:52:12'),(132,'Serangoon Library','13:40:00',5,13,49,'2026-10-30 02:52:12'),(133,'Sentosa, Universal Studios','13:40:00',5,18,58,'2026-10-30 02:52:12'),(134,'Lolas Cafe','13:40:00',13,10,61,'2026-10-30 02:52:12'),(135,'Gardens By The Bay flower dome','13:50:00',17,14,62,'2026-10-30 02:52:12'),(136,'Serangoon Library','13:50:00',18,11,56,'2026-10-30 02:52:12'),(137,'Sentosa, Universal Studios','13:50:00',13,12,59,'2026-10-30 02:52:12'),(138,'Lolas Cafe','13:50:00',10,14,57,'2026-10-30 02:52:12'),(139,'Gardens By The Bay flower dome','14:00:00',11,12,61,'2026-10-30 02:52:12'),(140,'Serangoon Library','14:00:00',9,8,57,'2026-10-30 02:52:12'),(141,'Sentosa, Universal Studios','14:00:00',15,10,64,'2026-10-30 02:52:12'),(142,'Lolas Cafe','14:00:00',7,13,51,'2026-10-30 02:52:12'),(143,'Gardens By The Bay flower dome','14:10:00',18,14,65,'2026-10-30 02:52:12'),(144,'Serangoon Library','14:10:00',11,14,54,'2026-10-30 02:52:12'),(145,'Sentosa, Universal Studios','14:10:00',15,15,64,'2026-10-30 02:52:12'),(146,'Lolas Cafe','14:10:00',10,7,54,'2026-10-30 02:52:12'),(147,'Gardens By The Bay flower dome','14:20:00',19,8,76,'2026-10-30 02:52:12'),(148,'Serangoon Library','14:20:00',19,8,65,'2026-10-30 02:52:12'),(149,'Sentosa, Universal Studios','14:20:00',8,16,56,'2026-10-30 02:52:12'),(150,'Lolas Cafe','14:20:00',18,14,58,'2026-10-30 02:52:12'),(151,'Gardens By The Bay flower dome','14:30:00',16,17,75,'2026-10-30 02:52:12'),(152,'Serangoon Library','14:30:00',5,15,55,'2026-10-30 02:52:12'),(153,'Sentosa, Universal Studios','14:30:00',8,12,52,'2026-10-30 02:52:12'),(154,'Lolas Cafe','14:30:00',13,10,61,'2026-10-30 02:52:12'),(155,'Gardens By The Bay flower dome','14:40:00',9,14,70,'2026-10-30 02:52:12'),(156,'Serangoon Library','14:40:00',20,11,64,'2026-10-30 02:52:12'),(157,'Sentosa, Universal Studios','14:40:00',5,11,46,'2026-10-30 02:52:12'),(158,'Lolas Cafe','14:40:00',14,9,66,'2026-10-30 02:52:12'),(159,'Gardens By The Bay flower dome','14:50:00',12,18,64,'2026-10-30 02:52:12'),(160,'Serangoon Library','14:50:00',8,17,55,'2026-10-30 02:52:12'),(161,'Sentosa, Universal Studios','14:50:00',14,6,54,'2026-10-30 02:52:12'),(162,'Lolas Cafe','14:50:00',17,14,69,'2026-10-30 02:52:12'),(163,'Gardens By The Bay flower dome','15:00:00',20,12,72,'2026-10-30 02:52:12'),(164,'Serangoon Library','15:00:00',8,10,53,'2026-10-30 02:52:12'),(165,'Sentosa, Universal Studios','15:00:00',15,10,59,'2026-10-30 02:52:12'),(166,'Lolas Cafe','15:00:00',18,15,72,'2026-10-30 02:52:12'),(167,'Gardens By The Bay flower dome','15:10:00',10,19,63,'2026-10-30 02:52:12'),(168,'Serangoon Library','15:10:00',18,11,60,'2026-10-30 02:52:12'),(169,'Sentosa, Universal Studios','15:10:00',20,15,64,'2026-10-30 02:52:12'),(170,'Lolas Cafe','15:10:00',5,15,62,'2026-10-30 02:52:12'),(171,'Gardens By The Bay flower dome','15:20:00',13,16,60,'2026-10-30 02:52:12'),(172,'Serangoon Library','15:20:00',9,16,53,'2026-10-30 02:52:12'),(173,'Sentosa, Universal Studios','15:20:00',9,12,61,'2026-10-30 02:52:12'),(174,'Lolas Cafe','15:20:00',20,14,68,'2026-10-30 02:52:12'),(175,'Gardens By The Bay flower dome','15:30:00',19,12,67,'2026-10-30 02:52:12'),(176,'Serangoon Library','15:30:00',5,5,53,'2026-10-30 02:52:12'),(177,'Sentosa, Universal Studios','15:30:00',9,8,62,'2026-10-30 02:52:12'),(178,'Lolas Cafe','15:30:00',5,17,56,'2026-10-30 02:52:12'),(179,'Gardens By The Bay flower dome','15:40:00',11,17,61,'2026-10-30 02:52:12'),(180,'Serangoon Library','15:40:00',14,10,57,'2026-10-30 02:52:12'),(181,'Sentosa, Universal Studios','15:40:00',19,9,72,'2026-10-30 02:52:12'),(182,'Lolas Cafe','15:40:00',18,10,64,'2026-10-30 02:52:12'),(183,'Gardens By The Bay flower dome','15:50:00',19,11,69,'2026-10-30 02:52:12'),(184,'Serangoon Library','15:50:00',15,8,64,'2026-10-30 02:52:12'),(185,'Sentosa, Universal Studios','15:50:00',12,16,68,'2026-10-30 02:52:12'),(186,'Lolas Cafe','15:50:00',11,7,68,'2026-10-30 02:52:12'),(187,'Gardens By The Bay flower dome','16:00:00',16,18,67,'2026-10-30 02:52:12'),(188,'Serangoon Library','16:00:00',16,11,69,'2026-10-30 02:52:12'),(189,'Sentosa, Universal Studios','16:00:00',6,10,64,'2026-10-30 02:52:12'),(190,'Lolas Cafe','16:00:00',18,18,68,'2026-10-30 02:52:12'),(191,'Gardens By The Bay flower dome','16:10:00',16,15,68,'2026-10-30 02:52:12'),(192,'Serangoon Library','16:10:00',13,13,69,'2026-10-30 02:52:12'),(193,'Sentosa, Universal Studios','16:10:00',15,14,65,'2026-10-30 02:52:12'),(194,'Lolas Cafe','16:10:00',17,17,68,'2026-10-30 02:52:12'),(195,'Gardens By The Bay flower dome','16:20:00',17,9,76,'2026-10-30 02:52:12'),(196,'Serangoon Library','16:20:00',18,13,74,'2026-10-30 02:52:12'),(197,'Sentosa, Universal Studios','16:20:00',5,15,55,'2026-10-30 02:52:12'),(198,'Lolas Cafe','16:20:00',12,17,63,'2026-10-30 02:52:12'),(199,'Gardens By The Bay flower dome','16:30:00',15,15,76,'2026-10-30 02:52:12'),(200,'Serangoon Library','16:30:00',19,9,84,'2026-10-30 02:52:12'),(201,'Sentosa, Universal Studios','16:30:00',15,9,61,'2026-10-30 02:52:12'),(202,'Lolas Cafe','16:30:00',9,8,64,'2026-10-30 02:52:12'),(203,'Gardens By The Bay flower dome','16:40:00',6,12,70,'2026-10-30 02:52:12'),(204,'Serangoon Library','16:40:00',18,14,88,'2026-10-30 02:52:12'),(205,'Sentosa, Universal Studios','16:40:00',16,11,66,'2026-10-30 02:52:12'),(206,'Lolas Cafe','16:40:00',17,10,71,'2026-10-30 02:52:12'),(207,'Gardens By The Bay flower dome','16:50:00',15,14,71,'2026-10-30 02:52:12'),(208,'Serangoon Library','16:50:00',10,11,87,'2026-10-30 02:52:12'),(209,'Sentosa, Universal Studios','16:50:00',13,15,64,'2026-10-30 02:52:12'),(210,'Lolas Cafe','16:50:00',12,10,73,'2026-10-30 02:52:12'),(211,'Gardens By The Bay flower dome','17:00:00',12,12,71,'2026-10-30 02:52:12'),(212,'Serangoon Library','17:00:00',15,14,88,'2026-10-30 02:52:12'),(213,'Sentosa, Universal Studios','17:00:00',5,12,57,'2026-10-30 02:52:12'),(214,'Lolas Cafe','17:00:00',7,9,71,'2026-10-30 02:52:12'),(215,'Gardens By The Bay flower dome','17:10:00',15,14,72,'2026-10-30 02:52:12'),(216,'Serangoon Library','17:10:00',16,12,92,'2026-10-30 02:52:12'),(217,'Sentosa, Universal Studios','17:10:00',15,9,63,'2026-10-30 02:52:12'),(218,'Lolas Cafe','17:10:00',6,13,64,'2026-10-30 02:52:12'),(219,'Gardens By The Bay flower dome','17:20:00',19,17,74,'2026-10-30 02:52:12'),(220,'Serangoon Library','17:20:00',12,16,88,'2026-10-30 02:52:12'),(221,'Sentosa, Universal Studios','17:20:00',13,9,67,'2026-10-30 02:52:12'),(222,'Lolas Cafe','17:20:00',14,13,65,'2026-10-30 02:52:12'),(223,'Gardens By The Bay flower dome','17:30:00',18,12,80,'2026-10-30 02:52:12'),(224,'Serangoon Library','17:30:00',12,13,87,'2026-10-30 02:52:12'),(225,'Sentosa, Universal Studios','17:30:00',9,18,58,'2026-10-30 02:52:12'),(226,'Lolas Cafe','17:30:00',9,13,61,'2026-10-30 02:52:12'),(227,'Gardens By The Bay flower dome','17:40:00',9,20,69,'2026-10-30 02:52:12'),(228,'Serangoon Library','17:40:00',19,12,94,'2026-10-30 02:52:12'),(229,'Sentosa, Universal Studios','17:40:00',8,10,56,'2026-10-30 02:52:12'),(230,'Lolas Cafe','17:40:00',10,13,58,'2026-10-30 02:52:12'),(231,'Gardens By The Bay flower dome','17:50:00',18,8,79,'2026-10-30 02:52:12'),(232,'Serangoon Library','17:50:00',7,17,84,'2026-10-30 02:52:12'),(233,'Sentosa, Universal Studios','17:50:00',10,9,57,'2026-10-30 02:52:12'),(234,'Lolas Cafe','17:50:00',17,14,61,'2026-10-30 02:52:12'),(235,'Gardens By The Bay flower dome','18:00:00',15,13,81,'2026-10-30 02:52:12'),(236,'Serangoon Library','18:00:00',13,15,82,'2026-10-30 02:52:12'),(237,'Sentosa, Universal Studios','18:00:00',7,11,53,'2026-10-30 02:52:12'),(238,'Lolas Cafe','18:00:00',10,11,60,'2026-10-30 02:52:12'),(239,'Gardens By The Bay flower dome','18:10:00',7,22,66,'2026-10-30 02:52:12'),(240,'Serangoon Library','18:10:00',8,13,77,'2026-10-30 02:52:12'),(241,'Sentosa, Universal Studios','18:10:00',11,10,54,'2026-10-30 02:52:12'),(242,'Lolas Cafe','18:10:00',17,10,67,'2026-10-30 02:52:12'),(243,'Gardens By The Bay flower dome','18:20:00',17,17,66,'2026-10-30 02:52:12'),(244,'Serangoon Library','18:20:00',11,21,67,'2026-10-30 02:52:12'),(245,'Sentosa, Universal Studios','18:20:00',8,8,54,'2026-10-30 02:52:12'),(246,'Lolas Cafe','18:20:00',14,12,69,'2026-10-30 02:52:12'),(247,'Gardens By The Bay flower dome','18:30:00',15,16,65,'2026-10-30 02:52:12'),(248,'Serangoon Library','18:30:00',7,14,60,'2026-10-30 02:52:12'),(249,'Sentosa, Universal Studios','18:30:00',16,9,61,'2026-10-30 02:52:12'),(250,'Lolas Cafe','18:30:00',14,8,75,'2026-10-30 02:52:12'),(251,'Gardens By The Bay flower dome','18:40:00',14,7,72,'2026-10-30 02:52:12'),(252,'Serangoon Library','18:40:00',9,15,54,'2026-10-30 02:52:12'),(253,'Sentosa, Universal Studios','18:40:00',12,9,64,'2026-10-30 02:52:12'),(254,'Lolas Cafe','18:40:00',19,12,82,'2026-10-30 02:52:12'),(255,'Gardens By The Bay flower dome','18:50:00',5,15,62,'2026-10-30 02:52:12'),(256,'Serangoon Library','18:50:00',12,9,57,'2026-10-30 02:52:12'),(257,'Sentosa, Universal Studios','18:50:00',17,13,68,'2026-10-30 02:52:12'),(258,'Lolas Cafe','18:50:00',18,19,81,'2026-10-30 02:52:12'),(259,'Gardens By The Bay flower dome','19:00:00',20,15,67,'2026-10-30 02:52:12'),(260,'Serangoon Library','19:00:00',18,13,62,'2026-10-30 02:52:12'),(261,'Sentosa, Universal Studios','19:00:00',8,13,63,'2026-10-30 02:52:12'),(262,'Lolas Cafe','19:00:00',16,19,78,'2026-10-30 02:52:12'),(263,'Gardens By The Bay flower dome','19:10:00',10,7,70,'2026-10-30 02:52:12'),(264,'Serangoon Library','19:10:00',20,9,73,'2026-10-30 02:52:12'),(265,'Sentosa, Universal Studios','19:10:00',16,14,65,'2026-10-30 02:52:12'),(266,'Lolas Cafe','19:10:00',16,17,77,'2026-10-30 02:52:12'),(267,'Gardens By The Bay flower dome','19:20:00',7,14,63,'2026-10-30 02:52:12'),(268,'Serangoon Library','19:20:00',7,18,62,'2026-10-30 02:52:12'),(269,'Sentosa, Universal Studios','19:20:00',8,15,58,'2026-10-30 02:52:12'),(270,'Lolas Cafe','19:20:00',19,21,75,'2026-10-30 02:52:12'),(271,'Gardens By The Bay flower dome','19:30:00',6,9,60,'2026-10-30 02:52:12'),(272,'Serangoon Library','19:30:00',5,12,55,'2026-10-30 02:52:12'),(273,'Sentosa, Universal Studios','19:30:00',10,11,57,'2026-10-30 02:52:12'),(274,'Lolas Cafe','19:30:00',20,14,81,'2026-10-30 02:52:12'),(275,'Gardens By The Bay flower dome','19:40:00',16,9,67,'2026-10-30 02:52:12'),(276,'Serangoon Library','19:40:00',19,8,66,'2026-10-30 02:52:12'),(277,'Sentosa, Universal Studios','19:40:00',12,6,63,'2026-10-30 02:52:12'),(278,'Lolas Cafe','19:40:00',18,13,86,'2026-10-30 02:52:12'),(279,'Gardens By The Bay flower dome','19:50:00',6,18,55,'2026-10-30 02:52:12'),(280,'Serangoon Library','19:50:00',6,14,58,'2026-10-30 02:52:12'),(281,'Sentosa, Universal Studios','19:50:00',13,16,60,'2026-10-30 02:52:12'),(282,'Lolas Cafe','19:50:00',7,16,77,'2026-10-30 02:52:12'),(283,'Gardens By The Bay flower dome','20:00:00',20,13,62,'2026-10-30 02:52:12'),(284,'Serangoon Library','20:00:00',5,8,55,'2026-10-30 02:52:12'),(285,'Sentosa, Universal Studios','20:00:00',15,17,58,'2026-10-30 02:52:12'),(286,'Lolas Cafe','20:00:00',20,17,80,'2026-10-30 02:52:12'),(287,'Gardens By The Bay flower dome','10:50:00',15,21,56,'2026-10-30 02:52:20'),(288,'Serangoon Library','10:50:00',5,2,58,'2026-10-30 02:52:20'),(289,'Sentosa, Universal Studios','10:50:00',12,20,50,'2026-10-30 02:52:20'),(290,'Lolas Cafe','10:50:00',13,7,86,'2026-10-30 02:52:20');
/*!40000 ALTER TABLE `location_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations_registry`
--

DROP TABLE IF EXISTS `locations_registry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations_registry` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `location_name` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`location_id`),
  UNIQUE KEY `location_name` (`location_name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations_registry`
--

LOCK TABLES `locations_registry` WRITE;
/*!40000 ALTER TABLE `locations_registry` DISABLE KEYS */;
INSERT INTO `locations_registry` VALUES (9,'Gardens By The Bay flower dome',1,'2026-10-30 02:37:00'),(10,'Serangoon Library',1,'2026-10-30 02:37:00'),(11,'Sentosa, Universal Studios',1,'2026-10-30 02:37:00'),(12,'Lolas Cafe',1,'2026-10-30 02:37:00');
/*!40000 ALTER TABLE `locations_registry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'occupancy_list'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `evt_populate_10min_occupancy` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `evt_populate_10min_occupancy` ON SCHEDULE EVERY 10 MINUTE STARTS '2026-10-30 10:42:20' ON COMPLETION PRESERVE ENABLE DO BEGIN
    CALL generate_multi_location_occupancy();
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'occupancy_list'
--
/*!50003 DROP PROCEDURE IF EXISTS `backfill_entire_day_occupancy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `backfill_entire_day_occupancy`()
BEGIN
    DECLARE loop_time TIME DEFAULT '08:00:00';
    DECLARE done INT DEFAULT FALSE;
    DECLARE curr_location VARCHAR(100);
    DECLARE prev_occupancy INT;
    DECLARE rand_entering INT;
    DECLARE rand_leaving INT;
    DECLARE final_occupancy INT;

    time_loop: LOOP
        IF loop_time > '20:00:00' THEN
            LEAVE time_loop;
        END IF;

        BLOCK_CURSOR: BEGIN
            DECLARE loc_cursor CURSOR FOR 
                SELECT location_name FROM locations_registry WHERE is_active = TRUE;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

            SET done = FALSE;
            OPEN loc_cursor;

            venue_loop: LOOP
                FETCH loc_cursor INTO curr_location;
                IF done THEN
                    LEAVE venue_loop;
                END IF;

                SET prev_occupancy = 0;

                SELECT number_now INTO prev_occupancy
                FROM location_information
                WHERE location_name = curr_location
                ORDER BY id DESC LIMIT 1;

                IF prev_occupancy IS NULL THEN
                    SET prev_occupancy = 0;
                END IF;

                
                SET rand_entering = FLOOR(5 + (RAND() * 16));

                
                SET rand_leaving = FLOOR((prev_occupancy * (0.10 + (RAND() * 0.15))) + (RAND() * 4));

                IF rand_leaving > (prev_occupancy + rand_entering) THEN
                    SET rand_leaving = prev_occupancy + rand_entering;
                END IF;

                SET final_occupancy = prev_occupancy + rand_entering - rand_leaving;

                INSERT INTO location_information (
                    location_name,
                    recorded_time,
                    number_entering,
                    number_leaving,
                    number_now
                ) VALUES (
                    curr_location,
                    loop_time,
                    rand_entering,
                    rand_leaving,
                    final_occupancy
                );
            END LOOP venue_loop;

            CLOSE loc_cursor;
        END BLOCK_CURSOR;

        SET loop_time = ADDTIME(loop_time, '00:10:00');
    END LOOP time_loop;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `generate_multi_location_occupancy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_multi_location_occupancy`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE curr_location VARCHAR(100);
    DECLARE current_hour INT;
    DECLARE current_minute INT;
    DECLARE aligned_time TIME;
    
    DECLARE prev_occupancy INT;
    DECLARE rand_entering INT;
    DECLARE rand_leaving INT;
    DECLARE final_occupancy INT;

    DECLARE loc_cursor CURSOR FOR 
        SELECT location_name 
        FROM locations_registry 
        WHERE is_active = TRUE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET current_hour = HOUR(CURRENT_TIME());
    SET current_minute = (MINUTE(CURRENT_TIME()) DIV 10) * 10;
    SET aligned_time = MAKETIME(current_hour, current_minute, 0);

    IF aligned_time >= '08:00:00' AND aligned_time <= '20:00:00' THEN
        OPEN loc_cursor;

        location_loop: LOOP
            FETCH loc_cursor INTO curr_location;
            IF done THEN
                LEAVE location_loop;
            END IF;

            SET prev_occupancy = 0;

            SELECT number_now 
            INTO prev_occupancy
            FROM location_information
            WHERE location_name = curr_location
            ORDER BY id DESC
            LIMIT 1;

            IF prev_occupancy IS NULL THEN
                SET prev_occupancy = 0;
            END IF;

            
            SET rand_entering = FLOOR(1 + (RAND() * 20));

            
            SET rand_leaving = FLOOR(1 + (RAND() * 30));
            IF rand_leaving > (prev_occupancy + rand_entering) THEN
                SET rand_leaving = prev_occupancy + rand_entering;
            END IF;

            SET final_occupancy = prev_occupancy + rand_entering - rand_leaving;

            INSERT INTO location_information (
                location_name,
                recorded_time,
                number_entering,
                number_leaving,
                number_now
            ) VALUES (
                curr_location,
                aligned_time,
                rand_entering,
                rand_leaving,
                final_occupancy
            );

        END LOOP location_loop;

        CLOSE loc_cursor;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-30 10:53:06
