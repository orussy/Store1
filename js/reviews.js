// Product Reviews JavaScript functionality

class ProductReviews {
    constructor(productId) {
        this.productId = productId;
        this.currentUser = this.getCurrentUser();
        this.currentRating = 0;
        this.reviews = [];
        this.averageRating = 0;
        this.totalReviews = 0;
        
        this.init();
    }
    
    init() {
        this.loadReviews();
        this.setupEventListeners();
    }
    
    getCurrentUser() {
        try {
            const userData = localStorage.getItem('userData');
            console.log('Raw userData from localStorage:', userData);
            const parsed = userData ? JSON.parse(userData) : null;
            console.log('Parsed user data:', parsed);
            return parsed;
        } catch (e) {
            console.error('Error parsing user data:', e);
            return null;
        }
    }
    
    setupEventListeners() {
        // Star rating interaction
        const starRating = document.getElementById('starRating');
        console.log('Setting up star rating listeners, starRating element:', starRating);
        
        if (starRating) {
            const stars = starRating.querySelectorAll('.star');
            console.log('Found stars:', stars.length);
            
            stars.forEach((star, index) => {
                console.log('Adding listeners to star', index + 1);
                star.addEventListener('click', () => {
                    console.log('Star clicked:', index + 1);
                    this.setRating(index + 1);
                });
                star.addEventListener('mouseenter', () => {
                    console.log('Star hovered:', index + 1);
                    this.highlightStars(index + 1);
                });
            });
            
            starRating.addEventListener('mouseleave', () => {
                console.log('Mouse left star rating');
                this.highlightStars(this.currentRating);
            });
        } else {
            console.log('Star rating element not found');
        }
        
        // Review form submission
        const reviewForm = document.getElementById('reviewForm');
        if (reviewForm) {
            reviewForm.addEventListener('submit', (e) => this.submitReview(e));
        }
    }
    
    setRating(rating) {
        console.log('Setting rating to:', rating);
        this.currentRating = rating;
        this.highlightStars(rating);
    }
    
    highlightStars(rating) {
        console.log('Highlighting stars up to:', rating);
        const stars = document.querySelectorAll('#starRating .star');
        console.log('Found stars to highlight:', stars.length);
        
        stars.forEach((star, index) => {
            if (index < rating) {
                star.classList.add('active');
                console.log('Star', index + 1, 'activated');
            } else {
                star.classList.remove('active');
                console.log('Star', index + 1, 'deactivated');
            }
        });
    }
    
    async loadReviews() {
        console.log('Loading reviews for product:', this.productId);
        try {
            this.showLoading();
            
            const response = await fetch(`product_reviews_api.php?product_id=${this.productId}`);
            console.log('API response status:', response.status);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const data = await response.json();
            console.log('API response data:', data);
            
            if (data.status === 'success') {
                this.reviews = data.reviews || [];
                this.averageRating = data.average_rating || 0;
                this.totalReviews = data.total_reviews || 0;
                
                console.log('Reviews loaded:', this.reviews);
                console.log('Average rating:', this.averageRating);
                console.log('Total reviews:', this.totalReviews);
                
                this.renderReviewsSummary();
                this.renderReviewForm();
                this.renderReviewsList();
            } else {
                throw new Error(data.message || 'API returned error status');
            }
        } catch (error) {
            console.error('Error loading reviews:', error);
            this.showError('Failed to load reviews: ' + error.message);
            
            // Show empty state if API fails
            this.reviews = [];
            this.averageRating = 0;
            this.totalReviews = 0;
            this.renderReviewsSummary();
            this.renderReviewForm();
            this.renderReviewsList();
        }
    }
    
    renderReviewsSummary() {
        const summaryContainer = document.getElementById('reviewsSummary');
        if (!summaryContainer) return;
        
        const starsHtml = this.generateStarsHtml(this.averageRating, true);
        
        summaryContainer.innerHTML = `
            <div class="average-rating">
                <span class="rating-number">${this.averageRating || 0}</span>
                <div class="rating-stars">${starsHtml}</div>
            </div>
            <div class="total-reviews">${this.totalReviews} review${this.totalReviews !== 1 ? 's' : ''}</div>
        `;
    }
    
    renderReviewForm() {
        const formContainer = document.getElementById('reviewFormContainer');
        if (!formContainer) return;
        
        // Check if user is logged in
        if (!this.currentUser) {
            formContainer.innerHTML = `
                <div class="review-form">
                    <h3>Write a Review</h3>
                    <p>Please <a href="index.html">login</a> to write a review.</p>
                </div>
            `;
            return;
        }
        
        // Check if user already reviewed this product
        const userReview = this.reviews.find(review => review.user_id == this.currentUser.id);
        if (userReview) {
            formContainer.innerHTML = `
                <div class="review-form">
                    <h3>Your Review</h3>
                    <div class="review-item">
                        <div class="review-header">
                            <div class="review-user">
                                <img src="${userReview.user_avatar}" alt="Avatar" class="review-user-avatar">
                                <div class="review-user-info">
                                    <h4>${userReview.user_name}</h4>
                                    <div class="review-date">${this.formatDate(userReview.created_at)}</div>
                                </div>
                            </div>
                            <div class="review-rating">${this.generateStarsHtml(userReview.rating, true)}</div>
                        </div>
                        <div class="review-content">${userReview.review || 'No written review'}</div>
                        <div class="review-actions">
                            <button class="delete-review-btn" onclick="productReviews.deleteReview(${userReview.id})">
                                Delete Review
                            </button>
                        </div>
                    </div>
                </div>
            `;
            return;
        }
        
        // Show review form
        formContainer.innerHTML = `
            <div class="review-form">
                <h3>Write a Review</h3>
                <form id="reviewForm">
                    <div class="form-group">
                        <label>Rating *</label>
                        <div class="star-rating" id="starRating">
                            ${this.generateStarsHtml(0, false)}
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="reviewText">Review (Optional)</label>
                        <textarea id="reviewText" name="review" placeholder="Share your experience with this product..."></textarea>
                    </div>
                    <button type="submit" class="submit-review-btn">Submit Review</button>
                </form>
            </div>
        `;
        
        // Re-setup event listeners for the new form
        this.setupEventListeners();
    }
    
