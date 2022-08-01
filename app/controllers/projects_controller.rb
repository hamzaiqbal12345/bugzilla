class ProjectsController < ApplicationController
  def index
    # @projects = if current_user.Manager?
    #   current_user.projects.all
    # else
    #   current_user.projects
    # end
    @projects = Project.all
  end

  def show
  end

  def new
    @project = current_user.projects.new
    authorize @project
  end

  def edit
    authorize @project
  end

  def create
    @project = Project.new(params_project)
    @project.creator = current_user
    authorize @project
    respond_to do |format|
      if @project.save
        format.html {redirect_to @project, notice: "project was created successfully"}
        format.json {render :show, status: :created, location: @project}
      else
        format.html {render :new}
        format.json {render json: @project.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    authorize @Project
    respond_to do |format|
      if @project.update(params_project)
        format.html {redirect_to @project, notice: "Project was updated successfully"}
        format.json {render :edit, status: :ok, location: @project}
      else
        format.html {render :edit}
        format.json {render json: @project.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html {redirect_to projects_url, notice: "project was destroyed successfully"}
      format.json {head :no_content}
    end
  end

  private

  def params_project
    params.require(:project).permit(:title, :description)
  end
end
