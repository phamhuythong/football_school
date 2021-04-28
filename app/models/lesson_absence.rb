# frozen_string_literal: true

# table_name = lesson_absences
# t.integer "lesson_id"
# t.integer "student_id"
# t.string "note"
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.integer "lock_version"
# t.boolean "deleted", default: false
# t.index ["lesson_id", "student_id"], name: "index_lesson_absences_on_lesson_id_and_student_id", unique: true
# t.index ["lesson_id"], name: "index_lesson_absences_on_lesson_id"
# t.index ["student_id"], name: "index_lesson_absences_on_student_id"

class LessonAbsence < ApplicationRecord
  include Scopeable

  belongs_to :lesson, inverse_of: :lesson_absences
  belongs_to :student, class_name: 'Student', inverse_of: :lesson_absences

  validates :student_id, uniqueness: { scope: :lesson_id }
end
