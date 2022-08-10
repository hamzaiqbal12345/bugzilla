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
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project has been updated successfully'
    else
      render :edit, notice: 'project didnt update'
    end
  end

  def add_user
    @user ||= User.find_by(id: params[:user_id])
    if @project.users << @user
      redirect_to @project
    else
      redirect_to @project, notice: 'Can not add user to project'
    end
  end

  def remove_user
    @user ||= User.find_by(id: params[:user_id])
    if @project.users.destroy(@user)
      redirect_to @project
    else
      redirect_to @project, notice: 'Can not remove user from project'
    end
  end

  def destroy
    if @project.destroy
      redirect_to projects_path, notice: 'Project successfully deleted'
    else
      redirect_to projects_path, notice: 'cannot delete the project'
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description)
  end

  def find_project
    @project ||= Project.find_by(id: params[:id])
  end

  def authorize_project
    if @project.present?
      authorize @project
    else
      authorize Project
    end
  end
end
