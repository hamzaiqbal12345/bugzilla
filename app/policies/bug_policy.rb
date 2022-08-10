class BugPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def initialize(user, bug)
    @user = user
    @bug = bug
  end

  def new?
    @user.role == 'qa' || @user.role == 'manager'
  end

  def create?
    new?
  end

  def edit?
    @bug.posted_by == @user
  end

  def update?
    edit?
  end

  def delete?
    edit?
  end
end
