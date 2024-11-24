require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  let!(:ingredient1) { double("Ingredient", id: 1, name: "Carrot") }
  let!(:ingredient2) { double("Ingredient", id: 2, name: "Potato") }
  let!(:ingredient3) { double("Ingredient", id: 3, name: "Onion") }

  let!(:recipe1) {
 double(
  "Recipe", id: 1, title: "Vegetable Soup", category: "Soup", author: "John Doe", ratings: 5, image: "image_url",
  cuisine: "Global") }
  let!(:recipe2) {
    double("Recipe", id: 2, title: "Carrot Salad", category: "Salad", author: "Jane Doe", ratings: 4, image: "image_url",
    cuisine: "Global") }
  let!(:recipe3) {
     double("Recipe", id: 3, title: "Potato Mash", category: "Side", author: "Alex Doe", ratings: 5, image: "image_url",
     cuisine: "Global") }

  describe "GET #index" do
    context "when ingredient_names param is provided" do
      it "fetches recipes filtered by the provided ingredients and renders the index template" do
        ingredient_names = [ "Carrot", "Potato" ]
        allow(Ingredient).to receive(:where).with(name: ingredient_names).and_return([ ingredient1, ingredient2 ])
        allow(Ingredient).to receive_message_chain(:where, :pluck).with(:id).and_return([ 1, 2 ])

        allow(RecipeService).to receive(:fetch_recipes).with(
          ingredient_ids: [ 1, 2 ],
          page: 1,
          per_page: 10
        ).and_return([ recipe1, recipe2 ])

        get :index, params: { ingredient_names: "Carrot,Potato" }

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:success)
        expect(RecipeService).to have_received(:fetch_recipes).with(
          ingredient_ids: [ 1, 2 ],
          page: 1,
          per_page: 10
        )
      end
    end

    context "when no ingredient_names param is provided" do
      it "fetches all recipes without ingredient filtering and renders the index template" do
        allow(RecipeService).to receive(:fetch_recipes).with(
          ingredient_ids: [],
          page: 1,
          per_page: 10
        ).and_return([ recipe1, recipe2, recipe3 ])

        get :index

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:success)
        expect(RecipeService).to have_received(:fetch_recipes).with(
          ingredient_ids: [],
          page: 1,
          per_page: 10
        )
      end
    end

    context "when pagination parameters are provided" do
      it "paginates the recipes correctly and renders the index template" do
        allow(RecipeService).to receive(:fetch_recipes).with(
          ingredient_ids: [],
          page: 2,
          per_page: 10
        ).and_return([ recipe1, recipe2 ])

        get :index, params: { page: "2", per_page: "10" }

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
