class HomeController < ApplicationController
  def index
    if current_user.Manager?
      @project = current_user.projects.all
      @count_bugs = Bug.where(:project=>current_user.projects).count
    else
      @projects = current_user.projects
    end
  end
end
