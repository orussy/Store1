-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 05, 2025 at 11:49 PM
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
(20, 14, 'Parents', '654 شارع الشهيد ابراهيم احمد', '', 'Egypt', 'القاهرة', '11865', 30.06446254, 31.46122057, 'exact', '2025-09-04 15:56:39', NULL);

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
(12, 14, 1700.00, '2025-09-03 21:32:00', NULL),
(13, 4, 3000.00, '2025-09-05 13:20:51', NULL),
(14, 2, 150.00, '2025-09-05 19:18:03', '2025-09-05 19:18:08');

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

--
-- Dumping data for table `cart_item`
--

INSERT INTO `cart_item` (`id`, `cart_id`, `product_id`, `product_sku_id`, `quantity`, `created_at`, `updated_at`) VALUES
(4, 12, 1, 66, 1, '2025-09-03 21:32:00', NULL),
(6, 12, 2, 68, 1, '2025-09-05 13:03:32', NULL),
(7, 13, 1, 66, 3, '2025-09-05 13:21:22', NULL);

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
(24, 13, 6, '2025-09-05 13:24:01');

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
(1, '0Qk2smhi0A0ELPl0rhF7dRIhQbccxZvaBXhcbiPLnu8sIh1tWCq2IN4uxt1eGEnR2wmx28KmaCHxHmDVzPKgHvKp7hwLrpTBMzu24QPiFOYpkjmDkz4zy5eWUs8HKfESZv0oXheTaUZWi2UccztTcBqN8kFGQ5OP7OWiXS4r43bERjKyMRZiiSF1', 'This is a description 0595456', '2009-08-06 00:53:00', NULL),
(2, '73ryrjhoanQLOuc65Ngymr1TsKrt1iZ6j6RkT7ARg6nwdoE2axSocnuoOGlS3PNTHJNwFF6No0dMWuZvWtpQAJqTPNA7hQohZS1o030ZrKnSK6bfna6bYDlikhT5tWVBZeUu87LgnEu3QZ8jRSkt8QS86zgWPQcJLy2oQD2ZMmiPrPYj0sYzn6WIsJHG7xLbYZpithIfxp1SeHx4RUaSGPgGCQl8EufcHBFHxVBqyDQh2kf5tu3aslgKM2h6', 'This is a description 8595881', '2014-10-16 22:44:00', NULL),
(3, '3tVl2isO34HGRZKzvXDBPvnRW5g5hOdWfiSon02tQzMPfy53stZRT0JsnJ4RKeBhqIjF6lsYtxU5SV3ySURQ7ZN5b2y4TkdUz3xprhBiMEeSMqjPwWd6fmZCUTIBgM5PbZR', 'This is a description 1232472', '2017-08-28 00:30:00', '2001-05-04 22:21:00'),
(4, '2GeLPqU5lDFEbPIzEvPICH3RQx4YGAAMDlUSPcbWhKduLLk1vJueQ1gzm', 'This is a description 1239704', '2006-12-17 05:30:00', '2007-06-04 21:36:00'),
(5, '1loZkMlLevR3jglIcrq3ZrcwdlYg6HwfhawOFMI7SVlNERnT2G10oJyAeMdAm', 'Description number 3302280', '2006-02-04 05:29:00', '2020-07-13 04:13:00'),
(6, 'AIisIjDpTSBxgbSYVQ3mRUq5ZZJcodR3GLX5dV2xJDSxQbIDP48nNO1VPDJ0bM2iv76pVuuMyQQkoA4Yz6FvNyNklGi5TnMMeKqj4jVbSPkjrQqsWAR', 'This is a description 1160770', '2021-03-30 22:55:00', '2022-01-19 23:22:00'),
(7, 'oE40I3xnPsJlu6T7c3lvXa7nCjjGO6ivKiFEPmViDE8wu2kcFgCx4HUIzhqApKVNaljtezWIdewHYpxfrkawO7uhrtrrTJf7r8FjBm8RoniRa', 'This is a description 0909709', '2021-04-06 04:10:00', '2020-02-09 22:31:00'),
(8, 'W5z8QoidNYXHqbDSve0bqlHjW8C7XKfQdGyMdCqoxdqkU3Ro5wkDNtrKOmTpVxegrDyMYViAKeM7lLREv45R', 'Description number 2226261', '2001-05-11 21:54:00', NULL),
(9, 'KssBhYKwQtIR4Oly85IFzBk0BHKUZYjozyeNGyKWwiGlkLtAbn20pygVUAYhTehmXeTknUvpMh3OXcW6iAs8taOcIrLTwRtQc5BK6H0xGXZ1wp8xMsETjOSYL1xYE5f3AF', 'This is a description 0711305', '2015-02-03 23:38:00', '2023-12-17 02:46:00'),
(10, 'IWGn1QQNRfaygOgciUwBCh1SE82tWTfeznGETl6X8vqad8LQxSGUZ3rroCUKP1a4XMLE4ePHdqfNKbOzzzRrNLhkRSVmUQNZYlIjnRhC2miwbg7HcTVhcZnvJ0c0ZPdVw', 'This is a description 5283341', '2010-06-22 02:12:00', NULL),
(11, 'PdSIdN2DzYtVJofaAkXvFpNRR3gMyabm5AF02BIGadw46lCKvDuw0E5VAXyWZaH8g7lDWcJcEfTepHLehHwauGEGS54INQoWyVKBIerVJR52wg0ItJXjY8DO46toxmVl4FGMbz0nKItjcc5cnygk2Solz4rkv3DMwhKZCPXNFDZ7eBHnJmrLUPu40SSwyoPyERrqteM8eOtNwZLxdcOAbMiK5WHEZKI0dcFFgMJtHMxFxLJSwLVm3gfh', 'This is a description 4466637', '2020-07-24 07:01:00', NULL),
(12, 'ILOwkuHaErUWfdR2vtvpZggXtnCZH2YdiGYMSY5FNy1qO2susITQB6cO5MeDHpygVkuJTMfSEG8OUfMgrTN', 'This is a description 0314253', '2021-02-12 03:16:00', '2010-10-18 04:21:00'),
(13, 'R2dj8J71oS761YoytDSUCr4jVHE7yIHJFc4kMpUOoCzapW5fwR4xDoH4ndjjEOojW22GxU2t6JjcdePM16sV3ipNmmjgTVcGox8hQ6IEMB0wAW5Hoq7eps5g8D4Eug8Y8f6qVyFLQBmbi460jcFcD6azVQ8dmNV4s2lq', 'Description number 0868662', '2017-12-02 05:39:00', '2015-05-01 01:07:00'),
(14, '3GPxXPPx0EQTQSRrKPSyO6pHVEc', 'Description number 8855841', '2014-12-29 02:37:00', NULL),
(15, 'Y0I1cY7yA7twDR1TjYU00QJovAVIZ48RSSOA3Oo3kHCpxwgh3FIveYMnnHpMo6Y6OnH8oSouJIRDSxtkZxSSobdiGo1nOKFbeeLVF6c5oFsV23S0pJfxXUpT1rhjfPjHPEzkAVD8lSr5FP6tz7UBuvR6ia1OnnjUYXLdKfhtoZTmRAdLfSQB8oRdVMWcWzWmwo41xa6', 'This is a description 9915064', '2015-11-24 02:42:00', '2002-10-13 21:50:00'),
(16, 'XB4PUt6SycO54E6JBqAPTWaeykiXdGAY4wdn3YZppfu0GOMgRgwDu4DwTpx0JlDT7GTPhqiG4eEVbOU58SGRiWmaZWYdEgiWymOLiq24ZnsxguYhXyL8daGMoMnxUUGpmwIWV06WEYHESp5LgJV7XtAaPOAhsIRIax8klGnQTdhGf6Sg0P0s75S5WEFcq7nBOgVJTmmCLBoN8p6Xy4jxBmhGG44OBN6lVZjp62cyOkQzoHwUmqC', 'This is a description 9915697', '2015-07-11 23:41:00', NULL),
(17, 'oeqKJH5pu7pVI7zsOt7MoYztkueSuTC1THCcyOlTrtXy0Kx3o1edopoESTEf36e0BmprkESwex8T6P7FWqa6kByMJtMFZpda7RX7sVc7L4ujRSCwB6p2XTDRn8cOlRPshye80HTsGTD7JrlJ5pIS66CjE2n64IWckba3T6OtkimUTzon48GUbPrGUVJoAuafoTrlmoPD6cTaEt18kBI3JURHihsC5aybhRWAyEtm0', 'This is a description 2471038', '2015-09-22 06:04:00', '2021-06-19 07:39:00'),
(18, '4IOQbVeo0iPowdllSQm8TMdhnRSEy1FcV6R3oxJz8j1VNk1EKUlkBdCYu', 'Description number 4773883', '2002-07-22 04:02:00', '2017-09-16 02:10:00'),
(19, 'DCm1eoB8xuHJc2YSWz7EpiD6MuZEZOGyD02VSowpuAtVeXMvUQEyVZgJypdSVzcS5zlz5OXcdEfZ2OOhuVNQe85Zawdtn1xdYKJYLNhArCLFOmW88xs5xq2No2d7JNtwU1KFJxuM1nnds5pKjxhfarGFNMBfcn4HWwKsOFxwSeo3Qng8knWyeWfNMKLxIcujqFFBtcxqqg83YPy3GWVAmI27Ug0P6wZkdSub8p2S', 'Description number 3101809', '2021-09-18 23:45:00', '2005-08-27 01:37:00'),
(20, 'Nv2KkyzquCdDIAe7Elbeh4gO155xji7u11QqCOs6dyNC77e1lxoDqNSiwb5Y1enmxDsqR1gLtqLZFxVXMoxIdZFm03cPkG666lNyEaD8OThpictl2n0oBfAY8zE2H0fTwo6ww6oFYHpDKIC1KnRoqaxG8W7Vel3Iz5wrZehCXGOHIg6Auq1CjNvkRh6UyW2jpim1YIwLsKqBWACdvGSLxLMruX1xkGaOcGbFm7s5HunTrSPgcviud', 'Description number 5840539', '2002-05-17 21:52:00', NULL),
(21, '0uiaogeuXyBMbLXYpa8FklcBqJz4GOT0ErBlRPDqJJy6x3Z7KWpCsVBHzl2kqVS1sl4WFHgYB1opPFf5GTBH1B8eQIsBpef7sSZ4Ppv1X61X8lanyTlwtVz2D322RdwI3ushgH2xwtlXqZYKz8SHRgSowG0F4KFEtdNpSteeVpA0YErL5BmKMHtKE4y12AIrFJ1OJpRutqrT7IWZBp7n5VkWIHHucQiy2GsPT0gSAgoCzSlYtYdg', 'This is a description 2216695', '2007-07-07 05:25:00', '2019-06-02 23:32:00'),
(22, '2lQTe2thuLG2x4zO7Ygutxj0Frdqnz1wfEGfuayPP8OggFkmvGomVRem8lVJAlX0DBJowNFFnXZnqbkcIvxN5V4eDKEUKWr65kIsBBM8C1JDYa274KGxwZLXo7jJNrLpLDvq8FKDpRIQPuw1LSuJymsu', 'This is a description 1840512', '2015-09-22 00:26:00', '2000-11-24 00:03:00'),
(23, 'rmqI4MLxJW38cZDTOvpeMoh6h4tprmPV0zOTh6Mb3tnBIcYEmi0ap4l26zrxBHgcMdNigcVJlytWIepxBnNl23zocEZnrzJR6RjBikoNq2sshfCj26qeE6s0UBDGOuhKyGV27VIq', 'Description number 4978536', '2001-07-19 06:32:00', '2001-04-13 07:52:00'),
(24, 'vs3XdzHGOCMshgbELpj82tLIAqIVjSkyBqhUhuAcR67wAQR1DlMifEikX5WBDBTyWzUpdCSpr0e2CLypTKM7tXnAeBw4cGK4ogG5risfb0jNTv5MOnZLJtTMGGVVpR2p7soQBtpFxsrS6gGqxLDCcIJcDcTCfpNZv5pcEOXEUN3J0LCtUxhJzRFnJP54kohs4PYSyGDJbGRjm2Jwfh', 'Description number 2814238', '2019-07-14 22:02:00', '2017-12-05 04:30:00'),
(25, 'XlebPdbjLdGB1EciO8wIpAN01GTTK6nkPsQTptwerWQDIRtLN0FNlZzn71uAb4gl2fhxjou6ZtcZxLcDR3tH7bN4zhosrqz20d7ron3xBBTQaCIWss35JyGCyUUeLpCYt', 'Description number 8615200', '2011-07-03 06:13:00', NULL),
(26, '5HTlpaD3x2UstTKJTyLrV6WSxMaR6ZhMac8faAeBw6GwvQlqYbYCKLxtf2duqMUoHyheKtXS8VGgPRGp0WJvJFhwgIRMkszLGX4227o574P2hmq1GMUiGgyKMNnG5vrHKaEZ5QryOvLcDsY8EiysHGd4csGMCdauVyenhg20zUDzI8nQdZsY60Yq6Uf8sKodkfAYv2IGAzpVYa0aasn4NQQ4ChjrkiWh5fMY3ARRLy', 'This is a description 1631208', '2022-03-25 23:00:00', NULL),
(27, 'pklZMPS3ZkKLkA11AGyBsU2eebhRSl31Ywl4YrJZcpdXOc8ioFPxCjhTti2F6GXBrTqN6nrcIE5yZKIQbd7lhFDvf8tfoQqg67GyfpgtMqJ5MaNGYY4Qq5Q2HvJgjDEL08M6U14SGzrHSZLOi8ErDYuZSEI1aLILMvEvzo0tnKEME3HXjl1p4Gs7odfTnXkIWaZ0hI25bh', 'This is a description 0577744', '2007-02-07 07:21:00', NULL),
(28, 'liIajdQHLhDpH1i3VgoDLEtZSk5FotGpfYFnzER6F3YysN0f5A8z8y4WlOVHscsFfWIXEBJdB28kHVM', 'Description number 0078035', '2014-08-06 02:14:00', '2021-09-28 07:09:00'),
(29, 'PVY8XxCsfN4u7z8RoyF8aRWoo5BSfdWT33RoWFmN', 'Description number 2416596', '2007-06-20 06:37:00', '2022-12-07 01:38:00'),
(30, 'wYVLT5aNTvecoXIJHUsNzNQjufTERzx12TksCYDSDRaXr4Ky8AGTAxUZjt5H28jFOhiz4XW6woHZUTv2AqkYEkCz455rg54CZPvLCvNdjNLDyfwomKCCbvmPJay7zFDhru1p4TOAEk0bvNjdlQFcRXg4SvzEaDXbisvWS07hiR3PhyN2yHkQFaDJam2fwnN5R5cGBGwffHrRMCQbIK1cQNAuzQbUlRxeDkd5aSsbsmV6b', 'Description number 9245451', '2022-01-05 02:38:00', '2004-07-21 00:38:00'),
(31, '1uPu8OO3R5I', 'This is a description 6243087', '2012-08-18 04:16:00', '2009-01-30 23:15:00'),
(32, 'ioreGYNWK4HnOQckrFKG0yiJJ1fYulcFfh31DRdSntRzX4xAtCAp4aUFMA08RcC5HdzBRGYU', 'This is a description 5171934', '2000-07-28 07:29:00', '2007-03-21 22:38:00'),
(33, 'YDAjZJVLmbpOMu1C2QDnaGIj4M8zkNejNCBuFfHSzWi7Q6toA', 'This is a description 4329731', '2001-11-02 04:28:00', NULL),
(34, 'kQIjP', 'This is a description 0672995', '2004-10-17 01:32:00', '2003-04-15 04:26:00'),
(35, 'MtfwqW25h5rFawwuTCmbhW42lT0j3Xy4U6rga05r3jy5mlhkJlbkhgqREGd6ZFqq81GTcu3uu0nTlO0qGMGlGGLeFQuCVkCbiotXDnoLUimlphPJNf6B3M8uVEE6YXQtxHanzhFB4U5lyHgWu4MJLhnn2OTGitiXU6XjwUeQwHsn36Nt26MkrSpN6P1qA7a0seUGAmD0PsZmhrRup4lxse', 'This is a description 5946061', '2001-05-02 21:30:00', '2008-12-21 23:24:00'),
(36, 'AsTLWZc8YyA6KN8of132hYuVCRocHhokoQVAp2E5FdriohwCQmISAnMEyCpn3VLIu2eupf8yLMDApOpIRSSc5b47florMj6UHd5Riq3cKOSVaJWG8c6tjncjlFlp77Djn8302zXfQQAEgXqE5RpRXyH2vBtBQnS2sBaoW0ACA3bGeo4cKCYdJX54xjsU6jXOmsJr2y6F07y', 'Description number 9338001', '2002-07-02 03:29:00', NULL),
(37, 'Si8W7PXSfdEo4tHquY1szvd17qZ7eFidDKItujcRj7ANr0R0e6TPuJGwAnpHUmf2ZZzmurHdySVZRbU0VWrHNRbemJPZzNBjLeFw1EFyLpLyBAwLIKm0GIKYADqeq2hyFJRPvrIm8Yf0arwJLCaHNZv5uZAyZsBUVaWqURwEQngHf0EQeqW3YqEVSWAaaMFgCfVQcYpbnv04iLgeQyyU8nYRA3QgRDVzm7bsV5bxqXxDU3eu', 'This is a description 0574943', '2008-09-07 00:11:00', '2019-09-23 23:16:00'),
(38, '2GPmyVeAHhUFFs5Bd8TBKpqH7xHamSo6DF6HkTThhdfoKfqmTFbrPRjRtF6nCxhDy6pi8ZcBRCYYbpyxDkpcWJWp2XD30WS5jKaKbsmuiUKp5ljU4cl1DpGoscdeBJkfjiQcbcSLnDw25lpdJxGXpwaDdPrSyoqeaEL3HAr7oMYwdsyZjVEu0zvYZhE2baauruhdLr5V', 'Description number 4128297', '2008-07-03 21:22:00', '2015-04-12 06:21:00'),
(39, 'GIXneTOqZCD3ImM1iyEwzMbj5cpRe4U2slWejoGwZUDHvplQZZLIU74rBfhM6vdmQBUm1D15RqAd0ZayPEFIyHVsBNrpGpWgsN4rqG7nWHklnBqvC3Kmb2dYSlGVY5q2ExgL08u660GQNIgkXquV1HK0', 'Description number 6383053', '2015-09-04 03:44:00', '2019-01-20 06:10:00'),
(40, 'UCazsrPE8ox7ePQdJpWtyZygR16UOyCbQ0qvqGAWsTnPBNYkzVg5Bc8AHc4Er4uJ4KMVWXs87qJcFVfxJ3al04YtE3vb2Csy52JQ8DuTNev2wVvgZtQ6AomQrHmSauGP4EmOc0GSjw5Vf43D4nuoFqpFZ3UEVsz1MoV2Pv0oNEcPfo4MfDoO21C2N1AdnienpaRS3nciw64LBdF1utbb', 'This is a description 3955980', '2022-04-12 02:50:00', '2009-10-07 21:20:00'),
(41, 'WabGUKWWPOSd1IukxDry6prxTs1sbK1DFMBVKyMwpPWuLJoVmmpYeA0yrPvHnonffBJWnSEJ0pQAwWKya5AvcSVVyiKBlbiWC653Ecizh16D6Btn71gGcWWbF8ewHx2c5jNQTdXQb6cFwtpus8lbkaPRk1xfngsacB8g14mhMoNY71ENdovWaJuQuuYZSAubDKTQZyxXKVQPNs', 'This is a description 3424777', '2008-12-05 22:17:00', '2012-04-22 05:18:00'),
(42, 'Va8tMOSBsP1jgJvx7yS2IBfHURvAICPILRkiErFJ6VFC8tcEGjw', 'Description number 9425665', '2003-07-06 07:28:00', '2006-04-14 02:05:00'),
(43, 'IT27FP22CLeeBLk6Jeizl5glmVMPnH4jqEw5pXVWILtUMWkwndEkCdlb3IVZf7UHznX113PYtSetT05AmlCi3jLPfstkkZf2jLabCrkPZLYwENOntRPNILQJwTUL4f', 'Description number 6277318', '2001-07-25 22:11:00', '2007-11-30 00:23:00'),
(44, 'MF0BEEuF5zvJyrkBE6QLP0Y8aThKa8Fr8icniJkgeyDJt600JIJRgpVXzODrfCoa4r0w1dRfTMUVMPi7lMoV5DPr3an3kKRC6EYNQBJ46oCVtGXwDZz0L0FpkYnBat3R3KMFJvqiqk0PoUtCmToO1W1XVIlTcFfZ8cD3LJI5snusi4332INmVwd5J8AM8ZM44jwJ', 'Description number 6580377', '2018-02-21 07:12:00', '2016-05-16 07:35:00'),
(45, 'dxDMqsLlMORLOgv23JSZKaREwXv1VDlzTMID8lW8cSMn', 'Description number 2322864', '2010-04-13 22:11:00', NULL),
(46, 'JV6xSKUzTf5ieTysHCS3JYrYDPy3M1Econ1wK4sX1JTEbB28glkHh2iD3ejRy4vk4ttHFsvYxiBXMgdevWdg', 'This is a description 6732768', '2010-03-07 02:28:00', '2009-09-30 23:41:00'),
(47, 'I4z2udRQ7Xcji', 'This is a description 4655508', '2013-02-10 08:37:00', NULL),
(48, 'uJzFna3kCIWSF4HPIknJsz5x6s4xtfW5FBeW0Kq7cDevP2fwbmOpznj5PWJjd17veSobreAIfsIXFX5TFYLHQ4TWjUtbM7EPl5qghvydDRWfz23rCGbHuKryRAEUAaJnVUVD0DTHZpUYLBpCPCBEth6FOxU2', 'Description number 3472049', '2016-02-04 02:25:00', '2018-06-29 06:41:00'),
(49, 'lMrufBJTXNs5MHFQ3kUOHiYrfKHfYoKnUL4IUlkSgGDTGvqFhLAEnLFxcdSCcDs2gkwIschY8MlLf4mQf8BAP6LjZcRW0yjHMkFGWkFl6M4ulrL8aPaKzjcRwynDbwthyR5xCawG5PTmkGMAV7bn2VOfHNLw2fZopPXVLKR0FQjBhMDAfA8eHb5junyJqDm8AgZyqbAXFfZX03', 'This is a description 4982825', '2010-04-01 04:00:00', NULL),
(50, 'njIveloTzRXWhLeWv3U0qa7sSpmxCNJJ2RIVOAGacX0mfgC75kOhmAfbELwvIVZLGj3AxOdatPFBcSnrUroVltzCX85HyqIfYNO3C3pCKAjXjQK5jgwUM5NE1t1yImV8bnIfcuKbf7RcrYVURVw5sluJ1JtvRhTUEf5Wnb4PknOTkqyzHLwMQwvBTwmi3w84iI62hLFrjymw5jvYArqTDKDvgXz1zE535HNdd3PFfZUFR6H3sNwUVVXqja', 'Description number 0663878', '2005-10-24 07:27:00', '2020-07-01 07:36:00'),
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
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_ID` int(11) NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(2, 1, 'percentage', 40.00, '2025-09-01', NULL, 0, '2025-09-04 14:50:33');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Pending',
  `tax_amount` decimal(10,2) DEFAULT 0.00,
  `tax_rate` decimal(5,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`id`, `user_id`, `cart_id`, `total`, `created_at`, `updated_at`, `status`, `tax_amount`, `tax_rate`) VALUES
(124, 14, 12, 1700.00, '2025-09-05 12:28:51', '2025-09-05 13:06:07', 'delivered', 0.00, 14.00),
(125, 4, 13, 3000.00, '2025-09-05 13:22:02', NULL, 'completed', 0.00, 0.00);

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

--
-- Dumping data for table `order_item`
--

INSERT INTO `order_item` (`id`, `order_id`, `product_id`, `product_sku_id`, `quantity`, `created_at`, `upated_at`) VALUES
(35, 124, 1, 66, 1, '2025-09-05 12:29:33', NULL),
(36, 124, 2, 68, 1, '2025-09-05 13:04:44', NULL),
(37, 125, 1, 66, 3, '2025-09-05 13:22:35', NULL);

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
(17, 14, '253f3c9b28ee53f3a3d6218e3c66599d776b908eed232291a0acc57a26167a96', '2025-09-05 00:46:30', 1, '2025-09-04 23:47:29', '2025-09-04 23:46:30');

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
(5, 124, 1530.00, 'cash', 'completed', '2025-09-05 13:06:38', NULL),
(6, 125, 2900.00, 'credit', 'completed', '2025-09-05 13:25:52', NULL);

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
  `cover` varchar(255) NOT NULL,
  `category_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `summary`, `cover`, `category_id`, `created_at`, `deleted_at`) VALUES
