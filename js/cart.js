// Cart functionality
let cart = {
    items: [],
    total: 0
};

function toggleCart() {
    const cartDropdown = document.getElementById('cartDropdown');
    cartDropdown.classList.toggle('show');
    
    if (cartDropdown.classList.contains('show')) {
        loadCart();
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
        window.location.href = 'index.html';
        return;
    }

    fetch('cart.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            product_id: product.id,
            quantity: 1
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            cart = data;
            updateCartDisplay();
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
    fetch('cart.php', {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            cart_item_id: cartItemId
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            cart = data;
            updateCartDisplay();
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
    fetch('cart.php', {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            cart_item_id: cartItemId,
            quantity: quantity
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            cart = data;
            updateCartDisplay();
        } else {
            showToast(data.message || 'Failed to update cart');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Failed to update cart');
    });
}

function loadCart() {
    fetch('cart.php')
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                cart = data;
                updateCartDisplay();
            } else {
                showToast(data.message || 'Failed to load cart');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('Failed to load cart');
        });
}

function updateCartDisplay() {
    const cartItems = document.getElementById('cartItems');
    
    if (!cart.items || cart.items.length === 0) {
        cartItems.innerHTML = '<div class="empty-cart">Your cart is empty</div>';
        return;
    }
    // Use the currency of the first item for the total (assuming all items have the same currency)
    const totalCurrency = cart.items[0]?.currency || '';
    cartItems.innerHTML = cart.items.map(item => `
        <div class="cart-item">
            <img src="${item.cover}" alt="${item.name}">
            <div class="cart-item-details">
                <h4>${item.name}</h4>
                <div class="quantity-controls">
                    <button onclick="updateCartItemQuantity(${item.id}, ${item.quantity - 1})" ${item.quantity <= 1 ? 'disabled' : ''}>-</button>
                    <span>${item.quantity}</span>
                    <button onclick="updateCartItemQuantity(${item.id}, ${item.quantity + 1})">+</button>
                </div>
                <div class="price">${item.price * item.quantity} ${item.currency || ''}</div>
            </div>
            <button class="remove-cart" onclick="removeFromCart(${item.id})">
                <i class="fas fa-trash"></i>
            </button>
        </div>
    `).join('') + `
        <div class="cart-total">
            <strong>Total: ${cart.total} ${totalCurrency}</strong>
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
document.addEventListener('DOMContentLoaded', loadCart);

// Export functions for use in other files
window.addToCart = addToCart;
window.removeFromCart = removeFromCart;
window.toggleCart = toggleCart;
window.updateCartItemQuantity = updateCartItemQuantity; 