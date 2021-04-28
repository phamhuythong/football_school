# frozen_string_literal: true

# table_name = receipt_categories
# t.string "name", null: false
# t.decimal "price", default: "0.0", null: false
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false

class ReceiptCategory < ApplicationRecord
  include Scopeable

  has_many :student_receipts, inverse_of: :receipt_category
  has_many :students, through: :student_receipts, class_name: 'Student', foreign_key: :student_id

  validates :name, presence: true
end
