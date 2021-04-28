# frozen_string_literal: true

class StudentReceiptPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    return true if account.admin? || account.teaching_management?
  end

  def edit?
    update?
  end

  def update?
    return true if account.admin? || account.teaching_management?
  end
end
