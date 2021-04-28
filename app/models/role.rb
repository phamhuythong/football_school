# frozen_string_literal: true

class Role < ApplicationRecord
  belongs_to :resource, polymorphic: true, optional: true

  has_many :account_roles, class_name: 'AccountRole', inverse_of: :role
  has_many :accounts, through: :account_roles

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify

  ROLES = { admin: 'admin', teacher: 'teacher', teaching_management: 'teaching_management' }.freeze
end
