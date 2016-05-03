require 'api_error'

module API
  module Concern
    module RecordsMultipleObjects
      extend ActiveSupport::Concern
      included do
        segment :records do
          route_param :record_id do
            desc "show list of record multiple objects"
            params do
              optional :access_token, type: String, desc: 'User access token'
              optional :page, type: Integer, desc: 'page number for objects list'
              optional :per_page, type: Integer, desc: 'specify how many objects in a page'
            end
            get '/multiple_objects' do
              begin
                multiple_objects = RecordManager.new(current_user).multiple_objects(params[:record_id])
                multiple_objects = multiple_objects.page(page).per(per_page) if params[:per_page].present?

                success! multiple_objects.as_api_response(:basic), 200
              rescue => e
                throw_error! 403, e.class.to_s, e.message
              end
            end

            desc "show multiple object"
            params do
              optional :access_token, type: String, desc: 'User access token'
            end
            get '/multiple_objects/:id' do
              begin
                multiple_object = RecordManager.new(current_user).find_multiple_object(params[:id])
                success! multiple_object.as_api_response(:basic), 200
              rescue => e
                throw_error! 403, e.class.to_s, e.message
              end
            end

            desc "create multiple object"
            params do
              optional :access_token, type: String, desc: 'User access token'
              optional :name, type: String, desc: 'Edition name'
              optional :material, type: String, desc: 'Edition material'
              optional :duration, type: Hash, desc: 'Edition duration' do
                optional :hours, type: Integer, desc: 'duration hours'
                optional :minutes, type: Integer, desc: 'duration minutes'
                optional :seconds, type: Integer, desc: 'duration seconds'
              end
              optional :system, type: String, desc: 'Edition system', values: ['standard', 'metric']
              optional :weight, type: Float, desc: 'Edition weight'
              optional :size, type: Hash do
                optional :height, type: Float, desc: 'Edition height'
                optional :width, type: Float, desc: 'Edition width'
                optional :depth, type: Float, desc: 'Edition depth'
              end
            end
            post '/multiple_objects' do
              begin
                multiple_object_params = ActionController::Parameters.new(params).permit(:name, :material, :system, :weight, duration: [:hours, :minutes, :seconds], size: [:height, :width, :depth])
                multiple_object = RecordManager.new(current_user).create_multiple_object(params[:record_id], multiple_object_params)
                success! multiple_object.as_api_response(:basic), 200
              rescue => e
                throw_error! 403, e.class.to_s, e.message
              end
            end

            desc "update multiple object"
            params do
              optional :access_token, type: String, desc: 'User access token'
              optional :name, type: String, desc: 'Edition name'
              optional :material, type: String, desc: 'Edition material'
              optional :duration, type: Hash, desc: 'Edition duration' do
                optional :hours, type: Integer, desc: 'duration hours'
                optional :minutes, type: Integer, desc: 'duration minutes'
                optional :seconds, type: Integer, desc: 'duration seconds'
              end
              optional :system, type: String, desc: 'Edition system', values: ['standard', 'metric']
              optional :weight, type: Float, desc: 'Edition weight'
              optional :size, type: Hash do
                optional :height, type: Float, desc: 'Edition height'
                optional :width, type: Float, desc: 'Edition width'
                optional :depth, type: Float, desc: 'Edition depth'
              end
            end
            put '/multiple_objects/:id' do
              begin
                multiple_object_params = ActionController::Parameters.new(params).permit(:name, :material, :duration, :system, :weight, duration: [:hours, :minutes, :seconds], size: [:height, :width, :depth])
                multiple_object = RecordManager.new(current_user).update_multiple_object(params[:id], multiple_object_params)
                success! multiple_object.as_api_response(:light), 200
              rescue => e
                throw_error! 403, e.class.to_s, e.message
              end
            end

            desc "detele record edition"
            params do
              optional :access_token, type: String, desc: 'User access token'
            end
            delete '/multiple_objects/:id' do
              begin
                multiple_object = RecordManager.new(current_user).delete_multiple_object(params[:id])
                success! multiple_object.as_api_response(:basic), 200
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
