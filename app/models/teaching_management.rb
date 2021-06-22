# frozen_string_literal: true

class TeachingManagement < User
  resourcify

  include Scopeable
  has_many :teaching_management_stadia, inverse_of: :teaching_management
  has_many :stadia, through: :teaching_management_stadia
end
