# frozen_string_literal: true

# table_name = addresses
# t.integer "addressable_id"
# t.string "addressabe_type"
# t.string "country"
# t.string "state"
# t.string "city"
# t.string "ward"
# t.string "postal_code"
# t.string "address1"
# t.string "address2"
# t.string "phone"
# t.string "fax"
# t.integer "lock_version", default: 0
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.index ["addressabe_type"], name: "index_addresses_on_addressabe_type"
# t.index ["addressable_id"], name: "index_addresses_on_addressable_id"

class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  def self.address_params
    { addresses_attributes: %i[id addressable_id addressable_type country state city ward postal_code
                               address1 address2 phone fax lock_version] }
  end
end
