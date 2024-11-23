document.addEventListener('turbo:load', () => {
    const ingredientInput = document.getElementById('ingredient-input');
    const ingredientTagsContainer = document.getElementById('ingredient-tags');
    const ingredientNamesField = document.getElementById('ingredient_names_field');
    const filterRecipesForm = document.getElementById('ingredient-filter-form');
    const filterRecipesBtn = document.getElementById('filter-recipes-btn');
    const ingredientSuggestionsContainer = document.getElementById('ingredient-suggestions');

    // Verificar que los elementos existen en el DOM antes de agregar los listeners
    if (!ingredientInput || !ingredientTagsContainer || !ingredientNamesField || !filterRecipesForm || !filterRecipesBtn) {
        console.error('Required elements not found in the DOM');
        return;
    }

    // Función para crear un tag de ingrediente
    function createTag(ingredient) {
        console.log(`Creating tag for: ${ingredient}`);
        // Verificar si el tag ya existe antes de crearlo
        const existingTag = Array.from(ingredientTagsContainer.querySelectorAll('.ingredient-tag'))
            .find(tag => tag.textContent.replace('×', '').trim() === ingredient.trim());

        if (existingTag) {
            console.log('Tag already exists');
            return; // Si el tag ya existe, no agregarlo de nuevo
        }

        const tag = document.createElement('div');
        tag.classList.add('ingredient-tag'); // Clase para los tags con fondo gris y bordes

        tag.textContent = ingredient;

        // Crear el botón de cierre (X)
        const closeButton = document.createElement('span');
        closeButton.classList.add('close-btn'); // Clase para la "X" pequeña
        closeButton.textContent = '×';

        // Eliminar el tag cuando se hace clic en la "X"
        closeButton.addEventListener('click', function() {
            tag.remove();
            updateIngredientNamesField();
            toggleSearchButtonState(); // Actualizar estado del botón de búsqueda
        });

        // Agregar la X al tag
        tag.appendChild(closeButton);

        // Agregar el tag al contenedor de tags
        ingredientTagsContainer.appendChild(tag);

        // Actualizar el campo oculto de nombres de ingredientes
        updateIngredientNamesField();

        // Actualizar el estado del botón de búsqueda
        toggleSearchButtonState();
    }

    // Función para actualizar el campo oculto con los ingredientes
    function updateIngredientNamesField() {
        const tags = Array.from(ingredientTagsContainer.querySelectorAll('.ingredient-tag'));
        const ingredients = tags.map(tag => tag.textContent.replace('×', '').trim());
        ingredientNamesField.value = ingredients.join(',');
    }

    // Función para habilitar o deshabilitar el botón de búsqueda
    function toggleSearchButtonState() {
        const tags = ingredientTagsContainer.querySelectorAll('.ingredient-tag');
        const isDisabled = tags.length === 0;  // Si no hay tags, el botón se desactiva
        filterRecipesBtn.disabled = isDisabled; // Habilitar o deshabilitar el botón según el número de tags

        // Asegurarnos de que los estilos visuales se actualicen (por ejemplo, con un cambio de opacidad o color)
        if (isDisabled) {
            filterRecipesBtn.classList.add('disabled');  // Asegurarse de agregar clase de estilo (si no se aplica el estilo)
        } else {
            filterRecipesBtn.classList.remove('disabled');
        }
    }

    // Función para mostrar las sugerencias de ingredientes
    function showIngredientSuggestions(query) {
        console.log(`Searching for: ${query}`);
        // Limpiar las sugerencias anteriores
        ingredientSuggestionsContainer.innerHTML = '';

        // Si el query tiene menos de 3 caracteres, no hacer nada
        if (query.length < 3) {
            ingredientSuggestionsContainer.style.display = 'none';
            return;
        }

        // Realizar la búsqueda de ingredientes a través de una solicitud fetch
        fetch(`/ingredients/search?q=${query}`)
            .then(response => response.json())
            .then(data => {
                if (data && Array.isArray(data.items)) {
                    const filteredIngredients = data.items;

                    // Si hay sugerencias, mostrarlas
                    if (filteredIngredients.length > 0) {
                        ingredientSuggestionsContainer.style.display = 'block'; // Asegurarse de mostrar el contenedor
                        filteredIngredients.forEach(ingredient => {
                            const suggestionItem = document.createElement('div');
                            suggestionItem.classList.add('suggestion-item');
                            suggestionItem.textContent = ingredient;

                            // Agregar el ingrediente como tag al hacer clic en él
                            suggestionItem.addEventListener('click', () => {
                                createTag(ingredient);
                                ingredientInput.value = '';  // Limpiar el campo de entrada
                                ingredientSuggestionsContainer.style.display = 'none';  // Ocultar las sugerencias
                            });

                            ingredientSuggestionsContainer.appendChild(suggestionItem);
                        });
                    } else {
                        ingredientSuggestionsContainer.style.display = 'none';  // Si no hay resultados, ocultar las sugerencias
                    }
                } else {
                    ingredientSuggestionsContainer.style.display = 'none';  // Si no se recibe un formato esperado, ocultar las sugerencias
                    console.error('No se encontraron ingredientes en la respuesta o la respuesta no tiene el formato esperado.');
                }
            })
            .catch(error => {
                console.error('Error fetching ingredients:', error);
                ingredientSuggestionsContainer.style.display = 'none'; // Ocultar las sugerencias si ocurre un error
            });
    }

    // Detectar la entrada de texto para mostrar sugerencias
    ingredientInput.addEventListener('input', (event) => {
        const query = event.target.value.trim();
        showIngredientSuggestions(query);
    });

    // Detectar la tecla Enter para agregar ingredientes como tags
    ingredientInput.addEventListener('keypress', (event) => {
        if (event.key === 'Enter' && ingredientInput.value.trim() !== '') {
            createTag(ingredientInput.value.trim());
            ingredientInput.value = ''; // Limpiar el campo de texto después de agregar
            event.preventDefault(); // Prevenir el envío del formulario al presionar Enter
        }
    });

    // Enviar el formulario de filtro cuando se hace clic en el botón
    filterRecipesBtn.addEventListener('click', (event) => {
        event.preventDefault(); // Prevenir el comportamiento predeterminado
        filterRecipesForm.requestSubmit(); // Esto enviará el formulario de manera remota
    });

    // Cargar los tags desde la URL después de que se cargue el contenido
    function loadTagsFromUrl() {
        const urlParams = new URLSearchParams(window.location.search);
        const ingredientNames = urlParams.get('ingredient_names');

        if (ingredientNames) {
            const ingredients = ingredientNames.split(',');

            // Limpiar los tags existentes antes de agregar los nuevos
            ingredientTagsContainer.innerHTML = ''; // Esto eliminará los tags previos

            console.log('Loading tags from URL: ', ingredients);

            // Crear los tags para los ingredientes recuperados de la URL
            ingredients.forEach(ingredient => {
                createTag(ingredient.trim());
            });
        }
    }

    initialize();

    // Inicialización de los listeners
    function initialize() {
        console.log('init')
        loadTagsFromUrl(); // Volver a cargar los tags desde la URL
        toggleSearchButtonState(); // Asegurarse de que el botón esté correctamente habilitado o deshabilitado
    }

});
