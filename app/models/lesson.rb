# frozen_string_literal: true

# table_name = lessons
# t.integer "course_id"
# t.date "hold_date"
# t.time "start_time"
# t.time "end_time"
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.integer "lock_version"
# t.integer "attendances", limit: 2, default: 0
# t.integer "absences", limit: 2, default: 0
# t.index ["course_id", "hold_date"], name: "index_lessons_on_course_id_and_hold_date", unique: true
# t.index ["course_id"], name: "index_lessons_on_course_id"

class Lesson < ApplicationRecord
  include Scopeable

  belongs_to :course, class_name: 'Course', inverse_of: :lessons

  has_many :lesson_absences, inverse_of: :lesson

  scope :by_course, ->(course_id) { where(course_id: course_id) }

  validates :hold_date, uniqueness: { scope: :course_id }, on: :create
end
