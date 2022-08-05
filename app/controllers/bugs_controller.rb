class BugsController < ApplicationController
  before_action :find_project


  def create
    @bug = @project.bugs.create(bug_params)
    @bug.posted_by = current_user
    @bug.status = "neew"
    redirect_to project_path(@project)
  end

  def destroy
    @bug = @project.bugs.find(params[:id])
    @bug.destroy
    redirect_to project_path(@project)
  end

  def show
    @bug = @project.bugs.find(params[:id])
  end

  # def edit
  #   @bug = @project.bugs.find(params[:id])
  # end

  # def update
  #   @bug = @project.bugs.find(params[:id])
  #   if @bugs.update(bug_params)
  #     redirect_to @bug
  #   else
  #     render :edit
  #   end
  # end

  def assign
    @bug = @project.bugs.find(params[:id])
    if @bug.update_attribute(:assigned_to_id, current_user.id)
      redirect_to @bug, notice: "dev assigned successfully"
    else
      redirect_to @bug, notice: "not assigned"
    end
  end

  def start_working
    @bug = @project.bugs.find(params[:id])
    if @bug.update_attribute(:status, 'started')
      redirect_to @bug, notice: "started successfully"
    else
      redirect_to @bug, notice: "not started"
    end
  end

  def work_done
    @bug = @project.bugs.find(params[:id])
    status = (@bug.bug_type == 'feature')? 'completed' : 'resolved'
    if @bug.update_attribute(:status, status)
      redirect_to @bug, notice: "started successfully"
    else
      redirect_to @bug, notice: "not started"
    end
  end


  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def bug_params
    params.require(:bug).permit(:project_id, :title, :description, :deadline, :posted_by, :status, :bug_type, :screenshot, :assigned_to_id)
  end
end
