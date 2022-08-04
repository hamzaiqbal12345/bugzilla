class BugsController < ApplicationController
  before_action :find_project


  def create
    @bug = @project.bugs.create(bug_params)
    # authorize @bug
    @bug.posted_by = current_user
    redirect_to project_path(@project)
  end

  def destroy
    @bug = @project.bugs.find(params[:id])
    # authorize @bug
    @bug.destroy
    redirect_to project_path(@project)
  end

  def edit
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :deadline, :posted_by, :status, :bug_type, :screenshot)
  end



end
