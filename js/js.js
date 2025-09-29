let slideIndex = 0;
        let slides = [];
        
        // Helper to normalize image URLs and apply fallback
        function normalizeImageUrl(path) {
            if (!path) return 'img/product/ultrabook.jpg';
            if (/^https?:\/\//i.test(path)) return path;
            if (path.startsWith('/')) return '/Store' + path; // ensure app base
            return path; // relative to current app directory
        }
        function productImgOnError(imgEl) {
            if (!imgEl) return;
            imgEl.onerror = null;
            imgEl.src = 'img/product/ultrabook.jpg';
        }

        // Function to create slides
        function createSlides() {
            const wrapper = document.getElementById('slideshow-wrapper');
            if (!wrapper) return; // Not present on this page
            // Get images from PHP endpoint
            fetch('get_images.php')
                .then(response => response.json())
                .then(imageFiles => {
                    imageFiles.forEach((filename, index) => {
                        const slide = document.createElement('div');
                        slide.className = 'mySlides fade';
                        slide.style.display = index === 0 ? 'block' : 'none';
                        
                        const img = document.createElement('img');
                        img.src = `img/slideshow/${filename}`;
                        img.style.width = '100%';
                        img.alt = `Banner ${index + 1}`;
                        img.title = `Banner ${index + 1}`;
                        
                        slide.appendChild(img);
                        wrapper.appendChild(slide);
                    });
                    slides = document.getElementsByClassName("mySlides");
                    showSlides();
                })
                .catch(error => console.error('Error loading images:', error));
        }
        function showToast(message, duration = 3000) {
            const toast = document.getElementById('toast');
            toast.textContent = message;
            toast.classList.add('show');
        
            setTimeout(() => {
                toast.classList.remove('show');
            }, duration);
        }
        
        function showSlides() {
            for (let i = 0; i < slides.length; i++) {
                slides[i].style.display = "none";  
            }
            slideIndex++;
            if (slideIndex > slides.length) {slideIndex = 1}    
            slides[slideIndex-1].style.display = "block";  
            setTimeout(showSlides, 3000); // Change slide every 3 seconds
        }
        
        function plusSlides(n) {
            slideIndex += n;
            if (slideIndex > slides.length) {slideIndex = 1}
            if (slideIndex < 1) {slideIndex = slides.length}
            
            // Show the current slide without auto-increment
            for (let i = 0; i < slides.length; i++) {
                slides[i].style.display = "none";  
            }
            slides[slideIndex-1].style.display = "block";
        }

        // Start the slideshow
        createSlides();

        let allProducts = [];
        const productsPerPage = 20;
        let currentPage = 1;

        function fetchProducts() {
            const container = document.getElementById('productsContainer');
            if (!container) return; // Not a listing page
            container.innerHTML = '<div class="loading">Loading products...</div>';

            fetch('get_product.php')
                .then(response => response.json())
                .then(data => {
                    // Convert data to array if it's not already
                    allProducts = Array.isArray(data) ? data : Object.values(data);
                    console.log('Received data:', allProducts); // Debug log
                    displayProducts(currentPage);
                    setupPagination();
                })
                .catch(error => {
                    console.error('Error:', error);
                    container.innerHTML = `
                        <div class="error">Error loading products: ${error.message}</div>
                    `;
                });
        }

        // Display products for current page
        function displayProducts(page) {
            const container = document.getElementById('productsContainer');
            const start = (page - 1) * productsPerPage;
            const end = start + productsPerPage;
            const paginatedProducts = allProducts.slice(start, end);

            container.innerHTML = '';

            paginatedProducts.forEach((product, index) => {
                const card = document.createElement('div');
                card.className = 'product-card';
                card.setAttribute('id', `item${start + index + 1}`); // Add unique ID
                
                // Determine the quantity text
                const quantityText = product.quantity > 0 ? '' : 'Out of Stock';

                // Generate price display with discount
                let priceDisplay = '';
                if (product.has_discount) {
                    if (product.discount_type === 'percentage') {
                        priceDisplay = `
                            <div class="price-container">
                                <span class="original-price">${product.original_price} ${product.Currency}</span>
                                <span class="discount-badge">-${product.discount_value}%</span>
                                <span class="final-price">${product.final_price} ${product.Currency}</span>
                            </div>
                        `;
                    } else { // fixed amount
                        priceDisplay = `
                            <div class="price-container">
                                <span class="original-price">${product.original_price} ${product.Currency}</span>
                                <span class="discount-badge">-${product.discount_value} ${product.Currency}</span>
                                <span class="final-price">${product.final_price} ${product.Currency}</span>
                            </div>
                        `;
                    }
                } else {
                    priceDisplay = `<p class="product-price">${product.price} ${product.Currency}</p>`;
                }

                // Generate variant buttons (colors and sizes)
                let variantButtons = '';
                if (product.variants && product.variants.length > 1) {
                    const colors = [...new Set(product.variants.map(v => v.color).filter(c => c))];
                    const sizes = [...new Set(product.variants.map(v => v.size).filter(s => s))];
                    
                    variantButtons = '<div class="variant-buttons">';
                    
                    // Add color buttons
                    if (colors.length > 1) {
                        variantButtons += '<div class="color-variants">';
                        colors.forEach(color => {
                            variantButtons += `<button class="variant-btn color-btn" data-color="${color}" 
                                style="background-color: ${getColorValue(color)}; border: 2px solid #ddd;" 
                                title="${color}">${color}</button>`;
                        });
                        variantButtons += '</div>';
                    }
                    
                    // Add size buttons
                    if (sizes.length > 1) {
                        variantButtons += '<div class="size-variants">';
                        sizes.forEach(size => {
                            variantButtons += `<button class="variant-btn size-btn" data-size="${size}" 
                                title="${size}">${size}</button>`;
                        });
                        variantButtons += '</div>';
                    }
                    
                    variantButtons += '</div>';
                }
                const imageUrl = normalizeImageUrl(product.cover);
                card.innerHTML = `
                    <div class="image-container">
                        <a href="product-details.html?id=${product.id}">
                            <img src="${imageUrl}" onerror="this.onerror=null; this.src='img/product/ultrabook.jpg'" 
                                 alt="${product.name}" 
                                 class="product-image">
                        </a>
                    </div>
                    <a href="product-details.html?id=${product.id}" class="product-name"><h3 class="product-name">${product.name}</h3></a>
                    ${priceDisplay}
                    <p class="product-description">${product.description}</p>
                    <p class="product-quantity">${quantityText}</p>
                    ${variantButtons}

                    <div class="product-buttons">
                        <button onclick="addToWishlist(${product.id})" class="wishlist-btn" title="Add to wishlist" aria-label="Add to wishlist">
                            <i class="fa-solid fa-heart" aria-hidden="true"></i>
                        </button>
                        <button onclick="addToCart({
                            id: '${product.id}',
                            name: '${product.name}',
                            price: ${parseFloat(product.has_discount ? product.final_price : product.price)},
                            image: '${product.cover}'
                        })" class="add-to-cart" ${product.quantity <= 0 ? 'disabled' : ''}>
                            <i class="fa-solid fa-cart-shopping"></i>
                            ${product.quantity <= 0 ? 'Out of Stock' : 'Add to Cart'}
                        </button>
                        <div id="toast" class="toast-message"></div>
                    </div>
                `;
                container.appendChild(card);
                
                // Add event listeners for variant buttons
                if (product.variants && product.variants.length > 1) {
                    addVariantListeners(card, product);
                }
            });
        }

        // Helper function to get color value for CSS
        function getColorValue(color) {
            const colorMap = {
                'Black': '#000000',
                'White': '#ffffff',
                'Red': '#ff0000',
                'Blue': '#0000ff',
                'Gold': '#ffd700',
                'Silver': '#c0c0c0'
            };
            return colorMap[color] || '#cccccc';
        }

        // Add event listeners for variant buttons
        function addVariantListeners(card, product) {
            const colorButtons = card.querySelectorAll('.color-btn');
            const sizeButtons = card.querySelectorAll('.size-btn');
            
            // Color button listeners
            colorButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    // Remove active class from all color buttons
                    colorButtons.forEach(b => b.classList.remove('active'));
                    // Add active class to clicked button
                    this.classList.add('active');
                    
                    // Find variant with this color
                    const selectedColor = this.dataset.color;
                    const selectedSize = card.querySelector('.size-btn.active')?.dataset.size;
                    
                    updateProductVariant(card, product, selectedColor, selectedSize);
                });
            });
            
            // Size button listeners
            sizeButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    // Remove active class from all size buttons
                    sizeButtons.forEach(b => b.classList.remove('active'));
                    // Add active class to clicked button
                    this.classList.add('active');
                    
                    // Find variant with this size
                    const selectedSize = this.dataset.size;
                    const selectedColor = card.querySelector('.color-btn.active')?.dataset.color;
                    
                    updateProductVariant(card, product, selectedColor, selectedSize);
                });
            });
            
            // Set first variant as active by default
            if (colorButtons.length > 0) colorButtons[0].classList.add('active');
            if (sizeButtons.length > 0) sizeButtons[0].classList.add('active');
        }

        // Update product variant display
        function updateProductVariant(card, product, selectedColor, selectedSize) {
            // Find the matching variant
            let selectedVariant = product.variants.find(variant => {
                const colorMatch = !selectedColor || variant.color === selectedColor;
                const sizeMatch = !selectedSize || variant.size === selectedSize;
                return colorMatch && sizeMatch;
            });
            
            // If no exact match, find the first available variant with the selected criteria
            if (!selectedVariant) {
                selectedVariant = product.variants.find(variant => {
                    if (selectedColor && selectedSize) {
                        return variant.color === selectedColor || variant.size === selectedSize;
                    } else if (selectedColor) {
                        return variant.color === selectedColor;
                    } else if (selectedSize) {
                        return variant.size === selectedSize;
                    }
                    return false;
                });
            }
            
            // Fallback to first variant if no match
            if (!selectedVariant) {
                selectedVariant = product.variants[0];
            }
            
            // Update product image if variant has a different cover
            if (selectedVariant.cover) {
                const productImage = card.querySelector('.product-image');
                if (productImage) {
                    const imageUrl = normalizeImageUrl(selectedVariant.cover);
                    productImage.src = imageUrl;
                    productImage.alt = `${product.name} - ${selectedVariant.color || ''} ${selectedVariant.size || ''}`.trim();
                }
            }
            
            // Update price display
            const priceContainer = card.querySelector('.price-container, .product-price');
            if (priceContainer) {
                if (product.has_discount) {
                    if (product.discount_type === 'percentage') {
                        priceContainer.innerHTML = `
                            <span class="original-price">${selectedVariant.original_price} ${selectedVariant.Currency}</span>
                            <span class="discount-badge">-${product.discount_value}%</span>
                            <span class="final-price">${selectedVariant.final_price} ${selectedVariant.Currency}</span>
                        `;
                    } else {
                        priceContainer.innerHTML = `
                            <span class="original-price">${selectedVariant.original_price} ${selectedVariant.Currency}</span>
                            <span class="discount-badge">-${product.discount_value} ${selectedVariant.Currency}</span>
                            <span class="final-price">${selectedVariant.final_price} ${selectedVariant.Currency}</span>
                        `;
                    }
                } else {
                    priceContainer.innerHTML = `<p class="product-price">${selectedVariant.price} ${selectedVariant.Currency}</p>`;
                }
            }
            
            // Update quantity display
            const quantityElement = card.querySelector('.product-quantity');
            if (quantityElement) {
                quantityElement.textContent = selectedVariant.quantity > 0 ? '' : 'Out of Stock';
            }
            
            // Update add to cart button
            const addToCartBtn = card.querySelector('.add-to-cart');
            if (addToCartBtn) {
                addToCartBtn.disabled = selectedVariant.quantity <= 0;
                addToCartBtn.innerHTML = `
                    <i class="fa-solid fa-cart-shopping"></i>
                    ${selectedVariant.quantity <= 0 ? 'Out of Stock' : 'Add to Cart'}
                `;
                
                // Update onclick with new variant data
                addToCartBtn.setAttribute('onclick', `addToCart({
                    id: '${product.id}',
                    sku_id: '${selectedVariant.sku_id}',
                    name: '${product.name}',
                    price: ${parseFloat(selectedVariant.has_discount ? selectedVariant.final_price : selectedVariant.price)},
                    image: '${selectedVariant.cover || product.cover}',
                    variant: '${selectedVariant.color || ''} ${selectedVariant.size || ''}'.trim()
                })`);
            }
        }
        // Setup pagination buttons
        function setupPagination() {
            const paginationContainer = document.getElementById('pagination');
            const pageCount = Math.ceil(allProducts.length / productsPerPage);
            
            paginationContainer.innerHTML = '';

            // Previous button
            const prevButton = document.createElement('button');
            prevButton.innerHTML = '&laquo; Previous';
            prevButton.onclick = () => {
                if (currentPage > 1) {
                    currentPage--;
                    displayProducts(currentPage);
                    updatePaginationButtons();
                }
            };
            paginationContainer.appendChild(prevButton);

            // Page number buttons
            for (let i = 1; i <= pageCount; i++) {
                const button = document.createElement('button');
                button.innerText = i;
                button.onclick = () => {
                    currentPage = i;
                    displayProducts(currentPage);
                    updatePaginationButtons();
                };
                paginationContainer.appendChild(button);
            }

            // Next button
            const nextButton = document.createElement('button');
            nextButton.innerHTML = 'Next &raquo;';
            nextButton.onclick = () => {
                if (currentPage < pageCount) {
                    currentPage++;
                    displayProducts(currentPage);
                    updatePaginationButtons();
                }
            };
            paginationContainer.appendChild(nextButton);

            updatePaginationButtons();
        }

        // Update active state of pagination buttons
        function updatePaginationButtons() {
            const buttons = document.querySelectorAll('#pagination button');
            buttons.forEach(button => {
                if (button.innerText === currentPage.toString()) {
                    button.classList.add('active');
                } else {
                    button.classList.remove('active');
                }
            });
        }

        // Load products when page loads
        document.addEventListener('DOMContentLoaded', fetchProducts);

        // Close wishlist when clicking outside
        document.addEventListener('click', function(event) {
            const wishlistDropdown = document.getElementById('wishlistDropdown');
            const wishlistNavItem = wishlistDropdown ? wishlistDropdown.closest('.nav-item') : null;
            
            // Check if click is outside the wishlist nav item
            if (wishlistDropdown && wishlistNavItem && !wishlistNavItem.contains(event.target)) {
                wishlistDropdown.classList.remove('show');
            }
        });

        // Check login status when page loads (validate with server to avoid stale localStorage)
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Checking login status with server validation...');
            const userDataStr = localStorage.getItem('userData');
            console.log('Raw userData from localStorage:', userDataStr);

            let userData;
            try {
                userData = JSON.parse(userDataStr);
                console.log('Parsed userData:', userData);
            } catch (e) {
                console.error('Error parsing userData:', e);
                userData = null;
            }

            const loginSection = document.getElementById('loginSection');
            const userSection = document.getElementById('userSection');
            const usernameSpan = document.getElementById('username');

            // Hide both until we validate
            if (loginSection) loginSection.style.display = 'none';
            if (userSection) userSection.style.display = 'none';

            if (!userData || !userData.email) {
                console.log('No local user data; showing login');
                if (loginSection) loginSection.style.display = 'flex';
                if (userSection) userSection.style.display = 'none';
                return;
            }

            // Validate session with server (pass user_id to avoid relying on cookie)
            const profileUrl = 'get_user_profile.php' + (userData && userData.id ? ('?user_id=' + encodeURIComponent(userData.id)) : '');
            fetch(profileUrl)
                .then(response => response.text().then(text => {
                    let data; try { data = JSON.parse(text); } catch (e) { data = { status: 'error', message: 'Invalid JSON', raw: text }; }
                    return data;
                }))
                .then(data => {
                    console.log('Session validation response:', data);
                    if (data && data.status === 'success' && data.userData && data.userData.email) {
                        // Server confirms session is valid
                        if (loginSection) loginSection.style.display = 'none';
                        if (userSection) userSection.style.display = 'flex';
                        if (usernameSpan) usernameSpan.textContent = data.userData.email;
                        // Sync localStorage with server data
                        try {
                            localStorage.setItem('userData', JSON.stringify({
                                id: data.userData.id,
                                email: data.userData.email,
                                role_id: data.userData.role_id || 7,
                                avatar: data.userData.avatar || ''
                            }));
                        } catch (e) { console.warn('Failed to sync userData to localStorage:', e); }
                    } else {
                        console.log('Server indicates not authenticated; clearing local data and showing login');
                        localStorage.removeItem('userData');
                        if (loginSection) loginSection.style.display = 'flex';
                        if (userSection) userSection.style.display = 'none';
                    }
                })
                .catch(err => {
                    console.error('Error validating session with server:', err);
                    // On error, show login UI without redirect
                    localStorage.removeItem('userData');
                    if (loginSection) loginSection.style.display = 'flex';
                    if (userSection) userSection.style.display = 'none';
                });
        });

        function logout() {
            // Clear user data
            localStorage.removeItem('userData');
            
            // Call logout.php to clear session
            fetch('logout.php');
        }

        // Add wishlist functionality
        function addToWishlist(productId) {
            console.log('Adding to wishlist, checking user data...');
            const userDataStr = localStorage.getItem('userData');
            console.log('Raw userData from localStorage:', userDataStr);
            
            let userData;
            try {
                userData = JSON.parse(userDataStr);
                console.log('Parsed userData:', userData);
            } catch (e) {
                console.error('Error parsing userData:', e);
                userData = null;
            }

            // Check if user is logged in
            if (!userData || !userData.email) {
                console.log('User not logged in; showing toast');
                showToast('Please login to view your wishlist');
                return;
            }

            // Get user ID from localStorage
            const userId = userData.id;
            if (!userId) {
                console.error('User ID not found in localStorage');
                showToast('Error: User ID not found. Please log in again.');
                return;
            }

            console.log('Adding product to wishlist:', productId, 'for user:', userId);

            // Make sure productId is a number
            const numericProductId = parseInt(productId);
            if (isNaN(numericProductId)) {
                console.error('Invalid product ID:', productId);
                showToast('Error: Invalid product ID');
                return;
            }

            fetch('wishlist_api.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'include',
                body: JSON.stringify({ 
                    product_id: numericProductId
                })
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Wishlist response:', data);
                if (data.status === 'success') {
                    showToast('Product added to wishlist!');
                    loadWishlist(); // Reload wishlist after adding
                } else {
                    // Check if the error is due to authentication  
                    if (data.message && data.message.includes('Authentication required')) {
                        showToast('Your session has expired. Please log in again.');
                    } else {
                        showToast(data.message || 'Failed to add product to wishlist');
                    }
                }
            })
            .catch(error => {
                console.error('Error adding to wishlist:', error);
                // Check if the error is due to authentication
                if (error.message && error.message.includes('Authentication required')) {
                    showToast('Your session has expired. Please log in again.');
                } else {
                    showToast('Failed to add product to wishlist: ' + error.message);
                }
            });
        }

        // Function to load wishlist items
        function loadWishlist() {
            console.log('Loading wishlist...');
            
            // Check if user is logged in
            const userData = JSON.parse(localStorage.getItem('userData'));
            console.log('User data from localStorage:', userData);
            
            if (!userData || !userData.email) {
                console.log('User not logged in, skipping wishlist load');
                return;
            }
            
            // Get user ID from localStorage
            const userId = userData.id;
            console.log('User ID from localStorage:', userId);
            
            if (!userId) {
                console.error('User ID not found in localStorage');
                return;
            }
            
            console.log('Loading wishlist for user:', userId);
            
            // Show loading animation
            showLoading();
            
            // Fetch wishlist data from the server
            const url = `wishlist_api.php`;
            console.log('Fetching wishlist data from URL:', url);
            
            fetch(url, {
                method: 'GET',
                credentials: 'include'
            })
                .then(response => {
                    console.log('Response status:', response.status);
                    return response.text().then(text => {
                        console.log('Raw response text:', text);
                        let data;
                        try { data = JSON.parse(text); } catch (e) { data = {status:'error', message:'Invalid JSON', raw:text}; }
                        return data;
                    });
                })
                .then(data => {
                    console.log('Wishlist data:', data);
                    
                    // Get the wishlist container
                    const wishlistContainer = document.getElementById('wishlistItems');
                    
                    // Clear existing items
                    wishlistContainer.innerHTML = '';
                    
                    if (data.status === 'success' && data.items && data.items.length > 0) {
                        console.log('Found', data.items.length, 'items in wishlist');
                        // Add each item to the wishlist
                        data.items.forEach(item => {
                            console.log('Adding item to wishlist:', item);
                            
                            // Generate price display with discount
                            let priceDisplay = '';
                            if (item.has_discount) {
                                if (item.discount_type === 'percentage') {
                                    priceDisplay = `
                                        <div class="price-container">
                                            <span class="original-price">${item.original_price} ${item.Currency}</span>
                                            <span class="discount-badge">-${item.discount_value}%</span>
                                            <span class="final-price">${item.final_price} ${item.Currency}</span>
                                        </div>
                                    `;
                                } else { // fixed amount
                                    priceDisplay = `
                                        <div class="price-container">
                                            <span class="original-price">${item.original_price} ${item.Currency}</span>
                                            <span class="discount-badge">-${item.discount_value} ${item.Currency}</span>
                                            <span class="final-price">${item.final_price} ${item.Currency}</span>
                                        </div>
                                    `;
                                }
                            } else {
                                priceDisplay = `<p class="price">${item.price} ${item.Currency}</p>`;
                            }
                            
                            const wishlistItem = document.createElement('div');
                            wishlistItem.className = 'wishlist-item';
                            wishlistItem.innerHTML = `
                                <img src="${item.cover}" alt="${item.name}">
                                <div class="wishlist-item-details">
                                    <h4>${item.name}</h4>
                                    ${priceDisplay}
                                </div>
                                <div class="wishlist-item-actions">
                                    <button onclick="removeFromWishlist(${item.id})" class="remove-wishlist">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            `;
                            wishlistContainer.appendChild(wishlistItem);
                        });
                    } else {
                        console.log('No items found in wishlist or error in response');
                        // Show empty wishlist message
                        wishlistContainer.innerHTML = '<div class="empty-wishlist">Your wishlist is empty</div>';
                    }
                })
                .catch(error => {
                    console.error('Error loading wishlist:', error);
                    const wishlistContainer = document.getElementById('wishlistItems');
                    
                    // Check if the error is due to authentication
                    if (error.message && error.message.includes('Authentication required')) {
                        wishlistContainer.innerHTML = '<div class="error-message">Please log in to view your wishlist</div>';
                    } else {
                        wishlistContainer.innerHTML = '<div class="error-message">Error loading wishlist. Please try again later.</div>';
                    }
                })
                .finally(() => {
                    // Hide loading animation
                    hideLoading();
                });
        }

        function removeFromWishlist(wishlistId) {
            // Check if user is logged in
            const userData = JSON.parse(localStorage.getItem('userData'));
            if (!userData || !userData.email) {
                showToast('Please log in to manage your wishlist');
                return;
            }

            // Get user ID from localStorage
            const userId = userData.id;
            if (!userId) {
                console.error('User ID not found in localStorage');
                showToast('Error: User ID not found. Please log in again.');
                return;
            }

            console.log('Removing item from wishlist:', wishlistId, 'for user:', userId);

            fetch('wishlist_api.php', {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'include',
                body: JSON.stringify({ 
                    wishlist_item_id: wishlistId
                })
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Remove wishlist response:', data);
                if (data.status === 'success') {
                    loadWishlist(); // Reload the wishlist
                } else {
                    // Check if the error is due to authentication
                    if (data.message && data.message.includes('Authentication required')) {
                        showToast('Your session has expired. Please log in again.');
                    } else {
                        showToast(data.message || 'Failed to remove item from wishlist');
                    }
                }
            })
            .catch(error => {
                console.error('Error removing from wishlist:', error);
                // Check if the error is due to authentication
                if (error.message && error.message.includes('Authentication required')) {
                    showToast('Your session has expired. Please log in again.');
                } else {
                    showToast('Failed to remove item from wishlist: ' + error.message);
                }
            });
        }

        // Load wishlist when page loads
        document.addEventListener('DOMContentLoaded', () => {
            fetchProducts();
            loadWishlist();
        });

        // Loading animation functions
        function showLoading() {
            const loadingOverlay = document.getElementById('loadingOverlay');
            if (!loadingOverlay) return;
            loadingOverlay.style.display = 'flex';
            console.log('Loading animation shown');
        }

        function hideLoading() {
            const loadingOverlay = document.getElementById('loadingOverlay');
            if (!loadingOverlay) return;
            loadingOverlay.style.display = 'none';
            console.log('Loading animation hidden');
        }

        // Product loading function
        function loadProducts() {
            console.log('Starting to load products');
            const productsContainer = document.getElementById('productsContainer');
            if (!productsContainer) return; // Not on this page
            showLoading();
            
            fetch('get_product.php')
                .then(response => {
                    console.log('Received response from server');
                    return response.json();
                })
                .then(data => {
                    console.log('Processing product data');
                    productsContainer.innerHTML = ''; // Clear existing products
                    
                    data.forEach(product => {
                        // Generate price display with discount
                        let priceDisplay = '';
                        if (product.has_discount) {
                            if (product.discount_type === 'percentage') {
                                priceDisplay = `
                                    <div class="price-container">
                                        <span class="original-price">${product.original_price} ${product.Currency}</span>
                                        <span class="discount-badge">-${product.discount_value}%</span>
                                        <span class="final-price">${product.final_price} ${product.Currency}</span>
                                    </div>
                                `;
                            } else { // fixed amount
                                priceDisplay = `
                                    <div class="price-container">
                                        <span class="original-price">${product.original_price} ${product.Currency}</span>
                                        <span class="discount-badge">-${product.discount_value} ${product.Currency}</span>
                                        <span class="final-price">${product.final_price} ${product.Currency}</span>
                                    </div>
                                `;
                            }
                        } else {
                            priceDisplay = `<p class="product-price">${product.price} ${product.Currency}</p>`;
                        }

                        const productCard = document.createElement('div');
                        productCard.className = 'product-card';
                        productCard.innerHTML = `
                            <div class="image-container">
                                <a href="product-details.html?id=${product.id}">
                                    <img src="${product.cover}" 
                                         alt="${product.name}" 
                                         class="product-image">
                                </a>
                            </div>
                            <a href="product-details.html?id=${product.id}" class="product-name"><h3 class="product-name">${product.name}</h3></a>
                            ${priceDisplay}
                            <div class="product-buttons">
                                <button onclick="addToWishlist(${product.id})" class="wishlist-btn" title="Add to wishlist" aria-label="Add to wishlist">
                                    <i class="fa-solid fa-heart" aria-hidden="true"></i>
                                </button>
                                <button onclick="addToCart({
                                    id: '${product.id}',
                                    name: '${product.name}',
                                    price: ${parseFloat(product.has_discount ? product.final_price : product.price)},
                                    image: '${product.cover}'
                                })" class="add-to-cart" ${product.quantity <= 0 ? 'disabled' : ''}>
                                    <i class="fa-solid fa-cart-shopping"></i>
                                    ${product.quantity <= 0 ? 'Out of Stock' : 'Add to Cart'}
                                </button>
                                <div id="toast" class="toast-message"></div>
                            </div>
                        `;
                        productsContainer.appendChild(productCard);
                    });
                    console.log('Products loaded successfully');
                })
                .catch(error => {
                    console.error('Error loading products:', error);
                    productsContainer.innerHTML = '<p class="error-message">Error loading products. Please try again later.</p>';
                })
                .finally(() => {
                    console.log('Finishing product loading process');
                    hideLoading();
                });
        }

        // Make sure loadProducts is called when the page loads
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM fully loaded, calling loadProducts');
            loadProducts();
        });

        // Toggle wishlist dropdown - Global function
        function toggleWishlist() {
            console.log('Toggling wishlist dropdown');
            const wishlistDropdown = document.getElementById('wishlistDropdown');
            
            // Check if user is logged in
            const userData = JSON.parse(localStorage.getItem('userData'));
            if (!userData || !userData.email) {
                console.log('User not logged in; showing toast');
                showToast('Please login to view your wishlist');
                return;
            }
            
            // Toggle the dropdown visibility
            if (wishlistDropdown.classList.contains('show')) {
                wishlistDropdown.classList.remove('show');
                console.log('Hiding wishlist dropdown');
            } else {
                wishlistDropdown.classList.add('show');
                console.log('Showing wishlist dropdown');
                // Load wishlist items when showing the dropdown
                loadWishlist();
            }
        }

        // Make functions globally accessible
        window.toggleWishlist = toggleWishlist;
        window.loadWishlist = loadWishlist;
        window.showToast = showToast;
        window.addToWishlist = addToWishlist;
        window.logout = logout;