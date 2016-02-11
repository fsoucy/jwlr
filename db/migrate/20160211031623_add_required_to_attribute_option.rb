class AddRequiredToAttributeOption < ActiveRecord::Migration
  def change
    add_column :category_options, :required, :boolean, :default => false
  end
end
