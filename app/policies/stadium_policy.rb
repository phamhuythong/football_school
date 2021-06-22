# frozen_string_literal: true

class StadiumPolicy < ApplicationPolicy
  class Scope
    attr_reader :account, :scope, :opts

    def initialize(account, scope, **opts)
      @account = account
      @scope = scope
      @opts = opts
    end

    def resolve
      if account.teacher?
        stadium_ids = account.teacher.courses.map(&:stadium_id)
        scope.by_stadiums(stadium_ids).order(:id)
      elsif account.teaching_management?
        stadium_ids = account.teaching_management.teaching_management_stadia.map(&:stadium_id)
        scope.by_stadiums(stadium_ids).order(:id)
      else
        scope.active.all.order(:id)
      end
    end
  end
end
