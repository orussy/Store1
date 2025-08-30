# 🔐 Admin Folder Security System

## Overview
This system prevents unauthorized access to the admin folder while using the same login system as regular users.

## How It Works

### 1. **Authentication Flow**
- Users login through the main login system (`/index.html` → `login.php`)
- Login system checks user role from database
- If role = 'admin', user is redirected to `/admin/admindashboard.php`
- If role ≠ 'admin', user is redirected to regular dashboard

### 2. **Admin Access Control**
- **`auth_check.php`**: Core security file that checks admin privileges
- **Session Validation**: Verifies user is logged in and has admin role
- **Automatic Redirect**: Non-admin users are redirected to login page
- **Session Timeout**: 30-minute inactivity timeout for security

### 3. **File Access Control**
- **`.htaccess`**: Blocks direct access to sensitive PHP files
- **Protected Files**: `auth_check.php` cannot be accessed directly
- **Allowed Files**: Only `admindashboard.php` and `index.php` are accessible
- **Directory Listing**: Disabled to prevent information disclosure

### 4. **Security Features**
- ✅ **Role-based Access Control**: Only admin users can access admin folder
- ✅ **Session Security**: Automatic timeout and validation
- ✅ **File Protection**: Direct access to sensitive files blocked
- ✅ **XSS Protection**: Security headers enabled
- ✅ **CSRF Protection**: Session-based authentication
- ✅ **Directory Traversal**: Prevented through proper file access control

## File Structure
```
admin/
├── .htaccess              # Apache security rules
├── auth_check.php         # Authentication middleware
├── index.php              # Auto-redirect to dashboard
├── admindashboard.php     # Main admin interface
├── test_security.php      # Test file (blocked by .htaccess)
└── SECURITY_README.md     # This documentation
```

## Testing Security

### ✅ **Authorized Access (Admin User)**
1. Login with admin account
2. Navigate to `/admin/` or `/admin/admindashboard.php`
3. Should see admin dashboard

### ❌ **Unauthorized Access (Regular User)**
1. Login with regular user account
2. Try to access `/admin/` or `/admin/admindashboard.php`
3. Should be redirected to login page with error

### ❌ **Direct File Access**
1. Try to access `/admin/auth_check.php` directly
2. Should be blocked by `.htaccess`
3. Try to access `/admin/test_security.php`
4. Should be blocked by `.htaccess`

## Database Requirements
Your `users` table must have these fields:
- `id`: User ID
- `email`: User email
- `role`: User role ('admin' or 'user')
- `status`: User status ('active' or 'blocked')

## Session Variables Used
- `$_SESSION['user_id']`: User ID from database
- `$_SESSION['username']`: User email
- `$_SESSION['role']`: User role ('admin' or 'user')
- `$_SESSION['last_activity']`: Last activity timestamp

## Security Best Practices
1. **Never expose** `auth_check.php` or other sensitive files
2. **Use HTTPS** in production for secure data transmission
3. **Regular audits** of admin user accounts
4. **Monitor access logs** for suspicious activity
5. **Keep sessions short** for admin accounts
6. **Use strong passwords** for admin accounts

## Troubleshooting
- **403 Forbidden**: Check `.htaccess` file permissions
- **Redirect Loop**: Verify session variables are set correctly
- **Access Denied**: Check user role in database
- **Session Issues**: Verify PHP session configuration

## Customization
- **Session Timeout**: Modify `1800` seconds in `auth_check.php`
- **Redirect URL**: Change login page URL in `redirectNonAdmin()`
- **Additional Checks**: Add more validation in `isAdmin()` function
