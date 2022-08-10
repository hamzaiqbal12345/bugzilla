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
    @bug.posted_by_id == @user.id
  end

  def update?
    edit?
  end

  def destroy?
      edit?
  end

  def assign?
    @user.developer?
  end

  def start_working?
    @bug.assigned_to_id == @user.id
  end

  def work_done?
    start_working?
  end

end
