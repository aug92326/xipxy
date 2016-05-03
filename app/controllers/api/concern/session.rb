module API
  module Concern::Session
    extend ActiveSupport::Concern
    included do
      desc "Return login status."
      params {
        requires :login, type: String, desc: "User email or username"
        requires :password, type: String, desc: "User password"
      }
      post '/login' do
        logout_user!
        user = User.authenticate(params[:login], params[:password])

        if user.present?
          user.signed_in! request

          if user.errors.any?
            error_422!(user.as_api_response(:errors))
          else
            success!(user.as_api_response(:default_token), status)
          end
        else
          error_404!('Credentials are invalid')
        end
      end

      desc "Return logout status."
      params do
        optional :access_token, type: String, desc: 'Security token'
      end
      delete '/logout' do
        authenticate_user!
        logout_user!
        {code: 200, status:"success", message: "You are logged out successfully"}
      end
    end
  end
end
