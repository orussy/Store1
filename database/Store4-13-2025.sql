-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 13, 2025 at 12:59 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

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
  `user_id` bigint(20) NOT NULL,
  `tite` varchar(255) NOT NULL,
  `address1` varchar(255) NOT NULL,
  `address2` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `postal_code` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `total` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `total`, `created_at`, `updated_at`) VALUES
(2, 2147483648, 0, '2025-04-13 10:18:06', NULL),
(3, 2147483649, 0, '2025-04-13 10:39:43', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cart_item`
--

CREATE TABLE `cart_item` (
  `id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_sku_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Table structure for table `loyalty_transactions`
--

CREATE TABLE `loyalty_transactions` (
  `id` int(11) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `points` int(11) NOT NULL,
  `action_type` enum('earn','redeem') NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `status` enum('unread','read') NOT NULL DEFAULT 'unread',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `id` int(11) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_item`
--

CREATE TABLE `order_item` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_sku_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `upated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_details`
--

CREATE TABLE `payment_details` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `provider` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
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
  `cover` varchar(255) NOT NULL,
  `category_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `summary`, `cover`, `category_id`, `created_at`, `deleted_at`) VALUES
(1, 'Wireless Headphones', 'High-quality noise-canceling wireless headphones.', 'Experience immersive sound with active noise cancellation.', 'img/product/1.jpg', 1, '2025-03-24 10:31:11', NULL),
(2, 'In-Ear Earbuds', 'Wireless and wired in-ear earbuds with deep bass.', 'Comfortable fit with superior sound.', 'img/product/earbuds.jpg', 2, '2025-03-24 10:31:11', NULL),
(3, 'Flagship Smartphone', 'High-end smartphone with powerful processor.', 'Premium design with cutting-edge technology.', 'img/product/flagship-phone.jpg', 3, '2025-03-24 10:31:11', NULL),
(4, 'Mid-Range Smartphone', 'Affordable smartphone with great performance.', 'Smooth experience with long battery life.', 'img/product/midrange-phone.jpg', 4, '2025-03-24 10:31:11', NULL),
(5, 'Gaming Laptop', 'High-performance gaming laptop with RGB keyboard.', 'Perfect for gaming and creative work.', 'img/product/gaming-laptop.jpg', 5, '2025-03-24 10:31:11', NULL),
(6, 'Ultrabook Laptop', 'Slim and lightweight laptop for productivity.', 'Powerful and stylish laptop for professionals.', 'img/product/ultrabook.jpg', 6, '2025-03-24 10:31:11', NULL),
(7, 'Fitness Smartwatch', 'Advanced smartwatch with fitness tracking.', 'Monitor your heart rate and track workouts.', 'img/product/fitness-watch.jpg', 7, '2025-03-24 10:31:11', NULL),
(8, 'Luxury Smartwatch', 'Premium smartwatch with elegant design.', 'Blends fashion with smart technology.', 'img/product/luxury-watch.jpg', 8, '2025-03-24 10:31:11', NULL),
(9, 'Portable Bluetooth Speaker', 'Compact speaker with powerful sound.', 'Enjoy music anywhere with wireless connectivity.', '/img/product/bluetooth-speaker.jpg', 9, '2025-03-24 10:31:11', NULL),
(10, 'Home Theater System', 'Immersive audio system for home entertainment.', 'Crystal-clear surround sound.', '/img/product/home-theater.jpg', 10, '2025-03-24 10:31:11', NULL),
(11, '4K Smart TV', 'Ultra HD television with smart features.', 'Cinematic experience with vivid colors.', '/img/product/4k-tv.jpg', 11, '2025-03-24 10:31:11', NULL),
(12, 'OLED TV', 'Premium OLED TV with deep blacks and vibrant colors.', 'Best picture quality for entertainment lovers.', '/img/product/oled-tv.jpg', 12, '2025-03-24 10:31:11', NULL),
(13, 'Mechanical Keyboard', 'Gaming keyboard with mechanical switches.', 'Responsive keys for better typing and gaming.', '/img/product/mechanical-keyboard.jpg', 13, '2025-03-24 10:31:11', NULL),
(14, 'Wireless Keyboard', 'Bluetooth keyboard for convenience.', 'Works seamlessly across multiple devices.', '/img/product/wireless-keyboard.jpg', 14, '2025-03-24 10:31:11', NULL),
(15, 'Ergonomic Chair', 'Comfortable chair for office and gaming.', 'Provides lumbar support for long hours.', '/img/product/ergonomic-chair.jpg', 15, '2025-03-24 10:31:11', NULL),
(16, 'Standing Desk', 'Adjustable height desk for healthy work habits.', 'Improve posture with an ergonomic desk.', '/img/product/standing-desk.jpg', 16, '2025-03-24 10:31:11', NULL),
(17, 'Security Camera', 'Surveillance camera for home and business.', 'Keep your space secure with real-time monitoring.', '/img/product/security-camera.jpg', 17, '2025-03-24 10:31:11', NULL),
(18, 'Smart Door Lock', 'Keyless entry with fingerprint scanner.', 'Enhance home security with smart locking system.', '/img/product/smart-lock.jpg', 18, '2025-03-24 10:31:11', NULL),
(19, 'Electric Toothbrush', 'Rechargeable toothbrush for deep cleaning.', 'Advanced technology for healthier teeth.', '/img/product/electric-toothbrush.jpg', 19, '2025-03-24 10:31:11', NULL),
(20, 'Hair Dryer', 'Powerful hair dryer with multiple heat settings.', 'Quick and efficient styling tool.', '/img/product/hair-dryer.jpg', 20, '2025-03-24 10:31:11', NULL),
(21, 'Wireless Charger', 'Fast wireless charging for smartphones.', 'Convenient charging without cables.', '/img/product/wireless-charger.jpg', 21, '2025-03-24 10:31:11', NULL),
(22, 'Power Bank', 'Portable battery for charging on the go.', 'High-capacity power solution for travelers.', '/img/product/power-bank.jpg', 22, '2025-03-24 10:31:11', NULL),
(23, 'Smart Scale', 'Body composition scale with Bluetooth.', 'Track weight, BMI, and more via an app.', '/img/product/smart-scale.jpg', 23, '2025-03-24 10:31:11', NULL),
(24, 'Fitness Tracker', 'Wearable fitness device with step counting.', 'Monitor daily activities and workouts.', '/img/product/fitness-tracker.jpg', 24, '2025-03-24 10:31:11', NULL),
(25, 'Blender & Mixer', 'Powerful kitchen appliance for smoothies.', 'Make delicious and healthy drinks easily.', '/img/product/blender.jpg', 25, '2025-03-24 10:31:11', NULL),
(26, 'Smart Light Bulb', 'Voice-controlled smart lighting.', 'Adjust brightness and colors via an app.', '/img/product/smart-light.jpg', 1, '2025-03-24 10:31:11', NULL),
(27, 'Noise Cancelling Earbuds', 'Premium earbuds with ANC.', 'Block outside noise for immersive listening.', '/img/product/noise-cancelling-earbuds.jpg', 2, '2025-03-24 10:31:11', NULL),
(28, 'Smartphone Stand', 'Adjustable phone stand for hands-free use.', 'Perfect for watching videos and video calls.', '/img/product/phone-stand.jpg', 3, '2025-03-24 10:31:11', NULL),
(29, 'Gaming Mouse', 'High-precision mouse for gaming.', 'Adjustable DPI and customizable RGB.', '/img/product/gaming-mouse.jpg', 13, '2025-03-24 10:31:11', NULL),
(30, 'Streaming Webcam', '1080p webcam for video calls and streaming.', 'Crystal-clear video and built-in mic.', '/img/product/webcam.jpg', 14, '2025-03-24 10:31:11', NULL),
(31, 'VR Headset', 'Immersive virtual reality headset.', 'Step into the world of VR gaming.', '/img/product/vr-headset.jpg', 5, '2025-03-24 10:31:11', NULL),
(32, 'Smart Coffee Maker', 'WiFi-enabled coffee machine.', 'Brew coffee remotely from your smartphone.', '/img/product/coffee-maker.jpg', 25, '2025-03-24 10:31:11', NULL),
(33, 'Air Purifier', 'Smart air purifier with HEPA filter.', 'Improves indoor air quality and reduces allergens.', '/img/product/air-purifier.jpg', 6, '2025-03-24 10:31:11', NULL),
(34, 'Dash Cam', 'Car camera for recording road trips.', 'Provides security and evidence in case of accidents.', '/img/product/dash-cam.jpg', 17, '2025-03-24 10:31:11', NULL),
(35, 'Electric Kettle', 'Fast boiling kettle with temperature control.', 'Perfect for tea, coffee, and more.', '/img/product/electric-kettle.jpg', 25, '2025-03-24 10:31:11', NULL),
(36, 'Car Phone Holder', 'Magnetic phone mount for cars.', 'Keeps your phone secure while driving.', '/img/product/car-phone-holder.jpg', 22, '2025-03-24 10:31:11', NULL),
(37, 'Portable Projector', 'Mini projector for home and travel.', 'Watch movies on a big screen anywhere.', '/img/product/mini-projector.jpg', 11, '2025-03-24 10:31:11', NULL),
(38, 'External Hard Drive', '1TB external storage device.', 'Backup files and carry data anywhere.', '/img/product/hard-drive.jpg', 6, '2025-03-24 10:31:11', NULL),
(39, 'WiFi Router', 'High-speed wireless internet router.', 'Provides stable internet connection.', '/img/product/wifi-router.jpg', 18, '2025-03-24 10:31:11', NULL),
(40, 'Smart Mirror', 'LED smart mirror with Bluetooth.', 'Features touch controls and voice assistant.', '/img/product/smart-mirror.jpg', 24, '2025-03-24 10:31:11', NULL);

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
-- Table structure for table `product_skus`
--

CREATE TABLE `product_skus` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `size_attribute_id` int(11) NOT NULL,
  `color_attribute_id` int(11) NOT NULL,
  `sku` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_skus`
--

INSERT INTO `product_skus` (`id`, `product_id`, `size_attribute_id`, `color_attribute_id`, `sku`, `price`, `quantity`, `created_at`, `deleted_at`) VALUES
(66, 1, 2, 6, 'WH-MEDIUM-WHITE', '0.1', 30, '2025-03-26 08:16:32', NULL),
(68, 2, 1, 6, 'IE-SMALL-WHITE', '59.99', 80, '2025-03-26 08:16:32', NULL),
(70, 3, 2, 6, 'FS-WHITE', '999.99', 15, '2025-03-26 08:16:32', NULL),
(72, 4, 3, 9, 'MR-GOLD', '499.99', 30, '2025-03-26 08:16:32', NULL),
(73, 5, 4, 4, 'GL-XL', '1499.99', 10, '2025-03-26 08:16:32', NULL),
(74, 6, 3, 4, 'UL-LARGE', '1199.99', 15, '2025-03-26 08:16:32', NULL),
(76, 7, 1, 8, 'FW-BLUE', '299.99', 50, '2025-03-26 08:16:32', NULL),
(77, 8, 2, 9, 'LW-GOLD', '499.99', 30, '2025-03-26 08:16:32', NULL),
(79, 9, 3, 7, 'BS-RED', '99.99', 60, '2025-03-26 08:16:32', NULL),
(80, 10, 4, 5, 'HT-BLACK', '799.99', 20, '2025-03-26 08:16:32', NULL),
(81, 11, 3, 8, 'FW-BLUE', '102221', 123, '2025-03-26 08:26:50', NULL);

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
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(11) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `f_name` varchar(255) NOT NULL,
  `l_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `birthdate` varchar(255) NOT NULL,
  `phone_no` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `gender` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'active',
  `role` varchar(255) NOT NULL DEFAULT 'user',
  `loyalty_points` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `avatar`, `f_name`, `l_name`, `email`, `password`, `birthdate`, `phone_no`, `created_at`, `deleted_at`, `gender`, `status`, `role`, `loyalty_points`) VALUES
