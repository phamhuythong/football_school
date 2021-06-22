# frozen_string_literal: true

class AccountPolicy < ApplicationPolicy
  def assign_stadium?
    record.teaching_management?
  end

  def process_assign_stadium?
    record.teaching_management?
  end
end
