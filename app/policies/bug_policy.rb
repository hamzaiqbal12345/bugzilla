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
    @user.qa?
  end

  def create?
    @user.qa?
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
