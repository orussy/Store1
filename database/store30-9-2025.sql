-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 30, 2025 at 09:57 AM
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
-- Database: `store`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `address1` varchar(255) NOT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `country` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `postal_code` varchar(255) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `location_accuracy` enum('exact','approximate','general') DEFAULT 'approximate',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `user_id`, `title`, `address1`, `address2`, `country`, `city`, `postal_code`, `latitude`, `longitude`, `location_accuracy`, `created_at`, `deleted_at`) VALUES
(20, 14, 'Parents', '654 شارع الشهيد ابراهيم احمد', '', 'Egypt', 'القاهرة', '11865', 30.06446254, 31.46122057, 'exact', '2025-09-04 15:56:39', NULL),
(21, 14, 'Work', 'منطقة الألف مصنع, القاهرة, 11835, مصر', '', 'Egypt', 'القاهرة', '11835', 29.96855900, 31.47762036, 'exact', '2025-09-11 08:44:37', NULL),
(22, 14, 'Vacation', 'طريق القطامية, العين السخنه', '', 'Egypt', 'القاهرة', '11936', 29.95538391, 31.45168743, 'exact', '2025-09-11 18:27:06', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `total`, `created_at`, `updated_at`) VALUES
(12, 14, 0.00, '2025-09-03 21:32:00', '2025-09-30 07:00:00'),
(13, 4, 3000.00, '2025-09-05 13:20:51', NULL),
(14, 2, 150.00, '2025-09-05 19:18:03', '2025-09-05 19:18:08'),
(15, 15, 0.00, '2025-09-21 12:42:17', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cart_item`
--

CREATE TABLE `cart_item` (
  `id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_sku_id` int(11) NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart_item`
--

INSERT INTO `cart_item` (`id`, `cart_id`, `product_id`, `product_sku_id`, `quantity`, `created_at`, `updated_at`) VALUES
(7, 13, 1, 66, 3.00, '2025-09-05 13:21:22', NULL),
(19, 12, 1, 66, 1.00, '2025-09-30 07:00:33', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cart_promocodes`
--

CREATE TABLE `cart_promocodes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cart_id` int(11) NOT NULL,
  `promocode_id` int(20) UNSIGNED NOT NULL,
  `applied_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart_promocodes`
--

INSERT INTO `cart_promocodes` (`id`, `cart_id`, `promocode_id`, `applied_at`) VALUES
(23, 12, 1, '2025-09-05 12:28:00'),
(24, 13, 6, '2025-09-05 13:24:01'),
(25, 12, 1, '2025-09-29 13:51:43');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `created_at`, `deleted_at`) VALUES
(101, 'Audio & Headphones', '', '2025-03-24 10:00:31', NULL),
(102, 'Smartphones & Accessories', '', '2025-03-24 10:00:31', NULL),
(103, 'Laptops & Computers', '', '2025-03-24 10:00:31', NULL),
(104, 'Wearables', '', '2025-03-24 10:00:31', NULL),
(105, 'Speakers & Sound Systems', '', '2025-03-24 10:00:31', NULL),
(106, 'Televisions & Home Theater', '', '2025-03-24 10:00:31', NULL),
(107, 'Keyboards & Accessories', '', '2025-03-24 10:00:31', NULL),
(108, 'Office Furniture', '', '2025-03-24 10:00:31', NULL),
(109, 'Home Security', '', '2025-03-24 10:00:31', NULL),
(110, 'Personal Care & Hygiene', '', '2025-03-24 10:00:31', NULL),
(111, 'Charging & Power Solutions', '', '2025-03-24 10:00:31', NULL),
(112, 'Fitness & Health', '', '2025-03-24 10:00:31', NULL),
(113, 'Kitchen Appliances', '', '2025-03-24 10:00:31', NULL),
(114, 'Smart Home Devices', '', '2025-03-24 10:00:31', NULL),
(115, 'Wireless Accessories', '', '2025-03-24 10:00:31', NULL),
(116, 'Storage & Hard Drives', '', '2025-03-24 10:00:31', NULL),
(117, 'Home Automation', '', '2025-03-24 10:00:31', NULL),
(118, 'Cameras & Photography', '', '2025-03-24 10:00:31', NULL),
(119, 'Computer Accessories', '', '2025-03-24 10:00:31', NULL),
(120, 'E-Readers & Tablets', '', '2025-03-24 10:00:31', NULL),
(121, 'Lighting & Lamps', '', '2025-03-24 10:00:31', NULL),
(122, 'Small Home Appliances', '', '2025-03-24 10:00:31', NULL),
(123, 'Portable Power Solutions', '', '2025-03-24 10:00:31', NULL),
(124, 'Car Electronics', '', '2025-03-24 10:00:31', NULL),
(125, 'Drones & Aerial Photography', '', '2025-03-24 10:00:31', NULL),
(126, 'Projectors & Displays', '', '2025-03-24 10:00:31', NULL),
(127, 'Action & Sports Cameras', '', '2025-03-24 10:00:31', NULL),
(128, 'Digital Art & Design', '', '2025-03-24 10:00:31', NULL),
(129, 'Gaming Consoles & Accessories', '', '2025-03-24 10:00:31', NULL),
(130, 'Virtual Reality', '', '2025-03-24 10:00:31', NULL),
(131, 'Smart Lighting', '', '2025-03-24 10:00:31', NULL),
(132, 'Keyboards & Input Devices', '', '2025-03-24 10:00:31', NULL),
(133, 'Streaming & Video', '', '2025-03-24 10:00:31', NULL),
(134, 'Smart Doorbells & Security', '', '2025-03-24 10:00:31', NULL),
(135, 'Vacuum & Cleaning Devices', '', '2025-03-24 10:00:31', NULL),
(136, 'Laptop Cooling & Stands', '', '2025-03-24 10:00:31', NULL),
(137, 'Personal Grooming', '', '2025-03-24 10:00:31', NULL),
(138, 'Home Security & Surveillance', '', '2025-03-24 10:00:31', NULL),
(139, 'Air Quality & Purifiers', '', '2025-03-24 10:00:31', NULL),
(140, 'Solar & Renewable Energy', '', '2025-03-24 10:00:31', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `discounts`
--

CREATE TABLE `discounts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `discount_type` varchar(20) NOT NULL CHECK (`discount_type` in ('percentage','fixed')),
  `discount_value` decimal(10,2) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `discounts`
--

INSERT INTO `discounts` (`id`, `product_id`, `discount_type`, `discount_value`, `start_date`, `end_date`, `is_active`, `created_at`) VALUES
(2, 1, 'percentage', 40.00, '2025-09-01', '2025-09-20', 1, '2025-09-04 14:50:33');

-- --------------------------------------------------------

--
-- Table structure for table `loyalty_transactions`
--

CREATE TABLE `loyalty_transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `points` int(11) NOT NULL,
  `action_type` enum('earn','redeem') NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` enum('read','unread') NOT NULL DEFAULT 'unread',
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`id`, `user_id`, `status`, `title`, `content`, `created_at`) VALUES
(1, 14, 'read', 'discount', '40% discount on sound core r50i', '2025-09-04 18:58:27');

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `add_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Pending',
  `tax_amount` decimal(10,2) DEFAULT 0.00,
  `tax_rate` decimal(5,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`id`, `user_id`, `cart_id`, `total`, `add_id`, `created_at`, `updated_at`, `status`, `tax_amount`, `tax_rate`) VALUES
(124, 14, 12, 1700.00, 20, '2025-09-05 12:28:51', '2025-09-05 13:06:07', 'delivered', 168.00, 14.00),
(125, 4, 13, 3000.00, 20, '2025-09-01 13:22:02', NULL, 'completed', 0.00, 14.00),
(126, 14, 14, 1200.00, 20, '2025-08-12 11:03:33', '2025-09-11 08:39:43', 'delivered', 0.00, 0.00),
(127, 15, 34, 1000.00, 20, '2025-09-19 12:48:21', '2025-09-21 13:12:44', 'delivered', 0.00, 14.00),
(128, 14, 12, 798.00, 20, '2025-09-29 08:15:14', '2025-09-29 08:26:44', 'shipped', 98.00, 14.00),
(132, 14, 12, 1140.00, 20, '2025-09-29 08:39:52', NULL, 'Pending', 140.00, 14.00),
(133, 14, 12, 798.00, 21, '2025-09-29 11:27:23', NULL, 'Pending', 98.00, 14.00),
(134, 14, 12, 728.00, 22, '2025-09-29 13:51:43', '2025-09-30 06:52:43', 'delivered', 98.00, 14.00),
(135, 14, 12, 1140.00, 21, '2025-09-30 06:53:56', NULL, 'Pending', 140.00, 14.00),
(136, 14, 12, 1000.00, 20, '2025-09-30 07:00:00', NULL, 'Pending', 140.00, 14.00);

-- --------------------------------------------------------

--
-- Table structure for table `order_item`
--

CREATE TABLE `order_item` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_sku_id` int(11) NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `upated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_item`
--

INSERT INTO `order_item` (`id`, `order_id`, `product_id`, `product_sku_id`, `quantity`, `created_at`, `upated_at`) VALUES
(35, 124, 1, 66, 1.00, '2025-09-05 12:29:33', NULL),
(36, 124, 2, 68, 1.00, '2025-09-05 13:04:44', NULL),
(37, 125, 1, 66, 3.00, '2025-09-05 13:22:35', NULL),
(38, 127, 1, 66, 1.00, '2025-09-21 12:49:50', NULL),
(40, 126, 6, 74, 1.00, '2025-09-22 08:43:10', NULL),
(41, 128, 2, 68, 1.00, '2025-09-29 08:15:14', NULL),
(42, 132, 1, 66, 1.00, '2025-09-29 08:39:52', NULL),
(43, 133, 2, 68, 1.00, '2025-09-29 11:27:23', NULL),
(44, 134, 2, 68, 1.00, '2025-09-29 13:51:43', NULL),
(45, 135, 1, 66, 1.00, '2025-09-30 06:53:56', NULL),
(46, 136, 1, 66, 1.00, '2025-09-30 07:00:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT 0,
  `used_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `password_resets`
--

INSERT INTO `password_resets` (`id`, `user_id`, `token`, `expires_at`, `used`, `used_at`, `created_at`) VALUES
(13, 14, '915ddf1a29b90fcb9679b1e98e90b5b905925b58fbf60fcded6aa47c27d85e1e', '2025-09-04 20:00:10', 1, '2025-09-04 19:07:19', '2025-09-04 19:00:10'),
(14, 14, '3473c8b03a023dec84dfb2e2c4250b28118301ea0fb7ab1955da6a3694600ce3', '2025-09-04 20:11:36', 1, '2025-09-04 19:12:16', '2025-09-04 19:11:36'),
(16, 14, 'db2223bccb1b82986f956e9c759fd585ed176c2550fcce7e7a6f7e48c625f059', '2025-09-05 00:31:59', 1, '2025-09-04 23:34:39', '2025-09-04 23:31:59'),
(17, 14, '253f3c9b28ee53f3a3d6218e3c66599d776b908eed232291a0acc57a26167a96', '2025-09-05 00:46:30', 1, '2025-09-04 23:47:29', '2025-09-04 23:46:30'),
(18, 15, '7b8cdaef6bc33a94ab9b7a50ef73a981d75f672b03c42a1e6075bfdae9fd7ad8', '2025-09-21 13:43:10', 1, '2025-09-21 12:43:47', '2025-09-21 12:43:10');

-- --------------------------------------------------------

--
-- Table structure for table `payment_details`
--

CREATE TABLE `payment_details` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `provider` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_details`
--

INSERT INTO `payment_details` (`id`, `order_id`, `amount`, `provider`, `status`, `created_at`, `updated_at`) VALUES
(5, 124, 1250.00, 'cash', 'completed', '2025-09-05 13:06:38', NULL),
(6, 125, 2900.00, 'credit', 'completed', '2025-09-05 13:25:52', NULL),
(7, 127, 684.00, 'cash', 'completed', '2025-09-21 13:45:25', NULL),
(8, 126, 1199.99, 'cash', 'completed', '2025-09-22 08:45:05', NULL),
(9, 128, 798.00, 'cash', 'completed', '2025-09-29 08:15:14', NULL),
(10, 132, 1140.00, 'cash', 'completed', '2025-09-29 08:39:52', NULL),
(11, 133, 798.00, 'cash', 'completed', '2025-09-29 11:27:23', NULL),
(12, 134, 728.00, 'cash', 'completed', '2025-09-29 13:51:43', NULL),
(13, 135, 1140.00, 'cash', 'completed', '2025-09-30 06:53:56', NULL),
(14, 136, 1140.00, 'cash', 'pending', '2025-09-30 07:00:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `function_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `summary` varchar(255) NOT NULL,
  `category_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `summary`, `category_id`, `created_at`, `deleted_at`) VALUES
(1, 'SoundCore R50I', 'High-quality noise-canceling wireless headphones.', 'Experience immersive sound with active noise cancellation. hello hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  h', 1, '2025-03-24 10:31:11', NULL),
(2, 'In-Ear Earbuds', 'Wireless and wired in-ear earbuds with deep bass.', 'Comfortable fit with superior sound.', 1, '2025-03-24 10:31:11', NULL),
(3, 'Flagship Smartphone', 'High-end smartphone with powerful processor.', 'Premium design with cutting-edge technology.', 3, '2025-03-24 10:31:11', NULL),
(4, 'Mid-Range Smartphone', 'Affordable smartphone with great performance.', 'Smooth experience with long battery life.', 4, '2025-03-24 10:31:11', NULL),
(5, 'Gaming Laptop', 'High-performance gaming laptop with RGB keyboard.', 'Perfect for gaming and creative work.', 5, '2025-03-24 10:31:11', NULL),
(6, 'Ultrabook Laptop', 'Slim and lightweight laptop for productivity.', 'Powerful and stylish laptop for professionals.', 6, '2025-03-24 10:31:11', NULL),
(7, 'Fitness Smartwatch', 'Advanced smartwatch with fitness tracking.', 'Monitor your heart rate and track workouts.', 7, '2025-03-24 10:31:11', NULL),
(8, 'Luxury Smartwatch', 'Premium smartwatch with elegant design.', 'Blends fashion with smart technology.', 8, '2025-03-24 10:31:11', NULL),
(9, 'Portable Bluetooth Speaker', 'Compact speaker with powerful sound.', 'Enjoy music anywhere with wireless connectivity.', 9, '2025-03-24 10:31:11', NULL),
(10, 'Home Theater System', 'Immersive audio system for home entertainment.', 'Crystal-clear surround sound.', 10, '2025-03-24 10:31:11', NULL),
(11, '4K Smart TV', 'Ultra HD television with smart features.', 'Cinematic experience with vivid colors.', 11, '2025-03-24 10:31:11', NULL),
(12, 'OLED TV', 'Premium OLED TV with deep blacks and vibrant colors.', 'Best picture quality for entertainment lovers.', 12, '2025-03-24 10:31:11', NULL),
(13, 'Mechanical Keyboard', 'Gaming keyboard with mechanical switches.', 'Responsive keys for better typing and gaming.', 13, '2025-03-24 10:31:11', NULL),
(14, 'Wireless Keyboard', 'Bluetooth keyboard for convenience.', 'Works seamlessly across multiple devices.', 14, '2025-03-24 10:31:11', NULL),
(15, 'Ergonomic Chair', 'Comfortable chair for office and gaming.', 'Provides lumbar support for long hours.', 15, '2025-03-24 10:31:11', NULL),
(16, 'Standing Desk', 'Adjustable height desk for healthy work habits.', 'Improve posture with an ergonomic desk.', 16, '2025-03-24 10:31:11', NULL),
(17, 'Security Camera', 'Surveillance camera for home and business.', 'Keep your space secure with real-time monitoring.', 17, '2025-03-24 10:31:11', NULL),
(18, 'Smart Door Lock', 'Keyless entry with fingerprint scanner.', 'Enhance home security with smart locking system.', 18, '2025-03-24 10:31:11', NULL),
(19, 'Electric Toothbrush', 'Rechargeable toothbrush for deep cleaning.', 'Advanced technology for healthier teeth.', 19, '2025-03-24 10:31:11', NULL),
(20, 'Hair Dryer', 'Powerful hair dryer with multiple heat settings.', 'Quick and efficient styling tool.', 20, '2025-03-24 10:31:11', NULL),
(21, 'Wireless Charger', 'Fast wireless charging for smartphones.', 'Convenient charging without cables.', 21, '2025-03-24 10:31:11', NULL),
(22, 'Power Bank', 'Portable battery for charging on the go.', 'High-capacity power solution for travelers.', 22, '2025-03-24 10:31:11', NULL),
(23, 'Smart Scale', 'Body composition scale with Bluetooth.', 'Track weight, BMI, and more via an app.', 23, '2025-03-24 10:31:11', NULL),
(24, 'Fitness Tracker', 'Wearable fitness device with step counting.', 'Monitor daily activities and workouts.', 24, '2025-03-24 10:31:11', NULL),
(25, 'Blender & Mixer', 'Powerful kitchen appliance for smoothies.', 'Make delicious and healthy drinks easily.', 25, '2025-03-24 10:31:11', NULL),
(26, 'Smart Light Bulb', 'Voice-controlled smart lighting.', 'Adjust brightness and colors via an app.', 12, '2025-03-24 10:31:11', NULL),
(27, 'Noise Cancelling Earbuds', 'Premium earbuds with ANC.', 'Block outside noise for immersive listening.', 2, '2025-03-24 10:31:11', NULL),
(28, 'Smartphone Stand', 'Adjustable phone stand for hands-free use.', 'Perfect for watching videos and video calls.', 3, '2025-03-24 10:31:11', NULL),
(29, 'Gaming Mouse', 'High-precision mouse for gaming.', 'Adjustable DPI and customizable RGB.', 13, '2025-03-24 10:31:11', NULL),
(30, 'Streaming Webcam', '1080p webcam for video calls and streaming.', 'Crystal-clear video and built-in mic.', 14, '2025-03-24 10:31:11', NULL),
(31, 'VR Headset', 'Immersive virtual reality headset.', 'Step into the world of VR gaming.', 5, '2025-03-24 10:31:11', NULL),
(32, 'Smart Coffee Maker', 'WiFi-enabled coffee machine.', 'Brew coffee remotely from your smartphone.', 25, '2025-03-24 10:31:11', NULL),
(33, 'Air Purifier', 'Smart air purifier with HEPA filter.', 'Improves indoor air quality and reduces allergens.', 6, '2025-03-24 10:31:11', NULL),
(34, 'Dash Cam', 'Car camera for recording road trips.', 'Provides security and evidence in case of accidents.', 17, '2025-03-24 10:31:11', NULL),
(35, 'Electric Kettle', 'Fast boiling kettle with temperature control.', 'Perfect for tea, coffee, and more.', 25, '2025-03-24 10:31:11', NULL),
(36, 'Car Phone Holder', 'Magnetic phone mount for cars.', 'Keeps your phone secure while driving.', 22, '2025-03-24 10:31:11', NULL),
(37, 'Portable Projector', 'Mini projector for home and travel.', 'Watch movies on a big screen anywhere.', 11, '2025-03-24 10:31:11', NULL),
(38, 'External Hard Drive', '1TB external storage device.', 'Backup files and carry data anywhere.', 6, '2025-03-24 10:31:11', NULL),
(39, 'WiFi Router', 'High-speed wireless internet router.', 'Provides stable internet connection.', 18, '2025-03-24 10:31:11', NULL),
(40, 'Smart Mirror', 'LED smart mirror with Bluetooth.', 'Features touch controls and voice assistant.', 24, '2025-03-24 10:31:11', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_attributes`
--

CREATE TABLE `product_attributes` (
  `id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_attributes`
--

INSERT INTO `product_attributes` (`id`, `type`, `value`, `created_at`, `deleted_at`) VALUES
(1, 'Size', 'Small', '2025-03-26 08:14:35', NULL),
(2, 'Size', 'Medium', '2025-03-26 08:14:35', NULL),
(3, 'Size', 'Large', '2025-03-26 08:14:35', NULL),
(4, 'Size', 'Extra Large', '2025-03-26 08:14:35', NULL),
(5, 'Color', 'Black', '2025-03-26 08:14:35', NULL),
(6, 'Color', 'White', '2025-03-26 08:14:35', NULL),
(7, 'Color', 'Red', '2025-03-26 08:14:35', NULL),
(8, 'Color', 'Blue', '2025-03-26 08:14:35', NULL),
(9, 'Color', 'Gold', '2025-03-26 08:14:35', NULL),
(10, 'Color', 'Silver', '2025-03-26 08:14:35', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_reviews`
--

CREATE TABLE `product_reviews` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `review` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_skus`
--

CREATE TABLE `product_skus` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `size_attribute_id` int(11) NOT NULL,
  `color_attribute_id` int(11) NOT NULL,
  `sku` varchar(255) NOT NULL,
  `cover` varchar(255) NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `cost_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `Currency` varchar(3) NOT NULL DEFAULT 'EGP',
  `quantity` decimal(10,2) NOT NULL,
  `unit_type` enum('piece','kg') NOT NULL DEFAULT 'piece',
  `loyalty` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_skus`
--

INSERT INTO `product_skus` (`id`, `product_id`, `size_attribute_id`, `color_attribute_id`, `sku`, `cover`, `price`, `cost_price`, `Currency`, `quantity`, `unit_type`, `loyalty`, `created_at`, `deleted_at`) VALUES
(66, 1, 2, 6, 'WH-MEDIUM-WHITE', 'img/product/r50i/13.jpg', 1000.00, 0.00, 'EGP', 100.00, 'piece', 0, '2025-03-26 08:16:32', NULL),
(68, 2, 1, 6, 'IE-SMALL-WHITE', 'img/product/earbuds/earbuds.jpg', 700.00, 0.00, 'EGP', 80.00, 'piece', 0, '2025-03-26 08:16:32', NULL),
(70, 3, 2, 6, 'FS-WHITE', 'img/product/flagship/1.png', 999.99, 0.00, 'EGP', 15.00, 'piece', 0, '2025-03-26 08:16:32', NULL),
(72, 4, 3, 9, 'MR-GOLD', 'img/product/midrange-phone/midrange-phone.jpg', 499.99, 0.00, 'EGP', 30.00, 'piece', 0, '2025-03-26 08:16:32', NULL),
(73, 5, 4, 4, 'GL-XL', 'img/product/gaming-laptop/gaming-laptop.jpg', 1499.99, 0.00, 'EGP', 10.00, 'piece', 0, '2025-03-26 08:16:32', NULL),
(74, 6, 3, 4, 'UL-LARGE', 'img/product/ultrabook/ultrabook.jpg', 1199.99, 0.00, 'EGP', 15.00, 'piece', 0, '2025-03-26 08:16:32', NULL),
(76, 7, 1, 8, 'FW-BLUE', 'img/product/fitness-watch/fitness-watch.jpg', 299.99, 0.00, 'EGP', 50.00, 'piece', 0, '2025-03-26 08:16:32', NULL),
(77, 8, 2, 9, 'LW-GOLD', 'img/product/luxury-watch/luxury-watch.jpg', 499.99, 0.00, 'EGP', 30.00, 'piece', 0, '2025-03-26 08:16:32', NULL),
(79, 9, 3, 7, 'BS-RED', '/img/product/bluetooth-speaker/bluetooth-speaker.jpg', 99.99, 0.00, 'EGP', 60.00, 'piece', 0, '2025-03-26 08:16:32', NULL),
(80, 10, 4, 5, 'HT-BLACK', '/img/product/home-theater/home-theater.jpg', 799.99, 0.00, 'EGP', 20.00, 'piece', 0, '2025-03-26 08:16:32', NULL),
(81, 11, 3, 8, 'FW-BLUE', '/img/product/4k-tv/4k-tv.jpg', 102221.00, 0.00, 'EGP', 123.00, 'piece', 0, '2025-03-26 08:26:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_suppliers`
--

CREATE TABLE `product_suppliers` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_suppliers`
--

INSERT INTO `product_suppliers` (`id`, `product_id`, `supplier_id`) VALUES
(1, 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `promocodes`
--

CREATE TABLE `promocodes` (
  `id` int(20) UNSIGNED NOT NULL,
  `code` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `discount_type` varchar(20) NOT NULL CHECK (`discount_type` in ('percentage','fixed')),
  `discount_value` decimal(10,2) NOT NULL,
  `min_cart_total` decimal(10,2) DEFAULT NULL,
  `max_uses` int(11) DEFAULT 1,
  `max_uses_per_user` int(11) DEFAULT 1,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `promocodes`
--

INSERT INTO `promocodes` (`id`, `code`, `description`, `discount_type`, `discount_value`, `min_cart_total`, `max_uses`, `max_uses_per_user`, `start_date`, `end_date`, `is_active`, `created_at`) VALUES
(1, 'WELCOME10', 'Welcome discount for new customers', 'percentage', 10.00, 100.00, 100, 1, '2024-01-01', '2025-12-31', 1, '2025-09-03 16:51:21'),
(2, 'SAVE20', '20% off on orders over 200 EGP', 'percentage', 20.00, 200.00, 50, 2, '2024-06-01', '2025-12-31', 1, '2025-09-03 16:51:21'),
(3, 'FIXED50', '50 EGP off on any order', 'fixed', 50.00, 150.00, 200, 3, '2024-01-01', '2025-12-31', 1, '2025-09-03 16:51:21'),
(4, 'SUMMER25', 'Summer sale - 25% off', 'percentage', 25.00, 300.00, 75, 1, '2024-07-01', '2024-08-31', 1, '2025-09-03 16:51:21'),
(5, 'STUDENT15', 'Student discount - 15% off', 'percentage', 15.00, 50.00, 500, 5, '2024-01-01', '2025-12-31', 1, '2025-09-03 16:51:21'),
(6, 'VIP100', 'VIP customer - 100 EGP off', 'fixed', 100.00, 500.00, 25, 1, '2024-01-01', '2025-12-31', 1, '2025-09-03 16:51:21'),
(7, 'EXPIRED', 'This promo code has expired', 'percentage', 30.00, 100.00, 10, 1, '2023-01-01', '2023-12-31', 0, '2025-09-03 16:51:21');

-- --------------------------------------------------------

--
-- Table structure for table `refunds`
--

CREATE TABLE `refunds` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `return_id` int(11) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` enum('Pending','Processed','Failed') NOT NULL,
  `processed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `returns`
--

CREATE TABLE `returns` (
  `id` int(11) NOT NULL,
  `order_item_id` int(11) NOT NULL,
  `reason` text NOT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT 1.00,
  `status` enum('Requested','Approved','Rejected','Received') NOT NULL DEFAULT 'Requested',
  `requested_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `processed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'Super Admin', 'Full access to everything, including managing roles and permissions.'),
(2, 'Admin', 'Manages users, products, categories, orders, and reports.'),
(3, 'Seller', 'Can manage their own products, view their sales, and process their orders.'),
(4, 'Warehouse', 'Manages stock levels, updates order fulfillment, and tracks shipments.'),
(5, 'Customer Support', 'Can view orders, assist customers, and handle returns/refunds.'),
(6, 'Marketing', 'Manages promotions, discount codes, and marketing reports.'),
(7, 'customer', 'normal Customer');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `can_read` tinyint(1) NOT NULL DEFAULT 0,
  `can_write` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stock_movements`
--

CREATE TABLE `stock_movements` (
  `id` int(11) NOT NULL,
  `product_sku_id` int(11) NOT NULL,
  `movement_type` enum('IN','OUT') NOT NULL,
  `quantity` int(11) NOT NULL,
  `reference` enum('Purchase','Sale','Return','Adjustment') NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_movements`
--

INSERT INTO `stock_movements` (`id`, `product_sku_id`, `movement_type`, `quantity`, `reference`, `reference_id`, `created_at`) VALUES
(2, 66, 'IN', 100, 'Purchase', NULL, '2025-09-06 09:36:18');

-- --------------------------------------------------------

--
-- Table structure for table `sub_categories`
--

CREATE TABLE `sub_categories` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sub_categories`
--

INSERT INTO `sub_categories` (`id`, `parent_id`, `name`, `description`, `created_at`, `deleted_at`) VALUES
(1, 101, 'Over-Ear Headphones', 'Comfortable over-ear headphones with noise cancellation.', '2025-03-24 10:25:29', NULL),
(2, 101, 'In-Ear Earbuds', 'Wireless and wired in-ear earbuds with deep bass.', '2025-03-24 10:25:29', NULL),
(3, 102, 'Flagship Smartphones', 'High-end smartphones with powerful processors.', '2025-03-24 10:25:29', NULL),
(4, 102, 'Mid-Range Phones', 'Affordable smartphones with excellent performance.', '2025-03-24 10:25:29', NULL),
(5, 103, 'Gaming Laptops', 'High-performance laptops for gaming and creative work.', '2025-03-24 10:25:29', NULL),
(6, 103, 'Ultrabooks', 'Slim and lightweight laptops for productivity.', '2025-03-24 10:25:29', NULL),
(7, 104, 'Fitness Smartwatches', 'Smartwatches with advanced health tracking.', '2025-03-24 10:25:29', NULL),
(8, 104, 'Luxury Smartwatches', 'Premium smartwatches with elegant designs.', '2025-03-24 10:25:29', NULL),
(9, 105, 'Portable Speakers', 'Compact speakers with Bluetooth connectivity.', '2025-03-24 10:25:29', NULL),
(10, 105, 'Home Theater Systems', 'High-quality sound systems for home entertainment.', '2025-03-24 10:25:29', NULL),
(11, 106, '4K TVs', 'Ultra HD televisions with smart features.', '2025-03-24 10:25:29', NULL),
(12, 106, 'OLED TVs', 'Premium OLED TVs with vibrant colors and deep blacks.', '2025-03-24 10:25:29', NULL),
(13, 107, 'Mechanical Keyboards', 'Responsive mechanical keyboards for gaming and work.', '2025-03-24 10:25:29', NULL),
(14, 107, 'Wireless Keyboards', 'Bluetooth-enabled wireless keyboards for convenience.', '2025-03-24 10:25:29', NULL),
(15, 108, 'Ergonomic Chairs', 'Comfortable chairs for office and gaming.', '2025-03-24 10:25:29', NULL),
(16, 108, 'Standing Desks', 'Adjustable height desks for a healthier workspace.', '2025-03-24 10:25:29', NULL),
(17, 109, 'Security Cameras', 'Surveillance cameras for home and business security.', '2025-03-24 10:25:29', NULL),
(18, 109, 'Smart Door Locks', 'Keyless entry smart locks with fingerprint scanning.', '2025-03-24 10:25:29', NULL),
(19, 110, 'Electric Toothbrushes', 'Rechargeable toothbrushes with advanced cleaning technology.', '2025-03-24 10:25:29', NULL),
(20, 110, 'Hair Dryers', 'Powerful hair dryers with multiple heat settings.', '2025-03-24 10:25:29', NULL),
(21, 111, 'Wireless Chargers', 'Fast wireless chargers for smartphones and accessories.', '2025-03-24 10:25:29', NULL),
(22, 111, 'Power Banks', 'Portable power solutions for charging on the go.', '2025-03-24 10:25:29', NULL),
(23, 112, 'Smart Scales', 'Body composition scales with Bluetooth connectivity.', '2025-03-24 10:25:29', NULL),
(24, 112, 'Fitness Trackers', 'Wearable fitness tracking devices with step counting.', '2025-03-24 10:25:29', NULL),
(25, 113, 'Blenders & Mixers', 'Kitchen appliances for smoothies and meal prep.', '2025-03-24 10:25:29', NULL),
(26, 113, 'Coffee Makers', 'Automatic coffee brewing machines for home and office.', '2025-03-24 10:25:29', NULL),
(27, 114, 'Smart Bulbs', 'Wi-Fi-enabled LED bulbs with adjustable brightness.', '2025-03-24 10:25:29', NULL),
(28, 114, 'Smart Plugs', 'Remote-controlled power plugs for home automation.', '2025-03-24 10:25:29', NULL),
(29, 115, 'True Wireless Earbuds', 'Completely wireless earbuds with high-quality sound.', '2025-03-24 10:25:29', NULL),
(30, 115, 'Bluetooth Adapters', 'USB Bluetooth adapters for seamless wireless connectivity.', '2025-03-24 10:25:29', NULL),
(31, 116, 'External Hard Drives', 'High-capacity storage solutions for backup and file storage.', '2025-03-24 10:25:29', NULL),
(32, 116, 'USB Flash Drives', 'Portable storage devices with fast transfer speeds.', '2025-03-24 10:25:29', NULL),
(33, 117, 'Smart Thermostats', 'AI-powered thermostats for efficient home climate control.', '2025-03-24 10:25:29', NULL),
(34, 117, 'Home Assistants', 'Voice-controlled AI assistants for smart homes.', '2025-03-24 10:25:29', NULL),
(35, 118, 'DSLR Cameras', 'Professional cameras with interchangeable lenses.', '2025-03-24 10:25:29', NULL),
(36, 118, 'Mirrorless Cameras', 'Compact cameras with high-quality image sensors.', '2025-03-24 10:25:29', NULL),
(37, 119, 'Laptop Stands', 'Ergonomic stands for comfortable laptop usage.', '2025-03-24 10:25:29', NULL),
(38, 119, 'Cooling Pads', 'Laptop cooling solutions for better performance.', '2025-03-24 10:25:29', NULL),
(39, 120, 'E-Readers', 'Lightweight digital book readers with e-ink displays.', '2025-03-24 10:25:29', NULL),
(40, 120, 'Tablets', 'Portable touchscreen devices for work and entertainment.', '2025-03-24 10:25:29', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact_name` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `contact_name`, `phone`, `email`, `address`, `created_at`) VALUES
(1, 'hikvision', 'omar khaled', '01286246292', 'ok3050802@gmail.com', 'nasrcity', '2025-09-06 11:22:04');

-- --------------------------------------------------------

--
-- Table structure for table `tax_rules`
--

CREATE TABLE `tax_rules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `country` varchar(2) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `tax_rate` decimal(5,2) NOT NULL,
  `start_date` date DEFAULT curdate(),
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tax_rules`
--

INSERT INTO `tax_rules` (`id`, `country`, `state`, `category_id`, `tax_rate`, `start_date`, `end_date`, `is_active`) VALUES
(1, 'EG', NULL, NULL, 14.00, '2025-01-01', NULL, 1),
(2, 'US', 'CA', NULL, 7.25, '2025-01-01', NULL, 1),
(3, 'US', 'NY', NULL, 8.88, '2025-01-01', NULL, 1),
(4, 'US', 'TX', NULL, 6.25, '2025-01-01', NULL, 1),
(5, 'UK', NULL, NULL, 20.00, '2025-01-01', NULL, 1),
(6, 'DE', NULL, NULL, 19.00, '2025-01-01', NULL, 1),
(7, 'AE', NULL, 101, 14.00, '2025-01-01', NULL, 1),
(8, 'EG', NULL, 129, 20.00, '2025-01-01', NULL, 1),
(9, 'EG', NULL, 130, 20.00, '2025-01-01', NULL, 1),
(10, 'US', 'CA', 102, 8.50, '2025-01-01', NULL, 1),
(11, 'EG', NULL, 112, 5.00, '2025-01-01', NULL, 1),
(12, 'EG', NULL, 110, 5.00, '2025-01-01', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `Google_ID` bigint(20) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `f_name` varchar(255) NOT NULL,
  `l_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `birthdate` varchar(255) NOT NULL,
  `phone_no` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `gender` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'active',
  `role_id` int(11) NOT NULL DEFAULT 7,
  `loyalty_points` int(11) NOT NULL DEFAULT 0,
  `Loyalty_status` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `Google_ID`, `avatar`, `f_name`, `l_name`, `email`, `password`, `birthdate`, `phone_no`, `created_at`, `updated_at`, `deleted_at`, `gender`, `status`, `role_id`, `loyalty_points`, `Loyalty_status`) VALUES
(2, NULL, 'uploads/gelan21867@baxidy.com/avatar.png', 'ahmed', 'ali', 'gelan21867@baxidy.com', '$2y$10$lQroJV.dNeUMj/bZ4MUYqeLEcGtwv5Be3K01FdAt1.n8aVy0FiHZu', '2000-12-15', '01286246292', '2025-08-15 20:20:37', NULL, NULL, 'male', 'active', 1, 0, 0),
(4, NULL, 'uploads/gitoni4718@besaies.com/avatar.png', 'gu', 'II', 'gitoni4718@besaies.com', '$2y$10$rb/wc6fIQICVLg6TGyv4e.Ew5KbbntzGXn1WI7E.NXMsROJlP4M4K', '0222-12-12', '122', '2025-08-30 15:16:55', NULL, NULL, 'male', 'active', 7, 0, 0),
(14, 9223372036854775807, 'uploads/profile_pictures/33864171114794816dbc188b7f979d29.jpg', 'OMar', 'Khaled', 'ok3050802@gmail.com', '$2y$10$3n.d4xcQiWak54pxDCYxIeeaiQ37bWBHiFhG6N1NBmdwdYs615xdG', '18-10-2000', '01286246292', '2025-09-03 20:27:53', '2025-09-04 15:16:35', NULL, 'male', 'active', 7, 0, 0),
(15, NULL, 'uploads/nawipo7483@camjoint.com/avatar.png', 'ali', 'khaled', 'nawipo7483@camjoint.com', '$2y$10$/mwUGfDhK/BIgWyJqDsEnesAXBt1U9RH6a22VlGmhhMbMmdKRs/ai', '2025-09-30', '01286246292', '2025-09-21 12:42:17', NULL, NULL, 'male', 'active', 7, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_activity`
--

CREATE TABLE `user_activity` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `activity_type` enum('View','AddToCart','Wishlist','Purchase') NOT NULL,
  `created_at` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_promocode_usage`
--

CREATE TABLE `user_promocode_usage` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `promocode_id` int(20) UNSIGNED NOT NULL,
  `used_count` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_promocode_usage`
--

INSERT INTO `user_promocode_usage` (`id`, `user_id`, `promocode_id`, `used_count`) VALUES
(3, 4, 6, 1);

-- --------------------------------------------------------

--
-- Table structure for table `whishlist`
--

CREATE TABLE `whishlist` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cart_item`
--
ALTER TABLE `cart_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_id` (`cart_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `product_sku_id` (`product_sku_id`);

--
-- Indexes for table `cart_promocodes`
--
ALTER TABLE `cart_promocodes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_id` (`cart_id`),
  ADD KEY `promocode_id` (`promocode_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `discounts`
--
ALTER TABLE `discounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `loyalty_transactions`
--
ALTER TABLE `loyalty_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `cart_id` (`cart_id`),
  ADD KEY `add_id` (`add_id`);

--
-- Indexes for table `order_item`
--
ALTER TABLE `order_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `product_sku_id` (`product_sku_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `payment_details`
--
ALTER TABLE `payment_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `function_name` (`function_name`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `product_attributes`
--
ALTER TABLE `product_attributes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `product_skus`
--
ALTER TABLE `product_skus`
  ADD PRIMARY KEY (`id`),
  ADD KEY `color_attribute_id` (`color_attribute_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `size_attribute_id` (`size_attribute_id`);

--
-- Indexes for table `product_suppliers`
--
ALTER TABLE `product_suppliers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `promocodes`
--
ALTER TABLE `promocodes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `refunds`
--
ALTER TABLE `refunds`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `payment_id` (`payment_id`),
  ADD KEY `return_id` (`return_id`);

--
-- Indexes for table `returns`
--
ALTER TABLE `returns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_item_id` (`order_item_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Indexes for table `stock_movements`
--
ALTER TABLE `stock_movements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_sku_id` (`product_sku_id`),
  ADD KEY `reference_id` (`reference_id`);

--
-- Indexes for table `sub_categories`
--
ALTER TABLE `sub_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tax_rules`
--
ALTER TABLE `tax_rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category_id` (`category_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `Google_ID` (`Google_ID`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `user_activity`
--
ALTER TABLE `user_activity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_promocode_usage`
--
ALTER TABLE `user_promocode_usage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `promocode_id` (`promocode_id`);

--
-- Indexes for table `whishlist`
--
ALTER TABLE `whishlist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `cart_item`
--
ALTER TABLE `cart_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `cart_promocodes`
--
ALTER TABLE `cart_promocodes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT for table `discounts`
--
ALTER TABLE `discounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `loyalty_transactions`
--
ALTER TABLE `loyalty_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT for table `order_item`
--
ALTER TABLE `order_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `payment_details`
--
ALTER TABLE `payment_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `product_attributes`
--
ALTER TABLE `product_attributes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=161;

--
-- AUTO_INCREMENT for table `product_reviews`
--
ALTER TABLE `product_reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_skus`
--
ALTER TABLE `product_skus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=812;

--
-- AUTO_INCREMENT for table `product_suppliers`
--
ALTER TABLE `product_suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `promocodes`
--
ALTER TABLE `promocodes`
  MODIFY `id` int(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `refunds`
--
ALTER TABLE `refunds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `returns`
--
ALTER TABLE `returns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `role_permissions`
--
ALTER TABLE `role_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stock_movements`
--
ALTER TABLE `stock_movements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sub_categories`
--
ALTER TABLE `sub_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tax_rules`
--
ALTER TABLE `tax_rules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `user_activity`
--
ALTER TABLE `user_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_promocode_usage`
--
ALTER TABLE `user_promocode_usage`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `whishlist`
--
ALTER TABLE `whishlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `cart_item`
--
ALTER TABLE `cart_item`
  ADD CONSTRAINT `cart_item_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`),
  ADD CONSTRAINT `cart_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `cart_item_ibfk_3` FOREIGN KEY (`product_sku_id`) REFERENCES `product_skus` (`id`);

--
-- Constraints for table `cart_promocodes`
--
ALTER TABLE `cart_promocodes`
  ADD CONSTRAINT `cart_promocodes_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`),
  ADD CONSTRAINT `cart_promocodes_ibfk_2` FOREIGN KEY (`promocode_id`) REFERENCES `promocodes` (`id`);

--
-- Constraints for table `discounts`
--
ALTER TABLE `discounts`
  ADD CONSTRAINT `discounts_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `loyalty_transactions`
--
ALTER TABLE `loyalty_transactions`
  ADD CONSTRAINT `loyalty_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`add_id`) REFERENCES `addresses` (`id`);

--
-- Constraints for table `order_item`
--
ALTER TABLE `order_item`
  ADD CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order_details` (`id`),
  ADD CONSTRAINT `order_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `order_item_ibfk_3` FOREIGN KEY (`product_sku_id`) REFERENCES `product_skus` (`id`);

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `payment_details`
--
ALTER TABLE `payment_details`
  ADD CONSTRAINT `payment_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order_details` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `sub_categories` (`id`);

--
-- Constraints for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD CONSTRAINT `product_reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `product_reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `product_skus`
--
ALTER TABLE `product_skus`
  ADD CONSTRAINT `product_skus_ibfk_1` FOREIGN KEY (`color_attribute_id`) REFERENCES `product_attributes` (`id`),
  ADD CONSTRAINT `product_skus_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `product_skus_ibfk_3` FOREIGN KEY (`size_attribute_id`) REFERENCES `product_attributes` (`id`);

--
-- Constraints for table `product_suppliers`
--
ALTER TABLE `product_suppliers`
  ADD CONSTRAINT `product_suppliers_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `product_suppliers_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`);

--
-- Constraints for table `refunds`
--
ALTER TABLE `refunds`
  ADD CONSTRAINT `refunds_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order_details` (`id`),
  ADD CONSTRAINT `refunds_ibfk_2` FOREIGN KEY (`payment_id`) REFERENCES `payment_details` (`id`),
  ADD CONSTRAINT `refunds_ibfk_3` FOREIGN KEY (`return_id`) REFERENCES `returns` (`id`);

--
-- Constraints for table `returns`
--
ALTER TABLE `returns`
  ADD CONSTRAINT `returns_ibfk_1` FOREIGN KEY (`order_item_id`) REFERENCES `order_item` (`id`);

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`);

--
-- Constraints for table `stock_movements`
--
ALTER TABLE `stock_movements`
  ADD CONSTRAINT `stock_movements_ibfk_1` FOREIGN KEY (`product_sku_id`) REFERENCES `product_skus` (`id`),
  ADD CONSTRAINT `stock_movements_ibfk_2` FOREIGN KEY (`reference_id`) REFERENCES `order_details` (`id`);

--
-- Constraints for table `sub_categories`
--
ALTER TABLE `sub_categories`
  ADD CONSTRAINT `sub_categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `tax_rules`
--
ALTER TABLE `tax_rules`
  ADD CONSTRAINT `tax_rules_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `user_promocode_usage`
--
ALTER TABLE `user_promocode_usage`
  ADD CONSTRAINT `user_promocode_usage_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `user_promocode_usage_ibfk_2` FOREIGN KEY (`promocode_id`) REFERENCES `promocodes` (`id`);

--
-- Constraints for table `whishlist`
--
ALTER TABLE `whishlist`
  ADD CONSTRAINT `whishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `whishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
