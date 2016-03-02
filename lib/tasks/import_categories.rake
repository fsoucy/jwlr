require 'csv'
namespace :import_categories do
  task :create_categories => :environment do
    csv_text = File.read("categories.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Category.create!(row.to_hash) unless !Category.find_by(id: row.to_hash["id"]).nil?
    end  
  end
  
  task :create_category_options => :environment do
    csv_text = File.read("category_options.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      CategoryOption.create!(row.to_hash) unless !CategoryOption.find_by(id: row.to_hash["id"]).nil?
    end
  end

  task :create_attribute_options => :environment do
    csv_text = File.read("attribute_options.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      AttributeOption.create!(row.to_hash) unless !AttributeOption.find_by(id: row.to_hash["id"]).nil?
    end
  end

  task :create_selling_methods => :environment do
    csv_text = File.read("sellingmethods.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      SellingMethod.create!(row.to_hash) unless !SellingMethod.find_by(id: row.to_hash["id"]).nil?
    end
  end

  task :create_exchange_methods => :environment do
    csv_text = File.read("exchangemethods.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      ExchangeMethod.create!(row.to_hash) unless !ExchangeMethod.find_by(id: row.to_hash["id"]).nil?
    end
  end

  task :create_payment_methods => :environment do
    csv_text = File.read("paymentmethods.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      PaymentMethod.create!(row.to_hash) unless !PaymentMethod.find_by(id: row.to_hash["id"]).nil?
    end
  end

end 
