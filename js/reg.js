$(document).ready(function() {
    $("#regform").submit(function(event) {
        event.preventDefault(); // Prevent default form submission
        
        var formData = {
            f_name: $("#f_name").val(),
            l_name: $("#l_name").val(),
            email: $("#email").val(),
            password: $("#password").val(),
            birthdate: $("#birthdate").val(),
            phone_no: $("#phone_no").val(),
            gender: $("#gender").val()
        };

        $.ajax({
            url: "reg.php",
            type: "POST",
            data: formData,
            dataType: "json",
            success: function(response) {
                if (response.status === "success") {
                    window.location.href = "index.html?" + encodeURIComponent(response.username);
                } else {
                    $("#responseMessage").text(response.message);
                }
            },
            error: function(xhr, status, error) {
                $("#responseMessage").text("Error: " + error);
            }
        });
    });
});