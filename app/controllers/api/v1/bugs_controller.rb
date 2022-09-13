# frozen_string_literal: true

module Api
  module V1
    class BugsController < ApplicationController
      before_action :find_project, only: %i[index show]
      before_action :find_bug, only: %i[show]
      skip_before_action :authenticate_user!

      def index
        @bugs = @project.bugs
        render json: @bugs, except: :screenshot, location: api_v1_project_bugs_path(@project)
      end

      def show
        render json: @bug, except: :screenshot, location: api_v1_project_bug_path(@project)
      end

      private

      def find_project
        @project = Project.find_by(id: params[:project_id])
      end

      def find_bug
        @bug = @project.bugs.find(params[:id])
      end
    end
  end
end
