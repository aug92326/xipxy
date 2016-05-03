module API
  module Concern::UserProfile
    extend ActiveSupport::Concern
    included do
      segment :user do
        resource :profile do
          desc "Show current user profile", {notes: 'Display User information(not fully finished yet)'}
          params {
            optional :access_token, type: String, desc: 'security token'
          }
          get do
            success! current_user.as_api_response(:my_profile_mode), 200, 'success'
          end

          desc "Update current user profile(not finished yet)"
          params {
            optional :access_token, type: String, desc: 'user access token'
            optional :first_name, type: String
            optional :last_name, type: String
            optional :mailing_address, type: String
            optional :country, type: String
            optional :city, type: String
            optional :state, type: String
            optional :zipcode, type: String
            optional :phone, type: String
            optional :alternative_email, type: String
          }
          put do
            params_profile = ActionController::Parameters.new(params).permit(:first_name, :last_name, :mailing_address, :country, :city, :state, :zipcode, :phone, :alternative_email)
            profile = current_user.profile
            profile.update! params_profile
            success! profile.as_api_response(:light), 200, 'profile updated'
          end
        end
      end
    end
  end
end