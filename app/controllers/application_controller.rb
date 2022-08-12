# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # expectional handling
  rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :render_404

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :role) }
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:name, :email, :password, :current_password, :role)
    end
  end

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_back(fallback_location: root_path)
  end

  def not_found(error)
    redirect_to projects_path, notice: error.message
  end

  def not_destroyed(e)
    render json: { errors: e.record }, status: :unprocessable_entity
  end

  def render_404
    respond_to do |format|
      format.html { render "#{Rails.root}/public/404.html", status: :not_found }
      format.json { render json: { status: 404, message: 'Page Not Found' } }
    end
  end
end
