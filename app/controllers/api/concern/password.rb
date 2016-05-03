module API
  module Concern::Password
    extend ActiveSupport::Concern
    included do
      resource :password do

        # desc "Change Password"
        # params {
        #   optional :access_token, type: String, desc: 'User access token'
        #   requires :current_password, type: String, desc: 'Current password'
        #   requires :password, type: String, desc: "New password"
        #   requires :password_confirmation, type: String, desc: "New password confirmation"
        # }
        # post "/force_change" do
        #   begin
        #     authenticate_user!
        #     return error_403!("Invalid current password") unless current_user.valid_password?(params[:current_password])
        #     current_user.password = params[:password]
        #     current_user.password_confirmation = params[:password_confirmation]
        #     current_user.save!
        #     after_save(current_user, status, "Password is changed successfully")
        #   rescue => e
        #     throw_error! 403, e.class.to_s, e.message
        #   end
        # end

        desc "Return instruction forgot password."
          params { requires :email, type: String, desc: "email user object." }
          post "/forgot" do
            params[:email] = params[:email].downcase if params[:email].present?
            user = User.find_by(email: params[:email])
            error_404!("User is not found") unless user
            user.send_reset_password_instructions
            {code: 201, status:"created", message: "Password instruction is sent successfully"} unless nil
          end

        desc "Return Change Password for Forgot Password."
          params {
            requires :password, type: String, desc: "New password"
            requires :password_confirmation, type: String, desc: "New password confirmation"
            requires :reset_password_token, type: String, desc: 'Reset password token'
          }
          post "/change" do
            user = User.reset_password_by_token(params)
            return error_404!("Invalid password token") unless user.errors.empty?
            after_save(user, status, "Password is changed successfully")
          end
      end
    end
  end
end
