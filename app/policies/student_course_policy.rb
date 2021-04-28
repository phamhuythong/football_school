# frozen_string_literal: true

class StudentCoursePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    create?
  end

  def new?
    create?
  end

  def create?
    true
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
