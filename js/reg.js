// Function to hash password using SHA-256
async function hashPassword(password) {
    const encoder = new TextEncoder();
    const data = encoder.encode(password);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
    return hashHex;
}

$(document).ready(function() {
    $("#regform").submit(async function(event) {
        event.preventDefault(); // Prevent default form submission
        
        // Hash password on client side
        const password = $("#password").val();
        const hashedPassword = await hashPassword(password);
        
        var formData = {
            f_name: $("#f_name").val(),
            l_name: $("#l_name").val(),
            email: $("#email").val(),
            password: hashedPassword,
            birthdate: $("#birthdate").val(),
            phone_no: $("#phone_no").val(),
            gender: $("#gender").val()
        };

        // Show loading message
        $("#responseMessage").text("Processing registration...").css("color", "#0d3b5e");

        $.ajax({
            url: "reg.php",
            type: "POST",
            data: formData,
            dataType: "json",
            success: function(response) {
                if (response.status === "verification_required") {
                    // Redirect to verification page
                    window.location.href = "verify-email.html";
                } else if (response.status === "success") {
                    window.location.href = "index.html?" + encodeURIComponent(response.username);
                } else {
                    $("#responseMessage").text(response.message).css("color", "#dc3545");
                }
            },
            error: function(xhr, status, error) {
                $("#responseMessage").text("Error: " + error).css("color", "#dc3545");
            }
        });
    });
});