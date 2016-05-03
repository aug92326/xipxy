require 'api_error'

module API
  module Concern
    module PriorOwnerships
      extend ActiveSupport::Concern
      included do
        segment :records do
          route_param :record_id do
            segment :editions do
              route_param :edition_id do
                segment :ownerships do
                  desc "return all ownerships data"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :page, type: Integer, desc: 'page number for ownerships list'
                    optional :per_page, type: Integer, desc: 'specify how many ownerships in a page'
                  end
                  get do
                    begin
                      ownerships = EditionManager.new(current_user).ownerships(params[:edition_id])
                      ownerships = ownerships.page(page).per(per_page) if params[:per_page].present?
                      success! ownerships.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "return an ownership data"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                  end
                  get '/:id' do
                    begin
                      ownership = EditionManager.new(current_user).find_ownership(params[:id])
                      success! ownership.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "create a new ownership"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :owner, type: String
                    optional :purchase_price, type: Float
                    optional :sale_price, type: Float
                    optional :date_of_purchase, type: DateTime
                    optional :date_of_sale, type: DateTime
                    optional :purchased_through, type: String
                    optional :sold_through, type: String
                  end
                  post  do
                    begin
                      ownership_params = ActionController::Parameters.new(params).permit(:owner, :purchase_price, :sale_price, :date_of_purchase, :date_of_sale, :purchased_through, :sold_through)
                      ownership = EditionManager.new(current_user).create_ownership(params[:edition_id], ownership_params)
                      success! ownership.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "update exist ownership"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :owner, type: String
                    optional :purchase_price, type: Float
                    optional :sale_price, type: Float
                    optional :date_of_purchase, type: DateTime
                    optional :date_of_sale, type: DateTime
                    optional :purchased_through, type: String
                    optional :sold_through, type: String
                  end
                  put '/:id' do
                    begin
                      ownership_params = ActionController::Parameters.new(params).permit(:owner, :purchase_price, :sale_price, :date_of_purchase, :date_of_sale, :purchased_through, :sold_through)
                      ownership = EditionManager.new(current_user).update_ownership(params[:id], ownership_params)
                      success! ownership.as_api_response(:light), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "delete exist ownership"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                  end
                  delete '/:id' do
                    begin
                      ownership = EditionManager.new(current_user).delete_ownership(params[:id])
                      success! ownership.as_api_response(:basic), 200
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
