class AddRequestToProducts < ActiveRecord::Migration
  def change
    add_column :products, :request, :boolean
  end
end
