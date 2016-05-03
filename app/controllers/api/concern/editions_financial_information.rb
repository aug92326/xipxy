require 'api_error'

module API
  module Concern
    module EditionsFinancialInformation
      extend ActiveSupport::Concern
      included do
        segment :records do
          route_param :record_id do
            segment :editions do
              route_param :edition_id do
                desc "show FinancialInformation "
                params do
                  optional :access_token, type: String, desc: 'User access token'
                end
                get '/financial_information' do
                  begin
                    financial_information = EditionManager.new(current_user).find_financial_information(params[:edition_id])
                    success! financial_information.as_api_response(:basic), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "update FinancialInformation"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                  optional :price, type: Float
                  optional :insured_price, type: Float
                  optional :insured_type, type: String
                  optional :policy, type: String
                end
                put '/financial_information' do
                  begin
                    financial_information_params = ActionController::Parameters.new(params).permit(:price, :insured_price, :insured_type, :policy)
                    financial_information = EditionManager.new(current_user).update_financial_information(params[:edition_id], financial_information_params)
                    success! financial_information.as_api_response(:light), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

              end
            end
          end
        end
      end
    end
  end
end
