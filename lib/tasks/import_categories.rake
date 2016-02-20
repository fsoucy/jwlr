require 'csv'
namespace :import_categories do
  task :create_categories => :environment do
    csv_text = File.read("categories.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Category.create!(row.to_hash)
    end  
  end
  
  task :create_category_options => :environment do
    csv_text = File.read("category_options.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      CategoryOption.create!(row.to_hash)
    end
  end

  task :create_attribute_options => :environment do
    csv_text = File.read("attribute_options.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      AttributeOption.create!(row.to_hash)
    end
  end

end 