(1, 'SoundCore R50I', 'High-quality noise-canceling wireless headphones.', 'Experience immersive sound with active noise cancellation. hello hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  hello  h', 'img/product/r50i/13.jpg', 1, '2025-03-24 10:31:11', NULL),
(2, 'In-Ear Earbuds', 'Wireless and wired in-ear earbuds with deep bass.', 'Comfortable fit with superior sound.', 'img/product/earbuds.jpg', 1, '2025-03-24 10:31:11', NULL),
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
(26, 'Smart Light Bulb', 'Voice-controlled smart lighting.', 'Adjust brightness and colors via an app.', '/img/product/smart-light.jpg', 12, '2025-03-24 10:31:11', NULL),
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
(10, 'Color', 'Silver', '2025-03-26 08:14:35', NULL),
(11, 'pKkrQzVmKkVk7qsDfbOdksk3vJW3oJFQ2lydfv234OebmhFbGIJ0nS7vv0i7Tb5XFjUB4gJiyCLpliFKdalbEUsMFlOAGpQpXMWP7gJ6WOuutcZZvkc8b51Snk1Ics3MWxQZlP0OShACzyQbTrTmGCTauJcSWeu1LgXwE', 'OxRCNLDMdkVCo2mM4cAeESNJJeWabGSFJ5lXFYZYQ2j2xsjBTaeR2cYRz2l2qWmhOxDnyKmnTvX80ITjq73NOJOaOCXl8Da74Ln', '2005-02-08 04:23:00', '2020-03-09 05:54:00'),
(12, 'JJxeYITo17CaWmeLRqONMwVe7cSkuPf2EgiIFoAEorZJYy6UxRAWzS34fDOo8MDmBBW45040MglxBTgAqEMaBe5zCZMGAAbr2qH6XncHx5N2BNfTVIUdLxYv2VENaox5Z2TXuHVQjYYwi7ZW6ZgtsCcxf1dWaWNCk5BBFVdDCjgdEIdpSOKF2BuOCwDpohZ0cpC2FtY2kEKKXMR6C4todiTEqfeQV6YwS41yeeK', 'KxvKw07CcfStuPjTKQUI7FqXKiV0bnZUkqWomxDtil4khgihyU6FHoJritY74tFYGF3VgF05CE374bNbXv4Gw6TUdIlYRfnM1kTk54F73EFDwRaPHZNbkz2vhXD3OieUv8Xei8mQ5ROuoh3GfmVm0oMlmmz3kcSF6L5cYvsukdlOWU0TsuLsleMHXDvSQFac0muz7kWxoLCTNWNtJWc7zc3Qd8ubm3V4G7r0YGfiGAdLKkG', '2021-09-05 01:18:00', '2013-12-18 23:32:00'),
(13, 'qkzOGvdvLliw620qnjYsI8UyXR', 'BUGV', '2015-06-10 23:30:00', '2015-07-07 00:55:00'),
(14, '46L7', 'qgMkVwcnQKIhSqFRluiwcn2dS1vWN8M6xwsMxpwLQHB4ToIxuvN6xHCKkH4KNv1xYHFLOT6SsCHW7Ezb6ojOOZhIPLolCR0Pe3Y02IUk4UH2QhjIgGA8XU4um1oliCiEGqlaBstBJSr2NHp7G0sWKvxOTiVv0FvrU6ZS4K17bNCPJNdyhhAilqq0nAFSOxVHyvLu0CscLpRAaFtSceAgWOnHEP5Kbww1yTnGbEsjhHUu470R', '2005-02-20 05:00:00', '2016-11-23 08:30:00'),
(15, 'rLsYFfrhlfwMxF8VhPa6hDEJGBqON1EG3nVKdrg1T1V3aQSM8rqTnw1IqJ20wWJnV01NYdHI7JIoVU18P6M2V38MY13odeWCfB0YFElxZkk2rD6QqGSoQHO2Tmk52DEqf2HJekhh6G8cGUK41TKIGcS7bCsPQch0nOHYQX0bBgUQupLLxF7HoAzWJVZtwQ8P8gGm2SGBABVMLPkApsGxM', 'tD6ZtkFlU7Xa3oBgmSHPSeKrv0SuIStDW10gdVoTEzrOoS4Fr4TyLfe3FkFhB1T5kOizo5pHuQMWYylEL1Oc0mUHUdKbiLr2OyIvN1dKnFSCGtleBAEJKc17uW0aItyxRNwfpRAYyVWnHxGhMh313IYSpbLuHesXEfYrqnRgIhrrt2nLPwS', '2012-08-03 21:00:00', NULL),
(16, 'UFTezciJtRarNy12GcMr2FqyWZOJBJmjruRVX0jJVWnDmE0yyVmbM1jGk1tTImKTGHUdiL3J2cQy42eZXBJLj5Z8oX6zNqL8lRwYcejaG55oCeSzGGwpU6qjruDTg5LFRRCsKRCSQcYjjLEKxOselJNCs8mpg1X4xPt6VmtUFiXKY1hb4PQ8PAdCX4FauOUCYUS0UN6EBdsTWAjzpHR5LKkItCI', '63EHkqSpavR5Y3jb0uI7xKRqnXEmRVcDL6HDROHnkj2IQ5E5xCB', '2016-02-18 02:18:00', '2016-08-11 21:21:00'),
(17, 'Ha38pYD3vCTSNlmpEkiReIWgYSSZFAndg1y5gbIMp3Olv5NGeq', 'J7yxOPowAKmEWrk8CWFUEufHVBjelYIAjZURqtiPidGH5ASsmNEJgBAGiZjclEMQCnrd8R1aZYtjGu6ET5IreokwOB7n1kSnQIWKvIexeeYMUOdJv2fTgfNMPHUjpiQJagwyRkOkNs3nmCu5rjcNDEt3B8abk0KHHuLlu8XNibhzshdxcdnJEUjPiWpAksF0jkegTsfWirFnP', '2007-10-03 00:53:00', '2023-09-06 04:28:00'),
(18, 'Z2isUz0qbrGzL3ghHfBbqmraZqfBo1DWAVA5yPWFAQfLFu5oLgihsXQLpvKycc7dLnqRNpOFObWzxn6AHqjME0t1XjxbJM6Y3zXHRPhsRLBivLzFe3SXav13frjgafpj0gFvOfKut0AFFcJYzQ', 'IWN0CXHYArFNIn3Mkljj8UZeMlMnGtisKdSppyD721SNSks5dXLmuA5hoZobJMAtJy2ynR8Een5K7c61VLRCQYIfvGEgEsPQ5IHySHWGxJNSzmhwHZauDtlMM6msqJ0OCZBZO5faAyKvYliyEpxluUW1c11iO7jpOG7CZtiQrpQbJ2LhJejm5J1qu0rUPSCkYwFrzbOMmCoCoekq0jaS218VXFISLjb', '2014-01-29 02:53:00', NULL),
(19, 'UFNekhcDikmWqgR2MHWhdiMOdW1XJW6kO80xHswPSbZ7SZ3uqqC5jT7abPPQs83yV2SxQPuCgqgwSLevFqLhhMnZfRyuEFwQ5zO4wyGdYfaRT6ReYBN7w0PqqaQls5eskeJzd8wXtYNeOkOw6QqaB3aFaySbVAxVJVm4ifLQSCm', '5CjZ0ZDau8rbdwInPEwiSaPTaxEd4gutPOlyKPOOCZl7', '2017-07-19 04:11:00', '2012-12-28 08:36:00'),
(20, 'aOatMIqLk7yYPAugqWapsdkQr4IgGD8FaX8elCf2GQX7yb8llwaJTwLWE3uQPvh8SbgoxzZypOy4RnWoTw6nmwgnY2YaIe7ChAWmqqOOwtFcUqumXGmeV8UfFQm64Hjrapc3TtDnbMDCDWutPCGWAthIidiVDgZpXR2LeyNbp06dL17jC06W1Be0wrGfpImSXSg47r8yylloxkZRYwB3LpQxk5XgIxBkhjJDJb31CW6GPS2Qhw4Hxm67G82QE', '0jACN6HBxMDZ7xoHxyBksD8xuYKWp1pG55IyneRU601ZyflaWK', '2000-08-17 00:50:00', NULL),
(21, 'WNJnibu55oMceXtQIAaX31HrNgnCJ061rjkalONooZlMudnbcH1iYlJWdvj5Fqefvy2ZeFql', 'tchWSMcmM0wGPPc2Bn2WrOAspzeQaJFopUig0o0HGheYkA5fwQUtFshudUKph1NtcqgK2nvMTxbJO32XCSqRU8vmCDpvPv7ExSOyLikbIUrbaIkcaBDGYnyhgNbZQ4FOpBjDRg8Y1bKknEFiFO4DTkUEBUsTGa01oKLOc8BgxPJPoEqQ6rDnE1LHRgwl', '2024-02-13 05:37:00', NULL),
(22, 'dOuexS8y81jV4stFqQVHzpStmUKzvSpRBTS1zhPGCDR4YXypTOtcTREdPCL12QuULUqYROE2FrDXbnsW5eyGs8Z8eP0SgyO1hsou2Z363zri6duumaFWtwTKOHsBgIN4LwfLvBzZzgth', 'OfMwl6OPL6cWmJg7oNjUK4QYPfNapN3ldUD10PX7oTATGhrBTpJq6gdJLlTkqbfksKSunRXgeDMe2A4cAwdIPS8qLnZ8lJMn1riMTegui7a3sv6TLxwOENKc3RhopANnqRZjNqBiMzbWpiKnYOIEPyfbmSWrdMZzSPgIoTyIUA7UwkaW41bJ68zYfynGLwUErOI0jtAEl1pUOpNcgevJLRX5ih4zUHHnelMQoDNHpvBcp6O', '2023-07-29 21:03:00', NULL),
(23, 'jSZGU5rsw5AkTRKTdCMbOmLVCZxz81zsYgO6m6g06drFuhtboyqWLDNDj5zdkeXkoz07YkH1gUian7vv7XiazEUvxcSY840BGtZFmnRlpIVkn5B6qFmxe1ICG8pg7tiJHUarEhnivanrjmJqTmeNlxuTEpa8fqohSR1QGxKstIDabLmCFE3LjNeuvvhtqkOd4ETpLFlg0yE7cam6D7VsL0VwEWzbXTaFqCWZiJS2VTdW5tgOI1kPfRxA', 'WPEugXtsT8N5UHKbKUgaBRrE3Vx8sfrBLSU4yhvXRsdeJuiS7mPfKMhmUPu7tDTT1zmfHAB', '2024-05-14 07:18:00', '2003-11-11 22:23:00'),
(24, 'Ysubc7JSCJk5hC3PkF2eentL4LvZiNbfDSuefhtXVoEjmI4oOGgpyMrp2kzjAstgbnXg2oQAwqtjBAh1Kc0OgPzWTYM6iiTlC7y', 'dpzjgnIDHPypPWriIhuiyUEG3skMeCps4Dpu2763LW7whSdrezQVL7fpGsbqPjo3BSiPi03OibCs7PL7F7dgsqByUd', '2006-09-20 21:30:00', NULL),
(25, '5jjBZP5T0G4gts3zaiv2lQqyP6XsfMDCfT3RCXl3PafKMpf4FLjwe3cn56CuHk5uBRvQHVZ2PiGjFxZj3buW4FQ5axh8VrLyMXJDFSlmyKYqhRSpfkgLsPRJvGEkiJidfHeLnL23DWDaE', 'QkAQioIlAr82nSfMF5PQHudflhwiIkuuavMJmFh2X1HgDNDdsHbetMVXgVk4mw7TowUXM6yt2Rnjb75ItBBxBKEOklCxtk3Ji06uxmloZDx3IjXX', '2014-11-12 08:37:00', NULL),
(26, 'R2rra3pVNgngy3iL3qI6bFsJC6QiRkRG3WK8Or5Ei8pfMX1G0d2qfBbbSTmfp2ExVdQJ7foM3xPIbdp48NBTzMHWcRXvaPZzKlNOgCEBOIrOUKp12s0H3spOsoSATAAEVC6fQKNkIx5E32CvZUyyT3tnvueH6bepXOlSrJzdmCOp8EAXk86U8Z2GfmyaaYZj1W030qjTCcszuc66MIQtIejepYLnSJpdqsqO7Odaz58mvOMvxi2eLVyjHs3', 'PZc0DxFjN6NaMCsFLh64gYswcFmyzFIpdHoHZmtwsvtYsI1q8ZLeSnA2D2YgXTWimSrS5CrrpHtdkhigXEhHuc2Xrm2RJKECqNzuQL02pvphac70Ee', '2006-10-07 01:17:00', NULL),
(27, 'BdD4HlfOKNo5bol4ONL2GnomaA31fbvwkcEcpJbIMffNNqzIw0GFbxoGLo7zZxHgFmN3lz5f1Bx88yhWsspHiHFaZ5IfIJa3nJYFGZxGHFw4KmJcu5kl0hj', 'cFouFTjdHGbGaOCCsWlJKWWzEEp4q0zCNOVy7sLAgezaalhcIFX6SaDLAx2wzh30FZy0xJU1ELamvmR47nQ537SxRjDp6u4sc4yGQb3dQB0Z2c743U5W8HepLgY6TuqBFOnv0ubeBSkAfEqOMAcMoDBPAnLp1MIFmCuvyoZo4DcRh', '2021-07-17 22:36:00', '2008-01-20 23:33:00'),
(28, 'uWYm1KnFW0JTseGXPe6jOS1Af4VlKjbW5041KWDWuC2xRAe4nkJ6rIosb07zKypoHdxxBWLoqIoCD7eDsrWvVXjcJjvEJYz2hHCxSs1uozaMZwXBjxq53vSldMhRfZ2p1OxZR2o3iCkTc0G7apjITdnmHXR8xlde2yd1LOvhvivURMElSTfmD4FgAXEUT55k3OFmF6g73y3JPFlAIQ2al4dnuefTFGujJhqmWSlrU35OUaIly8QBWcXKucxspV', 'whRJcxN2', '2016-09-09 03:41:00', '2006-06-04 03:56:00'),
(29, 'CwoNua77V10v', 'ZOdrWFs4SAIc5lSqAkqNM7XHIF0mtJyuPMuV03dvoUi4Rr3uMs', '2018-02-13 05:10:00', '2013-04-18 00:39:00'),
(30, 'UHvHtsDdZR0noIeBOMjtYmUQJb70lEnzxY2WBjZ1Y7rqOkVBF1eyqR1hYvtYfYcrWNpYiWpt7FZK2tvIURTcCZRONhHTpVRTdTvl4U', 'GQEAxgCMV5SfeT771oBIpL0cNsw4fpKmlrIwhhuXO3M5x4k4RZ8szpo6QbIWJ1P5mNiuzsHusBnDn0g1QC0Nmf5C8r1XssiusYPG51wkfxoEEhLlIdAxzkELEMm1alHAPCEswLIfETUBZtyHmBOcEzNprFhqyTeuktm37KUhrHXgRbqbvhgpXBq2hXyPRixgBG', '2003-12-16 00:43:00', NULL),
(31, 'UOU4xAZI5hVF21dVCjgMAuPbJ5hV5Tf4ynFcozuBsn6uffNJAVCHEkFwyINteIiLGlVeutHNtItStK5fTkjOk', '5USlQt8iw258xkSiJ7OCkoh0s3rw4eZO1m1PMVHqU03V1muulEbjb', '2014-12-25 00:12:00', NULL),
(32, 'sJORMqz1QZOBKk1KdXoyDfox4M42NztULyAmsba1b7FttaYclGlTL6jRoP5lXmcrc0ZkdbUcTqOfAJV8vRlaDp8l5EWU1U0ziS6coSlgz4RUJvqYNS3xlenIqyoIyRMVl8zksWgAulshh4BThQ6PGDnuFYxhLQ0AcF5oTw1FCfqQPnouRcb3SJKe3c4WSVZT3gtxsgFX8l1yRtzaTBsL6X2ROLcV8dZ1MW7ZlCXmyGjrs', '5pYgWBTocCejF1PAbCf8eP1rjho5kovW5s7uxx83kbTiWiOsT2zOJEMkee2lP5srD8R0r0y2Z1B553UQzUP4TnpWBKVmbrgFA7Mw7cEHAqY43EIrzFKCwVFhylwE', '2019-04-20 03:51:00', NULL),
(33, 'tQiJFOF2XH5aevMP46QadheWazXSR', 'dTU55v4oN3GdzcHDvjitRTOTgDLN2mXtWW5e35mKJgx8UUESyepfUvvMbN1InceKNPMcO3CWIfruvPdoIn0kIQmoye0DkjwP4ZBP', '2021-05-19 05:39:00', '2024-01-26 04:12:00'),
(34, '2eek1vhri5EZQRFf88QU4POlojuPSowB4MUkgZdyn26dACuI2IleS6p5aOY8tFqgu3dWBubA58pMEc1Cp0wr6t3XVty1kuCB', 'I38t5DL5exiA2HE3PgAmpxuwHSdTGmq0gOf7LPEKTxwWYIY7PPC0bHu86EYM3cSYJeUVMAFKPYacBLoC2KXU16C8fR5b3sCTMknhF03PsZLUVZMbBzVtL62QEwdwp14EC', '2007-02-12 00:19:00', '2003-03-18 22:52:00'),
(35, 'mUUXtdY7gu2b7AASPMGNX8CYIv6wjDogBbPmJmkPi2rbL7VKXGtT3edtyqbA2dEwg4TH33dYHIBPfCgziBfTFj4hpPEkoG3alw6PWhWFCauC0enLDexC6IDfK3IUQep60NgmryF0wLuTAvGZIRjW0VcwYOeQXqCpe2gHUpX4C8e624kPbYT0vqTJrqINOXg5hqYwDfsSfPxrLRW334sYUl3fFTBdNy3qiblxaaGSg4UWAcd1pCts', 'NVUlpGNrnqQAEmL68vAUkcQRRRrQRPCyMZY02pAkSJV1ivENH0sYZPr5xuYxXXWFGXq1Emawk8ubRhtSbe5mgfrq8NKGKzIsHfBJEZMzTBM', '2005-05-26 06:00:00', '2009-09-08 23:22:00'),
(36, 'duhSOJPDMb4GQlPJL673kUIBRAh7FulPD10AvWYQLcqh6dRQc4sJ3am7lZupdRbu1ptILqX4qswj2gaUXhqwhni8SuzlpNa6wkaZUZIh0D5kGzRutx6suqqvxfVZOgzbJgx56nVCWWy1WaWw4dv2TuwMbDNXfOGxwISbW6et8UdUpzsMQnIvCoBzZwrAJUoRHx8JHBQ3JBvZRa6BkuSfR1P3v', 'PWlK0aVllwSDNhCxi453d1SrSOTWg5jZ', '2001-03-06 07:26:00', '2012-07-18 21:42:00'),
(37, 'GjTdvWKAELoOT42hl6mVGKo6yuGQImBSeciPvSNyWKrTyxyt6G0glk0hTPx1F8lCLt4XNLwt82txyfJ8w8SibpKd5tke8Pw5rdseBw0ttrQoiTDm5yZP', 'l1TfWjU0IhEuXg1CGSQBH1YGUtyVlzBlSjDjjUTEZI7R3bZPCxxE5HGiiWyzonuv7P6aN0J1ELEIr6fER1VWJDbXIRN3buNjdjFouYQtQ2jsCx5tNBDkO8wXUoqO6UmArOJICxS30bqe22HnCTTGBSYafFJ4wNbzhE42gDJpbBFkn8d2lt3nmBb5jTjz4icVRKqBAfCWitTNTenxknaRuQK4LTEGfO6VcNbuDRQxS', '2011-11-26 01:11:00', '2025-05-01 07:36:00'),
(38, 'BsMpDlUHv7QRunHNh4f17GnzJBktXDs80ezYgopjHghvAsSm5qQcJfbEsaxQbDWt5u0j', 'JvoZFaUiKukQts8WWTrnURn7wle7V1kz8JHXdYnhZYroePoQlMzBsRGjkmtbyG4ZbjQ768vc5lwqQASoeiH4RENZHPiyUn6EU1dDrGCUZidWbiJzhHXg08EDcCCOkaGiE36wLe4GmZlEI3u62YblB7i6ftvXt5ZATE1mjqymtrCYaDwcagAD5XhTrJ2saIxrxfcutVEsGiLPiMuwJoFV4wlBEw', '2001-07-07 22:47:00', '2014-05-29 07:31:00'),
(39, 'fo4i7sC8nVvo5bR3Hs2OQand73', 'vTJl6WgEnrxpnRZmXo6E1JLO78kwnS4yb7j2VfsJmdPBkzsngyoZBFgPeDK3V4fhBOTeWPE1Cc73CvLgbNOxqVcMH0TkGxkWOJCRiEkrjpyp0YhiGDMjixQy85g2gLMzs5TyEMJaZ4w1Eo2Sf5DHdnD3sNwyPQ5B1it', '2023-12-24 06:26:00', '2000-07-13 05:20:00'),
(40, 'PCmSBKiMHApW', 'HfMfWh3OEWr48lsCsQbgX3W4EILDZjGEQzupbIEYlzMYgidRItBidT0nKJLVhfkgPWIPCmsCi223EzTF3uOtCWOJrUry2CRZXKgCbRODY0wakZCWAatkVgjzT6GsPb3fILUzAItcn1Npn8dJ1ltlfYL2W0kGbfCEvIepQHfcpUHPKkRKMrP4HsKuKtQMToC2IFDUPtY', '2024-11-03 23:29:00', '2010-05-16 03:47:00'),
(41, 'vvz8JWxc5jKoWk8WrxaTpI4BJpG2b2CvuddcYgmy6pfPJJ84DGSLoMDF3KCwSGe68JzSEe8mCVScZCYJTofXZj2FFne4BOUHpqcAPsJ4r5AgzQ0KgqrsXitqLXh1fstMu5do2Eu3kTITGmVdZpcAtiYH0I0HF80eD57uP7VRNTI5HmUShtOSAzEnTAyDTxDi2u5c0hfRNov1C7XHl4x0v', 'pDq5VIZTYfvoDCrd0IjZYo7IAmVYU7RPZGTJAX5SuJMmZk', '2024-11-16 03:08:00', '2015-10-07 23:03:00'),
(42, '5jsSyXnT8pXifKEfQ6aCXCx', 'SBjTSq0fjjPRRbp4kZzqlKiJSbrdkaBMDSvN8gBDFgag6WyTqe', '2000-01-16 08:18:00', '2018-05-11 22:00:00'),
(43, 'MJzyC6ldnckYDA5naUDLrnPFIYsLPFCISfMgYkRCqZKiBl4rciWGZft0SwipESgHzSpgkL7VYbXHVrEATuAN0a8AYVLEkn4Nr1wbYK12soSR1FdFTy8c1f5heuiYoqBe3LrokfBHCoBWTN1piRWYwNttnQKBvR1Z3KLyWJ8STCoovbjUomILf6pglOhEYMfXwuk7TifrqJBZv', 'jYhVZYuuUV0INhlawld4MDJw1gnM', '2021-03-31 01:06:00', '2025-01-23 23:17:00'),
(44, 'iHFHMSGUY6xqzu5n3zhnmLlb8bbbkC3qbLLUwOXwwXh4EU0CMlPBxLwA0ZOhFePzQGP6QN5', '6rZw0dBdBi0VY0QvDKd1uTEC1uprRKLCCDIb5INgEP8cXIEUO7C8hmJE7IMa2f3zrFn34pD7ynvLfBaqqGJuRau5TnY7H6nTQG3f1KHqUoBWcc3KbjvTekgz04WxhanRSSKZKuiQskAk5TpOfJud8Exf8xQQlXgEn0vSolV1ygEkidFRtfswsYbCWG', '2012-09-28 04:41:00', '2017-12-26 05:07:00'),
(45, 'hEBfSCzukESY1YbvqDc2VNk25szTs7BNC2RmHzlmsWPFxeupO5bM6VkmIbQYgDFMllM0ZCdrHWCtZGLyinMkLBMxEWyt37jtTngRvhQUkWuSajEIWsU', 'ivxKuGRWTwYsLvYuIoXeZEUUGRzrqe4qAhQzwk1czIurt4aELrjv8OiQhKak7aqdiEuYwDABPeUDkzgoM3v7oX8c1uHwdlvXrlLxt8tzWMaeMlxFd2B6IocJEAbflLaMgz4WvJVKu7sI5oHcHQGrZCRg01S4UspI6xHoztxgAkPOWArOTgzSECXs1nIn0qGN6WxvRTcUqvdS57VQbkUH', '2007-09-19 04:14:00', '2013-12-22 23:58:00'),
(46, 'QqTKJxODkOJbLu1wYVz3IzIq00zsxvzYeDam56C4QwIKCkXjYkyOnoaddIDF5twz0dFlQC3glAuIBnAeRYOSV0aW86ApDQlYR1Y4Pf1XV6R8sXwe3YXSRFl4CmUF2lcY2tCn8KXtHUGlejk3BA', 'VELvii5Op5y6GIE', '2016-10-15 04:31:00', NULL),
(47, 'YWMpzgpSlpw1jl7TvH3GGTov81ZrFCnKNRaeBhsdRtCyUyVcjFhHW3rL1ju5enUfsd54pcj5gpdHKVlywuGlbKmWAoxPv1K3u35JzrDS3uyQuIPeJRCU2wtV2tXApDRcNKo6KUzEi3Ml5AuTfyvy6TBTVqbB3sXtxIDtxTlfC4UYUfCXdwcneQkLIa0gdo2I', 'dDeHgQqeB0naVN8tdZApSroKampOoPgFjYOKDRWxIaAsV5vqmXRCRIVt2q7O44TzaCu7orSxEW01Za86gLS6eihLPpcNxmHTauCRCJwqfzdDj', '2003-02-28 08:56:00', NULL),
(48, 'N7RqBti5k4texhmCaNDOVeNCerjEdIsDqg6YWAxYLX5UPaP6RXMYRYuK', 'C2ZHXfLz3PuLdhsLOEvG5ROTHPP3kHNRJZWmGDFe2G4d8zDQbVHpZtKOHoVrIxI5BZvojE6t6ebZLfTrHrvm788PXzQdotjdUJemCRC0V7iOBCE1kkiJuSItCxe7YiWxSvZDRiZE6pusjthjQYceC7qyT1WlC3IYhIO8MIwR3XTEBbIJLJhxCNUlOuLRHww6q1cIEShuwmCAKsiGsXN', '2024-04-07 01:58:00', '2007-11-21 04:13:00'),
(49, 'qBeGat1SoTaHu7iHVfOCQYP7MMmOiSVueeA3POAN2ROsNau8XA5SiYTCvVeAXcJZUnosj6XtzqPI5Is0zYGPPx7QRDQEDiQBe', 'onDbqy47D', '2001-02-18 01:55:00', '2012-02-14 03:27:00'),
(50, 'GZWqSD2H0sWtfNpZiCaAjGqevHSe1DIvLjhDGqhhWGOct1Le5OlNEjV7GniqUXk5bC3P', 'cQaskHzpSHGVY6iffivXUC7eJDb3UdGSIzLF1ElnLKyRWSJivWxYhZETXSXinNtpBnxWmqPOJJUlXSheB1pBXU8Cib1lBlR8L0Ff3Vvo0FMyQf6tryxYne8EXzdlVieupEUSQFMcvHFawAnS2RPUUA18YM', '2007-07-26 07:26:00', '2005-01-17 01:40:00'),
(51, 'ogsignGXFzQtBVD2qEwOwDn5lYCOm2QexPocAoeDsypEifgqHMZgqs5zUocMopRgW507mjRe8iB8NX7mpV8Zdw1L4Kk11XL1TDNGodNJRMIOEnIqGC3iSOot1OtFTQJXmZzkMMYdY8XZZyKwvqmU7JsofkPBt45yyuENcSAwnUhZPMxubExjG1ySjZ8F18yRbvfnpRFO5KumiHczV2kCBrTrXrV', 'bv12t1clY10yceZjHAXt', '2006-04-07 04:47:00', '2021-10-01 03:57:00'),
(52, 'k1uL4VR3zV7Xlk4nVGHdNTVHRBgHcyzPWlFLFeeVsZcS5TKSf5g2b8ZFL0ZWfnJK8EWr3jjDEJ2SM8Ul0RKCpuWA51ymtLVYsdOkl5khasyOrzuU1bmM7mGHZnBA4IXiUxuzmjqFejqfrzT8SXZEGk7sWEq3gIylKXhTXfa3', 'TlsBuiwDLsm5VVIiFca4ZPWFxkIBUczL4d6KrGPHQk1YBccT8oybvcSQ7UO8K6fYoT5ACszJqJbrqKlqodgW62RbOQtHefsQhOmVsyW0Si2oZVgVp5uvj7bqeT6dUd2L1nI', '2012-11-26 22:27:00', '2007-11-11 01:43:00'),
(53, 'LJbr3bKl8xkR0wVocoTQOqysgXkFabBhc2ubgAPBkQRx2e', '15JqqqIAYCHNLy2GL4bgdqRzaqkVOR6Ef1KSiYwhHoReYUhuwnvUPl2rkW1tFXMRnf1AYFHtpRn820HoKWYlQH5dHafam0P4VLcCNQqneaJ3obaGEQeQSiqUY2xuuVVM301DOzX4rVGw6bTcomGbBuLiSUh2cA2ymVHipk6SSoPHniaKKa', '2000-03-07 04:13:00', '2003-09-22 01:13:00'),
(54, 'wxinR01G2BLsXl5ZYilaSOAXwuexKG4Uuu5hI86xosroYvQmOZa', '7AtPflsbmoEE0L8FGjQITL3vdRudpAKvWucllngidW6VKnWIuwzytLdTajAa1RRqxEPAgifRfr8l4yKGJoEidMOlCE5lyypNESMHjUVDOEUJWFkcLySlUesVQ2OI33IBpeto18f4nj5HtKCKr5mL3S6aUmgBg', '2021-12-30 00:37:00', NULL),
(55, '0gR32a70lXqOwlm6Ysv0R', 'a6KgY', '2000-09-29 05:05:00', '2022-07-11 00:07:00'),
(56, 'Bmu2bTmewZLPWLL6VX2QjO4R6jIvdYjNuR2Rb0eSckYcCKHPrP7C4th4zPHtFrgidzy8EwOz0uppM2rnTuoygYiW87LXeeX4ITRCgb4j5bPw1CoaXrN8QzTvxIwU7K37IvKlq1DWnStJkNkeR4xxQm7NoGjddzBcUtsfC6BZTIfTLO5Of6CrNhH4D5WaKiLUB', 'gkkPi48s6QwUAFYoyg6VzDOk4YJm4bFs4m6dNGeBTisjMFMkruMIdVeMv3YTVdgGfF20XRj5E0EzcgF5jwdRdaKrZLCJVFZt1s4qxMVmZUzj1IlbpUWoC', '2023-09-30 01:36:00', '2009-03-27 01:27:00'),
(57, 'cPKOtokPKcJgrpK7hZI57kn6p8Zn34gmSiR8nj2UPWfxFTXVq3gzcHLmHillwJp8AWnX5HMR8FEoSOpIJEktNfrtvyn5jUbhrfqSHgqHnaeLAPg6nHjqAV', 'PVEmpkn3u0Xn0IlYD4YDdFHaAcRjQCK6', '2022-03-25 07:08:00', NULL),
(58, 'TktodvlHChxz1Nh7002Y3klCNjg51u6GKcMtTASDQLq', 'R0dY67YozrydlvIha5VGNJTr5Py0WPq6oGZz380nuM1HsusWoYL45YTdG6oU8JqiIKYv3VJrEjxcIV2igtco01Qbc3pkIhlQEURI4y5PeP8NZqri5', '2016-06-14 07:33:00', NULL),
(59, 'pdxpMX1UDKtXJmGueSjonHKWXTX3zYdNVdMHMtzzV5tBLi', 'UpLUVvtUcggF', '2007-12-28 04:20:00', '2008-11-14 07:40:00'),
(60, '0L7GRjmWnS26ZBCNh1JvAaUnl3ACycumQgGmYxzx8oHHnuJIBhTmjRd2pvP3jpaRIo3kPXHzk7sHA6ukB3cLeHt06PWCLzJg2gLDztaa63o0HlUkcWrPk760TNW7jasExbsdzSlBbdV7nx3bFWEGxzOFg2b6okmD8QmuiEngGGwK7UEooITrWQctbuHuqYOVphH2gTDHOAhStSLJTcdhNBHiNjjHe8y', 'zZjEux7mPMYpMSSNPYHtHKG6oKXBNuCKfCOoixj54ZnGMXlqmJtVipz0DlgUQRCMLleAGHo0EotvuScjkOGrg4WhlbQXbeYK8gf5wkt2Nmjbu7FvGNX1rPHJN0FcA8VFkUXFEMv6lRcZB2cDsaVJPmR2FiK8UZLIppzOdVpr2KsxPKwyLxh', '2017-11-25 01:43:00', '2000-12-19 23:06:00'),
(61, 'bfC0RJELBrMdOXqnaHhULJ0nNUiTbKakIKXhLBdygwsDdatLDoMu0P8ML0Zoc4XjexMd6ZIrFQKcd1wwyaShRiC2tuV3cqte66s0KANHuikeVxiV6vRr2wZmwPGayVhFSQqLTdfpmvxhSj4f3bTqzCdQRyldJQC', 'RHDLZdJCtw0mBKktV0L43Fzre8koVjW8lOQa17twjnT373WVGQvyBGrA7iXwm8by6w1ZgJwT1nb5un5ECVGouPfRzMnXyTeVOqTIih85UvjDK8SVSF5yN8EhXrUsC6dbQQ5rNckhYdT8LLJpNHSb7shDJp8q1M8Vuj2iIWeQNz65I6JIkSsBEh1WgegBjMNAkYiqWZfHdSpj8jEPtsdAdeWLs', '2024-04-22 23:16:00', '2009-06-10 07:52:00'),
(62, 'fAkwIiFbUsPQalxrs5ItQZgFmrNrd4hhFVJQtYGRMbm2xgqBeifixVYFZ7SiJQthYhTgFOCWF0JyQC7dCAifMsy4J7EAGoHDuhQ6hrx7IBA5lBw7kVNwEj8DzppgpphcR2cNncAaTL7ULllXh8wMs4sx43u8jCnjQtkXumKO', 'mliPjvsujYJUHTuy7v7tlihIPbn2CJfOwJhGMoByIlcIAFmFmDIHiBtp73tBIWPMr5P0d6apPRfVlhdHDgjfZgRbJxBmmBOUlQwrDILe5zQzeN1Axp1NKIsy6fvVDEI02dJoWq2hwsMLSZkqPqxFGzN3NhsIrqvck71wu0trtFqinlZB', '2007-10-17 05:02:00', '2010-06-18 21:15:00'),
(63, 'y3lVkeuSu6PYpvaucJqsYpDSWbzl0m2yXOygqvy2qSKmoohNw6jI52bp5Zh7jFaFDf482PLCTTJzZ564UtfSbQMGZJh70zUu0wmDK5phkGZOY0AOO06zUA7n2LCCNN2DpeJqPlJzdP7hNojQbyt4nN5PEZpAdZ631alg4f06ptTh2pKJ0bO3zhoEHrZE0Cto1jf', 'T0bfybvsLmmumh4w7ApvXzBuRZlrDr38nedutoAEsSU1riykvgLIySPtSSm1dukyesEJgvig6T5LvkmwMd2xenhGPI3vd5JopmReXE0QOrd5T4XXwaBeoU54OC5CN56ONEBf7fJZxxDjfomx4m285gXHOJn21ncyWHsxsNmDWOswN2', '2018-05-29 22:49:00', '2010-10-23 22:10:00'),
(64, '1qHWOHZuPT21Bz2iOqgetSWduocv1NB6F6dsBOCbiMOxPVRToY3v3jHOetYfiKdBKe5UHh4BpTNOQN2cqm3TZKNNLVWUbr3vZuqchT3xhFck74SQ7e06itOYAJpTTTuXaUrvyvXTsW1HVv4JUh7drCVXggDLlTLstacspi0O3ihjmf8d1WeUqYNvEMeaIdSyhmJx1c2cONb6czXo4YQo2fkXzqIf5A', '6gsYga12bINhtwdw1k1yptitq8aWSpvREd3VovVdVQx4zMhQ2hEUIbHRB50yYBqdmyTyjhWYv8SIVpPnB0K0dyDyUXP3WTCGX', '2002-09-16 02:24:00', '2008-11-04 07:30:00'),
(65, 'gtgnBPX23wMpk0mvKGVSZF0xSBRlgPSLvcwOYIRjey7lPgsP7Rbp0Fcu4OpmRMLcX0LbiS12yntjMj4VHZwVOQ2LFpBgUtpEIZtqWkxdaZr6IUxigCoelU4M1lBKsIQp07HVwP0UBdi3lSjr8F8Ys5R7y5XRQGpNCg6dyrwuqu1x7iSEffGeehsIjkHBWXwzkwp0IL6edrstSHcDatrUQRd000MAHfV0nOxTtdmzk5jPE4UfrP4tAgzo', 'v3bHWxrq1mqqIH1D1J8qTzlw3N1WA0Wo0NvlNO3qLoWvvDEwjxe0y2la5pkGsXC6S1bYBRBfFe84CZCLVvo3cPtOcoVPiY8bpJ1ONaUW4U4imrbEvvxdqLNfONrhes1ixf6MxVhmGVLiQsLbspkeCCsyVuMWyErkdZn8BPUMG3qCRlauL5x', '2002-08-19 06:21:00', NULL),
(66, 'rS6IyRiMOBLMxxOZEFZd5JKgmcUNpi5tX3MhmCJWTcS8qTH7q85gsKi2pbeu68yHadmqcFBM1N7Tj3spDCgx3ygyCrG0ZEJHAt3LiePA8Gx2he6SYJn8wjPlpDs6ykBtICt8BnWFBTjBRvFO6uFlzp4vMAWl6ogZSlo3QItd4sx7', 'lKwbtZ4YrxE6Gg1JGYxPz1d1Bn0IZupHfzVnb7ysCprcJmCrQ7bxfOi45DTPWafDnQAJUuFVI57QBNppqKs5tqOgsfvUKauVoC1pJE7LyIczlcdU1P5IHT4cd4wIdLNDG08CC0rdYiFJH0kyRdDRY2hXiLxmCETwi4uJxSQnEwH6DjZph7rgCUiCY4YATrjdH7pdJAgx64OutTrnYr0nbhKFmw', '2010-09-08 22:09:00', '2021-05-27 01:48:00'),
(67, 'd5UKXCiEC3AcUK3QCRlMqBPYj2zwhMRgAeoAejyoTsXIbrH', 'DliQv3tVf1m0vfwpkxsqUYRR6ydyYRHlaqjiZE6KXIGEHZO1LQUGFyeW21uf3iSl3bPY7izwRi4Fjv4V5VUUsaHtssA3cl4m2icEgoQR8dreuhS2YM41fDUxXrZ2QRKSXBxurWXMeC0w6FMADB6ss74jD5OJDfCvZ2LNhS83nduZW6I3t1lhNlb51FrPsjHFDLdjqMwE7hRuqZczoyyufmFbHvoDfTS5CP0nB74xKuFV2JIBXb3tCKGGjZJ', '2007-08-31 03:37:00', NULL),
(68, 'hvERqcGjghdFd4QSVJggP38ZAifGqgkZmFoTZv2LVJMIrKfRhNGKLsfXSTYrWClqN5zCMfFCMyPITKCSfPQQGDWIR07R0Y0avhVLfNpo1p70K8zYullmongl4tBO7Yg4WMJm5rV5lQQ3YoGOZFjh', 'SfOPXu8hbk11dTTcN7HTssdWharWY', '2003-02-08 06:12:00', '2021-03-13 22:20:00'),
(69, 'nT6i8x5rsgVQlQV7Bs7rQabyKC4qEQOSSanGk0QJw2T8GmEno8IJ', 'JAZ1VHFVAqXRonoNJLKpxNQ7uofgWBa15aDOWV8ovmlaPSiny7ezS8tVPaIMm2nJZr6VgHTJpZnnYiWu5EKlsiwTuSud', '2014-01-25 04:21:00', '2010-01-04 08:40:00'),
(70, 'UFZT3EhvXLJe2lpkegtaGhvOEJ7njgJQsTUcIG16ZYeE8Sys4TpauwcFgndfWTpp7bTmapq5HZXFtrgebAPfxSDrhx6ELZkf0r0ZbMYXeI3LsOLIgvu2HnEuTTOOIpm668', '7HuAo2jO1KrUdQm7vlgQRHtzqX1PIUvzkQZJp8WBmEmlbeq6blncptWPbD7S88tWR5wRdKNKJDWUfjichFDlQFfJzCYio2Hy3', '2001-03-16 02:38:00', '2010-10-02 01:08:00'),
(71, 'YW61diF66drOfTQF1RwTCNvGGsek2I7ZgbyLLU8Kgbw4v0H7VRACuaaY1HLLzq53iwA007h8v7qkeTXRSvGMfLajAvFoN6MJ4pN3o7Un0vmAQkxlQYOxBtn8ne6kI56QAjFy8Ik4NdK3owBnRraIUaoeUD178YchaOQsZasNyjzciEvOaX2j2W6uBxPii', 'Mu17yIPZaLtAKiZc6EqpS4kNJgCYlLfxqBetwpDGEON', '2008-01-02 02:21:00', '2012-11-13 03:39:00'),
(72, 'D', 'ZULkMqmd6adaT0JUAtoCVvq3r6OlOgFIc2XVDPXUe2c8JpaiQpbETr78pNyGfroGehAtknG2l6hnQkCh7y85uCCOXcvBgWBFaHnmobb40kz453Ks', '2005-02-19 03:28:00', '2010-06-08 06:25:00'),
(73, '1gNJb1PoIZieG5GUtAAEOAFRW7KuEE54qsCdJsKU7srnEyoLgXI4ybvHAjG', 'O5bmu5Z1nAP65Zk6MrhIQXrAlcB5Eft6gN2LdwfGaLdZyM0WfchUfVpNCZB16JheI5jm2MdV7MZhyzMl1IrKXqkgncmyrqmCQdtUcKyZo0D1KbpVMQzHXvzJnH2gNCVIDJUFbNChhlE8BGC3e0vYIBDzlBH6nyYRJSA1klPvxveqlpIQf2jB7ywYqIW47nJTwx4BwykcD1bbdhz23KXJU2X5KhrN0TnjMcMAryiXXzHYP', '2015-04-07 05:50:00', '2014-01-23 06:14:00'),
(74, '7PcmGDddjQMTeCnKCb2AZ4SjewkKgYUObjguRvU83mL7AncKqy7R2dCsSVVpPxxXNAaW7Yd3pk4LzP7nmShPixHotsTctrKtfg5eI56RtsSPDv1HqqghZ4HMkEiSBsDldykP6Rku07T30j3NERmqIY4NjP030LvGqd8NQ3W50gVJffhQuEvcSSzWsfQLyuQFT10AY5TeIhhRBFln0SD5EHT1xZypxsFrdSHNpkdfI7ybFbK7c', 'ZRei3opgA0jzeyltjYZPosStuuAXQKV3zZAlLtgEfyEl5dApTZ8nDmG6O5EIHIrc5AMI4ck4ZFQc4fT6dDekXjKKjL264JGYf80igEsBR5Ts1joVhQmZn17uY4WG1JCrB5igoZ38g54620daIWefpjZDpUPVPWsNzUEy1xStvd1hcZyX8tfimfTRYpD4haz', '2019-10-31 06:25:00', '2022-02-08 00:35:00'),
(75, 'i4tCTEXDVcmMOE5MtEbhRBWMmXgjVFFcyYl4R6rbO1lYRbGzZq7LypvOeg8doeBDuldNwvP5HHsmYoFy15itvayKSg6uClg2A', '2nGJeacsdIJpVeMAvlsPiiy0QBNxvXmUBgu2dxXFzuKcP7YOIrDuw8v5UlyPgL3GKYk83ywwzvqatPpK0S7UW3kyfLt7mpBbKul6iEftVVGI3QIaB2HSu1GJhcq8izbdfTU0M2vld8T7z80zgWWiBjg3jPBAybk28BELpdWqNGtmySVNkTp1mNKDH5yk', '2002-11-26 05:23:00', '2010-05-06 06:35:00'),
(76, 'ZJObAImAE11H3ZCIXadtZzyk76FPlJiL3y51V4z0St4blUqyArpWM', 'S1xj8ZJEQor8BWdCTwMsVBLpqTyAHTqeKygQdsNloVXKTo5eQMGwaMc5hKw2fZ3svetV0rs77VEHtTJTel155cEPjR6s3kZ35yPxKElGFqbWhDZ0KDAwhgnfQzk2AHcAl0VGJOB3NtPXTy3Khvl5vbPcpTgINwyUXjue8IWGyb7W5wSI6jCeNXUMXe2VM632rRsv5OqjqojTQe0ZOmphxjBqUXoRASbXm4upiMxQyhwyYjfIhu0', '2012-11-09 00:46:00', '2016-01-27 00:39:00'),
(77, 'tTkdSlPnlBQDWRb1uG4HpxAunRCeuGajHQIsOWwgcPpkwhIUR2KK7kcHo8RDvb4FxX4eQZn3YCDwcYEYATPnfasHOchFLHtSFU3ocI7FtK0KpDzKkE3ReKiu4AJyJwxOafjprEeHHHDehFNPhhxrgNa80Z', 'M5P5UkZwr3h1vQ2WUDvgsiCCIkJnRcL4PjfSylTEf63CuVISI', '2009-05-16 01:14:00', '2021-10-07 01:41:00'),
(78, 'BTNBAUDnnzpjMDumSCsgMEgFn1DO5oFor1O1wVXdJR3d2BaMiHqDx32TEIdIDq06jKD6X7lNoZNxewxt6lFOQpUwCutbbsAGwXfraCepPkgl0u7BpSEHNT7scKRo0BqClZx7XOlJBCVtPwE0iPAEz5ITaq4axgf3WxZbsE4EWlc6t8fiGi4j2oyrrtafXwnKfa5Z', 'hhirQtP0QFO7rudFU7YZmhlK4K5ZNgnCma0wpv1r6sdFgOhBdro0rEV', '2014-10-03 01:54:00', '2001-04-17 05:27:00'),
(79, 'H64pEvksGbEgV5LZ3nbnHpPiDLt32WVzhLJqUHmKvgCXuj4ZlxNprqU6f2qUqBBvNM1blireIEfkmnwixg3bHrTwrLM6ZPwino6ITiJUxHhiUf8Qa26CztK', 'fSHDXC2HN0HyElMDjWpcmbkB4UDcbeETsNmNBivL3Xr5sTwNkx35oa0qU2BQ6oqm0FHGVw4UkqcxlZBLKCzG4FskMyFJLLHSTg2rCDP3Ygi1yjK8hf4uaR', '2014-08-24 00:31:00', NULL),
(80, 'QXIZVgV5ZBle', 'pWETcvqtwHvpJsY7ky2eSLGQFWS2FGdQIz7ikHRGJHaXnlefKp1YOVJsMWkxDPd4DwV4oMUjVpbp6RATuvky8QFikeU7NdsR8WVqYVEp4w31W2Yd5qwpjnZaflpRVjo7TMmArF', '2021-07-19 07:30:00', NULL),
(81, 'xqf6JSlCISkFoqaSr6XlZBpmT8TYCn4wui2smjx6Bhxchiu2EmFBwKckOtfqA40Na273WVkdseo0hKwX6f2G1YwlpeLDX4l5qpKGmGc6ZXYERrbNO', 'fB0jhdFueVkwkeHHBjj86KGAahsDcj26XQBFlJE1oKtqPh1ubNkUL2auBtnwXLpKaw46DTob3xMCFjBwrFeGEwPgyRq7abinYjLs5ckwgnunFjlBMvTmfAkcP1Hc14oakdr3yePO5QgtQ7LMhM3EsiCp0v7sBAoeRrybpxVdNGQoAOtkhgMuMpPBQ1gFGyS2IvzTWwXYAiKynB1kh6gzCfxBLeFqBGGOx4PZm3bE4', '2023-09-13 03:54:00', '2017-06-09 06:05:00'),
(82, '3ZrakfKzt6LdVelCBHbRLLsYL3VykGQiVA0oMBv7AL75ka8mPKwMLGw2Wo7wrsQBEX35DtGhqVCC8VgmyDUIXeew3VwyQufvUpkNbTRxSIRmXeiuaHmuFwQJmzT8a64WFNWrAWNoh7bqKbv6ZoA5eSUmVK0NgGc4QMhCUeNfhDPpgFvJJQbRlSVcnOWs3n5BIn7ishC2WFp284uf58EtAGNmttTuL', 'CnJXgsb4upgL8X0HgDQv5wMjvfd6irTYIoUft8FHcKEa4JtJejysjPZJleHOx8j6FKVf2Uz8h6ONHoeyWF3ox8LuG22VrlbPr7sgIZWoFqQpN4RleEMwnnqQSTVieBQfmqWMdI3hYHTa1bbywH3Gy5AREhVDqMkt8txGRXzk8EJRsz7IgbyqEJdMGk05', '2018-10-12 02:07:00', '2001-06-11 03:26:00'),
(83, 'xAY', 'r3Vua4Wt6Gv8VnWkr1iVsWy7sAhe784jS1PY7Mq5vMvaPoOW6ZsFOxIoXJMBQjnN5', '2022-01-15 01:23:00', '2012-08-01 05:54:00'),
(84, 'JJBEMiKJbV1foRPmX6161OY158NfUV2VeMzLLaNt3GgoUDQXYu2YUShWsPQjXSuvCIYCmZiBbwzQWRlmf45zVmoN8J7QFwK4g1RUnPyGUKxWmw4Yc4H8StIz0E4T6pp3Ev5VPGUtgDU1282ledzen4d4Pw0Sv1F1fuojxgOrAFj0z2AauxH08FpgtUmcIBjO3H4URMHl5K71r8jGimoLHuCUUolFuv3BKfKyxgFpXK', 'BWx6WzyGMhRCKlrzMPLkSWxTkARAOCAv7VLPxGW', '2004-09-02 05:14:00', '2012-08-25 07:26:00'),
(85, '7uKp1mE26o2xlwzKNkVsA3z7vWgIjgzxxOKc7SPeUoh2HwdGhntmMHPXqeoAatEZPmWyO4eCnQpjlQSFf3P0XkkXiRMNaezlZdOr4jnfqPpQyyDU6seJdvQYr2JRnEs7JFmE7TDZyL5Wqgz7EX6FSWUZRwz1aqxIiIywpzf7XKRxuRGcAkR385TRngEkCZeIO4c7YxrMQ61iT0FB', 'OTh3oKepOiwHoQhx1', '2013-01-11 05:03:00', '2010-08-18 06:33:00'),
(86, 'alvIP4Igq6bHTnxrJZFHgI3Nbnrk1ZiqyUMkqJGlHry16XxK1NRK3f275hEEZZ8Xf3GwX1UxEmOyoExZruJUlveD4qNpteEDcKNiYgysOmR3V2rdf54BJBk2E4s68KeIa2ptHiVDDFCP6nzRlWGbr1iJgR4f06c3nglUxvKjXwC5NQ8bfUhdumH0jRZMg3eWDgX', 'klEHYGyYBveuNNBbfXPoo4JQ1L1lEdNgqNjj2qHWYHUh4ZxaUNioVuosXFJqQsFRLl2ccLBYX', '2012-10-27 06:32:00', '2010-01-23 08:47:00'),
(87, 'DC6wNnTw7sdxSLpBCipOozySwhfIu5kLkFjtU7tHsgZWdLZFcUQohi3AeXJqGSofsygW6RQVamSv8bpH5zt4SkbMeborOJyqHCG5ntJKqsmimBfaltmULjt4hjUxklhlmL5Uu7zZSB5mWJZ0mLWBiO2vJx5pCaPNkkpnvRdiDmyHOjv3P', 'VCcCaGpvSIUP4Lmuq5E6AyW43wZnG7xwZH6ODga53dIQeShsNKZ2aCjyPjTTriEpf5YHcRrYxAxaOOTMAUUV6zwUE70U13tpZfD4ML1zIN5BwyyL6npknXmF8cvyclRAYv2', '2011-08-28 23:57:00', '2003-10-20 05:52:00'),
(88, 'NpR8ezo5HBxrlACkxnm4OebYNF0hNlaWWufm06mNLFOU3DfbDMSb7HfkaIWSaF', 'RdcaMO4', '2010-02-23 03:03:00', '2000-05-27 23:19:00'),
(89, 'W2S777rfQrz4rzytsFydcWho0SuR1avUIoHvLE2rRdfpwjvuhjQsKTeqL5wXp515CVRHIQ1I3axsa2G4PaJGnUnlmRwXYiyffOboWzyzBSCCd74DACqVpAOYubL3o31ripNbbzbo3GsAgAm64PSaGIPfDklODXmX7zcnknR5H8Vs1iCzvr0KP7zpPbI7ynflQCIAwl4CjBn7aa2L7LyVRhEddvVh8MokbluXnYtMOBQkSAr06yNo6TO', 'EE8Qvzx54HVygliEidNxpUMeZJP0RS71ebFmAvzplHQofJypfZpgfmpd8y8RYj06lvBqSC5Qwo60rRBYNFY8G4h5UNC4E1hrxss3KD', '2009-03-08 01:57:00', '2015-10-08 01:14:00'),
(90, 'SEC6JTbYLRKD8C3yqJJd7IEHKpVkun8dZWcXnLNLHNOYZNT2tMBiJSaEpSBJY2q4XDPCPakyPrkfqtl2VKXdDhdu5T5cv5RsuUaXB7ngESuhuUd3pIGShdeWcZF0G01BCDfJ55rVmnd1szBjKYpJvBmmVFzDdinpbhz1fRlQDDJyhZbNODkiyyg', 'L3zCDx6ryDTBaJvNz6HJyd66EMIV1JA3JA6jQgi3F3glFkXH0mshxlfUG633Y3NzlfRX4KgAvtRm1DuHDQdtRKO6rHC2iFQijSiJdVjYswSTvKlIoBGgBkiptSeRiYokcrezhG5SPPRi7ame4XEPQwHUZg8FkH1NQdcA0PHlAmba1lK3G1EXzeCrH5QDJqXLmtojSePI1utZPqH2rpEufSAawqO5BqoezuW17SENFuZh4', '2023-11-19 07:00:00', '2021-12-19 06:45:00'),
(91, 'OyccVUBhifGfe1yJCrcyeOEuwmZnd1DFJo2noHtccmKWaq1mvi7ImQFAOLScWjEpzj3bEY32v4VOwBaZwTkiR5dmyCMZZk2PkO4wBdmsaOYcX3UdXfX8zI7HOoGEwJ7qzRBv1rKSapdbGF84TZi', 'L6MPllelQ4gyq7GMqG2Jum7rpeuPt7xXutGvwXJVdyXe2EMpaZu6ptHDMM7QozGDRqxmN4pvZeiGxC8x7hTr2C8pnTpxzPDFOrCogsJgOcWcFfqCJbhHgukIJpVJyrwAHZ3eo2zRbfxrqOrsdEUFUFZYZ', '2012-03-22 05:29:00', '2017-09-28 03:45:00'),
(92, 'l177F4zWwOAttINY2lSGOmnXeTpErwC3G3Qlh0h6ggcW7YokzGgKosRycR6wL5qYaZnRmlIbcwpaoGFbckOczqRNIHalymfy7RjLs5TE3swHZgQHcmGyCUL4pss0HQkEpwfQx65B6akypTHEDebG1qisanVMges1C5kuztl67CFp7LGQT3m2Juucr4ryGg86MHzmxYPz0wtf', 'dKGpPkXquZwKKneiuBKlbwpfwbdea4cohhABxxnjKGHY4OC5JMOt81jOM0CzBMaFsCyPfXeHfrLh7DrGyblwahMFCXo8ZBq4cMbOyIiumJQdA7fenVu7nztEtnjBtoBUuioBYUpoP67yZvzqLUOG2rcJPGw6pRolBxxl0vNrUXmyHN7KstF0FkaKPrpuPBgd0kmqhP70PFHB1ZTU5rLdmHaD5Slxhm7EF0sBPWIgAHFxuMM8ppUxLLog', '2008-05-20 07:56:00', '2021-06-26 06:28:00'),
(93, 'RoGA5IqdnpO18ydN1K8wSzLLfl81p07ubSOwETmntr1oGKkh1CBsaEZcABfEXQUaRHDxOvccHgF6x5KrP3VGPVjqmt5h063RL6bwpUh7rLbHjZXJO1jwgfnt2wgE6K0LN4TlGqnPk1d2HdaPsz', 'AukoxT5NUUtURj1Vtqc77Lc3vMWweUH0nPtcy7nwtiQEvk2s7GHrmws3yqKBbYhvoGkBrcc04fxA234VzPLSStKjgElb0CiagNpsQ1w6ubcgU4XMihVRKqPHsYPeHJgzNeUeNu8O2spyL08HuHZQxjVTIRqm8TcwLNMCxMsSHsTk0wrMKveyUUHKyJiP5yrPEf', '2021-03-05 22:45:00', '2007-03-02 23:57:00'),
(94, 's7rcK8BX24NTU5OdCTkLLdlmT3ypoqjoE07scIasbm4h4c2lCvuQegdarpScxJyINQw5atqkRyNxyw3Su5P2JMuzZ35dNe4tqXma3XdBBRuoMOYaGirdw3x8ikUvZt51Oy', '74KyCxVPyo8ALd5I51hLAeweTzhf01', '2022-08-14 05:45:00', '2015-05-11 02:20:00'),
(95, 'GqNkPMhZUYVKYxkNm0HddKktsTmRucinnYCjxvXFzmYHNTmFCNVPoqOXv6RFGkuSc0DnGjSstS5CDXDf7ib2ln51r5JplGqMtZfLsQRAoKOggSFtqGmMDbuGNrQPbzxbIVaySmYSXXuUALdNjkD6atg3uck16kAGyDNfMWWSrzUUz8tpO0USiveedzpkHXloWCzS2IETrcomFRwBribwNNL8v4pm1f8cXXIG3clBGjQGEE0DxMdaXK', 'zGIKpRjs4YwsU', '2017-07-07 23:13:00', '2009-06-14 23:07:00'),
(96, 'cHV4IwhaiyTXyZTAF8Fhsj4ONNY5kynOWjJ64nydSNWB6KTiWwiDRhL4FOJAjzCLbfjCNjMZ3UCd5bXvAQPbCGmTDEl4GfvdlrPKkHzSJW4pIg3kaRZ66HlJodfrOywfJkT4EQMjUfGg53', '2FnuKwdaRQ5OWJQFyTcDmKwdL088z4hmj1v3VuBnmGkK4m6osqGb8RDCPwzpS4xtSoYasRBNDMkzAZOm85O3lbpm8ghJHwnfae4KJSsVN4Qk4zcnecbiNpfRKGkmv53OhSSr6wFfzKKBHQGr5ZvKM', '2006-10-30 05:05:00', '2020-08-10 01:51:00'),
(97, 'zAYQQAR53Ux7wqcm8LiY7Bw88V4LjsHV4BdQKpTpiXOjDugfzFOCgtB4AYDVx12kHi6tBiJ7NKRlT1Z', 'nheQXjJ5VVvgT3fQomvl1qwwQpcsEW1xjAky7ISJovjPGXm5lR02se', '2016-07-24 07:26:00', '2009-01-04 22:08:00'),
(98, 'BaRKrnuEJFmulDIrUEiiWeh3aYjYutRP38wkq0rLcS4MDvF1xQj28uHe6Vekl60pSAET5mgjo6rehuZP4yjHSOmkzPJnxEulZ6Vj2rCFgYlq81nCXTqTB3kKBSzqj6s10BsgnlK1uQXgJBUreAmuFfeCj5AWfVTFzZ5LRh6QEsdmfyT4LiD3Gp', 'EN7MhzRNbfpWVLAzgzPrEW8q0AF2t53EoBQtdHOlCQzxpdSTG3XxEjMpkuPPmrkeH2', '2017-09-14 00:51:00', '2006-12-21 03:36:00'),
(99, 'oyIZsZLAtWOOajTuJlv6iYU0Pmyp2okZPOpSDSCvdVtqWAOKyb8sQ1mwqzsf63rI6lgOf2zTVEefzbOwqbL7xYTaM5jZ7ZurNP73mfj7YiZCTSpGIhjraATTeQBWc3L3vU8', '7BZXuMbqUcJBmNLvF6QhDkfCjB0kldmbwPtNbyrwCMgo20FpXeQGLn07Vwa25', '2000-12-19 03:45:00', '2017-05-10 23:14:00'),
(100, 'EOMB7y3063wRttwCfw3act0OvO1F07SOZiDDJYbFQQPs6oK3jTtEvZd3bn3Fjhf8xyZzQMSy1CDaajOLocA1aLmQUmcv4JGmec3TRE1Uk5T0oG0I5r', 'qlvG025hedf0cVEnzrgZSxuRLLEGP6VkyuRvkfYJ34KToHK7TdmwczH6vaZVBOET', '2001-11-09 07:52:00', '2024-02-09 07:47:00'),
(101, '44u3n4XBesghmuI1t', 'FaXVDz728G00LXL1ke2tEWxYAZSP1ge1AiF2OZe28m1AXAbrHHWnsOsIZBC7J8suxHrpZrGdhse1Ll', '2003-08-24 02:05:00', '2022-09-28 21:03:00'),
(102, 'Xu2rM5IHybjeUZlawWjmFCulAuYruBWxOaltpRFRmcFJKu4YOW5feeWYqmH8XJeFfCCEy8J7kF1cORtQTmlC14PHs07UoOWgN0rmW0UIYVbICZ4uZjN1yGnGTAxDM2LPSNM01PFuUdtobnNXkz6oRPU31XuTMJtpMmNIB0hrlpksZPbGshu2JshxMxuSbL4E0CD4IEjxnMByYtxeAdShpyAbTsDLrl2q', 'EBjdbkm5x3WZkJpLDXuptkwUubMBW', '2022-12-15 07:18:00', '2017-04-02 06:40:00'),
(103, 'kaLkSz2mNuVwZKsLOg0XZ5Q2nF1Abc2YtnpCTNEMqFqwtEzDVWBI2QXGK8hTsHWV3Pqy472UW3OgiVzgpkIHKcNBg5l2TCBy0bSgJuKIl0e8nJd1dNxXMzEMzPhmEF84nXDBVPIcSa2CpLYV3nL5i4PFhLs2', '1DLI6qyQZtLbxzdz4myZSStSCoEkqegcT2VJQy888t5DSQwU2DCPxdFIUd7SVIUtyIcL6TeyJnOg7iiiHELVJrXmM3hbfh77X5W7IaQUk6DudiUp4BXsyepMcELKsP4Li8ufEQ8zsXTr07QbKuU8dvjKCsgFvZ2HksaJk1aHN181fuogHnS56PutCmqdsVT12DmtBEiwHTgzcJi18lEdIYvsuDGc1AYyy6TYuEI', '2001-10-03 07:11:00', NULL),
(104, '5alwQbWbcORzfwv21XPm5SIE0z1dKXrzvGCzXOvJeMDiermsSrUBdnLQyogqfqA3jFoOPhlkq3xK6kY16MDUSnUS3DXKicNoGrAG2WUxYMvMoY3ifJoIcIyOSgw1TkHzKOMiDOOxW4UcoWF632ZnOhNgaPOi2kVHKPprPRsolFSa5CUgSbLdfbn0aY4afXSdyokyWIR2jKWk2ouDu', 'MJfgZqMtLCXtlZWeRTBIZtp81XLoJDkKvixAuPrTUNdUM6YXOtoLOTvPXXPknSdwuvhG3Bxh7hDm6viTNgBXBzwV6Y7utJeOvMYo2gN6HtY5okkiy6rNA8MicxMex1iN7AOuyXxTkbKkD0pgHCeUlzak0AERA82wksXsZAk3EvRPWywpWMC2PQrsnCOV7H7epBzvnjCE1jW2mXkNC0fWxVu42ndlmm', '2009-08-24 22:28:00', NULL),
(105, 'GTDfQGkeUUqUuaoCaDNlu1gARaFOH5Ua6NrdhIZGMEtoEcnzHInOOWM7esUna3NGJXSIf2svw3iRvcyKXmvJAahXwc0bpt36K4n834Uqa2880FU2aRHHqJD4f6r6Jor2dSGk6gAsgTaDYDTowOmYCrwgjQdtmGeAGZ2dyBfkwe20YPd5Ka6g1JEdPnosIurE51XUuqoEu1yFDFctwmB3mQ5uWIb', '2NXpdfat1StD5AcRd1rAwyJIPRb77Vp2ByjS5SdDvCFWC2wbif4VuAAhOQHDrun8jqp87UoeSe', '2003-09-05 02:21:00', '2000-11-10 07:30:00'),
(106, 'SiZkGFRGLoVDnXEuTpKvfAGAQ6ARJVM6ihRQibBZTcR1TF0y5M1rkibuxg0LrI50GZkDN3RCKgwUvD83n7vNdHWc7Z3XQ0rD7XJrWoJvoNJzb68A7WYNvXjLduO7Jbd4wWvhGHOsfZxBvalN6aCYsFrZObdGo8V7778st66uyyvYSwZ61tDB7b1yzfC8U1YJsYvsfiAiSRCC0Pm5myG7wXDAnZNetEnSfkb7Fievztp1jpCvUsUJPxwsEARZ', 'WN4ME6HCGGiTTG5TlPYzz8wNRA815m8KCEmwxoVtdJBt6qrF36hyTNQ2hLgKE4RYKzO5uwf07o7ZiUihtzonJ7Z3IDkJcM0NKCR7eBhY72zM', '2003-10-07 23:06:00', '2005-03-14 01:56:00'),
(107, '7lGxxAFaOE2JQZPj6DJE3fxzVvPJxrW25DeCSfjQjms2IpjvR0rcR2Bi4OmXMdENSkd35j8wp6bILRCwB6UqGX2uKX4RI8JS3CykP3eXLLo1kd6xwunALw6yPwBnOK4iUEBfk2R60ZCgI3en5jeqWElzhZWj6Kza4TIGbIlxAkfh2gJjaz8BoWtIJG1w0ETUx1HzFXcyzqtJG435w37zP3v3oMLNbWn3LQKOn8b', 'D1UPjCivHTXTocyrtFzwJlbq1NlTRzrBQdTouJiW8WceD2irkBOa5GfQkYd3hv2Q0SWLPSueS2NvmaaWBcewklrVjMczOcxZxeOqoAH58CEIbW0d5F8O6rbA04N3BrHdUVAXgZV4j5Sm3OKCgnh5iNax1LNP1MpXmE8qzkMJW8BE43ueUDxIwSJE3eJ6dG0Za8B81RO5dnZ2BRvc4Jv42WJbkY3xJwX8lG', '2003-04-24 06:07:00', '2013-10-16 21:26:00'),
(108, 'HYXjo07YgmaOuLVrXCIrgwnzrgsgikIiyXJvtxOwB1bTr0RmSB3ysUm3knJZSaNwPBAzdI4hlwDnHpgv8lHwgH8eoglJ2lN1qVDVj0bS7rjgqZwZQ0vWHKHbzsOLxQOUicfVA0fIRpYLgmv6nABhmreJ5AVhE7IEIUeSacCP1nlTJZlqfqrHqcHXT0yY3eNHN0y5SzQxA2x505xWuoElFWs', '0ghSET5VbkULs7YTWDtxx5OWabS8anf5z74Ey05qTh3kVKnMJPVL2nYKQHn7eEvyUkEVNbntnD4h8iYf3JEwnDlOCv6BbyztUzqa2qQxaLDA7whUiN183JY18hGb75LoBsE8GvF', '2014-10-29 04:46:00', '2021-03-07 02:01:00'),
(109, 'oPckuZPs1a0jOa4TRSNpKiZW0aIkomRM2ZeflDyRBe5FKMOIKbQAn5I5c7BTFRYXWM3Rry3LyhQPrWtBUX5oW26McKBoPQDp1TNZAEHb0oBBywvjGFBQtUURWXvGkfEDqmcaH8RsHDLtW4lDFyf', 'ukzRPoISifSIPRZEGNBocvuuV6KmNzqS4RMLqIIROiFeuL7MW6GRtI8L2lb1QGXmRzexljVNsyrq4lLwPzEXcyHKAIeeWPZBc4zZnj6sADkujYchoKyZ8RG0VDvKZK4tGlUSIpNiYDCXuV4jXB2Ta4SqY4qWqBq7tlw1kiTdKm0alLhbKdF', '2024-12-18 01:21:00', '2019-12-18 23:31:00'),
(110, 'X3ZYZItatrG1lYwCcVbA2nLgFMWYpdGejqjhHIYllRWy1gOLRQJW6nFl2MvmuGF0CNW3WNSOUwgKvNc7SObxH0Fi', 'uVK8rezocZAqloVmC24ebYutCD1WIumAeeVgdzAHsE3GpOrA2H045xmJsQi3Swu2tVw8XyAjT10454ACGfSVkh31YZO6TrkbCaJpdt4krt5SU72SbOdfrNkRevsB8RjeCSuQNs0SayuXieAM', '2018-02-02 03:07:00', '2009-11-13 08:53:00'),
(111, 'dfPBXqQjXWQGXBLLfoAaQKBLO3qyLle3O15GRD026qcxkeGyK46cBUGXLhjmvHR00DjSMyThfsquMWsLZF6ujswso3j1oOW8axKGLWWopQU2eFtZNgrgYGKmAas3fddC4ROMspKwsxLsurYINj6YczEPJm7RbXne0fbdk8kfDSp6NraV24IZG48A2ggu5ldCyl3VdduXUp8KS3pnYt3ZnF6omklCNXpx7pt', 'sveE06dEbKwOUazxSe8GbndwY7xhkBw7IR51canZGUCLtckbbwScKOH2yFfbt8uCJ6AvAy4SAh4DSbYL55ndi1a4dmXMZq0siUXrqpBSMLch7G2jYYC6fSVsrCx780eccniCB4VNHSEMkhU2RMdunomkRiNm2oSQrycstix04Yr3wNLY', '2022-11-03 00:25:00', NULL),
(112, 'lMZYyViLA4OeJKSOVe4Wh5KqezpDWX1T0uNaoQHZqXaXEQvxk8fx3s1tQlxhR2PpuVmqqBbg2QSqWBUfEbD4dd5MFBSoAqtdGrRHnlb7W2qgzsbQ7xx1JXoQDDrTiDQqKO1zhSU34a23OBc7', 'Sbh', '2010-05-28 23:57:00', '2023-02-15 23:27:00'),
(113, '4AzRNLhgUcovmJ7RgUJS7goP6EFoAX1CTqEsPqGzOFr4MJ6x16y6hcFnzc2PwT17pfN5loTZkll2FUoADvlLKnJIYhEC0fYnuhBFqypl8F7ExKTeZB30hCLpPzvJjSF2yGLH8fD78iY0fPpo62WJyf0PSL', 'gaasebFX3', '2015-02-07 06:10:00', '2009-05-31 05:10:00'),
(114, 'I0jeSMVcHChkhhfoZ58', 'h6bAaRwIU6ILkWHaO84d1NdD7w6oEMnYWM3IeP18njfHReMB2WjulxRtPRCXvjMNZYXAAhxTj7yd5PViNfEdiVelrWavZHtsX3aLgz0elU6z7IYL3LNMWBgwoPVtQpXKvcqaxDfTcjBKWtBK0GkPEtM0ccm', '2024-04-24 05:48:00', '2004-06-01 01:44:00'),
(115, 'ZyzLXLBWSZtnazz8vqy7SLxE4gpPXF8HP5H6PGwen0zmAfbdii4YpOtgrACjcLsxCyo37GYyUZuawbsmPIBjafN5lX3hue76wEzyWSJ81hEaVwJ5d0OOliAGq4RAftDzwBJpd6OtVELOYv8EbbV3Ns1m8OCqixTPvP', '5aDHRtXAi5HduWj53C0XeUQvMElehGr8b5taz7ZthefPxLvzx0y5cvIdyeULkng6OMhCUsxTewlbeEx8uTbH7GaUv4Ia8t2fL3HX81GYshseE0A3jNKBRrM47z4eyoPnf0xwQGppqxf', '2021-08-05 07:16:00', NULL),
(116, 'ALlFbkBHftH6A3PuKwTPUKYrKKIhWbHUeWC5M0mGeyh1e8QB2XKaKMznw2HmH6KGAUi7Psqy7qJdLZPCb0Yn5UHPYsUAYVZqziEpddnqFCjpky7IhYsHHtY7PblCa7UsC5BnIyyJKTG6tZGbyT52KuvdPlA2Fn6OelerCmsP', 'j4Zgk0f8i0cwPmt62WBZBrpZy55krQxAxRFHu4HIx504NTAipfc8XqZ7ZskZdgNX6sJrQvp2DrF5mt7YpJzGDiXbxvMtbFiwUj4MxBGHt5n3xhFPrtW0G0viE4LERzEtTcksGw7rxjh2NCdNi1Qn1NnNzdAnHPcFbmJuo5IHDABgTrRKDy32pLEJHWTARnQTC2elkSIXVxuIl', '2001-04-30 22:29:00', '2010-12-20 05:11:00'),
(117, 'V7eXvSbbIojTfM7dBFLRAYEJRJ5Ytxg2h8qFZ6y6PZk5i8ONhb3DM4bjUrYTHVNsZ7wHbZbcIDbGVjjfCZRFVvrxJwuzAIE0rB0GNRuWmWxR0FzTxOoBeKrD2qu7jF2P2MACfNrjI0LyrBRc0pBFN663mbZzj1nONMITbKy2HQ18zpeyilJyqbcr6W6qxLXGxykDXsrW4K0YGLVICdkvim18AREOlnjhVgHzQA', 'sMfOMkctsbIlqlKoXVKVlsZCxWWMrimknxvP5YTG8nWZ3voVQQlpvobAQWxaAscxRJAxDVc5PpR2lLZTsLnPXQSPJB6luFx22Sf5OZMCu2KjKRC4lct1jTmuNTVpepW2sfAxduITzZPH8cJCyzcPU3TrikM3o8wk755f1ZXeOJeavGdZ6rgwecjNW4RwOtOe6HTqJLYVLHTucWoInv', '2020-11-24 05:16:00', '2018-04-08 00:57:00'),
(118, 'Bi3HQ6SsTHzECeCzP67RUsL287U5Unb4HIHP0wmEiivZs10PVHx8Jb8ujZ4fw3GXkzfW07Z6UyIuEKyokUd05gDP2tPeld677EYJWlqlYre8N5lOLhvEw2hZC5jStteHkwHoSlTdAqGC5gGe8HLPGjloU0x6WI7H4e0qlqzIqmVJ2THQaSfbYewWTBHww5av1Dz2bfbxHzb2h6pfI21bsFYYJxVFNNvBgMbVJIQKhh5newhYFcNIhlJz0WZ', 'vrFHbVQtrzy7egSiKWWyo1hsg7z5QZsxPJvx0S6IaDLIy1r2fsIc5zQeAm6FIhcY0pjZmWYxCcSwodIb3UHxoAJdCiqMrAeTtenYqmXwYoVuDM4dS7lLrARsovJrRMSOYho3CKvI8', '2022-08-10 01:10:00', '2022-05-19 06:37:00'),
(119, 'hk0qdu6uDt157aNuYagXjTFh7ADHOIZjUJUKnivMy3YODIBOwq', 'cKkfCgR16tL3dcv1WIQgvMkQr4Dw3Q0Wdm4HOxmKunUGuKe4m7SGeu0EUVyluqKAZ1DmIQiadmr0lPUpCCw14Y4bOT6yx7KpxkWqng3fBdXez7LmSM0jXjzVaYPT7AqWxGfiY4HG5abn24A48XpcruRgNSDjSo1i8CGS4g2fw4qK5Qfz27XV5fmyEVuCw4GjIpjRnbST7nrWAPJSlSbblv', '2008-03-21 05:40:00', NULL),
(120, 'gCcatmBWoQ7oCkJfQffuAYrLNUdH46ZlnLdwAj1fZPtvWZd', 'ei5aGT3RxSKvf8aXCrusONySqNe2aNzJUK5xfTpIsjflbZjpJWFJO58ddUtQ2ltgqRBcUUpDfmOHZMDlIS1I6h', '2005-02-28 00:16:00', NULL),
(121, 'siiA3U5OnnuKYTi6jEaJvdJ0jJNdFnXI1XKESWCyCOtUSJZ0zGqOAQeakkIaGRgXy4ULhzTSpnlqvFuFSKsPhXWYEoMmcfoT0abAAkJQV0zw7NdKuXxonCLcVTVB7sEtOZshR12A28z6fYYLyShLoWSNeLfCc5Ft2To3VwO4vqdJE56GaH8CJa040bSs10Pk14SCIws8egPHHd1LkeLVlHucJi', 'RIgANMapuVAiaUsXVckubKb4jci7P0L2A3hTtYqOoGNZIkTXUSr', '2004-11-10 07:22:00', '2010-12-02 01:02:00'),
(122, 'k6oqIS00VondxwP2kNilwZpocFOv1fbOKP3WWbhVrmlSphU', 'CppHDLvpESBQ3QEyd3IQxYxTKhLlnSrNcUYZv2fQZaJ6PekoE73JNQuxv6p5hl4PNQF4lwFMD36qlxjf4jE3', '2020-08-13 21:48:00', '2019-01-18 23:33:00'),
(123, 'L3IO8d08XnQubQH8ZNgOcGz5wbfDaf4clEZ1mCQwqh8ipoAgLdNu1pnAfVp5lDKWRdQ8wxhBmyFxNt42mWQN6CmpVTHZfLa63Fl3LXUBdIQnSSnwrpB5Ylwpx3GFNUfB34HY0aMo0kRnG3S0AmzUMZaCHmwDwVP8IAWSg8rOe6eXyN4ZHN0OLvo1BEZuSyNLOBe0u0cEAjbz6tAaFU55QZO16R5NnHxkmsUNdKk2A21ljtGCO', 'DmSHb4U4ZqiGxag1Y8GXLUlO6x7w8xsMADmh1', '2004-07-17 05:08:00', '2013-07-10 06:49:00'),
(124, 'HiENHs8smw1lC6ltiWVFXDqhlyMXx8cxiFIoz55o6jnpprH1', 'Z5S7wFFLOwXhZwkRXqTemaYZUr1FcKbDBOerUJydEYnKiZ8XQuryKWr5AoGDnSOaSVUzPHuNlfwMBj51yccxuPDodFO', '2002-02-16 03:27:00', '2004-08-03 21:58:00'),
(125, 'iTVB7aBgSFIszyvilwnmwImLvW7FMiZYqTFVIkpUHnXLscDICJ61MlvU2GOy4R5bCF8Vi5ItGakWZXd8lBDR1isGE5', 'f0pnNijVRmSVHwsZsWW6Oq3YUduK8ZYKhoPKCuDXczRsLio6tvJXImTEf6qg5jeRX3mThf6nZNWOggstPhqTdEwiYYxPUYGlSqUQclQ5BruhLR4WTQyt6W10hlkycB5WwN7pjSaQUzLux4nX550bgemNr4ZFAn3QIE8xfBhGJexRCEp3nmmnSv76mpxA7btreDtHO3Zp7CDjc4utDpteJ1C4DMx0MVxnJJ02KzAgBf803eJKZtcjaQtdNrX', '2020-02-25 06:06:00', NULL),
(126, 'fJo2XwYgOs2vVUdZ7yMzq764zbgvhB5ogBmVpzsNoGxQJTZb1TIaKgNXQwlqexOmdwsDACBtfgMPd2RMaRfehZeedH5efRmWOtpn3ZokevPiUsNSst0xHqezEBv2wFcXwXpENnC0YelacpUBExP25lyxKmn6tRYOE1rAtD', 'xjLvNB1JfZlI38Hl7d8bWR4mK7hV6ziPmSEGqRSJh6r8', '2006-03-08 22:42:00', '2004-01-11 04:16:00'),
(127, 'HNJmtozu4SXJUQ7l6hJgs6GLkjSSgoDwPIye3oWFM7FIpiCIe7xHBTdkbNhYE0tvdBj0VBW6joJNETiNNGrNFyFG8UqGw4WJ4UiimGyDEg6V78b2kyed1Q1iGp6lSKeoBVUs4tMrNiwgyQdZrsnRrsULiuKlMwcaI4QTVEwE2xqIyiRBvoxci5qcfIvtsapPEQLU4oF3zoYHoBvZojwAmjTZ6xISq2Y', 'Twv1AnYl4EJaxZzS2sFuGH3EWwnTPcZzlSzsRRsxH7apAIqCNFQN8D70q0P2edm1yzUfFPqOGwilVvn3LAAC2IiawVhYWUbgCRqCINyciHf2HXZwygmtjBSnrTu', '2021-10-13 04:43:00', '2008-04-27 03:44:00'),
(128, '3WJHC0ZYRq5i2QLQWNcclKk3RIQColodjoIan0BR6djqRePc8omKNiaEdF1i5ehjj0n7Z', '2GQtwvdaS2U8WnlIQvQPyMx', '2010-03-05 00:37:00', NULL),
(129, 'm0cchDdREk8cWT4svREC3Wm8ThdgBKx2OceutU6KXg0V34rzdxeiLqbGL6BXs2he5GhX1uLbGjze4HHAAbEuhSZ6vYjG5o2I0XKv7kt0NqbJzkmz3CQLgkQ72TcaeB5dfTDzqFVR7TtyZWYjyPisLHSMV0VjxQCzRFFd6Q4G4oxvK6qVDXpqiuDLG8jLWDRZLM15iRFBO', 'tmYBOZFoS6uErXdDnr2s2MPS0Fixcz0Ro1zuPRVWwrZcDop4XI7eEWhnSZ2iJFN7csuta0xzbDn8xecn2hBhm7YYA5ZSEfSsWYFuijtjidXgzJJ7l8bwFlZaKpkjHYmRaNAL6FWHoD0A7ka6nxRJCM2EcAQoIwTSaNnA0bm1XqrsMy0tSFLXuIRbzCR', '2019-03-05 08:31:00', NULL),
(130, 'vIC', 'IqVJqBLx2nheP0GMSV2nqqfSeQWSPYlg7aTlZ1AzTQGblZoH5RVY5vEXmOMGqPZCQxOZAWDk7etxwx7OXufcUSla8RL3n8pUfcoafgfOJRHzFG', '2019-11-01 01:27:00', '2009-11-12 02:02:00'),
(131, 'Y4vygTs60qDO6EiQGR7533KjPLxO0yb4DwcnQsBVC5oQSxV4oVOTc2jOooJKHXCebjPP0Dunn4bEdRzma60C17icRe8KheToyRomcnHsKsv34lbKXQyQbfbZqeivSUYR7z6MWULWudvJpaXr2RxsIaBLGezsw21ZhuC4mAwmTLexURkeTyT5J4KfCouh6CL7tqo2pL2asCxrND3GEezL0y5qpZbceMjDU4EtcRjH', 'FIFtrSzS1vLBX7ZeUcMpCNUJU68zeDBt1kSRdTBK28h8S0qaQUBvjL4AgJjo8ycajUwEYKkUoWZIXdjKDC35rWmakUHOYj6W4YFFRRzZRXMc1d0hSzWxMYqxAdpekmoWs02MOo0qTBg6oSw2ySngbYi75fLZTcchFTZtktj2OlNDgB3oeObUWpU4V6DUMW4cdJ3AaZh8VZDxbKT7XlAkBan5QAp7UJrJ8wJBZL6CiYVLxMLMZc6Cjmx', '2008-09-28 05:51:00', '2010-02-05 04:51:00'),
(132, 'vOD2KaCFfkh', 'AVU7TSBky3IgSmccsotIysa7fbOA0wDdP7qBpJcAYibpEDAnUiSWesiRF5KgmNfLSShjDzywHNaRkgDVWP4SEsvizN2knWNQ2jyVqvdH', '2003-08-16 22:05:00', NULL),
(133, 'as5gIVVN6YZAD8g0HpBGRAK4ujBBHMkyon7uQHSYRWdpgt8kZUvQe3fUdGABe017ugHne8zIUkQKjgeGZ', 'ldMDBWkFNyMbiUWhlxNXOuvaRh8CgiZEki2HbutSGjFx37vRnEMjqmDsiA0J7bFSgAMa2rAMwNglPwqmXGN7cNcv3vmHyKl8zW8mk4bSAyRPewcqWuoIlZ5Hprbpwqvw7Cg5YmkiNansJ1xSBzX0PFgu54AgH', '2000-05-15 04:28:00', NULL),
(134, 'OlOO4waNRrZunac64iQToieJEVo7a5w1Qm0r2Wu3BDhXiMspuViLcPMyc3H85DAcoLfFErDOFgQcyNa20bkS5yjAVfn0LUndJgtbpjvPWuCrH712qKz', 'yhXaXREgzvA6oqghhbqYfwSOOWTqzF6fHTNmZe4kXh3vOg4aVTWOWcs6GZ2xDovxnuaGZBJOvOCcqpZeAYJHptGVsGIaXfiNJoD6zjFoHejrOyHJff2E1HriIbOqPwihCIaqERRROCe0vWi4wsxkFzjbTvLU3KLoAt3hXuNIiiEjYKMRuBWawGoYwQmHHPF64jyMkbaZJNTromqtxxNMy6x1vJKYZ6', '2002-09-30 07:07:00', '2024-03-07 04:05:00'),
(135, 'Zanfaxv0aXWyEleDkcwjgw0aTiBDcxCBRCEMk1PgzrfQwyMwWLWwzqCa6AI5FBxpAgUeHhaflA8qv6Vqsx7BTxBQjq5P1YtwFiCLyqrcf54nXuhqutUkQjYHn8SG8pGXCsmNSO6qvzHXcpXVQuuaf7gEW3C10ByrNnJvCvznaKQBsfsTuKHlkStoGMtTstO4h50ERCvPaC00fNSUAWjORj24nUJbD5PKadpkwiobr1pNg', 'W', '2023-07-25 04:07:00', NULL),
(136, 'zNsEb6', '44ukL1urGvYJyrp8ax7RvOWA0XLJVcfB5AuqclhGGPYepV3rjp2iFchpLvlJnzXhc2qvqZazkyJfAiJ6FyiiazUoIrta0PZgwvY84Uz0H4jYIkKtyAVgRUAxaIcpW13Mg0PfRqkU46fl4tXH3vhNxiV5Wkx2pUPwLQU6jYL8rZbikVs6Vvh', '2013-03-10 08:39:00', NULL),
(137, 'qXGlGGKWwMuQvfuGQG5h553M0pFMQr3adgcISYVU8r7owG7B0X0CYP3kQMAgq2TtP7xuTfiOXRtrOoAu6vXfwZ0RK3iI4VYJAZnl5lgK5SMP7VNs1Aq4ipkWK54473Ov', 'TwqadocYS0pkjEESHLCtmaRBpwP8XouHkQD6hkdLj6fSTjp68KpJt7pKnILMjXZMzUeHDAsfqpja16aIyE7nROlQa1OOZ00043GjWWI42HZfafhNDdGa7kqxSAxd2NBbD2mhJGLyD4piTF2ymMpOL5D', '2022-06-24 21:31:00', '2012-06-03 21:41:00'),
(138, 'ZhTRxAOwzmNlWb82LBVBJlWL08LQR1mHm2JMOZb1lMlUMF60vdUQYwC3mlfDEiuAYhmreLQgGoUxrmVYVZzGdvVo4qJKKVGI14zHxN7Jy65jGts20aX3ZKyL0Cz07y4q4zETv4nVzW5FiiARep31EqRwLFdwMxmwGVmDvSnoay1UHdoxvslTe25carn1Z8viDIpv2rC', 'UXqCnoF7QL3wnFGy1N554JLc8KizNyS7nLS8dNGRQri42otSAdBQWsilRkfbmfpZMH1IMvQQovM6i5XzsX', '2022-10-06 07:20:00', NULL),
(139, 'pVGdUMj7F6O16231CnitgUSPUpRwgudAiHPrVcfwu67J6JUOhOLwMb3X2xvcqR0OMyCanUkj05mU0amLGOlAgOHNDjkS8TGx3', 'fybWpuo3vQlnfQCuHZUWv44HzwDkCUC1tHQvI6AM8ktitxhx4LWJQzzhlFYKNcCqNi1CscdDhVtBGGSNbamyvkCGMxmxeIpja5FcM3bs4RcSsfzDG7QJJhFEkCaQtRepo6v5gl3lEZibxQHgGmsK3HGgCUN6ayWF7bjFsl7CpZLLzf3DTy8POu5Rd5UPw1zsdHgZE', '2012-12-17 06:08:00', '2005-01-30 07:52:00'),
(140, '2V5dsqGgdPJ23mFSKVL1YvD02R0kvzBSyaSbACallQcU1WbjSyjhGwxgPqljObXYfvGJoUbPuFxfqqpR15kWgNeWtiSo8tNRfjxZG7Srj6oZiIf0zV1kv5jDJ00HIyf8lbrooaoQkf5mSWkgtZlGz1IS', 'mMdD7DVw0RRIPadTQDeR7RLDRuWbUkwBieUlsa0hTREwu2SrZV5ggmLXn7I6g3gimGwurQRfLuKK6mK5WZqrkp2STB2RHCQa3AUhBmsRFA41C0j57EPDtsiDQZmY5dUEvWQRPFC05WXMDfML0GOgbRSARteHY', '2012-11-18 02:11:00', '2015-02-08 23:23:00'),
(141, 'l6w3YZZNZzX5EBDOxXHhH2LVVEei7isVef4WHtlLNVDx7mpjfIjmiNV7q5XAzBT8LlyQAFTUJm2rvm6VHbzF18jROEcEcfKMF5aEiilb1uiTnruqMlCqwiXCP8QzMTxlj32UeMTIAcY4lMrvqzS3PXKQ27fD7ws2kqeqo7HQXuBRZIUeZE6aIpbd8nULmEEMPwYGumkPq1vg1fDXCN6wMc26uVL3kLF8gXhFS1PJFGyijaZ8eW0rcspHspZhiwI', 'IylThXFALqE866DLHW8j4f4UMqpN6VzEqBCsSkmj64OIEmxKe3ZecCVBQnwIjXWGzBMwsWDBV7enKHhjG6Sovqp673rd63ZNv7BKR71RbgutytuczZpZJLjUdSYYnTxwjd8b3vUGUkP6Rj5A6n8n6DdhPthtWrG3xvNIM303NgMzaoohLuMrVyN7gQHxvxIMtQBtSS21RJMv31ngqeYr', '2001-01-16 06:16:00', '2002-08-05 05:41:00'),
(142, 'sxUgYlUnEBoo42Zecn0uzo5UUMdmfOXlAqFZCITmQdNS01O2YmMc7bvC7HqD7mlJmQ2DAGzeZrSD0NUPTlEjpWcMzq8njVMN8SyvoXbRWeX4R5FPWz0VfP5lfRQGDVVhNIoCEK2ozvoiXKk8XJddRCwNtcggtN5uGh8iFo0UBLpCp4uU8ZZpgBhk4l1NrTxgmZKqJ', 'pzucNhAPuD6ZMXKdsDIPnrEZmrguQWICWky8Z1R8ShDq2Wyhp8Q4mmHL4JEbc1itknz3rMDJkus0btTqxDLSikT250DGZrke7Kt0YgcYiEeD43wzL', '2024-06-18 07:20:00', '2001-04-17 08:49:00'),
(143, 'd0uJWcoWqvIQlCHpILZaRMGvATNv66FY2AYQ8BIZr2pMsdbCeSGx5UishPBOIfP0yhjeN1m1uO4cxziDBAdKunol2ebMqDqAoEypASP2BRCfSzlPDSgA6iOVx6z2kLtmB2UjuNbWKfNuOSxSKTQpSuZcx3FX5k7thy0GhwJLgXU6kNGXGrsczEOfTNGBfj1b7DoYib3IJPUrAXZomtL8Q7mfxa4Z6Nqk36sX3N2hlAB83Wq5bh6JTpsXjMkA', 'xPLvIPf66yCpaILzy7WlhD5sfzNOaBJWbNBrVGRXuQHguhUTouexKdqlyZ8Q62ZoLwFtwOw6gcwQKD7Ns5u8d5qVc4v4EoLovmT3IailiVYYJLqky8sggM2ZcBHevQwTWkDmSu1JpjnofB1T1B1vzJnbu2hA06h4n6m2WBf', '2021-09-05 23:26:00', '2024-02-27 02:08:00'),
(144, 'i0rayza4vYiQXCZc7dQ4q0Zku7cL6h8COhdSvWaa8mS28b65K84OW2jHgVH0G3TOgMh71A3w7tnhhf6BU1qP8C1kEQZurSuy74wcbD5tZEJUCEiFk1odhRDg3xav7mQztZiGMrzUS878TIVds6OU7StjIbV03PuxdT3DxoDoVOql6encMtlQrUzJl5Xo6UChmxONrB7gcEVnzCxqj', 'iHUj5b6BEr25ulav6FvK', '2016-02-02 08:45:00', '2020-11-10 02:44:00'),
(145, 'UVPPtVshANuJVXjGXzXdHfR5tTCs34zr1sY4c6I7t8DNUq6fm21xBHGm3rQTEQ3OstCQ3YTotmoSeR18ogR0TVYygUako4pqzR88QFnvyj6UeK840yYgmVOInIcnQKer0l1ptoTZMtrhkxZ1c6qFXTh0qwe0Mf1jsgzaIl2XzJwFU82Gyga4dk3T5f1121mgQVzwtiDQXkuBOWDy', 'yxG8oZQxLd2ijCWRcrvxrSpLcaqpOU0iI8i0A0tAE5Oy8Rc8tBADfFNqKXZohIGhWXkeVhjmGJJxVQvm8rXHj', '2000-11-25 02:46:00', '2007-02-14 01:29:00'),
(146, 'bNlmNcK3KxWm4035xGXWYB5xVXObZ2UsVi5ZcrKyMZeZGpEAnCHOnaY1EwJrBQuNqhLGRD0WDvLLKTVWylKwWUdxpBSZZkMSdwqPVL3YdMicIobNmuKB4rppAAaXE3vU', '4PYLR0dve0ZwfT1UC8E5xKpiulRkGyvwiByDE7JI8Dtb3oPJFmoOQIWCg3b25pVKUIQLLVOM7yAljiXvHxYK1PTau4qbeEkYXazpLiF6E5DXx8etPF2sP7yDwl6gfLocuOt3m8ahu1Agye2IXZpKqdzrYq6lKbRfOiA2sXDLCS7TRbSFxIK286Dwl', '2016-10-09 21:45:00', '2023-02-01 01:50:00'),
(147, 'w3wI4xCm0xzuRDd1fBZkxhUsUl2nqEFVFpmJUzFLt8KAREemg4tD7xbbLsWkKYGHL3MKfGifQvuqwQG0YmRD5wMjVcOvvZWZH8NhXoIGer2jykf0MeoMkmKN8u5o75xDaOAf7FKL0YFqoxCPhMC8yJg8cTRNqRPEuiqJGoXiUqwIfYkPejMwnt7FLTsvYxzBHTY8FFgmYA13NzI3Vevyz26FFNfnwqAGcM', 'OVkydqgpMqVzrcfrY5IOXRuMgISlTNSqo7hG88FqCzSd7Vdg1mUIZxKT5JMjhiFoSeB', '2016-09-17 04:15:00', '2013-02-03 07:57:00'),
(148, '12Mntlt3CgT7slEeZy3kpQa6Y1iKfaoCSInCLycZvPPNFWvkE0RoJ1iRuWldwSOVJ8gvmJIipyrNiqFpFEHMa6oryV7nli7EwPOqYKMCuFY8qJzCjPQqM48Pz0lNi4XBu1IYLSahvVo2UJJS4pLknehXKl3DWJGdaGm1a1g4dVIG2Gbn0lUb2', 'jonR6RiUDxq2muv5YqrP5tyHdj7zBpVnoyAEoG1w1ftZXkdpfUE08nylkFBXPR42LBHqFwcs4sESZF7Mvvo53IJYqkTc0xIqFxaPs8rRT46rDmvlKd35mqFV8j', '2006-07-07 06:00:00', '2025-01-31 01:31:00'),
(149, 'm0FQ21J4WZCPZSLCUwpem2i1yu2radVvLKGezekDHv0BVQSYMPHlslf4W5kWnJ0YaMyn1XH82keykPxQ7kqa3NrpoofeIi6C0OZT2mhAvSuQF5GjfvBq7aL5xYi8VEvELSZGlAcyKbHGny2QLAuI', 'kvZSNgzTb3RGsmYHuxd7AiWgl0NOyy0Mcye7NIMdz3km5bej6AXUdUj7S17GYlzPJwELaBdYzs5D6IU4cIDfuBWAGC635EFI2vHHTI1', '2021-05-23 23:11:00', '2015-04-28 22:36:00'),
(150, 'gpSis25R81G2cJjQ4vrdkQY5RTjguAshopvk8vgXIxpbsr4OwcvlLhBj0T5JP1Za51gKn3eDyZY04pI722zoCO2EdJ8A7UXL8wst5wkYq8PxeccGMRRYX5pQPRD1nNJdek4Ck4vbDQWoKgPHPRfrsLOZ8HxVUot6hj6pgTgVuME7HORsshDsH4UWxU06LivQaOTkLnx', 'YTj0bzxnayAf8hejcBdk8SiuKHAo14FnMtXu2JQAbhCgriOWLFFe5D2AfyqE2yFS5Xtb2resi5Ps2HtBqKLC0nfOvhj1pDxnUoGKLqYDqxsNLKyCDyhmFbHZkIKBp7fdkksbbcpQiYYX0VFc4kls0f17ElmTOgctKKStTrxf1PlbCojyuxdHKZnpVNswakjSgbaLxznHuUw6yGwozGOZww2hUvHz3DwqpLxHC', '2009-01-08 04:43:00', '2005-09-01 03:32:00'),
(151, 'pjDjl6xxuguMYfwJD1IvbLVk65yePJGHsm2OwjIkd87s23q3nCzxPBdMg5kSczzYOQbG0TyNC1kznZ0BMcgEabMywnJQumGLY7z7GzhC1UlJnNujao7gv2VNyFKNjGL2V8fYTQmbTme', '5VNwt5QXPBsfsZOfwsoWUF78FIwhFKn5XBFXJ03VWAlMqUjhdFyXcQZKPnAbdnuRcOB8FgqKXZmDsPLDbgctxtrS6ZXdrfFJ0dpa6GGIOX55zlDgNFjR8IXxGxsEwFQZoEeSiwi7yocY7VTyTyCeziwyC5Db25D7CIWIuR6zCWsWF5JctkbFLxcCPv4Ybak1wd4rzmiTgfykCWnx4Rauu6O2ImqNsyft2GAaSUMozeZ4BKFEuQBiBrNDn3', '2003-01-27 07:38:00', '2007-10-06 21:41:00'),
(152, 'HErE6Hy5hzQmUhA6DVwJIXfrTTVA3PphIxKuAd4t2Dvfp7KgCVRDhjPYHHxaHxbIGkLOPSA0rhypyH1XmZiOaKUYNwbJ3OHcAWZT4cxXysTwlAgFqvnmF8TH50EqFLpHfDDYXklroPdpx1vjvqrrwQ3bNGZRWavVXkQlfHDXaLEQcIcjSK7mVKyBiep5', 'ibfLEmYApmGwelfeOHAsyjWT4b0zKhCIHGXw2e0sZGzlymvJKlm2QktXIwfLPb141aRN56eQ2nwTOdlsLHpNJTjhWfxWHUGIDjLGPtCVnU23xC45sDOWQGqC2aQEpnw', '2009-12-20 07:41:00', '2024-12-23 02:47:00'),
(153, 'Db6HqPTPTMJlsY8TIxnm7Vuvs3l1gJPgDMgT7lrRtVKonvLjzGHBTR2COVsCJroJH6MMwSUCSCeOW1WjfKwDGgbGvHXjq5mznpKJ2HAd02gSn0uXYf63hnfJZC3aruy7f7WU6UbM26qcWUFVzrKuFgYVs4KlVL0bnivbypT8ovz0BT5dIhgjB0MpISEEjzz6', 'mUXBx', '2007-09-23 07:12:00', NULL),
(154, 'ZMU64i3hzff57HIP0w3qMFKaNjxWelT1GpoinLtyUuL0Xwb4FYfiRaCNgvR8c11ReSiRtuxwkQFivm0OnjD5DfeqrGwFtCWaq3vhI6ClzOgM0510hHFMFFtTJ8PWV5nPoJTTUZ7CszwR45xfJaIttq8KWGrVVI1mbA5o0De1bqXM13paSwcJAUbPEWDv65tTtpM1IWAPjcIrHIljk', '0PwaQGMIKfMKsJ52ojLZBEoUFU5CKanwGRlAZtYDwJAAm4ujIJHVlKidGt5LvFqPt3IpTTxNTRtAwgrKUvBUjehWWCUKhROndg74vdrHnSK0fZKPzzHFbXRNutjhvA4I4J8DOrlfsmSCkAcd2m', '2016-05-10 07:29:00', '2018-09-12 21:42:00'),
(155, 'ziMjyCCRP4FPY4TyHMevOonYQnVVEanOctb04UhRlZCyNypILXkGnvjrE6bZsPnStnHizZKFVe2kUjIb8i3HSDswgc6jPKVj18HPdqQigGINzDquzt8OEimDom4RvtJMIKtOGAaHJ2IKEP2j4JccvKCDQnwZ4maHlnzj3TgDpRqf6KYIReO0N8YbzesBhHxgJVFGlnm0TAhqcBlG8yqXOhR0NRJLeexqJFwPvHwMW43r13A', '0BBUbR8U4vw2INlSHSfJKQ4FHI1GnsBH3yNThb2UQC5qZSmKbxXEpEQ2JwkQmtvWcVZBkxUTufRyaoNt6b5dSjWV6vPcupKXLL7mJWVJ', '2001-12-10 04:42:00', '2020-03-18 06:30:00'),
(156, 'irxpXwnHfjjLr', 'Jp3Ur5lH4rlUx5gPp74Kqzz4LwdQYUJl0DmthGLqdFc31vaFPCvM0gLmXcoM5Rblsz4kCNpe2GviPNW4Et3CNW7c82K5w3kzpRduPqZAcVi5KTpL1lsUvw67ojkvkj63wjdiizP2frezUOCbLC8BmHQwgnM4helAVAeGcYDF', '2007-12-22 02:45:00', '2004-12-27 00:07:00'),
(157, 'RDrJUUw', 'EMF0hg4ZX0ZwqShXbgJsrS1zUZbAAguNTxKo5VguvhHSTOAVwG2JiJfYyQ0BgQ8N2gANaKRaGirYO7dcSs1VBnIipGB3TcgxjmBhqflrHUQdpEHQWbrUBoxnlwRMLOesdZdLznTS8rdHEwkf48j5ApdjOH6uI6fQcdtEHsqvD2', '2024-02-08 05:19:00', NULL),
(158, 'ZL8mI3bTzhIBZkzz0tJRl2OaBrtI2dCzTrAkdztfhkOFRzlC0hO1xvpZaWdtVg5eshF5MRbznB4EeyrbnyaLFVC40BU271F8VK76rPr2aY34D', 'QMXnOXTGCMnwhUwAuFQdvSd3IAF7f7VtRNcnVc3Sfp00yB3TLmg3I8Y6ePmDwCvqTrPLCZCm0q27sB1zoBWbg4wkcTHM5MIu4jqvE2BqotZ2u1OEazbPrqSGrUf0e00xEdfZLUImgUdr3D17NmQ0AA85mbbVMMpl7D2FvoxMwyJVu5yRvFy6WNGpmhyGzeAgUzBgsqnGr7azF5CxsU17tSqWK10n48HwQtVu2oLlS4pZ4r0R6DWW5AdoHRCVYE', '2019-07-25 23:11:00', NULL),
(159, 'csmGaBrB6ATRTRkRdhFbMRUQIQ3m8L1KdWX1RBoDOUSNLCCeFq', 'SfhdRUZ5yNZ1eqwgGpWViuPLg3dA51oD0n1j2w8Chr7xL0g1t7PGYe7xpGJ0QAiJlKCic1zRfUDCjDh14hFxTijSdDjqCxzZN648wddVTpriu3rIHNFfazxzkmw3iz04eE0wYbmrVBAHDiRcOwdJ', '2010-10-23 22:54:00', '2018-08-02 22:47:00'),
(160, 'fuKj0tulqWZigmp3WKE7mE7R2s0ck2Z8cffFPsKph7wOdJO54jssRL7LpUYPhNU1aKF7F3e3MxtEVFqvxPJxkBOw0WU3WJO0t806WJsTlYPJgLDaFt2xf8jc3HbpNPoNp5zd1gPTxT', 'UJpcOADj7i46cx5DTkxbZfqesgUqu2hpAk48BPK14kmBlW75PHOgZBoSklBIsyBq5tXpnLkvCEDzpLPqx', '2003-01-03 06:39:00', '2016-04-28 23:46:00');

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
  `price` decimal(10,2) DEFAULT NULL,
  `Currency` varchar(3) NOT NULL DEFAULT 'EGP',
  `quantity` int(11) NOT NULL,
  `loyalty` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_skus`
--

INSERT INTO `product_skus` (`id`, `product_id`, `size_attribute_id`, `color_attribute_id`, `sku`, `price`, `Currency`, `quantity`, `loyalty`, `created_at`, `deleted_at`) VALUES
(66, 1, 2, 6, 'WH-MEDIUM-WHITE', 1000.00, 'EGP', 30, 0, '2025-03-26 08:16:32', NULL),
(68, 2, 1, 6, 'IE-SMALL-WHITE', 700.00, 'EGP', 80, 0, '2025-03-26 08:16:32', NULL),
(70, 3, 2, 6, 'FS-WHITE', 999.99, 'EGP', 15, 0, '2025-03-26 08:16:32', NULL),
(72, 4, 3, 9, 'MR-GOLD', 499.99, 'EGP', 30, 0, '2025-03-26 08:16:32', NULL),
(73, 5, 4, 4, 'GL-XL', 1499.99, 'EGP', 10, 0, '2025-03-26 08:16:32', NULL),
(74, 6, 3, 4, 'UL-LARGE', 1199.99, 'EGP', 15, 0, '2025-03-26 08:16:32', NULL),
(76, 7, 1, 8, 'FW-BLUE', 299.99, 'EGP', 50, 0, '2025-03-26 08:16:32', NULL),
(77, 8, 2, 9, 'LW-GOLD', 499.99, 'EGP', 30, 0, '2025-03-26 08:16:32', NULL),
(79, 9, 3, 7, 'BS-RED', 99.99, 'EGP', 60, 0, '2025-03-26 08:16:32', NULL),
(80, 10, 4, 5, 'HT-BLACK', 799.99, 'EGP', 20, 0, '2025-03-26 08:16:32', NULL),
(81, 11, 3, 8, 'FW-BLUE', 102221.00, 'EGP', 123, 0, '2025-03-26 08:26:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_suppliers`
--

