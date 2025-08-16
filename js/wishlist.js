// Fetch and display wishlist items
function getUserId() {
    const userDataStr = localStorage.getItem('userData');
    let userData;
    try {
        userData = JSON.parse(userDataStr);
    } catch (e) {
        userData = null;
    }
    if (!userData || !userData.id) {
        window.location.href = 'index.html';
        return null;
    }
    return userData.id;
}

function fetchWishlist() {
    const userId = getUserId();
    if (!userId) return;
    fetch(`wishlist.php?user_id=${userId}`)
        .then(response => response.json())
        .then(data => {
            const container = document.getElementById('wishlist-container');
            container.innerHTML = '';
            if (data.status === 'success' && data.items.length > 0) {
                data.items.forEach(item => {
                    // Generate price display with discount
                    let priceDisplay = '';
                    if (item.has_discount) {
                        if (item.discount_type === 'percentage') {
                            priceDisplay = `
                                <div class="price-container">
                                    <span class="original-price">${item.original_price} ${item.Currancy}</span>
                                    <span class="discount-badge">-${item.discount_value}%</span>
                                    <span class="final-price">${item.final_price} ${item.Currancy}</span>
                                </div>
                            `;
                        } else { // fixed amount
                            priceDisplay = `
                                <div class="price-container">
                                    <span class="original-price">${item.original_price} ${item.Currancy}</span>
                                    <span class="discount-badge">-${item.discount_value} ${item.Currancy}</span>
                                    <span class="final-price">${item.final_price} ${item.Currancy}</span>
                                </div>
                            `;
                        }
                    } else {
                        priceDisplay = `<p>Price: ${item.price} ${item.Currancy}</p>`;
                    }
                    
                    const card = document.createElement('div');
                    card.className = 'wishlist-item';
                    card.innerHTML = `
                        <img src="${item.cover}" alt="${item.name}" class="wishlist-img">
                        <div class="wishlist-info">
                            <h3>${item.name}</h3>
                            ${priceDisplay}
                            <div class="wishlist-actions">
                                <button onclick="removeFromWishlist(${item.id})">Remove</button>
                                <button onclick='addToCart({id: ${item.product_id}, name: "${item.name.replace(/'/g, "\\'")}", price: ${item.has_discount ? item.final_price : item.price}, image: "${item.cover}"})' class="add-to-cart">Add to Cart</button>
                            </div>
                        </div>
                    `;
                    container.appendChild(card);
                });
            } else {
                container.innerHTML = '<p>Your wishlist is empty.</p>';
            }
        })
        .catch(err => {
            document.getElementById('wishlist-container').innerHTML = '<p>Error loading wishlist.</p>';
        });
}

function removeFromWishlist(wishlistId) {
    const userId = getUserId();
    if (!userId) return;
    fetch('wishlist.php', {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ user_id: userId, wishlist_id: wishlistId })
    })
    .then(response => response.json())
    .then(data => {
        fetchWishlist();
    });
}

document.addEventListener('DOMContentLoaded', fetchWishlist); 