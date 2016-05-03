require 'api_error'

module API
  module Concern
    module Collections
      extend ActiveSupport::Concern
      included do
        segment :collections do
          desc "all collections for current user"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :page, type: Integer, desc: 'page number for collections list'
            optional :per_page, type: Integer, desc: 'specify how many collections in a page'
          end
          get do
            begin
              collections = CollectionManager.new(current_user).collections
              collections = collections.page(page).per(per_page) if params[:per_page].present?
              success! collections.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "return an collection data for current user"
          params do
            optional :access_token, type: String, desc: 'User access token'
          end
          get '/:id' do
            begin
              collection = CollectionManager.new(current_user).find(params[:id])
              success! collection.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "create a new collection"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :name, type: String, desc: 'name of collection'
          end
          post  do
            begin
              collection_params = ActionController::Parameters.new(params).permit(:name)
              collection = CollectionManager.new(current_user).create_collection(collection_params)
              success! collection.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "update exist collection"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :name, type: String, desc: 'name of collection'
          end
          put '/:id' do
            begin
              collection_params = ActionController::Parameters.new(params).permit(:name)
              collection = CollectionManager.new(current_user).update_collection(params[:id], collection_params)
              success! collection.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "add record to collection"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :record_id, type: Integer
          end
          post '/:id/record' do
            begin
              collection_params = ActionController::Parameters.new(params).permit(:record_id)
              collection = CollectionManager.new(current_user).add_record_to_collection(params[:id], collection_params)
              success! collection.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "remove record from collection"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :record_id, type: Integer
          end
          delete '/:id/record' do
            begin
              collection = CollectionManager.new(current_user).remove_record_from_collection(params[:id], params[:record_id])
              success! collection.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "delete exist collection"
          params do
            optional :access_token, type: String, desc: 'User access token'
          end
          delete '/:id' do
            begin
              collection = CollectionManager.new(current_user).delete_collection(params[:id])
              success! collection.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end
        end
      end
    end
  end
end
