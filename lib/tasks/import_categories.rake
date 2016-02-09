require 'csv'
namespace :import_categories do
  task :create_categories => :environment do
    csv_text = File.read("categories.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Category.create!(row.to_hash)
    end  
  end
end 
