# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.integer :addressable_id
      t.string :addressabe_type
      t.string :country
      t.string :state
      t.string :city
      t.string :ward
      t.string :postal_code
      t.string :address1
      t.string :address2
      t.string :phone
      t.string :fax
      t.integer :lock_version, default: 0
      t.index :addressabe_type
      t.index :addressable_id

      t.timestamps
    end
  end
end
