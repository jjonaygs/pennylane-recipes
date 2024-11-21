namespace :recipes do
  desc "Process recipes JSON file"
  task process_json: :environment do
    file_path = "recipes-en.json"
    json_data = JSON.parse(File.read(file_path), symbolize_names: true)

    json_data.each do |recipe_data|
      Recipes::RecipeProcessor.new(recipe_data).process
    end

    puts "Recipes processed successfully!"
  end
end
