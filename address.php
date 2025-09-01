<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Address</title>
    <link rel="stylesheet" href="style/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <style>
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #007bff;
        }
        .submit-btn {
            background: #007bff;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            width: 100%;
        }
        .submit-btn:hover {
            background: #0056b3;
        }
        .map-container {
            margin: 20px 0;
            height: 300px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .coordinates-display {
            background: #f8f9fa;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
            font-family: monospace;
        }
        .error-message {
            color: #dc3545;
            background: #f8d7da;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
            display: none;
            white-space: pre-wrap;
            word-wrap: break-word;
            max-height: 300px;
            overflow-y: auto;
            font-family: monospace;
            font-size: 12px;
        }
        .success-message {
            color: #155724;
            background: #d4edda;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
            display: none;
        }
        .user-info {
            text-align: center;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
        }
        .logout-link {
            text-align: right;
            margin-bottom: 20px;
        }
        .logout-link a {
            color: #dc3545;
            text-decoration: none;
        }
        .logout-link a:hover {
            text-decoration: underline;
        }
        .auth-error {
            background: #f8d7da;
            color: #721c24;
            padding: 20px;
            border-radius: 4px;
            text-align: center;
            margin: 50px auto;
            max-width: 600px;
        }
        .auth-error a {
            color: #721c24;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div id="authCheck" style="display: none;">
        <div class="auth-error">
            <h3>Authentication Required</h3>
            <p>You must be logged in to add addresses.</p>
            <a href="index.html">Go to Login</a>
        </div>
    </div>

    <div id="addressFormContainer" class="form-container" style="display: none;">
        <div class="logout-link">
            <a href="#" onclick="logout()">Logout</a>
        </div>
        
        <div class="user-info">
            <strong>User:</strong> <span id="userEmail"></span>
            <br>
            <strong>User ID:</strong> <span id="userId"></span>
        </div>
        
        <h2>Add New Address</h2>
        
        <div class="error-message" id="errorMessage"></div>
        <div class="success-message" id="successMessage"></div>
        
        <form id="addressForm">
            <div class="form-group">
                <label for="title">Title</label>
                <select name="title" id="title" required>
                    <option value="">Select Title</option>
                    <option value="Home">Home</option>
                    <option value="Work">Work</option>
                    <option value="Parents">Parents</option>
                    <option value="Vacation">Vacation</option>
                    <option value="Office">Office</option>
                    <option value="Gym">Gym</option>
                    <option value="Friend's House">Friend's House</option>
                    <option value="Delivery Point">Delivery Point</option>
                    <option value="Other">Other</option>
                </select>
            </div>

            <div class="form-group">
                <label for="address1">Address Line 1</label>
                <input type="text" placeholder="Enter address line 1" name="address1" id="address1" required>
            </div>

            <div class="form-group">
                <label for="address2">Address Line 2 (Optional)</label>
                <input type="text" placeholder="Enter address line 2" name="address2" id="address2">
            </div>

            <div class="form-group">
                <label for="country">Country</label>
                <select name="country" id="country" title="Select your country" required>
                    <option value="">Select Country</option>
                    <option value="Egypt">Egypt</option>
                    <option value="United States">United States</option>
                    <option value="United Kingdom">United Kingdom</option>
                    <option value="Germany">Germany</option>
                    <option value="France">France</option>
                    <option value="Canada">Canada</option>
                    <option value="Australia">Australia</option>
                    <option value="Japan">Japan</option>
                    <option value="China">China</option>
                    <option value="India">India</option>
                    <option value="Brazil">Brazil</option>
                    <option value="Mexico">Mexico</option>
                    <option value="Italy">Italy</option>
                    <option value="Spain">Spain</option>
                </select>
            </div>
        
            <div class="form-group">
                <label for="city">City</label>
                <input type="text" name="city" id="city" placeholder="Enter city name" required>
            </div>
            
            <div class="form-group">
                <label for="postal_code">Postal Code</label>
                <input type="text" placeholder="Enter postal code" name="postal_code" id="postal_code" required>
            </div>

            <div class="form-group">
                <label for="location_accuracy">Location Accuracy</label>
                <select name="location_accuracy" id="location_accuracy">
                    <option value="approximate">Approximate</option>
                    <option value="exact">Exact</option>
                    <option value="general">General</option>
                </select>
            </div>

            <div class="form-group">
                <label>Location on Map</label>
                <div class="map-container" id="map"></div>
                <div class="coordinates-display">
                    <strong>Coordinates:</strong> 
                    <span id="coordinatesDisplay">Click on the map to set location</span>
                </div>
                <small>Click on the map to set your exact location. This helps with delivery accuracy.</small>
            </div>

            <button type="submit" class="submit-btn">Save Address</button>
        </form>
    </div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        let map, marker;
        let selectedLatitude = null;
        let selectedLongitude = null;
        let currentUser = null;

        // Check authentication when page loads
        document.addEventListener('DOMContentLoaded', function() {
            checkAuthentication();
        });

        // Check if user is authenticated
        function checkAuthentication() {
            const userDataStr = localStorage.getItem('userData');
            
            if (!userDataStr) {
                showAuthError();
                return;
            }

            try {
                currentUser = JSON.parse(userDataStr);
                
                if (!currentUser || !currentUser.id || !currentUser.email) {
                    showAuthError();
                    return;
                }

                // User is authenticated, show the form
                showAddressForm();
                
            } catch (error) {
                console.error('Error parsing user data:', error);
                showAuthError();
            }
        }

        // Show authentication error
        function showAuthError() {
            document.getElementById('authCheck').style.display = 'block';
            document.getElementById('addressFormContainer').style.display = 'none';
        }

        // Show address form
        function showAddressForm() {
            document.getElementById('authCheck').style.display = 'none';
            document.getElementById('addressFormContainer').style.display = 'block';
            
            // Display user info
            document.getElementById('userEmail').textContent = currentUser.email;
            document.getElementById('userId').textContent = currentUser.id;
            
            // Initialize form
            initializeMap();
        }

        // Logout function
        function logout() {
            localStorage.removeItem('userData');
            window.location.href = 'index.html';
        }

        // Initialize map
        function initializeMap() {
            const mapDiv = document.getElementById('map');
            if (!mapDiv) return;
            
            // Default coordinates (Cairo, Egypt)
            const defaultLat = 30.0444;
            const defaultLng = 31.2357;
            
            map = L.map('map').setView([defaultLat, defaultLng], 13);
            
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '© OpenStreetMap contributors'
            }).addTo(map);
            
            // Add click event to set location
            map.on('click', function(e) {
                if (marker) {
                    map.removeLayer(marker);
                }
                marker = L.marker(e.latlng).addTo(map);
                selectedLatitude = e.latlng.lat;
                selectedLongitude = e.latlng.lng;
                updateCoordinatesDisplay();
            });
        }

        // Update coordinates display
        function updateCoordinatesDisplay() {
            const display = document.getElementById('coordinatesDisplay');
            if (selectedLatitude && selectedLongitude) {
                display.textContent = `${selectedLatitude.toFixed(6)}, ${selectedLongitude.toFixed(6)}`;
            } else {
                display.textContent = 'Click on the map to set location';
            }
        }

        // Handle form submission
        document.getElementById('addressForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            console.log('Form submitted!'); // Debug log
            
            // Hide previous messages
            document.getElementById('errorMessage').style.display = 'none';
            document.getElementById('successMessage').style.display = 'none';
            
            if (!selectedLatitude || !selectedLongitude) {
                showMessage('Please set a location on the map before saving.', 'error');
                return;
            }
            
            const formData = new FormData(this);
            
            // Add user ID from localStorage
            formData.append('user_id', currentUser.id);
            formData.append('latitude', selectedLatitude);
            formData.append('longitude', selectedLongitude);
            
            // Debug: Log what we're sending
            console.log('Sending form data:');
            for (let [key, value] of formData.entries()) {
                console.log(key + ': ' + value);
            }
            
            // Also log the currentUser object
            console.log('Current user data:', currentUser);
            console.log('Selected coordinates:', { lat: selectedLatitude, lng: selectedLongitude });
            
            try {
                console.log('Sending request to save_address_minimal.php...');
                const response = await fetch('save_address_minimal.php', {
                    method: 'POST',
                    body: formData
                });
                
                console.log('Response received:', response);
                const data = await response.json();
                console.log('Response data:', data);
                
                if (data.status === 'success') {
                    showMessage(data.message, 'success');
                    this.reset();
                    selectedLatitude = null;
                    selectedLongitude = null;
                    updateCoordinatesDisplay();
                    
                    // Remove marker from map
                    if (marker) {
                        map.removeLayer(marker);
                        marker = null;
                    }
                } else {
                    console.error('Server response:', data);
                    let errorMsg = data.message;
                    if (data.debug) {
                        errorMsg += '\n\nDebug info: ' + JSON.stringify(data.debug, null, 2);
                        console.log('Debug info:', data.debug);
                    }
                    showMessage(errorMsg, 'error');
                }
            } catch (error) {
                console.error('Error saving address:', error);
                showMessage('Error saving address. Please try again.', 'error');
            }
        });

        // Show message function
        function showMessage(message, type) {
            const errorDiv = document.getElementById('errorMessage');
            const successDiv = document.getElementById('successMessage');
            
            if (type === 'error') {
                errorDiv.textContent = message;
                errorDiv.style.display = 'block';
                successDiv.style.display = 'none';
            } else {
                successDiv.textContent = message;
                successDiv.style.display = 'block';
                errorDiv.style.display = 'none';
            }
        }
    </script>
</body>
</html>
