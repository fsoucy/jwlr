class CreateDefaultExchangeMethodLinks < ActiveRecord::Migration
  def change
    create_table :default_exchange_method_links do |t|

      t.timestamps null: false
    end
  end
end
