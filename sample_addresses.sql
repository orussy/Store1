-- Sample addresses for testing the user profile functionality
-- Make sure to update the user_id to match an existing user in your database

-- Insert sample addresses for user ID 1 (update this to match an existing user)
INSERT INTO `addresses` (`user_id`, `title`, `address1`, `address2`, `country`, `city`, `postal_code`, `latitude`, `longitude`, `location_accuracy`, `created_at`) VALUES
(1, 'Home', '123 Main Street', 'Apartment 4B', 'Egypt', 'Cairo', '11511', 30.0444, 31.2357, 'exact', NOW()),
(1, 'Work', '456 Business District', 'Floor 8, Office 12', 'Egypt', 'Cairo', '11512', 30.0569, 31.2234, 'exact', NOW()),
(1, 'Parents', '789 Family Villa', 'Garden House', 'Egypt', 'Alexandria', '21500', 31.2001, 29.9187, 'approximate', NOW());

-- Insert sample addresses for user ID 2 (update this to match an existing user)
INSERT INTO `addresses` (`user_id`, `title`, `address1`, `address2`, `country`, `city`, `postal_code`, `latitude`, `longitude`, `location_accuracy`, `created_at`) VALUES
(2, 'Home', '321 Oak Avenue', 'Unit 7', 'Egypt', 'Giza', '12511', 30.0131, 31.2089, 'exact', NOW()),
(2, 'Office', '654 Corporate Plaza', 'Suite 200', 'Egypt', 'Cairo', '11513', 30.0678, 31.2456, 'exact', NOW());

-- Insert sample addresses for user ID 3 (update this to match an existing user)
INSERT INTO `addresses` (`user_id`, `title`, `address1`, `address2`, `country`, `city`, `postal_code`, `latitude`, `longitude`, `location_accuracy`, `created_at`) VALUES
(3, 'Home', '987 Pine Street', 'Building A, Floor 3', 'Egypt', 'Cairo', '11514', 30.0789, 31.2567, 'exact', NOW()),
(3, 'Vacation', '147 Beach Road', 'Villa 25', 'Egypt', 'Sharm El Sheikh', '46619', 27.9158, 34.3296, 'approximate', NOW()),
(3, 'Gym', '258 Fitness Center', 'Near Shopping Mall', 'Egypt', 'Cairo', '11515', 30.0890, 31.2678, 'general', NOW());
