# frozen_string_literal: true

# table_name = courses
# t.string "name", null: false
# t.integer "stadium_id"
# t.integer "teacher_id"
# t.integer "course_category_id"
# t.string "start_time"
# t.string "end_time"
# t.date "start_date"
# t.date "end_date"
# t.integer "lock_version", default: 0
# t.boolean "deleted", default: false
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.index ["course_category_id"], name: "index_courses_on_course_category_id"
# t.index ["stadium_id"], name: "index_courses_on_stadium_id"
# t.index ["teacher_id"], name: "index_courses_on_teacher_id"

class Course < ApplicationRecord
  include Scopeable
  include Filterable

  belongs_to :course_category, inverse_of: :courses
  belongs_to :stadium, inverse_of: :courses
  belongs_to :teacher, class_name: 'Teacher', inverse_of: :courses

  has_many :student_courses, class_name: 'StudentCourse', inverse_of: :course
  has_many :students, through: :student_courses, class_name: 'Student', foreign_key: :student_id
  has_many :lessons, inverse_of: :course
  has_many :lesson_absences, through: :lessons, class_name: 'LessonAbsence'

  scope :by_stadium, ->(stadium_id) { where(stadium_id: stadium_id) }

  validates :name, presence: true
  validates :course_category_id, presence: true
  validates :stadium_id, presence: true
end
