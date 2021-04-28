# frozen_string_literal: true

class StudentPolicy < ApplicationPolicy
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
    account.admin? || account.teaching_management?
  end
end
