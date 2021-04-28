class CreateTeacherCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :teacher_courses do |t|
      t.integer :teacher_id
      t.integer :course_id
      t.boolean :deleted, default: false
      t.index :teacher_id
      t.index :course_id

      t.timestamps
    end

    add_foreign_key :teacher_courses, :users, column: :teacher_id
    add_foreign_key :teacher_courses, :courses, column: :course_id
  end
end
