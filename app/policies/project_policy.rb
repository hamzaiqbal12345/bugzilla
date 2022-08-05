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
    @user.manager?
  end

  def create?
    new?
  end

  def update?
    @user == @project.creator_id && @user.manager?
  end

  def edit?
    update?
  end

  def delete?
    update?
  end

end