    renderReviewsList() {
        const listContainer = document.getElementById('reviewsList');
        if (!listContainer) return;
        
        if (this.reviews.length === 0) {
            listContainer.innerHTML = `
                <div class="no-reviews">
                    No reviews yet. Be the first to review this product!
                </div>
            `;
            return;
        }
        
        const reviewsHtml = this.reviews.map(review => `
            <div class="review-item">
                <div class="review-header">
                    <div class="review-user">
                        <img src="${review.user_avatar}" alt="Avatar" class="review-user-avatar">
                        <div class="review-user-info">
                            <h4>${review.user_name}</h4>
                            <div class="review-date">${this.formatDate(review.created_at)}</div>
                        </div>
                    </div>
                    <div class="review-rating">${this.generateStarsHtml(review.rating, true)}</div>
                </div>
                <div class="review-content">${review.review || 'No written review'}</div>
                ${review.user_id == this.currentUser?.id ? `
                    <div class="review-actions">
                        <button class="delete-review-btn" onclick="productReviews.deleteReview(${review.id})">
                            Delete Review
                        </button>
                    </div>
                ` : ''}
            </div>
        `).join('');
        
        listContainer.innerHTML = reviewsHtml;
    }
    
    generateStarsHtml(rating, readonly = false) {
        const stars = [];
        for (let i = 1; i <= 5; i++) {
            const activeClass = i <= rating ? 'active' : '';
            const readonlyClass = readonly ? 'readonly' : '';
            stars.push(`<span class="star ${activeClass} ${readonlyClass}">★</span>`);
        }
        return stars.join('');
    }
    
    formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    }
    
    async submitReview(event) {
        event.preventDefault();
        
        if (!this.currentUser) {
            this.showError('Please login to submit a review');
            return;
        }
        
        if (this.currentRating === 0) {
            this.showError('Please select a rating');
            return;
        }
        
        const reviewText = document.getElementById('reviewText').value.trim();
        
        try {
            const submitBtn = document.querySelector('.submit-review-btn');
            submitBtn.disabled = true;
            submitBtn.textContent = 'Submitting...';
            
            const response = await fetch('product_reviews_api.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    product_id: this.productId,
                    rating: this.currentRating,
                    review: reviewText,
                    user_id: this.currentUser.id
                })
            });
            
            const data = await response.json();
            
            if (data.status === 'success') {
                this.showSuccess('Review submitted successfully!');
                this.loadReviews(); // Reload reviews
            } else {
                this.showError(data.message);
            }
        } catch (error) {
            this.showError('Failed to submit review');
            console.error('Error submitting review:', error);
        } finally {
            const submitBtn = document.querySelector('.submit-review-btn');
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.textContent = 'Submit Review';
            }
        }
    }
    
    async deleteReview(reviewId) {
        if (!this.currentUser) {
            this.showError('Please login to delete reviews');
            return;
        }
        
        if (!confirm('Are you sure you want to delete this review?')) {
            return;
        }
        
        try {
            const response = await fetch('product_reviews_api.php', {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    review_id: reviewId,
                    user_id: this.currentUser.id
                })
            });
            
            const data = await response.json();
            
            if (data.status === 'success') {
                this.showSuccess('Review deleted successfully!');
                this.loadReviews(); // Reload reviews
            } else {
                this.showError(data.message);
            }
        } catch (error) {
            this.showError('Failed to delete review');
            console.error('Error deleting review:', error);
        }
    }
    
    showLoading() {
        const container = document.getElementById('reviewsContainer');
        if (container) {
            container.innerHTML = '<div class="reviews-loading">Loading reviews...</div>';
        }
    }
    
    showError(message) {
        this.showToast(message, 'error');
    }
    
    showSuccess(message) {
        this.showToast(message, 'success');
    }
    
    showToast(message, type = 'info') {
        // Create toast element
        const toast = document.createElement('div');
        toast.className = `toast-message ${type}`;
        toast.textContent = message;
        
        // Add to page
        document.body.appendChild(toast);
        
        // Show toast
        setTimeout(() => toast.classList.add('show'), 100);
        
        // Remove toast after 3 seconds
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => document.body.removeChild(toast), 500);
        }, 3000);
    }
}

// Initialize reviews when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, initializing reviews...');
    
    // Get product ID from URL parameter or data attribute
    const urlParams = new URLSearchParams(window.location.search);
    const productId = urlParams.get('id') || document.querySelector('[data-product-id]')?.dataset.productId;
    
    console.log('Product ID found:', productId);
    
    if (productId) {
        console.log('Creating ProductReviews instance...');
        window.productReviews = new ProductReviews(productId);
        console.log('ProductReviews instance created:', window.productReviews);
    } else {
        console.log('No product ID found, reviews not initialized');
    }
});
