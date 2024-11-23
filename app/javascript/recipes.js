document.addEventListener('DOMContentLoaded', () => {
    const ingredientInput = document.getElementById('ingredient-input');
    const ingredientTags = document.getElementById('ingredient-tags');
    const ingredientNamesField = document.getElementById('ingredient_names_field');
    const filterRecipesForm = document.getElementById('ingredient-filter-form');
    const filterRecipesBtn = document.getElementById('filter-recipes-btn');

    // Función para crear un tag de ingrediente
    function createTag(ingredient) {
        const tag = document.createElement('span');
        tag.classList.add('badge', 'badge-secondary', 'mr-2', 'mt-2');
        tag.textContent = ingredient;
        const removeBtn = document.createElement('button');
        removeBtn.textContent = 'x';
        removeBtn.classList.add('close', 'ml-2');
        removeBtn.onclick = () => {
            tag.remove();
            updateIngredientNamesField();
        };
        tag.appendChild(removeBtn);
        ingredientTags.appendChild(tag);
        updateIngredientNamesField();
    }

    // Actualiza el campo oculto con los ingredientes
    function updateIngredientNamesField() {
        const tags = Array.from(ingredientTags.querySelectorAll('span'));
        const ingredients = tags.map(tag => tag.textContent.replace('x', '').trim());
        ingredientNamesField.value = ingredients.join(',');
    }

    // Detectar la tecla Enter para agregar ingredientes como tags
    ingredientInput.addEventListener('keypress', (event) => {
        if (event.key === 'Enter' && ingredientInput.value.trim() !== '') {
            createTag(ingredientInput.value.trim());
            ingredientInput.value = '';
        }
    });

    // Enviar el formulario de filtro cuando se haga clic en el botón
    filterRecipesBtn.addEventListener('click', (event) => {
        event.preventDefault(); // Prevenir el comportamiento predeterminado
        filterRecipesForm.requestSubmit(); // Esto enviará el formulario de manera remota
    });
});

