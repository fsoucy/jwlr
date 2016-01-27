class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.text :question
      t.text :answer
      t.references :store, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
