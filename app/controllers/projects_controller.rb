# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :find_project, except: %i[index new create]
  before_action :authorize_project, only: %i[new edit create show add_user remove_user]

  def index
    @projects = policy_scope(Project)
  end

  def show
    @project_pres = ProjectPresenter.new(@project, view_context)
  end

  def new
    @project = Project.new
  end

  def edit; end

  def create
    @project = current_user.projects.new(project_params)
    @project.creator_id = current_user.id
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render action: 'new', alert: 'Project was not created'
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project has been updated successfully'
    else
      render :edit, alert: 'project didnt update'
    end
  end

  def add_user
    authorize @project
    @user = User.find_by(id: params[:user_id])
    if @project.users << @user
      redirect_to @project
    else
      redirect_to @project, alert: 'Can not add user to project'
    end
  end

  def remove_user
    authorize @project
    @user = User.find_by(id: params[:user_id])
    if @project.users.destroy(@user)
      redirect_to @project
    else
      redirect_to @project, alert: 'Can not remove user from project'
    end
  end

  def destroy
    if @project.destroy
      redirect_to projects_path, notice: 'Project successfully deleted'
    else
      redirect_to projects_path, alert: 'cannot delete the project'
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :creator_id)
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def authorize_project
    if @project.present?
      authorize @project
    else
      authorize Project
    end
  end
end
