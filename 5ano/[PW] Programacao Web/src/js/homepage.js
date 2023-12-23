
//questions list effect
document.addEventListener("DOMContentLoaded", function () {
    // Function to handle the intersection for list items
    function handleListIntersection(entries, observer) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // If the list item is visible, add the 'show' class to trigger the entrance animation
                entry.target.classList.add('show');
            }
        });
    }

    var listItems = document.querySelectorAll('.question-list li');

    // For when the list items are visible
    var listObserver = new IntersectionObserver(handleListIntersection, { threshold: 0.5 });

    listItems.forEach(item => listObserver.observe(item));
});


//about section effect
document.addEventListener("DOMContentLoaded", function () {
    // Function to handle the intersection
    function handleIntersection(entries, observer) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // If the section is visible, add the 'show' class to trigger the entrance animation
                aboutContent.classList.add('show');
                aboutImage.classList.add('show');
                observer.disconnect();
            }
        });
    }

    var aboutContent = document.querySelector('.about-content');
    var aboutImage = document.querySelector('.about-image');

    // For when the about section is visible
    var observer = new IntersectionObserver(handleIntersection, { threshold: 0.5 });

    observer.observe(document.getElementById('about'));
});


function showAnimalContent(animalType) {
    window.location.href = "animals.html?animal=" + animalType;
}


