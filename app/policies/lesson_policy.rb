# frozen_string_literal: true

class LessonPolicy < ApplicationPolicy
  def index?
    account.admin? || account.teaching_management || account.teacher?
  end

  def show?
    lesson_policy
  end

  def create?
    account.admin? || account.teaching_management || account.teacher?
  end

  def update?
    lesson_policy
  end

  def destroy?
    lesson_policy
  end

  private

  def lesson_policy
    return true if account.admin?

    if account.teaching_management?
      account.teaching_management.teaching_management_stadia.map(&:stadium_id).include? record.course.stadium_id
    else
      account.teacher.teacher_courses.active.map(&:course_id).include? record.course_id
    end
  end
end
