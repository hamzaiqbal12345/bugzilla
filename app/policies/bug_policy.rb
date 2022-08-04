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
    if @user.role == 'qa'
      return true
    end
    false
  end

  def create?
    if @user.role == 'qa'
      return true
    end
    false
  end

  def edit?
    if @bug.posted_by == @user
      return true
    end
    false
  end

  def update?
    edit?
  end

  def delete?
    if @user.role == 'qa'
      return true
    end
    false
  end
end
