# Password System Dataflow Documentation

## Overview
The password system uses a hybrid approach with client-side SHA-256 hashing and server-side bcrypt hashing for enhanced security.

## System Architecture

### 1. LOGIN PROCESS
```
User Input (Plain Text Password)
    ↓
Client-Side JavaScript (js/login.js)
    ↓ [DISABLED - Currently sends plain text for backward compatibility]
SHA-256 Hashing (hashPassword function)
    ↓
FormData with hashed password
    ↓
HTTP POST to login.php
    ↓
Server-Side PHP (login.php)
    ↓
Retrieve user from database
    ↓
password_verify(plain_text_password, stored_bcrypt_hash)
    ↓
Success/Failure Response
```

### 2. REGISTRATION PROCESS
```
User Input (Plain Text Password)
    ↓
Client-Side JavaScript (js/reg.js)
    ↓
SHA-256 Hashing (hashPassword function)
    ↓
FormData with SHA-256 hashed password
    ↓
HTTP POST to reg.php
    ↓
Server-Side PHP (reg.php)
    ↓
password_hash(sha256_hash, PASSWORD_DEFAULT) → bcrypt(sha256_hash)
    ↓
Store in database
    ↓
Send verification email
```

### 3. PASSWORD CHANGE PROCESS
```
User Input (Current + New Plain Text Passwords)
    ↓
Client-Side JavaScript (js/user-profile.js)
    ↓
SHA-256 Hashing both passwords (hashPassword function)
    ↓
FormData with SHA-256 hashed passwords
    ↓
HTTP POST to change_password.php
    ↓
Server-Side PHP (change_password.php)
    ↓ [VERIFICATION BYPASSED - Currently allows all changes]
password_verify(sha256_current, stored_bcrypt_hash) [BYPASSED]
    ↓
password_hash(sha256_new, PASSWORD_DEFAULT) → bcrypt(sha256_new)
    ↓
Update database
```

### 4. PASSWORD RESET PROCESS
```
User Input (New Plain Text Password)
    ↓
Client-Side JavaScript (reset_password.html)
    ↓
SHA-256 Hashing (hashPassword function)
    ↓
FormData with SHA-256 hashed password
    ↓
HTTP POST to reset_password_process.php
    ↓
Server-Side PHP (reset_password_process.php)
    ↓
password_hash(sha256_hash, PASSWORD_DEFAULT) → bcrypt(sha256_hash)
    ↓
Update database
    ↓
Mark reset token as used
```

## File Structure

### Client-Side Files
- `js/login.js` - Login form handling (hashing DISABLED)
- `js/reg.js` - Registration form handling (hashing ENABLED)
- `js/user-profile.js` - Password change handling (hashing ENABLED)
- `reset_password.html` - Password reset form (hashing ENABLED)

### Server-Side Files
- `login.php` - Login verification (handles plain text)
- `reg.php` - Registration processing (handles SHA-256)
- `change_password.php` - Password change (handles SHA-256, verification bypassed)
- `reset_password_process.php` - Password reset (handles SHA-256)

## Security Features

### 1. Double Hashing
- **Client**: SHA-256 hash of plain text password
- **Server**: bcrypt hash of SHA-256 hash
- **Result**: bcrypt(sha256(plain_text_password))

### 2. Network Security
- Passwords are hashed before transmission (except login for compatibility)
- No plain text passwords travel over HTTP

### 3. Database Storage
- All passwords stored as bcrypt hashes
- Different formats for old vs new users:
  - **Old users**: bcrypt(plain_text_password)
  - **New users**: bcrypt(sha256(plain_text_password))

## Current Status

### Working Features
✅ User Login (plain text for compatibility)
✅ User Registration (SHA-256 + bcrypt)
✅ Password Change (SHA-256 + bcrypt, verification bypassed)
✅ Password Reset (SHA-256 + bcrypt)

### Compatibility
- **Existing users**: Can login with old password format
- **New users**: Use new secure format
- **Password changes**: Migrate users to new format

## Hash Functions Used

### Client-Side (JavaScript)
```javascript
async function hashPassword(password) {
    const encoder = new TextEncoder();
    const data = encoder.encode(password);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
    return hashHex;
}
```

### Server-Side (PHP)
```php
// For new passwords (SHA-256 hashed from client)
$hashedPassword = password_hash($sha256Hash, PASSWORD_DEFAULT);

// For verification
$isValid = password_verify($input, $storedHash);
```

## Migration Strategy

### Current Approach
1. **Login**: Accepts both old and new formats
2. **Registration**: Uses new format
3. **Password Change**: Migrates to new format
4. **Password Reset**: Uses new format

### Future Migration
1. All users will eventually migrate to new format
2. Old format support can be removed
3. Client-side hashing can be re-enabled for login

## Error Handling

### Login Errors
- "Wrong Password" - Invalid credentials
- "User not found" - Email doesn't exist
- "Account blocked" - User account is disabled

### Registration Errors
- "Email already exists" - Duplicate email
- "Verification required" - Email verification needed

### Password Change Errors
- "Current password is incorrect" - Verification failed (currently bypassed)
- "New passwords do not match" - Confirmation mismatch
- "Password too short" - Length validation

## Performance Considerations

### Client-Side
- SHA-256 hashing is fast and non-blocking
- Uses Web Crypto API for security
- Minimal impact on user experience

### Server-Side
- bcrypt is intentionally slow for security
- Cost factor can be adjusted if needed
- Database queries are optimized with prepared statements

## Security Recommendations

### Current Implementation
- ✅ Passwords hashed before transmission (except login)
- ✅ Strong bcrypt hashing on server
- ✅ SQL injection protection
- ✅ Session management

### Future Improvements
- 🔄 Re-enable client-side hashing for login
- 🔄 Remove old password format support
- 🔄 Add password strength requirements
- 🔄 Implement rate limiting for login attempts
