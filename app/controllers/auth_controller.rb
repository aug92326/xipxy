class AuthController < ApplicationController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  skip_before_action :auth_user!
  before_action :auth_user_additional!

  def login
  end

  def registration
  end

  def forgot_password
  end

  def get_token
    if current_user
      render json: (current_user.as_api_response(:default_token)).as_json
    else
      render json: nil
    end
  end

  private
  def auth_user_additional!
    if current_user
      current_user.validate_request!(request,params)
      redirect_to root_path if !current_user.errors.present? && [login_path, registration_path].include?(request.fullpath)
    end
  end

end