CREATE TABLE `product_suppliers` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `reference_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(7, 'AE', NULL, NULL, 5.00, '2025-01-01', NULL, 1),
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
(14, 9223372036854775807, 'uploads/profile_pictures/33864171114794816dbc188b7f979d29.jpg', 'OMar', 'Khaled', 'ok3050802@gmail.com', '$2y$10$3n.d4xcQiWak54pxDCYxIeeaiQ37bWBHiFhG6N1NBmdwdYs615xdG', '18-10-2000', '01286246292', '2025-09-03 20:27:53', '2025-09-04 15:16:35', NULL, 'male', 'active', 7, 0, 0);

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
(2, 14, 1, 1),
(3, 4, 6, 1),
(4, 4, 6, 1);

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
-- Dumping data for table `whishlist`
--

INSERT INTO `whishlist` (`id`, `user_id`, `product_id`, `created_at`, `deleted_at`) VALUES
(52, 14, 5, '2025-09-04 11:22:14', NULL);

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
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_ID` (`product_ID`);

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
  ADD KEY `cart_id` (`cart_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `cart_item`
--
ALTER TABLE `cart_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `cart_promocodes`
--
ALTER TABLE `cart_promocodes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=126;

--
-- AUTO_INCREMENT for table `order_item`
--
ALTER TABLE `order_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `payment_details`
--
ALTER TABLE `payment_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
-- AUTO_INCREMENT for table `product_skus`
--
ALTER TABLE `product_skus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=812;

--
-- AUTO_INCREMENT for table `product_suppliers`
--
ALTER TABLE `product_suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `promocodes`
--
ALTER TABLE `promocodes`
  MODIFY `id` int(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sub_categories`
--
ALTER TABLE `sub_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tax_rules`
--
ALTER TABLE `tax_rules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `user_promocode_usage`
--
ALTER TABLE `user_promocode_usage`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `whishlist`
--
ALTER TABLE `whishlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

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
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`product_ID`) REFERENCES `products` (`id`);

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
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`);

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
