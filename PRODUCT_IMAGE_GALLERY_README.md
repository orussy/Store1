# Product Image Gallery Feature

## Overview
This feature allows products to display multiple images in a gallery format. When users hover over thumbnail images, the main product image changes to show the hovered image. When not hovering, it returns to the cover image.

## How It Works

### 1. Folder Structure
- Each product can have its own folder containing multiple images
- The folder path is automatically determined from the product's cover image
- Example: If cover image is `img/product/r50i/1(1).jpg`, the system will look for additional images in `img/product/r50i/`

### 2. Supported Image Formats
- JPG/JPEG
- PNG
- GIF
- WebP

### 3. Automatic Image Discovery
- The system automatically scans the product's folder for all supported image files
- Images are sorted alphabetically for consistent display
- The cover image is excluded from the thumbnail list to avoid duplication

## Implementation Details

### Files Created/Modified:
1. **`get_product_images.php`** - New PHP endpoint that:
   - Gets product cover image from database
   - Extracts folder path from cover image
   - Scans folder for additional images
   - Returns JSON with image list

2. **`product-details.html`** - Updated with:
   - New CSS styles for image gallery
   - Thumbnail container
   - JavaScript for hover functionality
   - Click functionality to set active image

### JavaScript Features:
- **Hover Effect**: Mouse over thumbnail changes main image
- **Click Effect**: Click thumbnail to set it as active
- **Auto Return**: When mouse leaves thumbnail area, returns to cover image (if no thumbnail is active)
- **Active State**: Visual indication of which thumbnail is currently selected

## Usage Instructions

### For Developers:
1. Place product images in a folder (e.g., `img/product/product-name/`)
2. Set the product's cover image in the database to point to one image in that folder
3. The system will automatically find and display all other images in that folder

### For Users:
1. View product details page
2. See thumbnails below the main product image
3. Hover over thumbnails to see different views of the product
4. Click thumbnails to set them as the active view
5. Mouse away from thumbnails to return to the cover image

## Example Folder Structure:
```
img/product/
├── r50i/
│   ├── 1(1).jpg (cover image)
│   ├── 1(3).jpg
│   ├── 1(4).jpg
│   ├── 1(5).jpg
│   ├── 1(6).jpg
│   ├── 1(7).jpg
│   └── 13.jpg
└── other-product/
    ├── cover.jpg
    ├── side-view.jpg
    └── detail.jpg
```

## Database Requirements:
- No changes needed to database structure
- Uses existing `products.cover` field to determine image folder
- Automatically discovers additional images without database entries

## Testing:
1. Run `update_product_cover.php` to set a test product to use the r50i folder
2. Navigate to the product details page
3. Verify thumbnails appear and hover functionality works
4. Test click functionality to set active thumbnails
5. Test mouse leave functionality to return to cover image
