# frozen_string_literal: true

class CreateStadia < ActiveRecord::Migration[6.0]
  def change
    create_table :stadia do |t|
      t.string :name, null: false, unique: true
      t.integer :stadium_group_id, null: true
      t.boolean :deleted, default: false
      t.string :address
      t.index :stadium_group_id

      t.timestamps
    end

    add_foreign_key :stadia, :stadium_groups, column: 'stadium_group_id'
  end
end
