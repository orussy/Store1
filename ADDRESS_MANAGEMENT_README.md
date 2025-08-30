# Address Management System for User Profile

This document explains how to set up and use the new address management system that has been added to the user profile.

## Features

- **View Addresses**: Display all user addresses in the Personal Information section
- **Add New Addresses**: Create new addresses with map location selection
- **Edit Addresses**: Modify existing address details and locations
- **Delete Addresses**: Remove addresses (soft delete)
- **Map Integration**: Interactive map for setting precise location coordinates
- **Responsive Design**: Works on both desktop and mobile devices

## Database Setup

### 1. Update Addresses Table

First, run the SQL script to add the required columns:

```sql
-- Run this in your database
source update_addresses_table.sql;
```

This will add:
- `latitude` (DECIMAL 10,8) - For storing latitude coordinates
- `longitude` (DECIMAL 11,8) - For storing longitude coordinates  
- `updated_at` (TIMESTAMP) - For tracking when addresses are modified

### 2. Add Sample Data (Optional)

To test the system with sample addresses:

```sql
-- Update user_id values to match existing users in your database
source sample_addresses.sql;
```

## Files Added/Modified

### New PHP Files
- `get_user_addresses.php` - Fetches user addresses from database
- `save_address.php` - Saves/updates addresses with coordinates
- `delete_address.php` - Soft deletes addresses
- `reverse_geocode.php` - Converts coordinates to address information

### Modified Files
- `js/user-profile.js` - Added address management functions and map integration
- `style/user-profile.css` - Added styles for address management and maps
- `user-profile.html` - Added Leaflet map library

### SQL Files
- `update_addresses_table.sql` - Database schema updates
- `sample_addresses.sql` - Sample address data

## How to Use

### 1. View Addresses
- Navigate to User Profile
- Click "Personal Information" in the sidebar
- Addresses will be displayed below other personal information

### 2. Manage Addresses
- Click "Account Settings" in the sidebar
- Scroll to "Manage Addresses" section
- View existing addresses with edit/delete options
- Click "Add New Address" to create new addresses

### 3. Adding/Editing Addresses
1. Fill in address details (title, address lines, city, country, postal code)
2. **Set Location on Map**:
   - Click on the map to set coordinates
   - Use "Open Full Map" for better precision
   - Use "Use GPS" button to get current location
   - **Address fields are automatically filled** based on selected coordinates
   - Address Line 2 is automatically cleared when using map location
3. Click "Save Address" to store

### 4. Map Features
- **Interactive Map**: Click anywhere to set location
- **Coordinate Display**: Shows selected latitude/longitude
- **Full Map Modal**: Larger map for precise location selection
- **GPS Integration**: Use current location button for automatic positioning
- **Auto-fill Address**: Address fields automatically populated from coordinates
- **Default Location**: Cairo, Egypt (can be customized)

## Technical Details

### Map Library
- **Leaflet.js**: Free, open-source mapping library
- **OpenStreetMap**: Free map tiles (no API key required)
- **Responsive**: Works on all device sizes

### Database Fields
```sql
CREATE TABLE addresses (
  id INT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  title VARCHAR(255) NOT NULL,
  address1 VARCHAR(255) NOT NULL,
  address2 VARCHAR(255) NULL,  -- Now nullable
  country VARCHAR(255) NOT NULL,
  city VARCHAR(255) NOT NULL,
  postal_code VARCHAR(255) NOT NULL,
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL,
  deleted_at TIMESTAMP NULL
);
```

### API Endpoints
- `GET get_user_addresses.php` - Fetch user addresses
- `POST save_address.php` - Save/update address
- `POST delete_address.php` - Delete address
- `GET reverse_geocode.php` - Convert coordinates to address (reverse geocoding)

## Security Features

- **Session Validation**: All endpoints check user authentication
- **User Isolation**: Users can only access their own addresses
- **Input Validation**: All form inputs are validated
- **SQL Injection Protection**: Prepared statements used throughout
- **Soft Delete**: Addresses are marked as deleted, not physically removed

## Customization

### Default Map Location
To change the default map center, modify these coordinates in `js/user-profile.js`:

```javascript
// Default coordinates (Cairo, Egypt)
const defaultLat = selectedLatitude || 30.0444;
const defaultLng = selectedLongitude || 31.2357;
```

### Address Types
To add/remove address types, modify the select options in the JavaScript:

```javascript
<option value="Home">Home</option>
<option value="Work">Work</option>
<option value="Custom Type">Custom Type</option>
```

### Map Styling
Customize map appearance by modifying the CSS in `style/user-profile.css`:

```css
.map-preview {
    height: 300px; /* Adjust map height */
    border-radius: 8px; /* Adjust border radius */
}
```

## Troubleshooting

### Common Issues

1. **Map Not Loading**
   - Check if Leaflet library is loaded
   - Verify internet connection (for map tiles)
   - Check browser console for JavaScript errors

2. **Coordinates Not Saving**
   - Ensure latitude/longitude are numeric values
   - Check database table structure
   - Verify PHP error logs

3. **Addresses Not Displaying**
   - Check if user is logged in
   - Verify database connection
   - Check if addresses table exists

### Debug Mode
Enable debug mode by adding this to your JavaScript:

```javascript
console.log('Debug: Loading addresses...');
console.log('Debug: Addresses data:', addresses);
```

## Browser Compatibility

- **Chrome**: Full support
- **Firefox**: Full support  
- **Safari**: Full support
- **Edge**: Full support
- **Mobile Browsers**: Responsive design with touch support

## Performance Considerations

- **Map Tiles**: Cached by browser for better performance
- **Database Indexes**: Added on user_id and coordinates for faster queries
- **Lazy Loading**: Addresses loaded only when needed
- **Soft Delete**: Maintains data integrity without performance impact

## Future Enhancements

Potential improvements for future versions:
- Address validation using external APIs
- Geocoding (convert address to coordinates automatically)
- Address import/export functionality
- Multiple address types and categories
- Address sharing between users
- Integration with delivery services
