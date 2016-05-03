class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :auth_user!

  include DeviseOverrides

  def index
  end

  def show
  end

  private
  def auth_user!
    exclusion_redirect = [login_path, registration_path].include?(request.fullpath)
    if current_user
      current_user.validate_request!(request,params)
      current_user_valid = !current_user.errors.present?
      if exclusion_redirect
        redirect_to root_path if current_user_valid
      else
        unless current_user_valid
          warden.logout
        end
      end
    else
      redirect_to login_path if !exclusion_redirect
    end
  end
end
