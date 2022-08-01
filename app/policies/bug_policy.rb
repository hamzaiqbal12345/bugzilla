class BugPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    # end
  end

  def initialize(user, bug)
    @user = user
    @bug = bug
  end

  def new?
    if @user.role == 'QA' && @user.projects.include?(@bug.project)
      return true
    end
    false
  end

  def create?
    if @user.role == 'QA' && @user.projects.include?(@bug.project)
      return true
    end
    false
  end

  def edit?
    return treu if @bug.posted_by == @user
    false
  end

  def update?
    if (!@user.role == "Developer" && @user.projects.include?(@bug.project)) || @bug.posted_by == @user
      return true
    end
    false
  end

  def delete?
    if @bug.posted_by == @user
      return true
    end
    false
  end
end
