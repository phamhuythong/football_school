# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :code
      t.integer :account_id, null: true
      t.string :first_name, null: false
      t.string :last_name
      t.string :middle_name
      t.datetime :date_of_birth
      t.string :gender
      t.string :phone
      t.string :type
      t.integer :lock_version, default: 0
      t.boolean :deleted, default: false
      t.string :address
      t.string :email
      t.string :mother_name
      t.string :mother_phone
      t.string :father_name
      t.string :father_phone
      t.index :account_id

      t.timestamps
    end

    add_foreign_key :users, :accounts, column: :account_id
  end
end
