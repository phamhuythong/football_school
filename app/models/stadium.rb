# frozen_string_literal: true

# table_name = stadia
# t.string "name", null: false
# t.integer "stadium_group_id"
# t.boolean "deleted", default: false
# t.string "address"
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.index ["stadium_group_id"], name: "index_stadia_on_stadium_group_id"

class Stadium < ApplicationRecord
  include Scopeable

  self.table_name = 'stadia'

  belongs_to :stadium_group, inverse_of: :stadia

  has_many :addresses, as: :addressable, inverse_of: :stadium
  has_many :courses, inverse_of: :stadium
  has_many :teaching_management_stadia, inverse_of: :stadium
  has_many :teaching_managements, through: :teaching_management_stadia, class_name: 'TeachingMangement'

  validates :name, presence: true
  validates :stadium_group_id, presence: true

  scope :by_stadiums, ->(stadium_ids) { active.where(id: stadium_ids) }
end
