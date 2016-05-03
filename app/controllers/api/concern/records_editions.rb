require 'api_error'

module API
  module Concern
    module RecordsEditions
      extend ActiveSupport::Concern
      included do
        segment :records do
          route_param :record_id do
            desc "show list of record editions"
            params do
              optional :access_token, type: String, desc: 'User access token'
              optional :page, type: Integer, desc: 'page number for editions list', default: 1
              optional :per_page, type: Integer, desc: 'specify how many editions in a page, default to 25', default: 25
            end
            get '/editions' do
              begin
                editions = RecordManager.new(current_user).editions(params[:record_id])
                editions = editions.order('created_at DESC').page(page).per(per_page)
                success! editions.as_api_response(:basic), 200
              rescue => e
                throw_error! 403, e.class.to_s, e.message
              end
            end

            desc "show record edition"
            params do
              optional :access_token, type: String, desc: 'User access token'
            end
            get '/editions/:id' do
              begin
                edition = RecordManager.new(current_user).find_edition(params[:id])
                success! edition.as_api_response(:basic), 200
              rescue => e
                throw_error! 403, e.class.to_s, e.message
              end
            end

            desc "create record edition"
            params do
              optional :access_token, type: String, desc: 'User access token'
              optional :location_id, type: Integer, desc: 'Edition location ID'
              optional :primary_status, type: String, desc: 'Edition primary status'
              optional :secondary_status, type: String, desc: 'Edition secondary status'
              optional :notes, type: String, desc: 'Edition notes'
              optional :edition_type, type: String, desc: 'Edition type'
              optional :dup_from_primary, coerce: Virtus::Attribute::Boolean, desc: "Read only attributes, value either 0 or 1"
            end
            post '/editions' do
              begin
                edition_params = ActionController::Parameters.new(params).permit(:primary_status, :secondary_status, :notes, :edition_type, :location_id)
                rm  = RecordManager.new(current_user)
                edition =
                  if params[:dup_from_primary].present? && params[:dup_from_primary]
                    rm.clone_primary_edition(params[:record_id], edition_params)
                  else
                    rm.create_edition(params[:record_id], edition_params)
                  end
                success! edition.as_api_response(:basic), 200
              rescue => e
                throw_error! 403, e.class.to_s, e.message
              end
            end

            desc "update record edition"
            params do
              optional :access_token, type: String, desc: 'User access token'
              optional :primary_status, type: String, desc: 'Edition primary status'
              optional :secondary_status, type: String, desc: 'Edition secondary status'
              optional :notes, type: String, desc: 'Edition notes'
              optional :edition_type, type: String, desc: 'Edition type'
              optional :authenticity_id, type: Integer
              optional :authenticator, type: String
              optional :financial_information, type: Hash do
                optional :price, type: Float
                optional :insured_price, type: Float
                optional :insured_type, type: String
                optional :policy, type: String
              end
              optional :location, type: Hash do
                optional :name, type: String, desc: 'Location Name'
                optional :address, type: String, desc: 'Location address'
                optional :country, type: String, desc: 'Location country'
                optional :country_code, type: String, desc: 'Location country code'
                optional :city, type: String, desc: 'Location city'
                optional :state, type: String, desc: 'Location state'
                optional :zipcode, type: String, desc: 'Location zipcode'
                optional :sublocation, type: String, desc: 'Location sublocation'
                optional :location_notes, type: String, desc: 'Location notes'
              end
              optional :details, type: Hash, desc: 'Artwork details' do
                optional :manufacturer, type: String, desc: 'Artwork manufacturer'
                optional :designer, type: String, desc: 'Artwork designer'
                optional :period, type: String, desc: 'Artwork period'
                optional :packaging, type: String, desc: 'Artwork packaging'
                optional :unique_marks, type: String, desc: 'Artwork packaging'
                optional :additional_information, type: String, desc: 'Artwork packaging'
                optional :system, type: String, desc: 'Artwork details system', values: ['standard', 'metric']
                optional :frame, type: Hash, desc: 'Artwork details frame' do
                  optional :height, type: Float, desc: 'frame height'
                  optional :width, type: Float, desc: 'frame width'
                  optional :depth, type: Float, desc: 'frame depth'
                end
              end
              optional :admin, type: Hash do
                optional :inventory_number, type: String
                optional :copyright, type: String
              end
            end
            put '/editions/:id' do
              begin
                edition_params = ActionController::Parameters.new(params).permit(:authenticity_id, :authenticator,
                                                                                 :primary_status, :secondary_status, :notes,
                                                                                 :edition_type,
                                                                                 admin: [:inventory_number, :copyright],
                                                                                 details: [:manufacturer, :designer, :period, :packaging, :unique_marks, :additional_information, :system, frame: [:height, :width, :depth]],
                                                                                 financial_information: [:price, :insured_price, :insured_type, :policy],
                                                                                 location: [:name, :address, :country, :country_code, :city, :state, :zipcode, :sublocation, :location_notes] )
                edition = RecordManager.new(current_user).update_edition(params[:id], edition_params)
                success! edition.as_api_response(:light), 200
              rescue => e
                throw_error! 403, e.class.to_s, e.message
              end
            end

            desc "detele record edition"
            params do
              optional :access_token, type: String, desc: 'User access token'
            end
            delete '/editions/:id' do
              begin
                edition = RecordManager.new(current_user).delete_edition(params[:id])
                success! edition.as_api_response(:basic), 200
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
