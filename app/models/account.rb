# frozen_string_literal: true

# table_name = accounts
# t.string "email", null: false
# t.string "username"
# t.string "password_digest"
# t.string "remember_digest"
# t.string "activation_digest"
# t.boolean "activated"
# t.datetime "activated_at"
# t.string "reset_digest"
# t.datetime "reset_sent_at"
# t.string "status", default: "active"
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.index ["email"], name: "index_accounts_on_email", unique: true
# t.index ["password_digest"], name: "index_accounts_on_password_digest"
# t.index ["username"], name: "index_accounts_on_username", unique: true

class Account < ApplicationRecord
  has_secure_password

  has_many :users, inverse_of: :account

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :username, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }
end
