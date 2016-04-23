class CreateDefaultPaymentMethodLinks < ActiveRecord::Migration
  def change
    create_table :default_payment_method_links do |t|
      t.references :payment_method, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
