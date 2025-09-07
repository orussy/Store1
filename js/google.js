document.addEventListener('DOMContentLoaded', function() {
    // Get stored Google data
    const googleData = JSON.parse(localStorage.getItem('googleUserData'));
    
    if (!googleData) {
        // Do not force redirect; show minimal UI or let page handle
        return;
    }

    // Update profile picture and header info
    document.getElementById('profile-picture').src = googleData.picture || 'default-profile.png';
    document.getElementById('full-name').textContent = googleData.name || 'N/A';
    document.getElementById('email').textContent = googleData.email || 'N/A';

    // Create data rows for all available information
    const profileData = document.getElementById('profile-data');
    const dataFields = [
        { label: 'Given Name', key: 'given_name' },
        { label: 'Family Name', key: 'family_name' },
        { label: 'Email', key: 'email' },
        { label: 'Email Verified', key: 'email_verified' },
        { label: 'Locale', key: 'locale' },
        { label: 'Google ID', key: 'sub' },
        { label: 'Picture URL', key: 'picture' }
    ];

    dataFields.forEach(field => {
        if (googleData[field.key] !== undefined) {
            const row = document.createElement('div');
            row.className = 'data-row';
            row.innerHTML = `
                <div class="data-label">${field.label}:</div>
                <div class="data-value">${
                    field.key === 'email_verified' 
                        ? (googleData[field.key] ? 'Yes' : 'No')
                        : googleData[field.key]
                }</div>
            `;
            profileData.appendChild(row);
        }
    });
});