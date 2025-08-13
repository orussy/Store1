-- Create comments table for product comments
CREATE TABLE IF NOT EXISTS `comments` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`user_id` BIGINT(20) NOT NULL,
	`product_id` INT(11) NOT NULL,
	`comment` TEXT NOT NULL,
	`created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	KEY `user_id` (`user_id`),
	KEY `product_id` (`product_id`),
	CONSTRAINT `comments_ibfk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
	CONSTRAINT `comments_ibfk_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci; 