# frozen_string_literal: true

class CoursePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if account.admin?
    if account.teaching_management?
      account.teaching_management_stadia.map(&:stadium_id).include? record.stadium_id
    else
      account.teacher.teacher_courses.active.map(&:course_id).include? record.id
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
        scope.by_teacher(account.teacher.id).order(:id)
      elsif account.teaching_management?
        stadium_ids = account.teaching_management_stadia.map(&:stadium_id)
        scope.by_stadiums(stadium_ids).order(:id)
      else
        scope.active.all.order(:id)
      end
    end
  end
end
