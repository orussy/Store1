// Cart functionality
let cart = {
    items: [],
    total: 0
};

function toggleCart() {
    const cartDropdown = document.getElementById('cartDropdown');
    cartDropdown.classList.toggle('show');
    
    if (cartDropdown.classList.contains('show')) {
        loadCart('cartDropdownItems');
    }
}

// Close cart dropdown when clicking outside
document.addEventListener('click', function(event) {
    const cartDropdown = document.getElementById('cartDropdown');
    const cartIcon = document.querySelector('img[alt="Cart"]');
    
    if (!cartDropdown.contains(event.target) && !cartIcon.contains(event.target)) {
        cartDropdown.classList.remove('show');
    }
});

function addToCart(product) {
    // Check if user is logged in
    const userData = JSON.parse(localStorage.getItem('userData'));
    if (!userData || !userData.email) {
        showToast('Please login to add items to cart');
        return;
    }

    fetch('cart_api.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        credentials: 'include',
        body: JSON.stringify({
            product_id: product.id,
            quantity: 1
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            cart = data;
            updateCartDisplay('cartItems');
            updateCartDisplay('cartDropdownItems');
            showToast('Product added to cart!');
        } else {
            showToast(data.message || 'Failed to add product to cart');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Failed to add product to cart');
    });
}

function removeFromCart(cartItemId) {
    fetch('cart_api.php', {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json',
        },
        credentials: 'include',
        body: JSON.stringify({
            cart_item_id: cartItemId
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            cart = data;
            updateCartDisplay('cartItems');
            updateCartDisplay('cartDropdownItems');
            showToast('Product removed from cart!');
        } else {
            showToast(data.message || 'Failed to remove product from cart');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Failed to remove product from cart');
    });
}

function updateCartItemQuantity(cartItemId, quantity) {
    fetch('cart_api.php', {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        credentials: 'include',
        body: JSON.stringify({
            cart_item_id: cartItemId,
            quantity: quantity
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            cart = data;
            updateCartDisplay('cartItems');
            updateCartDisplay('cartDropdownItems');
        } else {
            showToast(data.message || 'Failed to update cart');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Failed to update cart');
    });
}

function loadCart(targetId = 'cartItems') {
    fetch('cart_api.php', {
        credentials: 'include'
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                cart = data;
                updateCartDisplay(targetId);
            } else {
                showToast(data.message || 'Failed to load cart');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('Failed to load cart');
        });
}

function updateCartDisplay(targetId = 'cartItems') {
    const cartItems = document.getElementById(targetId);
    if (!cartItems) return;
    if (!cart.items || cart.items.length === 0) {
        cartItems.innerHTML = '<div class="empty-cart">Your cart is empty</div>';
        return;
    }
    const totalCurrency = cart.items[0]?.Currency || cart.items[0]?.currency_code || cart.items[0]?.currency || 'EGP';
    cartItems.innerHTML = cart.items.map(item => {

        // Generate price display with discount
        let priceDisplay = '';
        if (item.has_discount) {
            if (item.discount_type === 'percentage') {
                priceDisplay = `
                    <div class="price-container">
                        <span class="original-price">${item.original_price} ${item.Currency || item.currency_code || item.currency || 'EGP'}</span>
                        <span class="discount-badge">-${item.discount_value}%</span>
                        <span class="final-price">${item.final_price} ${item.Currency || item.currency_code || item.currency || 'EGP'}</span>
                    </div>
                `;
            } else { // fixed amount
                priceDisplay = `
                    <div class="price-container">
                        <span class="original-price">${item.original_price} ${item.Currency || item.currency_code || item.currency || 'EGP'}</span>
                        <span class="discount-badge">-${item.discount_value} ${item.Currency || item.currency_code || item.currency || 'EGP'}</span>
                        <span class="final-price">${item.final_price} ${item.Currency || item.currency_code || item.currency || 'EGP'}</span>
                    </div>
                `;
            }
        } else {
            priceDisplay = `<div class="price">${item.price} ${item.Currency || item.currency_code || item.currency || 'EGP'}</div>`;
        }
        
        return `
            <div class="cart-item">
                <img src="${item.cover}" alt="${item.name}">
                <div class="cart-item-details">
                    <h4>${item.name}</h4>
                    <div class="quantity-controls">
                        <button onclick="updateCartItemQuantity(${item.id}, ${item.quantity - 1})" ${item.quantity <= 1 ? 'disabled' : ''}>-</button>
                        <span>${item.quantity}</span>
                        <button onclick="updateCartItemQuantity(${item.id}, ${item.quantity + 1})">+</button>
                    </div>
                    ${priceDisplay}
                    <div class="item-total">Total: ${(parseFloat(item.has_discount ? item.final_price : item.price) * item.quantity).toFixed(2)} ${item.Currency || item.currency_code || item.currency || 'EGP'}</div>
                </div>
                <button class="remove-cart" onclick="removeFromCart(${item.id})">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `;
    }).join('') + `
        <div class="cart-total">
            <strong>Total: ${cart.total.toFixed(2)} ${totalCurrency}</strong>
        </div>
    `;
}

function showToast(message) {
    const toast = document.createElement('div');
    toast.className = 'toast-message';
    toast.textContent = message;
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.classList.add('show');
    }, 100);
    
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => {
            document.body.removeChild(toast);
        }, 300);
    }, 3000);
}

// Load cart when page loads
document.addEventListener('DOMContentLoaded', function() { loadCart('cartItems'); });

// Export functions for use in other files
window.addToCart = addToCart;
window.removeFromCart = removeFromCart;
window.toggleCart = toggleCart;
window.updateCartItemQuantity = updateCartItemQuantity; 