# frozen_string_literal: true

# t.integer "account_id"
# t.integer "stadium_id"
# t.boolean "deleted", default: false
# t.integer "lock_version", default: 0
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.index ["account_id"], name: "index_teaching_manegement_stadia_on_account_id"
# t.index ["stadium_id"], name: "index_teaching_manegement_stadia_on_stadium_id"

class TeachingManagementStadium < ApplicationRecord
  include Scopeable

  belongs_to :account, inverse_of: :teaching_management_stadia
  belongs_to :stadium, inverse_of: :teaching_management_stadia
end
