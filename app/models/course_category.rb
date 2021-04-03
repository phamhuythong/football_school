# frozen_string_literal: true

# table_name = course_categories
# t.string "name", null: false
# t.text "info"
# t.boolean "deleted", default: false
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false

class CourseCategory < ApplicationRecord
  include Scopeable

  has_many :courses, inverse_of: :course_category

  validates :name, presence: true
  # validates :name, uniqueness: true
end
