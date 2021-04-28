# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :account, :record

  def initialize(account, record)
    @account = account
    @record = record
  end

  def index?
    account.admin?
  end

  def show?
    account.admin?
  end

  def create?
    account.admin?
  end

  def new?
    create?
  end

  def update?
    account.admin?
  end

  def edit?
    update?
  end

  def destroy?
    account.admin?
  end

  class Scope
    attr_reader :account, :scope, :opts

    def initialize(account, scope, **opts)
      @account = account
      @scope = scope
      @opts = opts
    end

    def resolve
      scope.all
    end
  end
end
