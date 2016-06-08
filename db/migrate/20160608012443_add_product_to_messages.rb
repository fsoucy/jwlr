class AddProductToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :product, index: true, foreign_key: true
  end
end
