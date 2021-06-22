# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :email, unique: true
      t.string :username, unique: true
      t.string :password_digest
      t.string :remember_digest
      t.string :activation_digest
      t.boolean :activated
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.string :status, default: 'active'
      t.integer :lock_version, default: 0
      t.text :avatar_data
      t.index :email
      t.index :username
      t.index :password_digest

      t.timestamps
    end
  end
end
