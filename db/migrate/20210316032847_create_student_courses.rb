class CreateStudentCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :student_courses do |t|
      t.integer :student_id
      t.integer :course_id
      t.date :register_date
      t.date :start_date
      t.date :end_date
      t.integer :lock_version, default: 0
      t.boolean :deleted, default: false
      t.index :student_id
      t.index :course_id

      t.timestamps
    end

    add_foreign_key :student_courses, :users, column: :student_id
    add_foreign_key :student_courses, :courses, column: :course_id
    add_index :student_courses, [:student_id, :course_id, :start_date], unique: true, name: 'student_course_start_unique'
  end
end
