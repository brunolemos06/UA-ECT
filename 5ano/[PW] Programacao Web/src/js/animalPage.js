
// Store the original modal content
var originalModalContent = document.getElementById('originalModalContent').innerHTML;

// Function to convert animal age to human age
function convertAnimalAge() {

    var animalAge = document.getElementById('animalAgeInput').value;

    // Convert animal age based on the type
    var convertedAge;
    var animalType = document.getElementById('animalType').value;
    switch (animalType) {
        case 'dog':
            convertedAge = animalAge * 6;
            break;
        case 'cat':
            convertedAge = animalAge * 6;
            break;
        case 'bird':
            convertedAge = animalAge * 5.3;
            break;
        case 'horse':
            convertedAge = animalAge * 6.5;
            break;
        default:
            convertedAge = 'Invalid animal type';
    }

    // Update the modal content
    var modalBody = document.getElementById('myModal2').getElementsByClassName('modal-body')[0];
    modalBody.innerHTML = 'Converted age: ' + convertedAge.toFixed(1) + ' human years';
}

// Function to reset the modal content
function resetModal() {
    var modalBody = document.getElementById('myModal2').getElementsByClassName('modal-body')[0];

    // Restore the original modal content
    modalBody.innerHTML = originalModalContent;

    // Clear input fields
    document.getElementById('animalAgeInput').value = '';
    document.getElementById('animalType').value = 'dog';
}

// Function to create HTML elements for the carousel
function createCarouselItem(imageSrc, altText) {
    const carouselItem = document.createElement("div");
    carouselItem.className = "carousel-item";

    const image = document.createElement("img");
    image.src = imageSrc;
    image.className = "d-block w-100";
    image.alt = altText;

    carouselItem.appendChild(image);

    return carouselItem;
}

// Function to populate the animal information section
function populateAnimalSection(animal) {
    console.log(animal);
    // Update carousel
    const carouselInner = document.querySelector("#imageCarousel .carousel-inner");
    carouselInner.innerHTML = ""; // Clear existing content

    animal.images.forEach((image, index) => {
        const carouselItem = createCarouselItem(image, `Image ${index + 1}`);
        if (index === 0) {
            carouselItem.classList.add("active");
        }
        carouselInner.appendChild(carouselItem);
    });

    // Update animal description table
    const animalName = document.querySelector(".animalcard h3");
    const scientificName = document.getElementById("scientificName");
    const habitat = document.getElementById("habitat");
    const diet = document.getElementById("diet");
    const lifespan = document.getElementById("lifespan");
    const audioElement = document.getElementById("animalSound");
    const habitatDescription = document.getElementById("habitatDescription");
    const dietDescription = document.getElementById("dietDescription");
    const lifespanDescription = document.getElementById("lifespanDescription");
    const scientificNameDescription = document.getElementById("scientificNameDescription");

    animalName.innerText = animal.name;

    // Check if the properties exist in the JSON before updating the table
    if ("scientificName" in animal) {
        scientificName.innerText = animal.scientificName;
    }
    if ("habitat" in animal) {
        habitat.innerText = animal.habitat;
    }
    if ("diet" in animal) {
        diet.innerText = animal.diet;
    }
    if ("lifespan" in animal) {
        lifespan.innerText = animal.lifespan;
    }
    if ("audio" in animal) {
        audioElement.src = animal.audio;
    }

    // Check if the additional information exists in the JSON before updating the table
    if ("additionalInformation" in animal) {
        scientificNameDescription.innerText = animal.additionalInformation.ScientificNameDescription || "";
        habitatDescription.innerText = animal.additionalInformation.HabitatDescription || "";
        dietDescription.innerText = animal.additionalInformation.DietDescription || "";
        lifespanDescription.innerText = animal.additionalInformation.LifespanDescription || "";
    }

    // Update modal
    const modalBody = document.querySelector(".modal-body");

    if ("additionalInformation" in animal) {
        modalBody.innerText = animal.additionalInformation.AdditionalDescription || "";
    }

    // Update comments section
    const commentSection = document.querySelector(".comment-section table");

    // Check if the table has a tbody, if not create one
    let commentTbody = commentSection.querySelector("tbody");
    if (!commentTbody) {
        commentTbody = document.createElement("tbody");
        commentSection.appendChild(commentTbody);
    }

    // Assume 'animal' is your object with comments
    const commentsTable = document.querySelector(".table.table-bordered.shadow-sm.animalcard");
    const commentsArray = animal.comments;

    commentsArray.forEach((comment, index) => {
        const commentRow = createCommentRow(index + 1, comment.user, comment.text);
        commentTbody.insertBefore(commentRow, commentTbody.firstChild);
    });

    const userCommentRow = document.getElementById("userComment");
    const userCommentAvatar = document.getElementById("userCommentAvatar");
    const userCommentText = document.getElementById("userCommentText");
    const commentTextArea = document.getElementById("commentTextArea");
    const submitCommentBtn = document.getElementById("submitCommentBtn");

    if ("comments" in animal) {
        const userCommentIndex = animal.comments.length + 1;

        userCommentRow.id = `comment${userCommentIndex}`;
        userCommentAvatar.id = `comment${userCommentIndex}Avatar`;
        userCommentText.id = `comment${userCommentIndex}Text`;
        commentTextArea.id = `commentTextArea${userCommentIndex}`;
        submitCommentBtn.id = `submitCommentBtn${userCommentIndex}`;
    }

    submitCommentBtn.addEventListener("click", function () {
        const userCommentTextValue = commentTextArea.value;
        if (!userCommentTextValue) {
            return;
        }   
        animal.comments.push({
            user: "User", // You might want to get the actual user info
            text: userCommentTextValue,
        });

        const newCommentIndex = animal.comments.length;
        const commentRow = createCommentRow(newCommentIndex, "User", userCommentTextValue);

        // Insert the new comment row at the beginning of the tbody
        if (commentTbody.firstChild) {
            commentTbody.insertBefore(commentRow, commentTbody.firstChild);
        } else {
            commentTbody.appendChild(commentRow);
        }

        commentTextArea.value = "";
    });

    function createCommentRow(index, user, text) {
        const commentRow = document.createElement("tr");
        const avatarCell = document.createElement("th");
        const textCell = document.createElement("td");

        commentRow.id = `comment${index}`;
        avatarCell.id = `comment${index}Avatar`;
        textCell.id = `comment${index}Text`;

        const avatarImage = document.createElement("img");
        avatarImage.src = "images/user.png";
        avatarImage.alt = user;
        avatarImage.classList.add("user-avatar");

        avatarCell.appendChild(avatarImage);
        textCell.innerText = text;

        commentRow.appendChild(avatarCell);
        commentRow.appendChild(textCell);

        return commentRow;
    }
}

// Function to fetch the JSON data from a file
async function fetchData(animalName) {
    try {
        const response = await fetch('json/animals.json'); // Update the path to the correct file
        const data = await response.json();
        const selectedAnimal = data.animals.find(animal => animal.name === animalName);
        populateAnimalSection(selectedAnimal);
    } catch (error) {
        console.error('Error fetching data:', error);
    }
}

// Function to get the value of a query parameter from the URL
function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
}

// Get the animal name from the URL query parameter
const animalNameFromUrl = getQueryParam('animal');

// Call the fetchData function with the animal name from the URL
if (animalNameFromUrl) {
    fetchData(animalNameFromUrl);
} else {
    console.error('Animal name not provided in the URL.');
}

function showAnimalContent(animalType) {
    window.location.href = "animals.html?animal=" + animalType;
}
