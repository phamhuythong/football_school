# frozen_string_literal: true

class StudentReceiptPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    account.admin? || account.teaching_management?
  end

  def update?
    account.admin? || account.teaching_management?
  end
end
