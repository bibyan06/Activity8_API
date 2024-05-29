-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 29, 2024 at 07:00 PM
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
-- Database: `emp_hr`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `userid` int(11) NOT NULL,
  `username` varchar(45) NOT NULL,
  `pass` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `dname` int(11) NOT NULL,
  `totalsalary` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`userid`, `username`, `pass`, `email`, `dname`, `totalsalary`) VALUES
(6, 'vivian', 'biyan', 'vivianvivo@gmail.com', 1, 1),
(7, 'sandra ', 'sands', 'sandravivo@gmail.com', 3, 3),
(8, 'shiela', 'shi', 'shielavivo@gmail.com', 5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `dnumber` int(11) NOT NULL,
  `dname` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`dnumber`, `dname`) VALUES
(1, 'TechSupport'),
(3, 'Research'),
(5, 'Payroll');

-- --------------------------------------------------------

--
-- Table structure for table `deptsal`
--

CREATE TABLE `deptsal` (
  `dnumber` int(11) NOT NULL DEFAULT 0,
  `totalsalary` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `deptsal`
--

INSERT INTO `deptsal` (`dnumber`, `totalsalary`) VALUES
(1, 104000),
(3, 228800),
(5, 185900);

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `superid` int(11) DEFAULT NULL,
  `salary` double DEFAULT NULL,
  `bdate` date DEFAULT NULL,
  `dno` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`id`, `name`, `superid`, `salary`, `bdate`, `dno`) VALUES
(9, 'john', 3, 185900, '1982-06-26', 5),
(10, 'mary', 3, 71500, '1999-01-01', 3),
(11, 'bob', NULL, 114400, '2000-02-14', 3),
(12, 'tom', 1, 71500, '2001-09-23', 1),
(13, 'bill', NULL, NULL, '2005-08-08', 5),
(14, 'mike', NULL, 42900, '1990-06-26', 3),
(15, 'john', NULL, 16500, NULL, 1),
(16, 'mark', NULL, 11000, NULL, 1),
(17, 'kim', NULL, 10000, NULL, 1),
(18, 'jen', NULL, 15000, NULL, NULL);

--
-- Triggers `employee`
--
DELIMITER $$
CREATE TRIGGER `employee_BEFORE_INSERT` BEFORE INSERT ON `employee` FOR EACH ROW BEGIN
   DECLARE msg VARCHAR(255);
   IF NEW.dno IS NULL THEN
       SET msg = CONCAT('You cannot insert ', NEW.name, ' without department number.');
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
   END IF;
END
$$
DELIMITER ;

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`dnumber`);

--
-- Indexes for table `deptsal`
--
ALTER TABLE `deptsal`
  ADD PRIMARY KEY (`dnumber`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`id`),
  ADD KEY `myfk_idx` (`dno`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `userid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `dnumber` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`dname`) REFERENCES `department` (`dnumber`),
  ADD CONSTRAINT `accounts_ibfk_2` FOREIGN KEY (`totalsalary`) REFERENCES `deptsal` (`dnumber`);

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `myfk` FOREIGN KEY (`dno`) REFERENCES `department` (`dnumber`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