(2, NULL, 'omar', 'khaled', 'omar@ws', '$2y$10$61VA3IX7dC9RSK.nc.1RueR45XsdgU/ZK.zDeIJ8DV1F0CxKpboMa', '2000-10-18', '01286246292', '2025-03-10 10:35:57', NULL, 'male', 'active', 'user', 0),
(3, 'uploads/ali@ws/avatar.png', 'ali', 'ali', 'ali@ws', '$2y$10$cT2SNzyB462KlCiwvmkN9uvTIHMZNG7TU5ca31CLo68VOmSEkgk4a', '2000-10-18', '01286246292', '2025-04-08 09:21:02', NULL, 'male', 'active', 'user', 0),
(2147483647, 'uploads/profile_pictures/33864171114794816dbc188b7f979d29.jpg', 'OMar', 'Khaled', 'ok3050802@gmail.com', '', '', '', '2025-04-13 09:56:48', NULL, '', 'active', 'user', 0),
(2147483648, 'uploads/ahmed@ws/avatar.png', 'ahmed', 'ali', 'ahmed@ws', '$2y$10$Z0jp61c0NbOHFXv6cUABvezUu7mkdPVJgUn8znyyX.qDCckD9qov2', '2000-12-10', '012312', '2025-04-13 10:18:06', NULL, 'male', 'block', 'user', 0),
(2147483649, 'uploads/khaled@ws/avatar.png', 'khaled', 'omar', 'khaled@ws', '$2y$10$X0LI.pVGwfLV3Uo.YRcbye1rR3c.ZTjJ/2CRLC0l02sOpMVt4V7EK', '2000-10-18', '012544585', '2025-04-13 10:39:43', NULL, 'male', 'active', 'user', 0);

