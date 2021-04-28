# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false, unique: true
      t.integer :stadium_id, null: true
      t.integer :teacher_id, null: true
      t.integer :course_category_id, null: true
      t.time :start_time
      t.time :end_time
      t.date :start_date
      t.date :end_date
      t.integer :lock_version, default: 0
      t.boolean :deleted, default: false
      t.index :stadium_id
      t.index :teacher_id
      t.index :course_category_id

      t.timestamps
    end

    add_foreign_key :courses, :stadia, column: :stadium_id
    add_foreign_key :courses, :users, column: :teacher_id
    add_foreign_key :courses, :course_categories, column: :course_category_id
  end
end
