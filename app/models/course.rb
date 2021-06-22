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

  has_many :student_courses, class_name: 'StudentCourse', inverse_of: :course
  has_many :students, through: :student_courses, class_name: 'Student', foreign_key: :student_id
  has_many :teacher_courses, class_name: 'TeacherCourse', inverse_of: :course
  has_many :teachers, through: :teacher_courses, class_name: 'Teacher', foreign_key: :teacher_id
  has_many :lessons, inverse_of: :course
  has_many :lesson_absences, through: :lessons, class_name: 'LessonAbsence'
  has_many :student_receipts, inverse_of: :course

  scope :by_stadium, ->(stadium_id) { active.where(stadium_id: stadium_id) }
  scope :by_student, lambda { |student_id|
                       active.joins(:student_courses).where(student_courses: { student_id: student_id, deleted: false })
                     }
  scope :by_teacher, lambda { |teacher_id|
                       active.joins(:teacher_courses).where(teacher_courses: { teacher_id: teacher_id, deleted: false })
                     }
  scope :by_stadiums, ->(stadium_ids) { active.where(stadium_id: stadium_ids) }

  validates :name, presence: true
  validates :course_category_id, presence: true
  validates :stadium_id, presence: true
end
