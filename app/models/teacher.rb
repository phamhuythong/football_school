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

class Teacher < User
  resourcify

  include Scopeable
  # self.adapter = User.adapter
  has_many :teacher_courses, class_name: 'TeacherCourse', inverse_of: :teacher
  has_many :courses, through: :teacher_courses, class_name: 'Course', foreign_key: :course_id
end
