class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.integer :course_id
      t.date :hold_date
      t.time :start_time
      t.time :end_time
      t.integer :lock_version, default: 0
      t.index :course_id
      t.index [:course_id, :hold_date], unique: true

      t.timestamps
    end

    add_foreign_key :lessons, :courses, column: :course_id
  end
end
