# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :email, null: false, unique: true
      t.string :username, unique: true
      t.string :password_digest
      t.string :remember_digest
      t.string :activation_digest
      t.boolean :activated
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.string :status, default: 'active'
      t.index :email, unique: true
      t.index :password_digest
      t.index :username, unique: true

      t.timestamps
    end
  end
end
