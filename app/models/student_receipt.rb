# frozen_string_literal: true

# table_name = student_receipts
# t.date "receipt_date"
# t.string "receipt_no"
# t.string "book_no"
# t.integer "student_id"
# t.integer "course_id"
# t.integer "receipt_category_id"
# t.decimal "amount"
# t.decimal "paid"
# t.decimal "remain"
# t.string "payer"
# t.string "cashier"
# t.boolean "deleted", default: false
# t.integer "lock_version", default: 0
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.index ["course_id"], name: "index_student_receipts_on_course_id"
# t.index ["receipt_category_id"], name: "index_student_receipts_on_receipt_category_id"
# t.index ["student_id"], name: "index_student_receipts_on_student_id"

class StudentReceipt < ApplicationRecord
  include Scopeable

  belongs_to :student, inverse_of: :student_receipts
  belongs_to :course, inverse_of: :student_receipts
  belongs_to :receipt_category, inverse_of: :student_receipts

  scope :by_student_course, ->(student_id, course_id) { where(student_id: student_id, course_id: course_id) }
end
