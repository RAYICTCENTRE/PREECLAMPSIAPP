-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 21, 2026 at 10:42 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `invoicing`
--
CREATE DATABASE IF NOT EXISTS `invoicing` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `invoicing`;

-- --------------------------------------------------------

--
-- Table structure for table `company_settings`
--

CREATE TABLE `company_settings` (
  `id` int(11) NOT NULL,
  `company_name` varchar(200) NOT NULL DEFAULT 'RESTORE A YOUTH (RAY) LTD',
  `company_tagline` varchar(500) DEFAULT 'Computer Training | Secretarial Services | Office Supplies',
  `company_services` text DEFAULT NULL,
  `company_address` text DEFAULT NULL,
  `company_tin` varchar(50) DEFAULT NULL,
  `company_phone` varchar(20) DEFAULT NULL,
  `company_email` varchar(100) DEFAULT NULL,
  `company_logo` varchar(255) DEFAULT NULL,
  `invoice_footer` text DEFAULT NULL,
  `terms_conditions` text DEFAULT NULL,
  `default_tax_rate` decimal(5,2) DEFAULT 0.00,
  `currency_symbol` varchar(10) DEFAULT 'UGX',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Company settings and branding';

--
-- Dumping data for table `company_settings`
--

INSERT INTO `company_settings` (`id`, `company_name`, `company_tagline`, `company_services`, `company_address`, `company_tin`, `company_phone`, `company_email`, `company_logo`, `invoice_footer`, `terms_conditions`, `default_tax_rate`, `currency_symbol`, `updated_at`) VALUES
(1, 'RESTORE A YOUTH (RAY) LTD', 'Computer Training | Secretarial Services | Office Supplies', 'Online Services | Consultancy | Merchandising', 'Avaj House, Opposite Post Bank, Bweyale Town', '1015619642', '0785413934', 'rayuganda@gmail.com', NULL, NULL, NULL, 0.00, 'UGX', '2026-06-11 08:32:54');

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `id` int(11) NOT NULL,
  `type` enum('invoice','receipt','proforma','delivery') NOT NULL COMMENT 'Document type',
  `doc_no` varchar(50) NOT NULL COMMENT 'Document number (unique)',
  `client_name` varchar(150) NOT NULL COMMENT 'Client/Company name',
  `client_address` text DEFAULT NULL COMMENT 'Client physical address',
  `client_email` varchar(100) DEFAULT NULL COMMENT 'Client email address',
  `client_phone` varchar(20) DEFAULT NULL COMMENT 'Client phone number',
  `tax_rate` decimal(5,2) DEFAULT 0.00 COMMENT 'Tax rate percentage (0-100)',
  `notes` text DEFAULT NULL COMMENT 'Additional notes or terms',
  `status` enum('draft','sent','paid','cancelled') DEFAULT 'sent' COMMENT 'Document status',
  `created_by` int(11) DEFAULT NULL COMMENT 'User ID who created document',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation timestamp',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Last update timestamp'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Main documents table (invoices, receipts, proformas, delivery notes)';

--
-- Dumping data for table `documents`
--

INSERT INTO `documents` (`id`, `type`, `doc_no`, `client_name`, `client_address`, `client_email`, `client_phone`, `tax_rate`, `notes`, `status`, `created_by`, `created_at`, `updated_at`) VALUES
(8, 'receipt', 'RCT-2026-0003', 'BWEYALE PUBLIC PRIMARY SCHOOL', 'BWEYALE TOWN COUNCIL, KICWAHBUGINGO', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-11 10:30:23', '2026-06-11 10:30:23'),
(9, 'invoice', 'INV-2026-0001', 'ANGELO NEGRI EDUCATION CENTRE NURSERY AND PRIMARY SCHOOLS', 'BWEYALE, KIRYANDONGO', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-12 10:00:54', '2026-06-12 10:00:54'),
(14, 'delivery', 'DN-2026-0001', 'IGNITEHER MEDIA NETWORK', 'P.O BOX 541144 Bweyale, Kiryandongo (U) Email: ignitehermedianet@gmail.com', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-12 15:22:21', '2026-06-12 15:22:21'),
(15, 'invoice', 'INV-2026-0002', 'IGNITEHER MEDIA NETWORK', 'P.O BOX 541144 Bweyale, Kiryandongo (U) Email: ignitehermedianet@gmail.com', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-12 15:36:10', '2026-06-12 15:36:10'),
(16, 'receipt', 'RCT-2026-0004', 'IGNITEHER MEDIA NETWORK', 'P.O BOX 541144 Bweyale, Kiryandongo (U) Email: ignitehermedianet@gmail.com', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-12 15:37:03', '2026-06-12 15:37:03'),
(17, 'proforma', 'PINV-2026-0001', 'IGNITEHER MEDIA NETWORK', 'P.O BOX 541144 Bweyale, Kiryandongo (U) Email: ignitehermedianet@gmail.com', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-12 15:37:30', '2026-06-12 15:37:30'),
(18, 'receipt', 'RCT-2026-0005', 'FRIENDS UNITY FOUNDATION', 'BWEYALE, KIRYANDONGO', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-16 10:37:29', '2026-06-16 10:37:29'),
(19, 'receipt', 'RCT-2026-0006', 'BWEYALE PUBLIC PRIMARY SCHOOL', 'BWEYALE TOWN, KICWAHBUGINGO', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-16 15:03:24', '2026-06-16 15:03:24'),
(20, 'receipt', 'RCT-2026-0007', 'BIDONG PRIMARY SCHOOL', 'P.O.BOX 02, BWEYALE, KIRYANDONGO DISTRICT', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-17 12:59:53', '2026-06-17 12:59:53'),
(21, 'receipt', 'RCT-2026-0008', 'ANGELO NEGRI EDUCATION CENTRE NURSERY AND PRIMARY SCHOOLS', 'BWEYALE, KIRYANDONGO', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-17 13:02:21', '2026-06-17 13:02:21'),
(22, 'proforma', 'PINV-2026-0002', 'WINDLE INTERNATIONAL UGANDA', 'BWEYALE, KIRYANDONGO', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-18 07:39:09', '2026-06-18 07:39:09'),
(23, 'receipt', 'RCT-2026-0009', 'KIGUMBA TOWN COMMUNITY SEE SECONDARY SCHOOL STAFF SAVINGS AND CREDIT COOPERATIVE SOCIETY LIMITED', 'KIGUMBA TOWN COUNCIL, KIRYANDONGO DISTRICT', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-18 15:05:19', '2026-06-18 15:05:19'),
(24, 'proforma', 'PINV-2026-0003', 'WINDLE INTERNATIONAL UGANDA', 'KIRYANDONGO REFUGEE SETTLEMENT', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-19 06:26:05', '2026-06-19 06:26:05'),
(25, 'invoice', 'INV-2026-0003', 'WINDLE INTERNATIONAL UGANDA', 'KIRYANDONGO REFUGEE SETTLEMENT', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-19 06:28:11', '2026-06-19 06:28:11'),
(26, 'delivery', 'DN-2026-0002', 'WINDLE INTERNATIONAL UGANDA', 'KIRYANDONGO REFUGEE SETTLEMENT', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-19 06:30:26', '2026-06-19 06:30:26'),
(27, 'receipt', 'RCT-2026-0010', 'WINDLE INTERNATIONAL UGANDA', 'KIRYANDONGO REFUGEE SETTLEMENT', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-19 06:33:15', '2026-06-19 06:33:15'),
(28, 'proforma', 'PINV-2026-0004', 'SOVEREIGN HANDS INTERNATIONAL (SHI)', 'P.O.BOX 114, KIRYANDONGO (U)', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-19 07:34:34', '2026-06-19 07:34:34'),
(29, 'receipt', 'RCT-2026-0011', 'ROFO LEGEND TOURS', 'KAMPALA', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-19 07:59:02', '2026-06-19 07:59:02'),
(30, 'receipt', 'RCT-2026-0012', 'MUSEMA JOYCE', 'ST. BAKHITA PRIMARY SCHOOL', NULL, NULL, 0.00, NULL, 'sent', NULL, '2026-06-19 12:55:24', '2026-06-19 12:55:24');

--
-- Triggers `documents`
--
DELIMITER $$
CREATE TRIGGER `validate_tax_rate_before_insert` BEFORE INSERT ON `documents` FOR EACH ROW BEGIN
    IF NEW.tax_rate < 0 OR NEW.tax_rate > 100 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Tax rate must be between 0 and 100';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validate_tax_rate_before_update` BEFORE UPDATE ON `documents` FOR EACH ROW BEGIN
    IF NEW.tax_rate < 0 OR NEW.tax_rate > 100 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Tax rate must be between 0 and 100';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `document_summary`
-- (See below for the actual view)
--
CREATE TABLE `document_summary` (
`id` int(11)
,`type` enum('invoice','receipt','proforma','delivery')
,`doc_no` varchar(50)
,`client_name` varchar(150)
,`created_at` timestamp
,`status` enum('draft','sent','paid','cancelled')
,`item_count` bigint(21)
,`subtotal` decimal(32,2)
,`tax_amount` decimal(41,8)
,`grand_total` decimal(42,8)
);

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `doc_id` int(11) NOT NULL COMMENT 'Reference to documents table',
  `description` text NOT NULL COMMENT 'Item description or particulars',
  `qty` int(11) NOT NULL DEFAULT 1 COMMENT 'Quantity ordered',
  `price` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Unit price (for non-delivery docs)',
  `delivered_qty` int(11) DEFAULT NULL COMMENT 'Quantity delivered (for delivery notes)',
  `condition_status` enum('new','good','fair','poor','damaged') DEFAULT NULL COMMENT 'Item condition (for delivery notes)',
  `discount` decimal(5,2) DEFAULT 0.00 COMMENT 'Discount percentage for this item',
  `total` decimal(10,2) GENERATED ALWAYS AS (round(`qty` * `price` - `qty` * `price` * `discount` / 100,2)) STORED COMMENT 'Calculated total after discount',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Line items for each document';

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `doc_id`, `description`, `qty`, `price`, `delivered_qty`, `condition_status`, `discount`, `created_at`) VALUES
(11, 8, 'Printing Documents', 132, 200.00, 0, '', 0.00, '2026-06-11 10:30:23'),
(12, 9, 'Passport Photo taking and printing', 17, 2000.00, 0, '', 0.00, '2026-06-12 10:00:54'),
(13, 9, 'Plastic ID Printing', 2, 8000.00, 0, '', 0.00, '2026-06-12 10:00:54'),
(23, 14, 'Supply of Sports Jerseys and Branding Services', 8, 0.00, 8, 'good', 0.00, '2026-06-12 15:22:21'),
(24, 15, 'Supply of Sports Jerseys and Branding Services', 8, 35000.00, 0, '', 0.00, '2026-06-12 15:36:10'),
(25, 16, 'Supply of Sports Jerseys and Branding Services', 8, 35000.00, 0, '', 0.00, '2026-06-12 15:37:03'),
(26, 17, 'Supply of Sports Jerseys and Branding Services', 8, 35000.00, 0, '', 0.00, '2026-06-12 15:37:30'),
(27, 18, 'TIN PROCESSING', 1, 35000.00, 0, '', 0.00, '2026-06-16 10:37:29'),
(28, 18, 'SEALING DOCUENTS', 2, 2000.00, 0, '', 0.00, '2026-06-16 10:37:29'),
(29, 18, 'ENVELOPE', 2, 500.00, 0, '', 0.00, '2026-06-16 10:37:29'),
(30, 19, 'RECEIPT BOOK (BIG VOLUME)', 1, 35000.00, 0, '', 0.00, '2026-06-16 15:03:24'),
(31, 20, 'RECEIPT BOOK (BIG VOLUME)', 1, 35000.00, 0, '', 0.00, '2026-06-17 12:59:53'),
(32, 21, 'Passport Photo taking and printing', 17, 2000.00, 0, '', 0.00, '2026-06-17 13:02:21'),
(33, 21, 'Plastic ID Printing', 2, 8000.00, 0, '', 0.00, '2026-06-17 13:02:21'),
(34, 22, 'School emergency playbook printing', 14, 8000.00, 0, '', 0.00, '2026-06-18 07:39:09'),
(35, 22, 'Emergency Incident Log Book', 10, 32400.00, 0, '', 0.00, '2026-06-18 07:39:09'),
(36, 22, 'Phone Tree', 17, 800.00, 0, '', 0.00, '2026-06-18 07:39:09'),
(37, 22, 'Binding', 24, 3000.00, 0, '', 0.00, '2026-06-18 07:39:09'),
(38, 23, 'TIN PROCESSING', 1, 35000.00, 0, '', 0.00, '2026-06-18 15:05:19'),
(39, 24, 'School emergency playbook printing', 14, 6000.00, 0, '', 0.00, '2026-06-19 06:26:06'),
(40, 24, 'Emergency Incident Log Book', 10, 24300.00, 0, '', 0.00, '2026-06-19 06:26:06'),
(41, 24, 'Phone Tree', 17, 800.00, 0, '', 0.00, '2026-06-19 06:26:06'),
(42, 24, 'Binding', 24, 3000.00, 0, '', 0.00, '2026-06-19 06:26:06'),
(43, 25, 'School emergency playbook printing', 14, 6000.00, 0, '', 0.00, '2026-06-19 06:28:11'),
(44, 25, 'Emergency Incident Log Book', 10, 24300.00, 0, '', 0.00, '2026-06-19 06:28:11'),
(45, 25, 'Phone Tree', 17, 800.00, 0, '', 0.00, '2026-06-19 06:28:11'),
(46, 25, 'Binding', 24, 3000.00, 0, '', 0.00, '2026-06-19 06:28:11'),
(47, 26, 'School emergency playbook printing(BOOKLET)', 14, 0.00, 14, 'good', 0.00, '2026-06-19 06:30:27'),
(48, 26, 'Emergency Incident Log Book', 10, 0.00, 10, 'good', 0.00, '2026-06-19 06:30:27'),
(49, 26, 'Phone Tree', 17, 0.00, 17, 'good', 0.00, '2026-06-19 06:30:27'),
(50, 27, 'School emergency playbook printing', 14, 6000.00, 0, '', 0.00, '2026-06-19 06:33:15'),
(51, 27, 'Emergency Incident Log Book', 10, 24300.00, 0, '', 0.00, '2026-06-19 06:33:15'),
(52, 27, 'Phone Tree', 17, 800.00, 0, '', 0.00, '2026-06-19 06:33:15'),
(53, 27, 'Binding', 24, 3000.00, 0, '', 0.00, '2026-06-19 06:33:15'),
(54, 28, 'PEN (BOX)', 1, 22000.00, 0, '', 0.00, '2026-06-19 07:34:34'),
(55, 28, 'Long Rulers (Dozen)', 3, 18000.00, 0, '', 0.00, '2026-06-19 07:34:34'),
(56, 28, 'Tear Drops', 2, 295000.00, 0, '', 0.00, '2026-06-19 07:34:34'),
(57, 28, 'Vistors Book', 2, 8000.00, 0, '', 0.00, '2026-06-19 07:34:34'),
(58, 28, 'Collar T. Shirts', 36, 30000.00, 0, '', 0.00, '2026-06-19 07:34:34'),
(59, 28, '50 Seater Tent with SHI and Y Global Logo', 1, 2056000.00, 0, '', 0.00, '2026-06-19 07:34:34'),
(60, 29, 'WEBSITE DESIGN PAYMENT BALANCE', 1, 50000.00, 0, '', 0.00, '2026-06-19 07:59:02'),
(61, 30, 'TMIS APPLICATION', 1, 70000.00, 0, '', 0.00, '2026-06-19 12:55:24');

--
-- Triggers `items`
--
DELIMITER $$
CREATE TRIGGER `validate_delivery_qty_before_insert` BEFORE INSERT ON `items` FOR EACH ROW BEGIN
    DECLARE doc_type_val VARCHAR(20);
    
    SELECT type INTO doc_type_val FROM documents WHERE id = NEW.doc_id;
    
    IF doc_type_val = 'delivery' THEN
        IF NEW.delivered_qty IS NULL OR NEW.delivered_qty < 0 THEN
            SET NEW.delivered_qty = NEW.qty;
        END IF;
        
        IF NEW.delivered_qty > NEW.qty THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Delivered quantity cannot exceed ordered quantity';
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `doc_id` int(11) NOT NULL COMMENT 'Reference to documents table',
  `amount` decimal(10,2) NOT NULL COMMENT 'Payment amount',
  `payment_method` enum('cash','bank_transfer','mobile_money','cheque','credit_card') NOT NULL COMMENT 'Payment method',
  `reference_no` varchar(100) DEFAULT NULL COMMENT 'Transaction reference number',
  `payment_date` date NOT NULL COMMENT 'Date of payment',
  `notes` text DEFAULT NULL COMMENT 'Additional payment notes',
  `received_by` int(11) DEFAULT NULL COMMENT 'User ID who recorded payment',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Payment records for documents';

-- --------------------------------------------------------

--
-- Stand-in structure for view `payment_summary`
-- (See below for the actual view)
--
CREATE TABLE `payment_summary` (
`doc_id` int(11)
,`doc_no` varchar(50)
,`client_name` varchar(150)
,`total_amount` decimal(42,8)
,`paid_amount` decimal(32,2)
,`balance_due` decimal(43,8)
,`last_payment_date` date
);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `role` enum('admin','staff','viewer') DEFAULT 'staff',
  `is_active` tinyint(1) DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='System users';

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `full_name`, `role`, `is_active`, `last_login`, `created_at`) VALUES
(1, 'admin', 'admin@ray.com', '$2y$10$YourHashedPasswordHere', 'System Administrator', 'admin', 1, NULL, '2026-06-11 08:32:54');

-- --------------------------------------------------------

--
-- Structure for view `document_summary`
--
DROP TABLE IF EXISTS `document_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `document_summary`  AS SELECT `d`.`id` AS `id`, `d`.`type` AS `type`, `d`.`doc_no` AS `doc_no`, `d`.`client_name` AS `client_name`, `d`.`created_at` AS `created_at`, `d`.`status` AS `status`, count(`i`.`id`) AS `item_count`, coalesce(sum(`i`.`total`),0) AS `subtotal`, coalesce(sum(`i`.`total`) * (`d`.`tax_rate` / 100),0) AS `tax_amount`, coalesce(sum(`i`.`total`) + sum(`i`.`total`) * `d`.`tax_rate` / 100,0) AS `grand_total` FROM (`documents` `d` left join `items` `i` on(`d`.`id` = `i`.`doc_id`)) GROUP BY `d`.`id`, `d`.`type`, `d`.`doc_no`, `d`.`client_name`, `d`.`created_at`, `d`.`status`, `d`.`tax_rate` ;

-- --------------------------------------------------------

--
-- Structure for view `payment_summary`
--
DROP TABLE IF EXISTS `payment_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `payment_summary`  AS SELECT `d`.`id` AS `doc_id`, `d`.`doc_no` AS `doc_no`, `d`.`client_name` AS `client_name`, `d`.`grand_total` AS `total_amount`, coalesce(sum(`p`.`amount`),0) AS `paid_amount`, `d`.`grand_total`- coalesce(sum(`p`.`amount`),0) AS `balance_due`, max(`p`.`payment_date`) AS `last_payment_date` FROM (`document_summary` `d` left join `payments` `p` on(`d`.`id` = `p`.`doc_id`)) GROUP BY `d`.`id`, `d`.`doc_no`, `d`.`client_name`, `d`.`grand_total` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `company_settings`
--
ALTER TABLE `company_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_doc_no` (`doc_no`),
  ADD KEY `idx_doc_type` (`type`),
  ADD KEY `idx_client_name` (`client_name`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_created_by` (`created_by`),
  ADD KEY `idx_doc_type_status` (`type`,`status`),
  ADD KEY `idx_doc_created` (`created_at`,`type`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_items_doc` (`doc_id`),
  ADD KEY `idx_condition_status` (`condition_status`),
  ADD KEY `idx_items_doc_price` (`doc_id`,`price`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_payments_doc` (`doc_id`),
  ADD KEY `idx_payment_date` (`payment_date`),
  ADD KEY `idx_payment_method` (`payment_method`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_active` (`is_active`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `company_settings`
--
ALTER TABLE `company_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `documents`
--
ALTER TABLE `documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `items_ibfk_1` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE;
--
-- Database: `mothercare`
--
CREATE DATABASE IF NOT EXISTS `mothercare` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `mothercare`;

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `country_code` varchar(10) DEFAULT '+256',
  `dcontact` varchar(20) NOT NULL,
  `qualifications` text DEFAULT NULL,
  `specialty` varchar(100) DEFAULT NULL,
  `facility` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`id`, `user_id`, `photo`, `photo_path`, `country_code`, `dcontact`, `qualifications`, `specialty`, `facility`, `created_at`, `updated_at`) VALUES
(1, 2, NULL, 'uploads/doctors/doctor_2_1774350489.jpeg', '+256', '+256771494963', 'MBchb', 'GYN', 'MENGO', '2026-03-24 14:08:09', '2026-03-24 14:08:09');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `sender_type` enum('patient','doctor','admin') NOT NULL,
  `message` text NOT NULL,
  `status` enum('sent','delivered','read') DEFAULT 'sent',
  `is_reply_to` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `read_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `sender_type`, `message`, `status`, `is_reply_to`, `created_at`, `read_at`) VALUES
(1, 1, 2, 'patient', 'hello. good afternoon', 'sent', NULL, '2026-03-24 14:26:23', NULL),
(2, 2, 1, 'doctor', 'good afternoon to you', 'read', NULL, '2026-03-24 14:32:39', '2026-06-01 12:31:25'),
(3, 1, 2, 'patient', 'HELLO DOCTOR, GOOD MORNING', 'sent', NULL, '2026-06-01 12:31:51', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `otp` varchar(6) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `used` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pre_eclampsia_assessments`
--

CREATE TABLE `pre_eclampsia_assessments` (
  `id` int(11) NOT NULL,
  `patient_type` varchar(50) NOT NULL,
  `systolic_bp` int(11) NOT NULL,
  `diastolic_bp` int(11) NOT NULL,
  `has_proteinuria` tinyint(1) DEFAULT 0,
  `has_severe_symptoms` tinyint(1) DEFAULT 0,
  `risk_level` varchar(20) NOT NULL,
  `recommendation` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `mode` varchar(20) DEFAULT 'home',
  `input_type` varchar(50) DEFAULT 'text',
  `previous_pe` tinyint(4) DEFAULT 0,
  `multiple_pregnancy` tinyint(4) DEFAULT 0,
  `hypertension` tinyint(4) DEFAULT 0,
  `risk` int(11) DEFAULT NULL,
  `message` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `symptoms_records`
--

CREATE TABLE `symptoms_records` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `mode` varchar(20) DEFAULT 'home',
  `input_type` varchar(50) DEFAULT 'text',
  `symptoms` text NOT NULL,
  `blood_pressure` varchar(20) DEFAULT NULL,
  `systolic_bp` int(11) DEFAULT NULL,
  `diastolic_bp` int(11) DEFAULT NULL,
  `proteinuria` varchar(20) DEFAULT 'None',
  `gestational_age_weeks` float DEFAULT NULL,
  `maternal_age_yrs` int(11) DEFAULT NULL,
  `diabetes` tinyint(4) DEFAULT 0,
  `previous_pe` tinyint(4) DEFAULT 0,
  `multiple_pregnancy` tinyint(4) DEFAULT 0,
  `hypertension` tinyint(4) DEFAULT 0,
  `risk` int(11) DEFAULT NULL,
  `risk_level` varchar(20) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `symptoms_records`
--

INSERT INTO `symptoms_records` (`id`, `user_id`, `mode`, `input_type`, `symptoms`, `blood_pressure`, `systolic_bp`, `diastolic_bp`, `proteinuria`, `gestational_age_weeks`, `maternal_age_yrs`, `diabetes`, `previous_pe`, `multiple_pregnancy`, `hypertension`, `risk`, `risk_level`, `message`, `created_at`) VALUES
(51, 1, 'home', 'checkbox', 'Headache', '145/80', 145, 80, 'None', 16, 28, 0, 0, 0, 0, 35, 'Moderate', 'MODERATE RISK\n\nRisk Score: 35%\n\n📋 Recommended Actions:\n• Check BP DAILY\n• Reduce salt intake\n• Rest on left side\n\n🏥 Visit clinic within 2 weeks', '2026-06-20 18:17:40'),
(52, 1, 'clinical', 'checkbox', 'Headache, Abdominal pain, Nausea', '145/90', 145, 90, 'Yes', 16, 28, 0, 0, 0, 0, 55, 'High', 'HIGH RISK - URGENT\n\nRisk Score: 55%\n\n⚠️ Go to clinic TODAY or TOMORROW\n• Check BP TWICE daily\n• Strict bed rest\n• Low salt diet\n\n🚨 EMERGENCY: Go NOW if convulsions, severe headache, vision changes', '2026-06-20 18:25:58'),
(53, 1, 'home', 'checkbox', 'Abdominal pain', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 12, 'Low', 'LOW RISK\n\nRisk Score: 12%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms', '2026-06-20 22:40:08'),
(54, 1, 'home', 'checkbox', 'Abdominal pain', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 12, 'Low', 'LOW RISK\n\nRisk Score: 12%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms', '2026-06-20 22:43:49'),
(55, 1, 'home', 'checkbox', 'Swelling, Nausea', '170/89', 170, 89, 'None', 16, 28, 0, 0, 0, 0, 50, 'Moderate', 'MODERATE RISK\n\nRisk Score: 50%\n\n📋 Recommended Actions:\n• Check BP DAILY\n• Reduce salt intake\n• Rest on left side\n• Monitor warning signs\n\n🏥 Visit AGULURUDE HC III within 2 weeks', '2026-06-20 23:22:46'),
(56, 1, 'home', 'checkbox', 'Headache, Blurred vision, Abdominal pain', '137/89', 137, 89, 'None', 16, 28, 0, 0, 0, 0, 57, 'High', 'HIGH RISK - URGENT\n\nRisk Score: 57%\n\n⚠️ Go to AGULURUDE HC III TODAY or TOMORROW\n• Check BP TWICE daily\n• Strict bed rest\n• Low salt diet\n• Monitor fetal movement\n\n🚨 EMERGENCY: Go NOW if convulsions, severe headache, vision changes, difficulty breathing', '2026-06-20 23:32:47'),
(57, 1, 'home', 'checkbox', 'Headache, Blurred vision, Abdominal pain', '137/89', 137, 89, 'None', 16, 28, 0, 0, 0, 0, 57, 'High', 'HIGH RISK - URGENT\n\nRisk Score: 57%\n\n⚠️ Go to AGULURUDE HC III TODAY or TOMORROW\n• Check BP TWICE daily\n• Strict bed rest\n• Low salt diet\n• Monitor fetal movement\n\n🚨 EMERGENCY: Go NOW if convulsions, severe headache, vision changes, difficulty breathing', '2026-06-20 23:40:24'),
(58, 1, 'home', 'checkbox', 'Headache, Blurred vision, Abdominal pain', '137/89', 137, 89, 'None', 16, 28, 0, 0, 0, 0, 57, 'High', 'HIGH RISK - URGENT\n\nRisk Score: 57%\n\n⚠️ Go to AGULURUDE HC III TODAY or TOMORROW\n• Check BP TWICE daily\n• Strict bed rest\n• Low salt diet\n• Monitor fetal movement\n\n🚨 EMERGENCY: Go NOW if convulsions, severe headache, vision changes, difficulty breathing', '2026-06-20 23:40:27'),
(59, 1, 'home', 'checkbox', 'Headache', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 15, 'Low', 'LOW RISK\n\nRisk Score: 15%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-20 23:40:37'),
(60, 1, 'home', 'checkbox', 'Headache', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 15, 'Low', 'LOW RISK\n\nRisk Score: 15%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-20 23:55:49'),
(61, 1, 'clinical', 'checkbox', 'Headache, Blurred vision, Abdominal pain', '150/90', 150, 90, 'Yes', 16, 28, 1, 1, 0, 1, 93, 'Critical', 'CRITICAL RISK - EMERGENCY\n\nRisk Score: 93%\n\n🚑 GO TO AGULURUDE HC III NOW\n• Call emergency services (112)\n• DO NOT WAIT\n• Do not drive yourself\n\n🚨 EMERGENCY SIGNS:\n• Convulsions\n• Loss of consciousness\n• Severe headache\n• Visual changes\n• Difficulty breathing\n• Severe abdominal pain', '2026-06-20 23:57:52'),
(62, 1, 'home', 'checkbox', 'Nausea', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 8, 'Low', 'LOW RISK\n\nRisk Score: 8%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 00:04:08'),
(63, 1, 'home', 'checkbox', 'Blurred vision', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 20, 'Low', 'LOW RISK\n\nRisk Score: 20%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 00:24:52'),
(64, 1, 'home', 'checkbox', 'Headache', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 15, 'Low', 'LOW RISK\n\nRisk Score: 15%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 00:28:16'),
(65, 1, 'home', 'checkbox', 'Swelling', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 12, 'Low', 'LOW RISK\n\nRisk Score: 12%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 01:21:35'),
(66, 1, 'home', 'checkbox', 'Swelling', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 12, 'Low', 'LOW RISK\n\nRisk Score: 12%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 01:37:38'),
(67, 1, 'home', 'checkbox', 'Headache, Blurred vision', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 20, 'Green', 'LOW RISK\n\nRisk Score: 20%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 01:38:36'),
(68, 1, 'clinical', 'checkbox', 'Headache, Blurred vision', '167/90', 167, 90, 'Yes', 16, 28, 0, 0, 0, 0, 20, 'Green', 'LOW RISK\n\nRisk Score: 20%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 01:40:08'),
(69, 1, 'clinical', 'checkbox', 'Abdominal pain', '200/90', 200, 90, 'Yes', 16, 28, 0, 0, 0, 0, 20, 'Green', 'LOW RISK\n\nRisk Score: 20%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 01:41:40'),
(70, 1, 'home', 'checkbox', 'Swelling', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 20, 'Green', 'LOW RISK\n\nRisk Score: 20%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 01:42:11'),
(71, 1, 'clinical', 'checkbox', 'Blurred vision', '180/110', 180, 110, 'Yes', 16, 28, 1, 0, 0, 0, 20, 'Green', 'LOW RISK\n\nRisk Score: 20%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 01:47:46'),
(72, 1, 'home', 'checkbox', 'Blurred vision', '180/110', 180, 110, 'None', 16, 28, 0, 0, 0, 0, 95, 'Critical', 'CRITICAL RISK - EMERGENCY\n\nRisk Score: 95%\n\n🚑 GO TO AGULURUDE HC III NOW\n• Call emergency services (112)\n• DO NOT WAIT\n• Do not drive yourself\n\n🚨 EMERGENCY SIGNS:\n• Convulsions\n• Loss of consciousness\n• Severe headache\n• Visual changes\n• Difficulty breathing\n• Severe abdominal pain', '2026-06-21 01:50:07'),
(73, 1, 'home', 'checkbox', 'Swelling', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 12, 'Low', 'LOW RISK\n\nRisk Score: 12%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 01:51:42'),
(74, 1, 'home', 'checkbox', 'Blurred vision, Abdominal pain', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 32, 'Moderate', 'MODERATE RISK\n\nRisk Score: 32%\n\n📋 Recommended Actions:\n• Check BP DAILY\n• Reduce salt intake\n• Rest on left side\n• Monitor warning signs\n\n🏥 Visit AGULURUDE HC III within 2 weeks', '2026-06-21 01:52:32'),
(75, 1, 'home', 'checkbox', 'Abdominal pain, Headache', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 27, 'Moderate', 'MODERATE RISK\n\nRisk Score: 27%\n\n📋 Recommended Actions:\n• Check BP DAILY\n• Reduce salt intake\n• Rest on left side\n• Monitor warning signs\n\n🏥 Visit AGULURUDE HC III within 2 weeks', '2026-06-21 01:53:56'),
(76, 1, 'home', 'checkbox', 'Nausea, Blurred vision', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 28, 'Moderate', 'MODERATE RISK\n\nRisk Score: 28%\n\n📋 Recommended Actions:\n• Check BP DAILY\n• Reduce salt intake\n• Rest on left side\n• Monitor warning signs\n\n🏥 Visit AGULURUDE HC III within 2 weeks', '2026-06-21 01:55:40'),
(77, 1, 'home', 'checkbox', 'Swelling, Abdominal pain', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 24, 'Low', 'LOW RISK\n\nRisk Score: 24%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 01:56:25'),
(78, 1, 'home', 'checkbox', 'Abdominal pain, Nausea', NULL, 0, 0, 'None', 16, 28, 0, 0, 0, 0, 20, 'Low', 'LOW RISK\n\nRisk Score: 20%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: AGULURUDE HC III', '2026-06-21 01:59:26');

-- --------------------------------------------------------

--
-- Table structure for table `symptom_logs`
--

CREATE TABLE `symptom_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `mode` varchar(50) DEFAULT NULL,
  `symptoms` text DEFAULT NULL,
  `systolic_bp` int(11) DEFAULT NULL,
  `diastolic_bp` int(11) DEFAULT NULL,
  `gestational_age_weeks` float DEFAULT NULL,
  `maternal_age_yrs` int(11) DEFAULT NULL,
  `diabetes` int(11) DEFAULT NULL,
  `previous_pe` int(11) DEFAULT NULL,
  `multiple_pregnancy` int(11) DEFAULT NULL,
  `hypertension` int(11) DEFAULT NULL,
  `risk_score` int(11) DEFAULT NULL,
  `risk_level` varchar(50) DEFAULT NULL,
  `prediction_type` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `user_type` enum('client','doctor','admin') NOT NULL DEFAULT 'client',
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `approved` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`, `password`, `user_type`, `status`, `approved`, `created_at`, `updated_at`) VALUES
(1, 'AKELLO', 'MONICA', 'monioka24@gmail.com', '+256786628308', '$2y$10$wO/gw1FeRk353URWkhM1huQJN8J68ogmSFzxZ/dwFXpiRBiJoQ.fC', 'client', 'active', 1, '2026-03-23 21:32:05', '2026-03-24 12:40:06'),
(2, 'OBONG', 'GAIUS', 'obong@gmail.com', '+256771494963', '$2y$10$Goc1hGn1r6Hu99PmBqqBouKktzW10YEMK3BkvawsZcgE6ZCjV09s2', 'doctor', 'active', 1, '2026-03-24 13:41:17', '2026-06-19 13:21:40'),
(3, 'MOSES', 'MATHEW', 'matthewokao@gmail.com', '+256785413934', '$2y$10$wO/gw1FeRk353URWkhM1huQJN8J68ogmSFzxZ/dwFXpiRBiJoQ.fC', 'admin', 'active', 1, '2026-03-24 14:03:29', '2026-06-19 13:48:06'),
(4, 'AUMA', 'TALITHA', 'auma@gmail.com', '0785413934', '$2y$10$kb5W4r51aJ8PRaJVIDZvOuK8H0Kj8heBau62fqIifw/n7vQVhsnF2', 'doctor', 'active', 0, '2026-03-25 13:13:59', '2026-03-25 13:13:59'),
(5, 'Test', 'User', 'test@example.com', '+256712345678', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'client', 'active', 1, '2026-06-19 10:54:45', '2026-06-19 13:21:40'),
(6, 'APIO', 'DORCUS', 'dorcusapio@gmail.com', '+2560772334567', '$2y$10$Fy8FTByk1sNtpHBol/vkZe2XY3I780NhVCedMQO8OQgIqdZk6rqmG', 'client', 'active', 1, '2026-06-19 12:40:14', '2026-06-19 12:40:42');

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `nationality` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `sub_county` varchar(100) DEFAULT NULL,
  `parish` varchar(100) DEFAULT NULL,
  `village` varchar(100) DEFAULT NULL,
  `nearest_health` varchar(200) DEFAULT NULL,
  `kin_name` varchar(100) DEFAULT NULL,
  `kin_relationship` varchar(50) DEFAULT NULL,
  `kin_contact` varchar(20) DEFAULT NULL,
  `kin_country_code` varchar(10) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `last_period` date DEFAULT NULL,
  `expected_delivery` date DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_profiles`
--

INSERT INTO `user_profiles` (`id`, `user_id`, `phone`, `nationality`, `district`, `sub_county`, `parish`, `village`, `nearest_health`, `kin_name`, `kin_relationship`, `kin_contact`, `kin_country_code`, `age`, `last_period`, `expected_delivery`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, 'UGANDAN', 'OYAM', 'LORO', 'ALIDI', 'ALIMO A', 'AGULURUDE HC III', 'OKAO MOSES MATHEW', 'HUSBAND', '+256', '+256', 28, '2026-02-28', '2026-12-05', '2026-03-23 21:32:05', '2026-06-01 13:10:31'),
(2, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '+256', NULL, NULL, NULL, '2026-03-24 13:41:18', '2026-03-24 13:41:18'),
(3, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-25 13:14:00', '2026-03-25 13:14:00'),
(4, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28, '2026-05-15', NULL, '2026-06-19 10:54:45', '2026-06-19 10:54:45'),
(5, 6, NULL, '', '', '', '', '', '', '', '', '+256', '+256', NULL, '0000-00-00', '0000-00-00', '2026-06-19 12:40:14', '2026-06-19 12:40:42'),
(6, 1, NULL, NULL, NULL, NULL, NULL, NULL, 'AGULURUDE HC III', NULL, NULL, NULL, NULL, 28, '2025-11-22', NULL, '2026-06-20 16:55:31', '2026-06-20 16:55:31'),
(7, 5, NULL, NULL, NULL, NULL, NULL, NULL, 'Test Health Center', NULL, NULL, NULL, NULL, 28, '2025-12-27', NULL, '2026-06-20 16:55:31', '2026-06-20 16:55:31'),
(8, 6, NULL, NULL, NULL, NULL, NULL, NULL, 'Maternal Health Clinic', NULL, NULL, NULL, NULL, 25, '2026-01-31', NULL, '2026-06-20 16:55:31', '2026-06-20 16:55:31'),
(9, 3, NULL, NULL, NULL, NULL, NULL, NULL, 'Your Health Facility', NULL, NULL, NULL, NULL, 28, '2025-12-06', NULL, '2026-06-20 16:55:31', '2026-06-20 16:55:31');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_specialty` (`specialty`),
  ADD KEY `idx_doctors_user_id` (`user_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `is_reply_to` (`is_reply_to`),
  ADD KEY `idx_sender_receiver` (`sender_id`,`receiver_id`),
  ADD KEY `idx_receiver_status` (`receiver_id`,`status`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_otp` (`user_id`,`otp`),
  ADD KEY `idx_expires` (`expires_at`);

--
-- Indexes for table `pre_eclampsia_assessments`
--
ALTER TABLE `pre_eclampsia_assessments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `symptoms_records`
--
ALTER TABLE `symptoms_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_risk_level` (`risk_level`),
  ADD KEY `idx_mode` (`mode`);

--
-- Indexes for table `symptom_logs`
--
ALTER TABLE `symptom_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `unique_email` (`email`),
  ADD UNIQUE KEY `unique_phone` (`phone`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_user_type` (`user_type`),
  ADD KEY `idx_approved` (`approved`),
  ADD KEY `idx_users_email` (`email`),
  ADD KEY `idx_users_user_type` (`user_type`),
  ADD KEY `idx_users_phone` (`phone`);

--
-- Indexes for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_last_period` (`last_period`),
  ADD KEY `idx_user_profiles_user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pre_eclampsia_assessments`
--
ALTER TABLE `pre_eclampsia_assessments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `symptoms_records`
--
ALTER TABLE `symptoms_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT for table `symptom_logs`
--
ALTER TABLE `symptom_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `user_profiles`
--
ALTER TABLE `user_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `doctors`
--
ALTER TABLE `doctors`
  ADD CONSTRAINT `doctors_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_doctors_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_3` FOREIGN KEY (`is_reply_to`) REFERENCES `messages` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `symptoms_records`
--
ALTER TABLE `symptoms_records`
  ADD CONSTRAINT `symptoms_records_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `fk_user_profiles_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
--
-- Database: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Table structure for table `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Table structure for table `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Table structure for table `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

-- --------------------------------------------------------

--
-- Table structure for table `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Table structure for table `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Table structure for table `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Table structure for table `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

--
-- Dumping data for table `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"mothercare\",\"table\":\"symptoms_records\"},{\"db\":\"mothercare\",\"table\":\"password_resets\"},{\"db\":\"mothercare\",\"table\":\"user_profiles\"},{\"db\":\"mothercare\",\"table\":\"pre_eclampsia_assessments\"},{\"db\":\"mothercare\",\"table\":\"users\"},{\"db\":\"mothercare\",\"table\":\"messages\"},{\"db\":\"INFORMATION_SCHEMA\",\"table\":\"KEY_COLUMN_USAGE\"}]');

-- --------------------------------------------------------

--
-- Table structure for table `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Table structure for table `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

-- --------------------------------------------------------

--
-- Table structure for table `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Dumping data for table `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2026-06-21 08:37:56', '{\"Console\\/Mode\":\"collapse\"}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Table structure for table `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Indexes for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Indexes for table `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Indexes for table `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Indexes for table `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Indexes for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Indexes for table `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Indexes for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Indexes for table `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Indexes for table `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Indexes for table `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Indexes for table `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Indexes for table `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Indexes for table `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Database: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
