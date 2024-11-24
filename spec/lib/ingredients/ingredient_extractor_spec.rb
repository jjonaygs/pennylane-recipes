require 'rails_helper'

RSpec.describe Ingredients::IngredientExtractor, type: :model do
  describe '#extract' do
    context 'when ingredients are provided' do
      let(:ingredients) do
        [
          '1 cup flour',
          '2 teaspoons sugar',
          '¼ teaspoon salt',
          '⅔ cup milk',
          '3/4 cup butter',
          '1 package yeast',
          '1 pepper'
        ]
      end

      let(:expected_output) do
        [
          { quantity: '1', unit: 'cup', name: 'Flour' },
          { quantity: '2', unit: 'teaspoons', name: 'Sugar' },
          { quantity: '¼', unit: 'teaspoon', name: 'Salt' },
          { quantity: '⅔', unit: 'cup', name: 'Milk' },
          { quantity: '3/4', unit: 'cup', name: 'Butter' },
          { quantity: '1', unit: 'package', name: 'Yeast' },
          { quantity: '1', unit: nil, name: 'Pepper' }
        ]
      end

      it 'parses the ingredients correctly' do
        extractor = described_class.new(ingredients)
        result = extractor.extract
        expect(result).to eq(expected_output)
      end
    end

    context 'when an ingredient cannot be parsed' do
      let(:ingredients) { [ '' ] }

      it 'logs a warning and returns nil for unparsed ingredients' do
        expect(Rails.logger).to receive(:warn).with('Ingredient string could not be parsed: ')
        extractor = described_class.new(ingredients)
        result = extractor.extract
        expect(result).to eq([ nil ])
      end
    end

    context 'when no ingredients are provided' do
      it 'returns an empty array when ingredients are nil' do
        extractor = described_class.new(nil)
        expect(extractor.extract).to eq([])
      end

      it 'returns an empty array when ingredients are an empty array' do
        extractor = described_class.new([])
        expect(extractor.extract).to eq([])
      end
    end

    context 'edge cases' do
      it 'handles ingredients with no quantity or unit' do
        ingredients = [ 'salt' ]
        extractor = described_class.new(ingredients)
        result = extractor.extract
        expect(result).to eq([ { quantity: nil, unit: nil, name: 'Salt' } ])
      end

      it 'handles fractional quantities' do
        ingredients = [ '1 1/2 cups milk', '3/4 cup sugar' ]
        expected_output = [
          { quantity: '1 1/2', unit: 'cups', name: 'Milk' },
          { quantity: '3/4', unit: 'cup', name: 'Sugar' }
        ]
        extractor = described_class.new(ingredients)
        expect(extractor.extract).to eq(expected_output)
      end
    end
  end
end
