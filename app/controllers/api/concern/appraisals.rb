require 'api_error'
require 'api_file_preprocessor'

module API
  module Concern
    module Appraisals
      extend ActiveSupport::Concern
      included do
        segment :records do
          route_param :record_id do
            segment :editions do
              route_param :edition_id do
                segment :financial_information do
                  desc "return all appraisals data"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :page, type: Integer, desc: 'page number for appraisals list'
                    optional :per_page, type: Integer, desc: 'specify how many appraisals in a page'
                  end
                  get '/appraisals' do
                    begin
                      appraisals = EditionManager.new(current_user).appraisals(params[:edition_id])
                      appraisals = appraisals.page(page).per(per_page) if params[:per_page].present?
                      success! appraisals.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "return an appraisal data"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                  end
                  get '/appraisals/:id' do
                    begin
                      appraisal = EditionManager.new(current_user).find_appraisal(params[:id])
                      success! appraisal.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "create a new appraisal"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :name, type: String
                    optional :appraisal_price, type: Float
                    optional :appraisal_at, type: DateTime
                  end
                  post '/appraisals' do
                    begin
                      appraisal_params = ActionController::Parameters.new(params).permit(:name, :appraisal_price, :appraisal_at)
                      appraisal = EditionManager.new(current_user).create_appraisal(params[:edition_id], appraisal_params)
                      success! appraisal.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "update exist appraisal"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :name, type: String
                    optional :appraisal_price, type: Float
                    optional :appraisal_at, type: DateTime
                  end
                  put '/appraisals/:id' do
                    begin
                      appraisal_params = ActionController::Parameters.new(params).permit(:name, :appraisal_price, :appraisal_at)
                      appraisal = EditionManager.new(current_user).update_appraisal(params[:id], appraisal_params)
                      success! appraisal.as_api_response(:light), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "delete exist appraisal"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                  end
                  delete '/appraisals/:id' do
                    begin
                      appraisal = EditionManager.new(current_user).delete_appraisal(params[:id])
                      success! appraisal.as_api_response(:basic), 200
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
end
