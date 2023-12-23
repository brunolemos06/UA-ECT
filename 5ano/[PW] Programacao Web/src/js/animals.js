  // Function to create an animal card
  function createAnimalCard(animal) {
    const col = document.createElement("div");
    col.classList.add("col");

    const cardLink = document.createElement("a");
    //cardLink.href = "animalPage" + animal.name.toUpperCase() + ".html";
    cardLink.href = "animalPage.html?animal=" + encodeURIComponent(animal.name);
    cardLink.classList.add("text-decoration-none");

    const card = document.createElement("div");
    card.classList.add("card", "animalcard", "shadow-lg");

    const img = document.createElement("img");
    img.src = animal.images[1];
    img.alt = animal.name;
    img.classList.add("card-img-top");
    img.height = 270;

    const cardBody = document.createElement("div");
    cardBody.classList.add("card-body");

    const title = document.createElement("h5");
    title.classList.add("card-title");
    title.textContent = animal.name;

    const description = document.createElement("p");
    description.classList.add("card-text");
    description.textContent = animal.description;

    // Append elements to build the card structure
    cardBody.appendChild(title);
    cardBody.appendChild(description);

    card.appendChild(img);
    card.appendChild(cardBody);

    cardLink.appendChild(card);
    col.appendChild(cardLink);

    return col;
  }

  

document.addEventListener("DOMContentLoaded", function () {

    // get the argument from the URL
    // window.location.href = "animals.html?animal=" + animalType;
    const urlParams = new URLSearchParams(window.location.search);
    const animalType = urlParams.get("animal");
    
    // != null
    // dog, cat, bird, horse, all
    if (animalType == "all" || animalType == "cat" || animalType == "dog" || animalType == "bird" || animalType == "horse") {
      if( animalType != null)  
      document.getElementById("animal-filter").value = animalType;
    }
    
    console.log("animalType: " + animalType);
    // if the argument is null, then show all animals
    


    // Fetch animals data from animals.json
    fetch("json/animals.json")
      .then(response => response.json())
      .then(data => {
        // Select the container where cards will be appended
        const container = document.querySelector(".row-cols-1.row-cols-md-2.row-cols-lg-3.g-4");
  

        // Iterate through each animal and create a card if animal-filter == 
        data.animals.forEach(animal => {
          // if(animalFilter == animal.type || animalFilter == "all"){
            if (animalType == animal.type || animalType == "all" || animalType == null) {                 
              const card = createAnimalCard(animal);
              container.appendChild(card);
            }

          // }
        });
      })
      .catch(error => console.error("Error fetching animals:", error));
  });
  
// when  <select class="form-control mt-2" id="animal-filter"> is changed call the function
document.getElementById("animal-filter").addEventListener("change", function () {
  // get the animal-trilter id 
  const animalFilter = document.getElementById("animal-filter").value;
  // print the animal-filter value
  console.log(animalFilter);
  // Select the container where cards will be appended
  const container = document.querySelector(".row-cols-1.row-cols-md-2.row-cols-lg-3.g-4");
  // remove all the cards from the container
  container.innerHTML = "";
  // Fetch animals data from animals.json
  fetch("json/animals.json")
      .then(response => response.json())
      .then(data => {
          // Iterate through each animal and create a card if animal-filter == 
          data.animals.forEach(animal => {
              if (animalFilter == animal.type || animalFilter == "all") {                  
                  const card = createAnimalCard(animal);
                  container.appendChild(card);
              }
          });
      })
      .catch(error => console.error("Error fetching animals:", error));
});


document.getElementById("searchInput").addEventListener("input", function() {
  var content = document.getElementById("searchInput").value;
  const container = document.querySelector(".row-cols-1.row-cols-md-2.row-cols-lg-3.g-4");
  const animalFilter = document.getElementById("animal-filter").value;
  // remove all the cards from the container
  container.innerHTML = "";
  fetch("json/animals.json")
  .then(response => response.json())
  .then(data => {
      // Iterate through each animal and create a card if animal-filter == 
      data.animals.forEach(animal => {
        if (animal.description.toLowerCase().includes(content.toLowerCase()) || 
            animal.name.toLowerCase().includes(content.toLowerCase())) {
              if (animalFilter == animal.type || animalFilter == "all") {               
                const card = createAnimalCard(animal);
                container.appendChild(card);
              }
        }
        
      });
  })
  .catch(error => console.error("Error fetching animals:", error));

});


function showAnimalContent(animalType) {
  window.location.href = "animals.html?animal=" + animalType;
}
