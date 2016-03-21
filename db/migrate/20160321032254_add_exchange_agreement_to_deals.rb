class AddExchangeAgreementToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :exchange_agreement_buyer, :boolean
    add_column :deals, :exchange_agreement_seller, :boolean
  end
end
