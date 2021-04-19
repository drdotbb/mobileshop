-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: localhost    Database: mobilerepair
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customerID` int NOT NULL,
  `firstName` varchar(45) DEFAULT NULL,
  `lastName` varchar(45) DEFAULT NULL,
  `address` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `staffID` int DEFAULT NULL,
  `feedback` varchar(45) DEFAULT NULL,
  `emailReferenceNumber` varchar(45) DEFAULT NULL,
  `returnDate` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`customerID`),
  KEY `staffID_idx` (`staffID`),
  CONSTRAINT `Customer_staffID` FOREIGN KEY (`staffID`) REFERENCES `staff` (`staffID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (100,'brad','bak','203 north rd','brad@gmail.com','778-222-8497',1,'positive','100','2021-01-25'),(101,'max','b','7448 broadway','maxb@gmail.com','778-254-1147',2,'negative','101','2021-01-27'),(102,'stephen','curry','201 inglewood','steph30@gmail.com','778-254-9632',1,NULL,'102','2021-01-02'),(103,'james','harden','987 nets av','jamesflop@gmail.com','778-552-4785',3,'positive','103','2021-01-05'),(104,'lebron','james','225 hollywood blvd','lebron23@gmail.com','604-554-5521',1,'positive','105','2021-02-05');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device`
--

DROP TABLE IF EXISTS `device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `device` (
  `imeiNumber` varchar(20) NOT NULL,
  `os` varchar(45) DEFAULT NULL,
  `manufacturer` varchar(45) DEFAULT NULL,
  `warrantyStatus` varchar(45) DEFAULT NULL,
  `model` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`imeiNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device`
--

LOCK TABLES `device` WRITE;
/*!40000 ALTER TABLE `device` DISABLE KEYS */;
INSERT INTO `device` VALUES ('145236521458798','mac','apple','expired','macbook pro 2020'),('154856954785214','windows','asus','expired','rog gv15'),('156895478512456','android','samsung','valid','s8'),('158796548524695','android ','sony','valid','z4'),('178546953256485','mac','apple','expired','pro 12');
/*!40000 ALTER TABLE `device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diagnoses`
--

DROP TABLE IF EXISTS `diagnoses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnoses` (
  `staffID` int NOT NULL,
  `issueType` varchar(45) NOT NULL,
  PRIMARY KEY (`staffID`,`issueType`),
  KEY `Diagnoses_issueType_idx` (`issueType`),
  CONSTRAINT `Diagnoses_issueType` FOREIGN KEY (`issueType`) REFERENCES `issue` (`issueType`),
  CONSTRAINT `Diagnoses_staffID` FOREIGN KEY (`staffID`) REFERENCES `staff` (`staffID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnoses`
--

LOCK TABLES `diagnoses` WRITE;
/*!40000 ALTER TABLE `diagnoses` DISABLE KEYS */;
/*!40000 ALTER TABLE `diagnoses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fixes`
--

DROP TABLE IF EXISTS `fixes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fixes` (
  `imeiNumber` varchar(45) NOT NULL,
  `staffID` int NOT NULL,
  `staffName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`imeiNumber`,`staffID`),
  KEY `Fixes_staffID_idx` (`staffID`),
  CONSTRAINT `Fixes_imeiNumber` FOREIGN KEY (`imeiNumber`) REFERENCES `device` (`imeiNumber`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Fixes_staffID` FOREIGN KEY (`staffID`) REFERENCES `staff` (`staffID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fixes`
--

LOCK TABLES `fixes` WRITE;
/*!40000 ALTER TABLE `fixes` DISABLE KEYS */;
/*!40000 ALTER TABLE `fixes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gives`
--

DROP TABLE IF EXISTS `gives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gives` (
  `customerID` int NOT NULL,
  `imeiNumber` varchar(45) NOT NULL,
  `dropDate` varchar(45) DEFAULT NULL,
  `emailTrackingUrl` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`customerID`,`imeiNumber`),
  KEY `Gives_imeiNumber_idx` (`imeiNumber`),
  CONSTRAINT `Gives_customerID` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`),
  CONSTRAINT `Gives_imeiNumber` FOREIGN KEY (`imeiNumber`) REFERENCES `device` (`imeiNumber`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gives`
--

LOCK TABLES `gives` WRITE;
/*!40000 ALTER TABLE `gives` DISABLE KEYS */;
INSERT INTO `gives` VALUES (100,'156895478512456','2021-01-23','shop.com/100'),(101,'145236521458798','2021-01-26','shop.com/101'),(102,'154856954785214','2021-01-01','shop.com/102'),(103,'158796548524695','2021-01-04','shop.com/103'),(104,'178546953256485','2021-02-04','shop.com/104');
/*!40000 ALTER TABLE `gives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `productID` int NOT NULL,
  `productQuantity` varchar(45) DEFAULT NULL,
  `productType` varchar(45) DEFAULT NULL,
  `productName` varchar(45) DEFAULT NULL,
  `productPrice` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`productID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1000,'100','SAMSUNG S10 SCREEN PROTECTOR','T-MOR','3'),(1001,'25','SAMSUNG S10 REGULAR CASE','MyBat','5'),(1002,'10','SAMSUNG S10 BACK GLASS(BLACK)','SAMSUNG','10'),(1003,'5','SAMSUNG S10 BACK CAMERA','SAMSUNG','70'),(1004,'3','SAMSUNG S10 LCD ORIGINAL','SAMSUNG LCD','325');
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue`
--

DROP TABLE IF EXISTS `issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `issue` (
  `imeiNumber` varchar(45) NOT NULL,
  `issueType` varchar(45) NOT NULL,
  `issueDescription` varchar(45) DEFAULT NULL,
  `cost` varchar(45) DEFAULT NULL,
  `fixable` varchar(45) DEFAULT NULL,
  `estimatedFixTime` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`imeiNumber`,`issueType`),
  KEY `Diagnoses_issueType_idx` (`issueType`),
  CONSTRAINT `Issue_imeiNumber` FOREIGN KEY (`imeiNumber`) REFERENCES `device` (`imeiNumber`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue`
--

LOCK TABLES `issue` WRITE;
/*!40000 ALTER TABLE `issue` DISABLE KEYS */;
INSERT INTO `issue` VALUES ('145236521458798','Hardware','Faulty motherboard','','no',NULL),('156895478512456','Hardware','Broken LCD','200','yes','2 Days'),('178546953256485','Software','Jail break','50','yes','1 Hour');
/*!40000 ALTER TABLE `issue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laptop`
--

DROP TABLE IF EXISTS `laptop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laptop` (
  `imeiNumber` varchar(45) NOT NULL,
  KEY `Laptop_imeiNumber_idx` (`imeiNumber`),
  CONSTRAINT `Laptop_imeiNumber` FOREIGN KEY (`imeiNumber`) REFERENCES `device` (`imeiNumber`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laptop`
--

LOCK TABLES `laptop` WRITE;
/*!40000 ALTER TABLE `laptop` DISABLE KEYS */;
/*!40000 ALTER TABLE `laptop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smartphone`
--

DROP TABLE IF EXISTS `smartphone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `smartphone` (
  `imeiNumber` varchar(45) NOT NULL,
  KEY `Smartphone_imeiNumber_idx` (`imeiNumber`),
  CONSTRAINT `Smartphone_imeiNumber` FOREIGN KEY (`imeiNumber`) REFERENCES `device` (`imeiNumber`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smartphone`
--

LOCK TABLES `smartphone` WRITE;
/*!40000 ALTER TABLE `smartphone` DISABLE KEYS */;
/*!40000 ALTER TABLE `smartphone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `staffID` int NOT NULL,
  `firstName` varchar(45) DEFAULT NULL,
  `lastName` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`staffID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'moin','p','778-885-4452','moinp@gmail.com'),(2,'alex','m','778-548-5124','alexm@gmail.com'),(3,'john','doe','604-554-8745','johnd@gmail.com');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tablet`
--

DROP TABLE IF EXISTS `tablet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tablet` (
  `imeiNumber` varchar(45) NOT NULL,
  KEY `Tablet_imeiNumber_idx` (`imeiNumber`),
  CONSTRAINT `Tablet_imeiNumber` FOREIGN KEY (`imeiNumber`) REFERENCES `device` (`imeiNumber`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tablet`
--

LOCK TABLES `tablet` WRITE;
/*!40000 ALTER TABLE `tablet` DISABLE KEYS */;
/*!40000 ALTER TABLE `tablet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `use`
--

DROP TABLE IF EXISTS `use`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `use` (
  `productID` int NOT NULL,
  `staffID` int NOT NULL,
  `productName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`productID`,`staffID`),
  KEY `Use_staffID_idx` (`staffID`),
  CONSTRAINT `Use_productID` FOREIGN KEY (`productID`) REFERENCES `inventory` (`productID`),
  CONSTRAINT `Use_staffID` FOREIGN KEY (`staffID`) REFERENCES `staff` (`staffID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `use`
--

LOCK TABLES `use` WRITE;
/*!40000 ALTER TABLE `use` DISABLE KEYS */;
INSERT INTO `use` VALUES (1000,1,'T-MOR');
/*!40000 ALTER TABLE `use` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-19 17:57:12
