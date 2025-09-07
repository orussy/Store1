# Store1 API Documentation

This repository contains comprehensive API documentation for the Store1 e-commerce platform.

## 📁 Files Included

1. **`API_Documentation.md`** - Complete API documentation in Markdown format
2. **`swagger.json`** - OpenAPI 3.0 specification for Swagger/OpenAPI tools
3. **`Store1_API_Postman_Collection.json`** - Postman collection for easy API testing
4. **`README_API.md`** - This file with setup and usage instructions

## 🚀 Quick Start

### Prerequisites
- XAMPP (Apache + MySQL)
- PHP 7.4 or higher
- MySQL 5.7 or higher

### Setup Instructions

1. **Start XAMPP**
   ```bash
   # Start Apache and MySQL services
   ```

2. **Database Setup**
   - Create database named `store`
   - Import your database schema
   - Ensure all required tables exist:
     - `users`
     - `products`
     - `product_skus`
     - `cart`
     - `cart_items`
     - `whishlist`
     - `comments`

3. **Project Setup**
   - Place your Store1 project in `C:/xampp/htdocs/Store1/`
   - Ensure all PHP files are accessible

## 📖 Using the Documentation

### 1. Markdown Documentation (`API_Documentation.md`)
- **Best for**: Reading and understanding the API structure
- **Contains**: Complete endpoint descriptions, request/response examples, error handling
- **Usage**: Open in any Markdown viewer or text editor

### 2. OpenAPI Specification (`swagger.json`)
- **Best for**: Code generation, automated testing, API visualization
- **Tools that support it**:
  - [Swagger UI](https://swagger.io/tools/swagger-ui/)
  - [Swagger Editor](https://editor.swagger.io/)
  - [Postman](https://www.postman.com/)
  - [Insomnia](https://insomnia.rest/)

#### Using Swagger UI:
1. Go to https://editor.swagger.io/
2. Copy and paste the contents of `swagger.json`
3. View interactive API documentation

### 3. Postman Collection (`Store1_API_Postman_Collection.json`)
- **Best for**: Testing APIs directly
- **Setup**:
  1. Open Postman
  2. Click "Import"
  3. Select the `Store1_API_Postman_Collection.json` file
  4. Update the `base_url` variable if needed

## 🔧 API Testing

### Using Postman Collection

1. **Import Collection**
   - Open Postman
   - Import `Store1_API_Postman_Collection.json`

2. **Set Environment Variables**
   - Create a new environment
   - Set `base_url` to `http://localhost/Store1`

3. **Test Authentication Flow**
   ```
   1. User Registration → POST /reg.php
   2. User Login → POST /login.php
   3. Get User Data → GET /get_user_data.php
   ```

4. **Test Product Operations**
   ```
   1. Get All Products → GET /get_product.php
   2. Get Product Details → GET /get_product_details.php?id=1
   ```

5. **Test Cart Operations** (requires authentication)
   ```
   1. Get Cart → GET /cart.php
   2. Add to Cart → POST /cart.php
   3. Update Cart → PUT /cart.php
   4. Remove from Cart → DELETE /cart.php
   ```

### Using cURL

#### User Registration
```bash
curl -X POST http://localhost/Store1/reg.php \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "f_name=John&l_name=Doe&email=john@example.com&password=password123"
```

#### User Login
```bash
curl -X POST http://localhost/Store1/login.php \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "email=john@example.com&password=password123" \
  -c cookies.txt
```

#### Get Products
```bash
curl -X GET http://localhost/Store1/get_product.php
```

#### Add to Cart (with session)
```bash
curl -X POST http://localhost/Store1/cart.php \
  -H "Content-Type: application/json" \
  -d '{"product_id": 1, "quantity": 2}' \
  -b cookies.txt
```

## 🔐 Authentication

The API uses **session-based authentication**:

1. **Login** to get a session cookie
2. **Include the session cookie** in subsequent requests
3. **Session variables**:
   - `$_SESSION['username']` - User's email
   - `$_SESSION['role']` - User role (user/admin)
   - `$_SESSION['user_id']` - User ID

### Session Management
- Sessions are managed by PHP
- Cookie name: `PHPSESSID`
- Session timeout: Default PHP session timeout

## 📊 Database Schema Overview

### Key Tables
- **`users`** - User accounts and profiles
- **`products`** - Product catalog
- **`product_skus`** - Product variants and pricing
- **`cart`** - Shopping cart headers
- **`cart_items`** - Individual cart items
- **`whishlist`** - User wishlists
- **`comments`** - Product reviews/comments

## 🛡️ Security Features

1. **SQL Injection Protection** - All queries use prepared statements
2. **Password Security** - Passwords hashed with `password_hash()`
3. **Session Security** - Session-based authentication
4. **Input Validation** - Parameters validated before processing
5. **Authorization** - Users can only access their own data

## 🚨 Error Handling

### HTTP Status Codes
- `200` - Success
- `400` - Bad Request (missing parameters)
- `401` - Unauthorized (authentication required)
- `405` - Method Not Allowed
- `500` - Internal Server Error

### Error Response Format
```json
{
  "status": "error",
  "message": "Error description"
}
```

## 🧪 Testing Scenarios

### Basic Flow
1. Register a new user
2. Login with credentials
3. Browse products
4. Add items to cart
5. Manage wishlist
6. Add comments
7. Update profile

### Admin Flow
1. Login as admin user
2. Access admin dashboard
3. Manage products and users

## 📝 Development Notes

### File Structure
```
Store1/
├── config/
│   └── db.php          # Database configuration
├── reg.php             # User registration
├── login.php           # User authentication
├── get_product.php     # Product listing
├── cart.php            # Cart operations
├── wishlist.php        # Wishlist operations
├── comments.php        # Comment system
├── update_profile.php  # Profile management
└── ...                 # Other API files
```

### Database Configuration
```php
// config/db.php
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_NAME', 'store');
```

## 🤝 Contributing

To update the API documentation:

1. **Update API files** - Modify the PHP files as needed
2. **Update Markdown** - Edit `API_Documentation.md`
3. **Update Swagger** - Modify `swagger.json`
4. **Update Postman** - Export new collection from Postman
5. **Test thoroughly** - Ensure all endpoints work correctly

## 📞 Support

For API support or questions:
- Check the documentation files
- Review error messages in API responses
- Ensure XAMPP is running correctly
- Verify database connectivity

## 📄 License

This documentation is provided for the Store1 e-commerce platform.

---

**Last Updated**: 2024  
**API Version**: 1.0  
**PHP Version**: 7.4+  
**Database**: MySQL 5.7+ 