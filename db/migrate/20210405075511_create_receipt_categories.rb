class CreateReceiptCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :receipt_categories do |t|
      t.string :name, null: false
      t.decimal :price, default: 0
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
