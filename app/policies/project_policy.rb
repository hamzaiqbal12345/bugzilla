class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if @user.manager?
      	scope.where(creator_id: @user.id)
      elsif @user.qa?
      	scope.all
      elsif @user.developer?
      	scope = @user.projects
      end
    end
  end

  def initialize(user, project)
    @user = user
    @project = project
  end

  def new?
    if @user.role == 'manager'
      return true
    end
      false
  end

  def create?
    if @user.role == 'manager'
      return true
    end
    false
  end

  def update?
    if @user == @project.creator_id && @user.role == 'manager'
      return true
    end
    false
  end

  def edit?
    if @user == @project.creator_id && @user.role == 'manager'
      return true
    end
    false
  end

  def delete?
    if @user == @project.creator_id && @user.role == 'manager'
      return true
    end
    false
  end

end
