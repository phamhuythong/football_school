# frozen_string_literal: true

class CreateStadiumGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :stadium_groups do |t|
      t.string :name, null: false, unique: true
      t.string :info
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
