class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def initialize(user, project)
    @user = user
    @project = project
  end

  def new?
    if @user.role == 'Manager'
      return true
    end
      false
  end

  def create?
    if @user.role == 'Manager'
      return true
    end
    false
  end

  def update?
    if @user == @project.creater && @user.role == 'Manager'
      return true
    end
    false
  end

  def edit?
    if @user == @project.creater && @user.role == 'Manager'
      return true
    end
    false
  end

  def delete?
    if @user == @project.creater && @user.role == 'Manager'
      return true
    end
    false
  end

end
