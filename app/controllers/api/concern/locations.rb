require 'api_error'

module API
  module Concern
    module Locations
      extend ActiveSupport::Concern
      included do
        segment :locations do
          desc "return all locations "
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :term, type: String, desc: "The search term"
          end
          get do
            begin
              locations = LocationManager.new(current_user).latest
              locations = locations.search_by_name params[:term] if params[:term].present?
              locations = locations.order('created_at DESC').page(page).per(per_page)
              #some hack
              locations = Location.where('id IN (?)', locations.map(&:id)).select('distinct on (name) *')
              success! locations.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          # desc "return an location data"
          # params do
          #   optional :access_token, type: String, desc: 'User access token'
          # end
          # get '/:id' do
          #   begin
          #     location = LocationManager.new(current_user).find(params[:id])
          #     success! location.as_api_response(:basic), 200
          #   rescue => e
          #     throw_error! 403, e.class.to_s, e.message
          #   end
          # end
          #
          # desc "create a new locations"
          # params do
          #   optional :access_token, type: String, desc: 'User access token'
          #   requires :name, type: String, desc: 'Location Name'
          #   optional :address, type: String, desc: 'Location address'
          #   optional :country, type: String, desc: 'Location country'
          #   optional :city, type: String, desc: 'Location city'
          #   optional :state, type: String, desc: 'Location state'
          #   optional :zipcode, type: String, desc: 'Location zipcode'
          #   optional :sublocation, type: String, desc: 'Location sublocation'
          #   optional :location_notes, type: String, desc: 'Location notes'
          # end
          # post do
          #   begin
          #     location_params = ActionController::Parameters.new(params).permit(:name, :address, :city, :state, :zipcode, :sublocation, :location_notes)
          #     location = LocationManager.new(current_user).create_location(location_params)
          #     success! location.as_api_response(:basic), 200
          #   rescue => e
          #     throw_error! 403, e.class.to_s, e.message
          #   end
          # end
          #
          # desc "update exist location"
          # params do
          #   optional :access_token, type: String, desc: 'User access token'
          #   optional :name, type: String, desc: 'Location Name'
          #   optional :address, type: String, desc: 'Location address'
          #   optional :country, type: String, desc: 'Location country'
          #   optional :city, type: String, desc: 'Location city'
          #   optional :state, type: String, desc: 'Location state'
          #   optional :zipcode, type: String, desc: 'Location zipcode'
          #   optional :sublocation, type: String, desc: 'Location sublocation'
          #   optional :location_notes, type: String, desc: 'Location notes'
          # end
          # put ':id' do
          #   begin
          #     location_params = ActionController::Parameters.new(params).permit(:name, :address, :country, :city, :state, :zipcode, :sublocation, :location_notes)
          #     location = LocationManager.new(current_user).update_location(params[:id], location_params)
          #     success! location.as_api_response(:basic), 200
          #   rescue => e
          #     throw_error! 403, e.class.to_s, e.message
          #   end
          # end
          #
          # desc "delete exist location"
          # params do
          #   optional :access_token, type: String, desc: 'User access token'
          # end
          # delete ':id' do
          #   begin
          #     location = LocationManager.new(current_user).delete_location(params[:id])
          #     success! location.as_api_response(:basic), 200
          #   rescue => e
          #     throw_error! 403, e.class.to_s, e.message
          #   end
          # end
        end
      end
    end
  end
end
