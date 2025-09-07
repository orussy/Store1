# Store1 API Documentation

## Overview
This document provides comprehensive API documentation for the Store1 e-commerce platform. All APIs return JSON responses and use session-based authentication.

**Base URL:** `http://localhost/Store1/`  
**Content-Type:** `application/json`  
**Authentication:** Session-based (PHP sessions)

---

## Database Configuration
- **Server:** localhost
- **Database:** store
- **Username:** root
- **Password:** (empty)
- **Charset:** utf8mb4

---

## Authentication APIs

### 1. User Registration
**Endpoint:** `POST /reg.php`

**Request Body (Form Data):**
```json
{
  "f_name": "string",
  "l_name": "string", 
  "email": "string",
  "password": "string",
  "birthdate": "YYYY-MM-DD",
  "phone_no": "string",
  "gender": "string"
}
```

**Response:**
```json
{
  "status": "success|error",
  "message": "string"
}
```

**Notes:**
- Automatically creates user avatar folder
- Creates cart for new user
- Password is hashed using PHP password_hash()

---

### 2. User Login
**Endpoint:** `POST /login.php`

**Request Body (Form Data):**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "status": "success|error",
  "username": "string",
  "role": "user|admin",
  "id": "integer",
  "redirect": "string",
  "userData": {
    "email": "string",
    "role": "string",
    "name": "string",
    "id": "integer"
  }
}
```

**Notes:**
- Sets session variables: username, role, user_id
- Redirects to dashboard.html for users, admin/admindashboard.php for admins

---

### 3. Get User Data
**Endpoint:** `GET /get_user_data.php`

**Headers:** Requires session authentication

**Response:**
```json
{
  "username": "string",
  "role": "string"
}
```

**Error Response (401):**
```json
{
  "error": "Not authenticated"
}
```

---

### 4. Dashboard Data
**Endpoint:** `GET /dashboard`

**Headers:** Requires session authentication

**Response:**
```json
{
  "username": "string",
  "role": "string"
}
```

**Error Response (401):**
```json
{
  "error": "Not authenticated"
}
```

---

## Product APIs

### 5. Get All Products
**Endpoint:** `GET /get_product.php`

**Response:**
```json
[
  {
    "id": "integer",
    "name": "string",
    "description": "string",
    "cover": "string",
    "price": "decimal",
    "Currancy": "string",
    // ... other product fields
  }
]
```

**Notes:**
- Joins with product_skus table for pricing
- Returns array of all products

---

### 6. Get Product Details
**Endpoint:** `GET /get_product_details.php?id={product_id}`

**Parameters:**
- `id` (required): Product ID

**Response:**
```json
{
  "id": "integer",
  "name": "string",
  "description": "string",
  "cover": "string",
  "price": "decimal",
  "Currancy": "string",
  // ... other product fields
}
```

**Error Response:**
```json
{
  "error": "No product ID provided|Product not found"
}
```

**Notes:**
- Uses MIN() aggregation for price and currency from product_skus

---

### 7. Design Products (Alternative)
**Endpoint:** `GET /desgin/get_product.php`

**Response:**
```json
[
  {
    "id": "integer",
    "name": "string",
    "description": "string",
    // ... other product fields
  }
]
```

**Notes:**
- Simpler product listing without SKU joins

---

## Cart APIs

### 8. Cart Operations
**Endpoint:** `POST /cart.php`

**Headers:** Requires session authentication

**HTTP Methods:**
- `GET`: Retrieve cart items
- `POST`: Add item to cart
- `PUT`: Update cart item quantity
- `DELETE`: Remove item from cart

#### GET - Retrieve Cart
**Response:**
```json
{
  "status": "success",
  "cart_id": "integer",
  "items": [
    {
      "id": "integer",
      "product_id": "integer",
      "quantity": "integer",
      "price": "decimal",
      "product_name": "string",
      "product_cover": "string"
    }
  ],
  "total": "decimal"
}
```

#### POST - Add to Cart
**Request Body:**
```json
{
  "product_id": "integer",
  "quantity": "integer"
}
```

**Response:**
```json
{
  "status": "success|error",
  "message": "string"
}
```

#### PUT - Update Cart Item
**Request Body:**
```json
{
  "cart_item_id": "integer",
  "quantity": "integer"
}
```

#### DELETE - Remove from Cart
**Request Body:**
```json
{
  "cart_item_id": "integer"
}
```

**Error Responses (401):**
```json
{
  "status": "error",
  "message": "Authentication required"
}
```

---

## Wishlist APIs

### 9. Wishlist Operations
**Endpoint:** `POST /wishlist.php`

**Headers:** Requires session authentication

**HTTP Methods:**
- `GET`: Retrieve wishlist items
- `POST`: Add item to wishlist
- `DELETE`: Remove item from wishlist

#### GET - Retrieve Wishlist
**Parameters:**
- `user_id` (required): User ID (must match authenticated user)

**Response:**
```json
{
  "status": "success",
  "items": [
    {
      "id": "integer",
      "product_id": "integer",
      "name": "string",
      "price": "decimal",
      "cover": "string"
    }
  ]
}
```

#### POST - Add to Wishlist
**Request Body:**
```json
{
  "user_id": "integer",
  "product_id": "integer"
}
```

#### DELETE - Remove from Wishlist
**Request Body:**
```json
{
  "user_id": "integer",
  "wishlist_id": "integer"
}
```

**Error Responses:**
```json
{
  "status": "error",
  "message": "Authentication required|User ID is required|Unauthorized access"
}
```

---

## Comments APIs

### 10. Product Comments
**Endpoint:** `POST /comments.php`

**HTTP Methods:**
- `GET`: Retrieve comments for a product
- `POST`: Add a comment (requires authentication)

#### GET - Get Comments
**Parameters:**
- `product_id` (required): Product ID

**Response:**
```json
{
  "status": "success",
  "items": [
    {
      "id": "integer",
      "user_id": "integer",
      "product_id": "integer",
      "comment": "string",
      "created_at": "datetime",
      "user_name": "string"
    }
  ]
}
```

#### POST - Add Comment
**Headers:** Requires session authentication

**Request Body:**
```json
{
  "product_id": "integer",
  "comment": "string"
}
```

**Response:**
```json
{
  "status": "success",
  "id": "integer"
}
```

**Error Responses:**
```json
{
  "status": "error",
  "message": "product_id is required|product_id and comment are required|Authentication required"
}
```

---

## Profile APIs

### 11. Update Profile
**Endpoint:** `POST /update_profile.php`

**Headers:** Requires session authentication

**Request Body:**
```json
{
  "f_name": "string",
  "l_name": "string",
  "birthdate": "YYYY-MM-DD",
  "phone_no": "string",
  "gender": "string"
}
```

**Response:**
```json
{
  "status": "success|error",
  "message": "string"
}
```

**Error Response:**
```json
{
  "status": "error",
  "message": "Not logged in"
}
```

---

## Error Handling

### Common HTTP Status Codes
- `200`: Success
- `400`: Bad Request (missing parameters)
- `401`: Unauthorized (authentication required)
- `405`: Method Not Allowed
- `500`: Internal Server Error

### Standard Error Response Format
```json
{
  "status": "error",
  "message": "Error description"
}
```

---

## Session Management

### Session Variables Set on Login
- `$_SESSION['username']`: User's email
- `$_SESSION['role']`: User role (user/admin)
- `$_SESSION['user_id']`: User ID

### Session Validation
All protected endpoints check for `$_SESSION['user_id']` or `$_SESSION['username']`

---

## Database Schema Overview

### Key Tables
- `users`: User accounts and profiles
- `products`: Product catalog
- `product_skus`: Product variants and pricing
- `cart`: Shopping cart
- `cart_items`: Individual cart items
- `whishlist`: User wishlists
- `comments`: Product reviews/comments

---

## Security Considerations

1. **SQL Injection Protection**: All queries use prepared statements
2. **Password Security**: Passwords are hashed using PHP password_hash()
3. **Session Security**: Session-based authentication with user validation
4. **Input Validation**: Parameters are validated before processing
5. **Authorization**: Users can only access their own data (cart, wishlist, etc.)

---

## Usage Examples

### JavaScript Fetch Examples

#### Login
```javascript
const formData = new FormData();
formData.append('email', 'user@example.com');
formData.append('password', 'password123');

fetch('/Store1/login.php', {
  method: 'POST',
  body: formData
})
.then(response => response.json())
.then(data => console.log(data));
```

#### Get Products
```javascript
fetch('/Store1/get_product.php')
.then(response => response.json())
.then(products => console.log(products));
```

#### Add to Cart
```javascript
fetch('/Store1/cart.php', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    product_id: 1,
    quantity: 2
  })
})
.then(response => response.json())
.then(data => console.log(data));
```

---

## Testing

### Test Environment Setup
1. Ensure XAMPP is running (Apache + MySQL)
2. Database 'store' should be created
3. All required tables should exist
4. Session cookies should be enabled

### Common Test Scenarios
1. User registration and login
2. Product browsing
3. Cart operations
4. Wishlist management
5. Comment posting and retrieval
6. Profile updates

---

## Version Information
- **API Version**: 1.0
- **PHP Version**: 7.4+
- **Database**: MySQL 5.7+
- **Last Updated**: 2024 