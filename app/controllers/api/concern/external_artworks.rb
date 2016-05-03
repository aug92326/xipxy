require 'api_error'

module API
  module Concern
    module ExternalArtworks
      extend ActiveSupport::Concern
      included do
        segment :external_artworks do
          desc "return all external artworks data by artist"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :artist_id, type: Integer, desc: 'Artist ID'
            optional :term, type: String, desc: "The search term"
            optional :page, type: Integer, desc: 'page number for artworks list', default: 1
            optional :per_page, type: Integer, desc: 'specify how many artworks in a page, default to 25', default: 25
          end
          get do
            begin
              artworks = ExternalArtworkManager.new(current_user).latest(params[:artist_id])
              artworks = artworks.search_by_model params[:term] if params[:term].present?
              artworks = artworks.order('created_at DESC').page(page).per(per_page)
              success! artworks.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "return an external artwork data"
          params do
            optional :access_token, type: String, desc: 'User access token'
          end
          get '/:id' do
            begin
              artwork = ExternalArtworkManager.new(current_user).find(params[:id])
              success! artwork.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

        end
      end
    end
  end
end
