-- Add missing columns to the addresses table
-- Run this script to update your existing addresses table

-- Add latitude and longitude columns
ALTER TABLE `addresses` 
ADD COLUMN `latitude` DECIMAL(10, 8) NULL AFTER `postal_code`,
ADD COLUMN `longitude` DECIMAL(11, 8) NULL AFTER `latitude`;

-- Add updated_at column
ALTER TABLE `addresses` 
ADD COLUMN `updated_at` TIMESTAMP NULL DEFAULT NULL AFTER `created_at`;

-- Add indexes for better performance
ALTER TABLE `addresses` 
ADD INDEX `idx_user_id` (`user_id`),
ADD INDEX `idx_coordinates` (`latitude`, `longitude`);

-- Update existing addresses with default coordinates (Cairo, Egypt)
-- You can update these coordinates as needed
UPDATE `addresses` 
SET `latitude` = 30.0444, `longitude` = 31.2357 
WHERE `latitude` IS NULL OR `longitude` IS NULL;
