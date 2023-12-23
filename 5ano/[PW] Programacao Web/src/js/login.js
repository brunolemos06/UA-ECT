document.addEventListener('DOMContentLoaded', function () {
    // Get the login button, email input, and password input
    var loginBtn = document.getElementById('loginBtn');
    var emailInput = document.getElementById('email');
    var passwordInput = document.getElementById('password');

    // Add a click event listener to the login button
    loginBtn.addEventListener('click', function () {
        // Get the values entered by the user
        var emailValue = emailInput.value;
        var passwordValue = passwordInput.value;

        // Perform basic validation (you can add more validation as needed)
        if (emailValue.trim() === '' || passwordValue.trim() === '') {
            alert('Please enter both email and password.');
            return;
        }

        // Here, you can add your login logic (e.g., send a request to a server for authentication)
        // For simplicity, let's just log the values to the console
        console.log('Email:', emailValue);
        console.log('Password:', passwordValue);

        // Fetch user data from the JSON file
        fetch("json/users.json")
            .then(response => response.json())
            .then(data => {
                // Verify email and password
                var verified = false;

                // Iterate through each user
                data.users.forEach(user => {
                    // If email and password match, set verified to true
                    if (emailValue == user.email && passwordValue == user.password) {
                        verified = true;
                        console.log("user: ", user);
                    }
                });

                // If verified is true, then redirect to index.html
                if (verified) {
                    localStorage.setItem("isLoggedIn", true);
                    // parse emailValue to get the username
                    var user = emailValue.split('@')[0];
                    localStorage.setItem("user", user);
                    window.location.href = "index.html";
                }
                // Else, alert the user that the email or password is incorrect
                else {
                    alert("Invalid email or password");
                }
            });
    });
});



function showAnimalContent(animalType) {
    window.location.href = "animals.html?animal=" + animalType;
}


function togglePassword() {
    var passwordInput = document.getElementById("password");
    var toggleBtn = document.getElementById("toggleBtn");

    if (passwordInput.type === "password") {
        passwordInput.type = "text";
        toggleBtn.innerHTML = '<i class="fas fa-eye"></i>';
    } else {
        passwordInput.type = "password";
        toggleBtn.innerHTML = '<i class="fas fa-eye-slash"></i>';
    }
}