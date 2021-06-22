# frozen_string_literal: true

class StudentCoursePolicy < ApplicationPolicy
  def index?
    account.admin? || account.teaching_management?
  end

  def show?
    student_course_policy
  end

  def create?
    account.admin? || account.teaching_management?
  end

  def update?
    student_course_policy
  end

  def destroy?
    student_course_policy
  end

  def student_course_policy
    return true if account.admin?

    if account.teaching_management?
      account.teaching_management.teaching_management_stadia.map(&:stadium_id).include? record.course.stadium_id
    else
      false
    end
  end
end
