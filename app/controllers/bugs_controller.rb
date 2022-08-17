# frozen_string_literal: true

class BugsController < ApplicationController
  before_action :find_project
  before_action :find_bug, only: %i[show edit update destroy]

  def create
    @bug = @project.bugs.new(bug_params)
    authorize @bug
    @bug.posted_by_id = current_user.id
    @bug.status = 'neew'
    if @bug.save
      redirect_to project_path(@project), notice: 'bug created successfully'
    else
      redirect_to project_path(@project), alert: @bug.errors.messages
    end
  end

  def show; end

  def edit; end

  def update
    if @bugs.update(bug_params)
      redirect_to @bug, notice: 'bug updated successfully'
    else
      render :edit, 'bug not updated'
    end
  end

  def destroy
    authorize @bug
    if @bug.destroy
      redirect_to project_path(@project), notice: 'bug successfully destroyed'
    else
      redirect_to project_path(@project), alert: 'bug not destroyed'
    end
  end

  def assign
    @bug = @project.bugs.find_by(id: params[:bug_id])
    authorize @bug
    @bug.assigned_to_id = current_user.id
    if @bug.save
      redirect_to project_bug_path(@project, @bug), notice: 'dev assigned successfully'
    else
      redirect_to project_bug_path(@project, @bug), alert: 'not assigned'
    end
  end

  def start_working
    @bug = @project.bugs.find_by(id: params[:bug_id])
    authorize @bug
    @bug.status = 'started'
    if @bug.save
      redirect_to project_bug_path(@project, @bug), notice: 'started successfully'
    else
      redirect_to project_bug_path(@project, @bug), alert: 'not started'
    end
  end

  def work_done
    @bug = @project.bugs.find_by(id: params[:bug_id])
    status = @bug.bug_type == 'feature' ? 'completed' : 'resolved'
    authorize @bug
    @bug.status = status
    if @bug.save
      redirect_to project_bug_path(@project, @bug), notice: 'started successfully'
    else
      redirect_to project_bug_path(@project, @bug), alert: 'not started'
    end
  end

  private

  def find_project
    @project = Project.find_by(id: params[:project_id])
  end

  def find_bug
    @bug = @project.bugs.find(params[:id])
  end

  def bug_params
    params.require(:bug).permit(:project_id, :title, :description, :deadline, :posted_by, :status, :bug_type,
                                :screenshot, :assigned_to_id)
  end
end
