# frozen_string_literal: true

# table_name = teacher_courses
# t.integer "teacher_id"
# t.integer "course_id"
# t.boolean "deleted", default: false
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.index ["course_id"], name: "index_teacher_courses_on_course_id"
# t.index ["teacher_id"], name: "index_teacher_courses_on_teacher_id"

class TeacherCourse < ApplicationRecord
  include Scopeable

  belongs_to :teacher, class_name: 'Teacher', inverse_of: :teacher_courses
  belongs_to :course, inverse_of: :teacher_courses

  validates :teacher_id, presence: true
  validates :course_id, presence: true
end
