class CreateLessonAbsences < ActiveRecord::Migration[6.0]
  def change
    create_table :lesson_absences do |t|
      t.integer :lesson_id
      t.integer :student_id
      t.string :note
      t.boolean :deleted, default: false
      t.integer :lock_version, default: 0
      t.index :lesson_id
      t.index :student_id
      t.index [:lesson_id, :student_id], unique: true

      t.timestamps
    end

    add_foreign_key :lesson_absences, :lessons, column: :lesson_id
    add_foreign_key :lesson_absences, :users, column: :student_id
  end
end
