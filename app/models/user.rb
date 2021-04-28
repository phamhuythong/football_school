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

class User < ApplicationRecord
  include Scopeable
  include ImageUploader[:image]

  belongs_to :account, optional: true, inverse_of: :users

  has_one_attached :avatar

  has_many :addresses, as: :addressable

  validates :first_name, presence: true
  validates :date_of_birth, format: { with: /\d{4}-\d{2}-\d{2}/,
                                      message: I18n.t('errors.messages.invalid_date') }, allow_nil: true

  def full_name
    [last_name, middle_name, first_name].compact.join(' ')
  end
end
