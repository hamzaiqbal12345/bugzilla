# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :find_project, except: %i[index new]
      skip_before_action :authenticate_user!

      def index
        @projects = Project.all
        render json: @projects, location: api_v1_projects_path
      end

      def show
        @project_pres = ProjectPresenter.new(@project, view_context)
        render json: @project, location: api_v1_project_path(@project)
      end

      private

      def project_params
        params.require(:project).permit(:title, :description, :creator_id)
      end

      def find_project
        @project = Project.find(params[:id])
      end

    end

  end
end
