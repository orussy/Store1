let slideIndex = 0;
        let slides = [];
        
        // Function to create slides
        function createSlides() {
            const wrapper = document.getElementById('slideshow-wrapper');
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
            slideIndex += n - 1;
            showSlides();
        }

        // Start the slideshow
        createSlides();

        let allProducts = [];
        const productsPerPage = 20;
        let currentPage = 1;

        function fetchProducts() {
            const container = document.getElementById('productsContainer');
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

                card.innerHTML = `
                    <div class="image-container">
                        <img src="${product.cover}" 
                             alt="${product.name}" 
                             class="product-image">
                    </div>
                    <a href="#" class="product-name"><h3 class="product-name">${product.name}</h3></a>
                    <p class="product-price">${product.price} ${product.Currancy}</p>
                    <p class="product-description">${product.description}</p>
                    <p class="product-quantity">${quantityText}</p>

                    <div class="product-buttons">
                        <button onclick="addToWishlist(${product.product_id})" class="wishlist-btn">
                            <i class="fa-solid fa-heart"></i>
                        </button>
                        <button onclick="addToCart({
                            id: '${product.product_id}',
                            name: '${product.name}',
                            price: ${parseFloat(product.price)},
                            image: '${product.cover}'
                        })" class="add-to-cart" ${product.quantity <= 0 ? 'disabled' : ''}>
                            <i class="fa-solid fa-cart-shopping"></i>
                            ${product.quantity <= 0 ? 'Out of Stock' : 'Add to Cart'}
                        </button>
                        <div id="toast" class="toast-message"></div>
                    </div>
                `;
                container.appendChild(card);
            });
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

        // Toggle wishlist dropdown
        function toggleWishlist() {
            console.log('Toggling wishlist dropdown');
            const wishlistDropdown = document.getElementById('wishlistDropdown');
            
            // Check if user is logged in
            const userData = JSON.parse(localStorage.getItem('userData'));
            if (!userData || !userData.email) {
                console.log('User not logged in, redirecting to login page');
                showToast('Please login to view your wishlist');
                window.location.href = 'index.html';
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

        // Close wishlist when clicking outside
        document.addEventListener('click', function(event) {
            const wishlistDropdown = document.getElementById('wishlistDropdown');
            const wishlistIcon = document.querySelector('.nav-icon[alt="wishlist"]');
            
            // Check if click is outside the wishlist dropdown and icon
            if (!wishlistDropdown.contains(event.target) && event.target !== wishlistIcon) {
                wishlistDropdown.classList.remove('show');
            }
        });

        // Check login status when page loads
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Checking login status...');
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

            if (userData && userData.email) {
                console.log('User is logged in with email:', userData.email);
                console.log('User ID:', userData.id);
                // User is logged in
                loginSection.style.display = 'none';
                userSection.style.display = 'flex';
                usernameSpan.textContent = userData.email;
            } else {
                console.log('User is not logged in or missing email');
                // User is not logged in
                loginSection.style.display = 'flex';
                userSection.style.display = 'none';
            }
        });

        function logout() {
            // Clear user data
            localStorage.removeItem('userData');
            
            // Call logout.php to clear session
            fetch('logout.php')
                .finally(() => {
                    // Redirect to login page
                    window.location.href = 'index.html';
                });
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
                console.log('User not logged in, redirecting to login...');
                showToast('Please login to view your wishlist');
                window.location.href = 'index.html';
                return;
            }

            // Get user ID from localStorage
            const userId = userData.id;
            if (!userId) {
                console.error('User ID not found in localStorage');
                showToast('Error: User ID not found. Please log in again.');
                window.location.href = 'index.html';
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

            fetch('wishlist.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ 
                    product_id: numericProductId,
                    user_id: userId
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
                        window.location.href = 'index.html';
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
                    window.location.href = 'index.html';
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
            const url = `wishlist.php?user_id=${userId}`;
            console.log('Fetching wishlist data from URL:', url);
            
            fetch(url)
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
                            const wishlistItem = document.createElement('div');
                            wishlistItem.className = 'wishlist-item';
                            wishlistItem.innerHTML = `
                                <img src="${item.cover}" alt="${item.name}">
                                <div class="wishlist-item-details">
                                    <h4>${item.name}</h4>
                                    <p class="price">$${item.price}</p>
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
                        // Redirect to login page after a short delay
                        setTimeout(() => {
                            window.location.href = 'index.html';
                        }, 2000);
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
                window.location.href = 'index.html';
                return;
            }

            // Get user ID from localStorage
            const userId = userData.id;
            if (!userId) {
                console.error('User ID not found in localStorage');
                showToast('Error: User ID not found. Please log in again.');
                window.location.href = 'index.html';
                return;
            }

            console.log('Removing item from wishlist:', wishlistId, 'for user:', userId);

            fetch('wishlist.php', {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ 
                    wishlist_id: wishlistId,
                    user_id: userId
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
                        window.location.href = 'index.html';
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
                    window.location.href = 'index.html';
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
            loadingOverlay.style.display = 'flex';
            console.log('Loading animation shown');
        }

        function hideLoading() {
            const loadingOverlay = document.getElementById('loadingOverlay');
            loadingOverlay.style.display = 'none';
            console.log('Loading animation hidden');
        }

        // Product loading function
        function loadProducts() {
            console.log('Starting to load products');
            showLoading();
            
            fetch('get_products.php')
                .then(response => {
                    console.log('Received response from server');
                    return response.json();
                })
                .then(data => {
                    console.log('Processing product data');
                    const productsContainer = document.getElementById('productsContainer');
                    productsContainer.innerHTML = ''; // Clear existing products
                    
                    data.forEach(product => {
                        const productCard = document.createElement('div');
                        productCard.className = 'product-card';
                        productCard.innerHTML = `
                            <img src="${product.cover}" alt="${product.name}">
                            <h3>${product.name}</h3>
                            <p class="price">$${product.price}</p>
                            <div class="product-actions">
                                <button onclick="addToCart(${product.id})" class="add-to-cart">
                                    <i class="fa-solid fa-cart-plus"></i> Add to Cart
                                </button>
                                <button onclick="addToWishlist(${product.id})" class="wishlist-btn" data-product-id="${product.id}">
                                    <i class="fa-solid fa-heart"></i>
                                </button>
                            </div>
                        `;
                        productsContainer.appendChild(productCard);
                    });
                    console.log('Products loaded successfully');
                })
                .catch(error => {
                    console.error('Error loading products:', error);
                    const productsContainer = document.getElementById('productsContainer');
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