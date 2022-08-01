class BugsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @bugs = @project.bugs
  end

  def new
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.new
    authorize @bug
  end

  def edit
    authorize @bug
  end

  def show
  end

  def create
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.new(params_bug)
    @bug.posted_by = current_user
    respond_to do |format|
      if @bug.save
        format.html {redirect_to [@project,@bug], notice: "bug was created successfully"}
        format.json {render :show, status: :created, location: @bug}
      else
        format.html {render :new}
        format.json {render json: @bug.errors, status: unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @bug.update(params_bug)
        format.html {redirect_to [@project, @bug], notice: "bug was updated successfully"}
        format.json {render :show, status: :ok, location: @bug}
      else
        format.html {redirect_to :edit}
        format.json {render json: @bug.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @bug.destroy
    respond_to do |format|
      format.html {redirect_to [@project, Bug], notice: "Bug was deleted succesfully"}
      format.json {head :no_content}
    end
  end

  private

  def params_bug
    params[:bug] = params[:bug].to_i
    params.require(:bug).permit(:title, :description, :deadline)
  end

end
