//To change navbar buttons if user is logged in
document.addEventListener('DOMContentLoaded', function () {

    var signInButton = document.querySelector('.nav-item.bg-white');
    var signUpButton = document.querySelector('.nav-item.bg-primary');
    
    // Check if the user is logged in
    var isLoggedIn = localStorage.getItem("isLoggedIn") === "true";
    var user = localStorage.getItem("user");
    console.log("user: ", user);

    if (isLoggedIn) {
        var signOutButton = document.createElement('li');
        var userButton = document.createElement('li');
        
        signOutButton.className = 'nav-item border border-0 rounded mx-lg-2 mx-lg-0 bg-primary';
        userButton.className = 'nav-item border border-0 rounded ms-lg-5 ms-sm-0 bg-white';

        signOutButton.innerHTML = '<a class="nav-link text-white" id="signOutBtn" href="#">Sign Out</a>';
        userButton.innerHTML = '<a class="nav-link" href="#">' + user + '</a>';
        
        signOutButton.querySelector('#signOutBtn').addEventListener('click', function () {

            localStorage.removeItem("isLoggedIn");
            localStorage.removeItem("user");
            window.location.href = "login.html";
        });

        var navbar = document.querySelector('.navbar-nav');
        navbar.replaceChild(userButton, signInButton);
        navbar.replaceChild(signOutButton, signUpButton);
    } else {
        // If not logged in, display the "Sign In" and "Sign Up" buttons
        signInButton.style.display = 'block';
        signUpButton.style.display = 'block';
    }
});

function showAnimalContent(animalType) {
    window.location.href = "animals.html?animal=" + animalType;
}
