require 'rails_helper'

RSpec.describe RecipeService, type: :service do
  describe '.fetch_recipes' do
    let(:ingredient_ids) { [1, 2, 3] }
    let(:page) { 1 }
    let(:per_page) { 2 }
    let(:recipes_relation) { class_double(Recipe) }
    let(:filtered_recipes) { instance_double(ActiveRecord::Relation) }
    let(:paginated_recipes) { instance_double(ActiveRecord::Relation) }

    before do
      # Mock Recipe.all to return a mock relation
      allow(Recipe).to receive(:all).and_return(recipes_relation)
      allow(recipes_relation).to receive(:by_matched_ingredients).and_return(filtered_recipes)
      allow(filtered_recipes).to receive(:paginate).and_return(paginated_recipes)
      allow(recipes_relation).to receive(:paginate).and_return(paginated_recipes) # For the case without filtering
    end

    context 'when ingredient_ids are present' do
      it 'filters recipes by matched ingredients and paginates the result' do
        result = described_class.fetch_recipes(ingredient_ids: ingredient_ids, page: page, per_page: per_page)

        expect(Recipe).to have_received(:all)
        expect(recipes_relation).to have_received(:by_matched_ingredients).with(ingredient_ids)
        expect(filtered_recipes).to have_received(:paginate).with(page: page, per_page: per_page)
        expect(result).to eq(paginated_recipes)
      end
    end

    context 'when ingredient_ids are empty' do
      let(:ingredient_ids) { [] }

      it 'does not filter recipes and only paginates' do
        result = described_class.fetch_recipes(ingredient_ids: ingredient_ids, page: page, per_page: per_page)

        expect(Recipe).to have_received(:all)
        expect(recipes_relation).not_to have_received(:by_matched_ingredients)
        expect(recipes_relation).to have_received(:paginate).with(page: page, per_page: per_page)
        expect(result).to eq(paginated_recipes)
      end
    end

    context 'when ingredient_ids are nil' do
      let(:ingredient_ids) { nil }

      it 'does not filter recipes and only paginates' do
        result = described_class.fetch_recipes(ingredient_ids: ingredient_ids, page: page, per_page: per_page)

        expect(Recipe).to have_received(:all)
        expect(recipes_relation).not_to have_received(:by_matched_ingredients)
        expect(recipes_relation).to have_received(:paginate).with(page: page, per_page: per_page)
        expect(result).to eq(paginated_recipes)
      end
    end
  end
end
