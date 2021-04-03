# frozen_string_literal: true

# table_name = student_courses
# t.integer "student_id"
# t.integer "course_id"
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.boolean "deleted", default: false
# t.date "start_date"
# t.date "register_date"
# t.date "end_date"
# t.integer "lock_version", default: 0
# t.index ["course_id"], name: "index_student_courses_on_course_id"
# t.index ["student_id", "course_id", "start_date"], name: "student_course_start_unique", unique: true
# t.index ["student_id"], name: "index_student_courses_on_student_id"

class StudentCourse < ApplicationRecord
  include Scopeable

  belongs_to :student, class_name: 'Student', inverse_of: :student_courses
  belongs_to :course, inverse_of: :student_courses

  validates :student_id, presence: true
  validates :course_id, presence: true
end
