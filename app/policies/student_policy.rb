# frozen_string_literal: true

class StudentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if account.admin?

    if account.teaching_management?
      (account.teaching_management.teaching_management_stadia.map(&:stadium_id) & record.courses.map(&:stadium_id)).any?
    else
      (account.teacher.teacher_courses.active.map(&:course_id) & record.student_courses.map(&:course_id)).any?
    end
  end

  def create?
    account.admin? || account.teaching_management?
    # return true if account.admin?
    # if account.teaching_management?
    #   course = Course.find opts[:course_id]
    #   account.teaching_management.teaching_management_stadia.map(&:stadium_id).include? course.stadium_id
    # else
    #   false
    # end
  end

  def update
    student_policy
  end

  def destroy
    student_policy
  end

  def student_policy
    return true if account.admin?

    if account.teaching_management?
      (account.teaching_management.teaching_management_stadia.map(&:stadium_id) && record.courses.map(&:stadium_id)).any?
    else
      false
    end
  end

  class Scope
    attr_reader :account, :scope, :opts

    def initialize(account, scope, **opts)
      @account = account
      @scope = scope
      @opts = opts
    end

    def resolve
      if account.teacher?
        []
      elsif account.teaching_management?
        stadium_ids = account.teaching_management.teaching_management_stadia.map(&:stadium_id)
        scope.by_stadiums(stadium_ids)
      else
        scope
      end
    end
  end
end
