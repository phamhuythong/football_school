# frozen_string_literal: true

# table_name = users
# t.string "code"
# t.integer "account_id"
# t.string "first_name", null: false
# t.string "last_name"
# t.string "middle_name"
# t.datetime "date_of_birth"
# t.string "gender"
# t.string "phone"
# t.string "type"
# t.integer "lock_version", default: 0
# t.boolean "deleted", default: false
# t.string "address"
# t.string "mother_name"
# t.string "mother_phone"
# t.string "father_name"
# t.string "father_phone"
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.index ["account_id"], name: "index_users_on_account_id"

class Student < User
  include Scopeable
  include Filterable

  has_many :student_courses, class_name: 'StudentCourse'
  has_many :courses, through: :student_courses, class_name: 'Course', foreign_key: :course_id
  has_many :lesson_absences, inverse_of: :student
  has_many :student_receipts, inverse_of: :student

  # accepts_nested_attributes_for :student_courses, reject_if: :all_blank, allow_destroy: true

  scope :by_stadium, lambda { |stadium_id|
                       joins(:courses).where(courses: { stadium_id: stadium_id },
                                             student_courses: { deleted: false })
                     }
  scope :by_course, ->(course_id) { joins(:courses).where(courses: { id: course_id }, student_courses: { deleted: false }) }
  scope :by_first_name, ->(first_name) { where('lower(first_name) = ?', first_name.downcase) }
end
