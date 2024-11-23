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
        });

        // Agregar la X al tag
        tag.appendChild(closeButton);

        // Agregar el tag al contenedor de tags
        ingredientTagsContainer.appendChild(tag);

        // Actualizar el campo oculto de nombres de ingredientes
        updateIngredientNamesField();
    }

    // Función para actualizar el campo oculto con los ingredientes
    function updateIngredientNamesField() {
        const tags = Array.from(ingredientTagsContainer.querySelectorAll('.ingredient-tag'));
        const ingredients = tags.map(tag => tag.textContent.replace('×', '').trim());
        ingredientNamesField.value = ingredients.join(',');
    }

    // Detectar la tecla Enter para agregar ingredientes como tags
    ingredientInput.addEventListener('keypress', (event) => {
        if (event.key === 'Enter' && ingredientInput.value.trim() !== '') {
            createTag(ingredientInput.value.trim());
            ingredientInput.value = ''; // Limpiar el campo de texto después de agregar
        }
    });

    // Enviar el formulario de filtro cuando se hace clic en el botón
    filterRecipesBtn.addEventListener('click', (event) => {
        event.preventDefault(); // Prevenir el comportamiento predeterminado
        filterRecipesForm.requestSubmit(); // Esto enviará el formulario de manera remota
    });
});
