// Function to toggle university information visibility
function toggleUniversityInfo() {
    var universityInfo = document.getElementById('universityInfo');
    if (universityInfo.style.display === 'none' || universityInfo.style.display === '') {
        universityInfo.style.display = 'block';
    } else {
        universityInfo.style.display = 'none';
    }
}

// Function to toggle department information visibility
function toggleDepartmentInfo() {
    var departmentInfo = document.getElementById('departmentInfo');
    if (departmentInfo.style.display === 'none' || departmentInfo.style.display === '') {
        departmentInfo.style.display = 'block';
    } else {
        departmentInfo.style.display = 'none';
    }
}

document.addEventListener('DOMContentLoaded', function () {
    // Function to fill HTML container with user information
    function fillUserInformation(users) {
        var container = document.getElementById('userInformationContainer');

        // Specify the emails of the users to be displayed
        var selectedUserEmails = ["ricardo@ua.pt", "bruno@ua.pt", "tiago@ua.pt"];

        // Filter users 
        var selectedUsers = users.filter(function (user) {
            return selectedUserEmails.includes(user.email);
        });

        selectedUsers.forEach(function (user) {
            // Create a new div element for each user
            var userDiv = document.createElement('div');
            userDiv.className = 'col-md-3 p-4 border border-1 rounded-5 shadow-lg my-4 contact-content';
            userDiv.style.backgroundColor = 'var(--bs-gray-400)';

            // Create HTML content for the user
            userDiv.innerHTML = `
                <img src="images/${user.email.split('@')[0]}.jpeg" alt="${user.email}" class="img-fluid rounded-circle" width="200" height="200">
                <hr/>
                <h4>${user.email.split('@')[0]}</h4>
                <p>Position: ${user.position}</p>
                <p>Email: ${user.email}</p>
                <p>Phone: ${user.phone}</p>
            `;

            // Append the userDiv to the container
            container.appendChild(userDiv);
        });
    }

    // Fetch user data from the JSON file
    fetch("json/users.json")
        .then(response => response.json())
        .then(data => {
            fillUserInformation(data.users);
        })
        .catch(error => console.error('Error fetching user data:', error));
});

function showAnimalContent(animalType) {
    window.location.href = "animals.html?animal=" + animalType;
}
