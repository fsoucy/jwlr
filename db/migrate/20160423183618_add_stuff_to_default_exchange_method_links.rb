class AddStuffToDefaultExchangeMethodLinks < ActiveRecord::Migration
  def change
    add_reference :default_exchange_method_links, :exchange_method, index: true, foreign_key: true
    add_reference :default_exchange_method_links, :user, index: true, foreign_key: true
  end
end