-- --------------------------------------------------------

--
-- Table structure for table `whishlist`
--

CREATE TABLE `whishlist` (
  `id` int(11) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `whishlist`
--

INSERT INTO `whishlist` (`id`, `user_id`, `product_id`, `created_at`, `deleted_at`) VALUES
(19, 2, 6, '2025-04-13 10:23:09', NULL);

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
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loyalty_transactions`
--
ALTER TABLE `loyalty_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_id` (`payment_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_item`
--
ALTER TABLE `order_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `product_sku_id` (`product_sku_id`);

--
-- Indexes for table `payment_details`
--
ALTER TABLE `payment_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

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
-- Indexes for table `product_skus`
--
ALTER TABLE `product_skus`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `size_attribute_id` (`size_attribute_id`),
  ADD KEY `color_attribute_id` (`color_attribute_id`);

--
-- Indexes for table `sub_categories`
--
ALTER TABLE `sub_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `whishlist`
--
ALTER TABLE `whishlist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cart_item`
--
ALTER TABLE `cart_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT for table `loyalty_transactions`
--
ALTER TABLE `loyalty_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_item`
--
ALTER TABLE `order_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment_details`
--
ALTER TABLE `payment_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `product_attributes`
--
ALTER TABLE `product_attributes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `product_skus`
--
ALTER TABLE `product_skus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `sub_categories`
--
ALTER TABLE `sub_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2147483650;

--
-- AUTO_INCREMENT for table `whishlist`
--
ALTER TABLE `whishlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

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
-- Constraints for table `loyalty_transactions`
--
ALTER TABLE `loyalty_transactions`
  ADD CONSTRAINT `loyalty_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`payment_id`) REFERENCES `payment_details` (`id`),
  ADD CONSTRAINT `order_details_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `order_item`
--
ALTER TABLE `order_item`
  ADD CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order_details` (`id`),
  ADD CONSTRAINT `order_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `order_item_ibfk_3` FOREIGN KEY (`product_sku_id`) REFERENCES `product_skus` (`id`);

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
-- Constraints for table `product_skus`
--
ALTER TABLE `product_skus`
  ADD CONSTRAINT `product_skus_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `product_skus_ibfk_2` FOREIGN KEY (`size_attribute_id`) REFERENCES `product_attributes` (`id`),
  ADD CONSTRAINT `product_skus_ibfk_3` FOREIGN KEY (`color_attribute_id`) REFERENCES `product_attributes` (`id`);

--
-- Constraints for table `sub_categories`
--
ALTER TABLE `sub_categories`
  ADD CONSTRAINT `sub_categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `whishlist`
--
ALTER TABLE `whishlist`
  ADD CONSTRAINT `whishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `whishlist_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
