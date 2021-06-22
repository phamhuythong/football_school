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
  include Filterable
  include ImageUploader[:avatar]
  rolify
  has_secure_password(validations: false)

  has_one :user, class_name: 'User', inverse_of: :account
  has_one :teacher, class_name: 'Teacher', inverse_of: :account
  has_one :teaching_management, class_name: 'TeachingManagement', inverse_of: :account

  has_many :accounts_roles, class_name: 'AccountsRole', inverse_of: :account
  has_many :roles, through: :accounts_roles
  # has_many :teaching_management_stadia, inverse_of: :account
  # has_many :stadia, through: :teaching_management_stadia, class_name: 'Stadium'

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, on: :create

  scope :active, -> { where(status: 'active') }
  scope :by_email_username, lambda { |email_username|
                              where('lower(email) LIKE ? OR lower(username) LIKE ?', "%#{email_username}%", "%#{email_username}%")
                            }

  TYPES = %w[Admin Teacher Student TeachingManagement].freeze

  def admin?
    has_role? :admin
  end

  def teaching_management?
    (has_role? :teaching_management) && teaching_management.present?
  end

  def teacher?
    (has_role? :teacher) && teacher.present?
  end

  def student?
    has_role? :student
  end
end
