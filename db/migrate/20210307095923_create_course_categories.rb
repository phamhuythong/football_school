# frozen_string_literal: true

class CreateCourseCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :course_categories do |t|
      t.string :name, null: false, unique: true
      t.text :info
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
