class AddMethodsToDeals < ActiveRecord::Migration
  def change
    add_reference :deals, :selling_method, index: true, foreign_key: true
    add_reference :deals, :exchange_method, index: true, foreign_key: true
    add_reference :deals, :payment_method, index: true, foreign_key: true
  end
end
