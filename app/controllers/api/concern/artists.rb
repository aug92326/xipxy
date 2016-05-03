require 'api_error'

module API
  module Concern
    module Artists
      extend ActiveSupport::Concern
      included do
        segment :artists do
          desc "return all artists data"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :term, type: String, desc: "The search term"
            optional :page, type: Integer, desc: 'page number for artists list', default: 1
            optional :per_page, type: Integer, desc: 'specify how many artists in a page, default to 25', default: 25
          end
          get do
            begin
              artists = ArtistManager.new(current_user).latest
              artists = artists.search_by_brand params[:term] if params[:term].present?
              artists = artists.order('created_at DESC').page(page).per(per_page)
              success! artists.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "return an artist data"
          params do
            optional :access_token, type: String, desc: 'User access token'
          end
          get '/:id' do
            begin
              artist = ArtistManager.new(current_user).find(params[:id])
              success! artist.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "create a new artist"
          params do
            optional :access_token, type: String, desc: 'User access token'
            requires :brand, type: String, desc: 'Artist Name'
            optional :country, type: String, desc: 'Artist country'
            optional :founded, type: Integer, desc: 'Artist Birth year'
            optional :closed, type: Integer, desc: 'Artist Death year'
          end
          post do
            begin
              artist_params = ActionController::Parameters.new(params).permit(:name, :brand, :country, :founded, :closed)
              artist = ArtistManager.new(current_user).create_artist(artist_params)
              success! artist.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "update exist artist"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :brand, type: String, desc: 'Artist Name'
            optional :country, type: String, desc: 'Artist country'
            optional :founded, type: Integer, desc: 'Artist Birth year'
            optional :closed, type: Integer, desc: 'Artist Death year'
          end
          put ':id' do
            begin
              artist_params = ActionController::Parameters.new(params).permit(:name, :brand, :country, :founded, :closed)
              artist = ArtistManager.new(current_user).update_artist(params[:id], artist_params)
              success! artist.as_api_response(:light), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "delete exist artist"
          params do
            optional :access_token, type: String, desc: 'User access token'
          end
          delete ':id' do
            begin
              artist = ArtistManager.new(current_user).delete_artist(params[:id])
              success! artist.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end
        end
      end
    end
  end
end
