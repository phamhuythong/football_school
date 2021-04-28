# frozen_string_literal: true

# table_name = stadium_groups
# t.string "name", null: false
# t.string "info"
# t.boolean "deleted", default: false
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false

class StadiumGroup < ApplicationRecord
  include Scopeable

  has_many :stadia, class_name: 'Stadium', inverse_of: :stadium_group
  has_many :addresses, as: :addressable, inverse_of: :stadium_group

  validates :name, presence: true
  # validates :name, uniqueness: true
end
