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
# t.text "avatar_data"
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.index ["email"], name: "index_accounts_on_email", unique: true
# t.index ["password_digest"], name: "index_accounts_on_password_digest"
# t.index ["username"], name: "index_accounts_on_username", unique: true

class Account < ApplicationRecord
  include ImageUploader[:avatar]
  rolify
  has_secure_password

  has_one :teacher, class_name: 'Teacher', inverse_of: :account

  has_many :accounts_roles, class_name: 'AccountsRole', inverse_of: :account
  has_many :roles, through: :accounts_roles
  has_many :users, inverse_of: :account
  has_many :teaching_management_stadia, inverse_of: :account
  has_many :stadia, through: :teaching_management_stadia, class_name: 'Stadium'

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :username, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }

  scope :active, ->{ where(status: 'active')}

  def admin?
    has_role? :admin
    # account_roles.map(&:role_id).include? 1
  end

  def teaching_management?
    has_role? :teaching_management
    # account_roles.map(&:role_id).include? 3
  end

  def teacher?
    has_role? :teacher
    # account_roles.map(&:role_id).include? 2
  end
end
