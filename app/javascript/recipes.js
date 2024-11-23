document.addEventListener('DOMContentLoaded', () => {
    const ingredientInput = document.getElementById('ingredient-input');
    const ingredientTagsContainer = document.getElementById('ingredient-tags');
    const ingredientNamesField = document.getElementById('ingredient_names_field');
    const filterRecipesForm = document.getElementById('ingredient-filter-form');
    const filterRecipesBtn = document.getElementById('filter-recipes-btn');

    // Función para crear un tag de ingrediente
    function createTag(ingredient) {
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
    }

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

    // Opcional: Enviar el formulario también cuando se presiona Enter en el formulario
    filterRecipesForm.addEventListener('keypress', (event) => {
        if (event.key === 'Enter') {
            event.preventDefault(); // Prevenir el comportamiento predeterminado
            filterRecipesForm.requestSubmit(); // Esto enviará el formulario de manera remota
        }
    });

    // Cargar los tags desde la URL después de que se cargue el contenido
    function loadTagsFromUrl() {
        const urlParams = new URLSearchParams(window.location.search);
        const ingredientNames = urlParams.get('ingredient_names');

        if (ingredientNames) {
            const ingredients = ingredientNames.split(',');

            // Crear los tags para los ingredientes recuperados de la URL
            ingredients.forEach(ingredient => {
                createTag(ingredient.trim());
            });
        }
    }

    // Inicialización de los listeners
    function initialize() {
        loadTagsFromUrl(); // Volver a cargar los tags desde la URL
        toggleSearchButtonState(); // Asegurarse de que el botón esté correctamente habilitado o deshabilitado
    }

    // Reconfigurar los listeners después de que se recargue el contenido con Turbo
    document.addEventListener('turbo:load', () => {
        initialize(); // Reconfigurar los listeners y cargar los tags de la URL
    });

    // Inicializar en la carga inicial
    initialize();
});
