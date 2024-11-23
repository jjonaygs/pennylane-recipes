document.addEventListener('turbo:load', () => {
    const ingredientInput = document.getElementById('ingredient-input');
    const ingredientTagsContainer = document.getElementById('ingredient-tags');
    const ingredientNamesField = document.getElementById('ingredient_names_field');
    const filterRecipesForm = document.getElementById('ingredient-filter-form');
    const filterRecipesBtn = document.getElementById('filter-recipes-btn');
    const ingredientSuggestionsContainer = document.getElementById('ingredient-suggestions');

    // Verify that the elements exist in the DOM before adding listeners
    if (!ingredientInput || !ingredientTagsContainer || !ingredientNamesField || !filterRecipesForm || !filterRecipesBtn) {
        console.error('Required elements not found in the DOM');
        return;
    }

    // Function to create an ingredient tag
    function createTag(ingredient) {
        console.log(`Creating tag for: ${ingredient}`);
        // Check if the tag already exists before creating it
        const existingTag = Array.from(ingredientTagsContainer.querySelectorAll('.ingredient-tag'))
            .find(tag => tag.textContent.replace('×', '').trim() === ingredient.trim());

        if (existingTag) {
            console.log('Tag already exists');
            return; // If the tag already exists, do not add it again
        }

        const tag = document.createElement('div');
        tag.classList.add('ingredient-tag'); // Class for tags with gray background and borders

        tag.textContent = ingredient;

        // Create the close button (X)
        const closeButton = document.createElement('span');
        closeButton.classList.add('close-btn'); // Class for the small "X"
        closeButton.textContent = '×';

        // Remove the tag when the "X" is clicked
        closeButton.addEventListener('click', function() {
            tag.remove();
            updateIngredientNamesField();
            toggleSearchButtonState(); // Update the search button state
            highlightIngredientsInRecipes(); // Update the highlighted ingredients
        });

        // Add the "X" to the tag
        tag.appendChild(closeButton);

        // Add the tag to the tags container
        ingredientTagsContainer.appendChild(tag);

        // Update the hidden ingredient names field
        updateIngredientNamesField();

        // Update the search button state
        toggleSearchButtonState();

        // Update the highlighted ingredients
        highlightIngredientsInRecipes();
    }

    // Function to update the hidden field with ingredients
    function updateIngredientNamesField() {
        const tags = Array.from(ingredientTagsContainer.querySelectorAll('.ingredient-tag'));
        const ingredients = tags.map(tag => tag.textContent.replace('×', '').trim());
        ingredientNamesField.value = ingredients.join(',');
    }

    // Function to enable or disable the search button
    function toggleSearchButtonState() {
        const tags = ingredientTagsContainer.querySelectorAll('.ingredient-tag');
        const isDisabled = tags.length === 0;  // If there are no tags, disable the button
        filterRecipesBtn.disabled = isDisabled; // Enable or disable the button based on the number of tags

        // Ensure visual styles are updated (e.g., with a change in opacity or color)
        if (isDisabled) {
            filterRecipesBtn.classList.add('disabled');  // Make sure to add the disabled style class (if not already applied)
        } else {
            filterRecipesBtn.classList.remove('disabled');
        }
    }

    // Function to show ingredient suggestions
    function showIngredientSuggestions(query) {
        console.log(`Searching for: ${query}`);
        // Clear previous suggestions
        ingredientSuggestionsContainer.innerHTML = '';

        // If the query is less than 3 characters, do nothing
        if (query.length < 3) {
            ingredientSuggestionsContainer.style.display = 'none';
            return;
        }

        // Perform the ingredient search via a fetch request
        fetch(`/ingredients/search?q=${query}`)
            .then(response => response.json())
            .then(data => {
                if (data && Array.isArray(data.items)) {
                    const filteredIngredients = data.items;

                    // If there are suggestions, show them
                    if (filteredIngredients.length > 0) {
                        ingredientSuggestionsContainer.style.display = 'block'; // Make sure to display the container
                        filteredIngredients.forEach(ingredient => {
                            const suggestionItem = document.createElement('div');
                            suggestionItem.classList.add('suggestion-item');
                            suggestionItem.textContent = ingredient;

                            // Add the ingredient as a tag when clicked
                            suggestionItem.addEventListener('click', () => {
                                createTag(ingredient);
                                ingredientInput.value = '';  // Clear the input field
                                ingredientSuggestionsContainer.style.display = 'none';  // Hide suggestions
                            });

                            ingredientSuggestionsContainer.appendChild(suggestionItem);
                        });
                    } else {
                        ingredientSuggestionsContainer.style.display = 'none';  // If no results, hide suggestions
                    }
                } else {
                    ingredientSuggestionsContainer.style.display = 'none';  // If no valid response format, hide suggestions
                    console.error('No ingredients found in the response or the response is not in the expected format.');
                }
            })
            .catch(error => {
                console.error('Error fetching ingredients:', error);
                ingredientSuggestionsContainer.style.display = 'none'; // Hide suggestions if an error occurs
            });
    }

    // Detect text input to show suggestions
    ingredientInput.addEventListener('input', (event) => {
        const query = event.target.value.trim();
        showIngredientSuggestions(query);
    });

    // Detect the Enter key to add ingredients as tags
    ingredientInput.addEventListener('keypress', (event) => {
        if (event.key === 'Enter' && ingredientInput.value.trim() !== '') {
            createTag(ingredientInput.value.trim());
            ingredientInput.value = ''; // Clear the text field after adding
            event.preventDefault(); // Prevent form submission when pressing Enter
        }
    });

    // Submit the filter form when the button is clicked
    filterRecipesBtn.addEventListener('click', (event) => {
        event.preventDefault(); // Prevent the default behavior
        filterRecipesForm.requestSubmit(); // This will submit the form remotely
    });

    // Load tags from the URL after the content is loaded
    function loadTagsFromUrl() {
        const urlParams = new URLSearchParams(window.location.search);
        const ingredientNames = urlParams.get('ingredient_names');

        if (ingredientNames) {
            const ingredients = ingredientNames.split(',');

            // Clear existing tags before adding new ones
            ingredientTagsContainer.innerHTML = ''; // This will remove previous tags

            console.log('Loading tags from URL: ', ingredients);

            // Create tags for the ingredients retrieved from the URL
            ingredients.forEach(ingredient => {
                createTag(ingredient.trim());
            });
        }
    }

    // Function to highlight ingredients found in recipes
    function highlightIngredientsInRecipes() {
        // Make sure ingredientTagsContainer is correctly assigned
        const ingredientTagsContainer = document.querySelector('.ingredient-tags-container');
    
        // If the container is not found, exit the function
        if (!ingredientTagsContainer) return;
    
        // Get ingredient names from the tags
        const ingredients = Array.from(ingredientTagsContainer.querySelectorAll('.ingredient-tag'))
            .map(tag => tag.textContent.replace('×', '').trim());
    
        // Select all ingredient elements in recipes
        const ingredientElements = document.querySelectorAll('.ingredient-name');
    
        // Loop through each ingredient in the recipes and add or remove the highlighted class
        ingredientElements.forEach(element => {
            if (ingredients.includes(element.textContent.trim())) {
                element.classList.add('highlighted-ingredient');
            } else {
                element.classList.remove('highlighted-ingredient');
            }
        });
    }

    // Detect when new recipes are loaded (infinite scroll)
    const recipesContainer = document.querySelector('#recipes');  // Changed this selector
    if (recipesContainer) {
        const observer = new MutationObserver(() => {
            highlightIngredientsInRecipes(); // Highlight ingredients after new recipes are loaded
        });

        // Start observing the recipes container
        observer.observe(recipesContainer, {
            childList: true,
            subtree: true
        });
    }

    // Load tags from the URL when the page loads
    loadTagsFromUrl();
});
