require 'api_error'

module API
  module Concern
    module Records
      extend ActiveSupport::Concern
      included do
        segment :records do
          desc "return all records data"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :search_keyword, type: String, desc: 'Keyword for search'
            optional :filters, type: Hash do
              optional :artists, type: String, desc: 'Artists List. Please use ", " as separator.'
              optional :categories, type: String, desc: 'Categories. List Please use ", " as separator.'
              optional :locations, type: String, desc: 'Locations List. Please use ", " as separator.'
              optional :statuses, type: String, desc: 'Statuses List. Please use ", " as separator.'
              optional :start_years, type: String, desc: 'Start year List. Please use ", " as separator.'
            end
            optional :sorts, type: Hash do
              optional :sort_by, type: String, values: ['alphabetical']
              optional :direction, type: String, values: ['asc', 'desc']
            end
            optional :page, type: Integer, desc: 'page number for records list', default: 1
            optional :per_page, type: Integer, desc: 'specify how many records in a page, default to 25', default: 25
          end
          get do
            begin
              record_params = ActionController::Parameters.new(params).permit(:search_keyword, :page, :per_page, filters: [:artists, :categories, :locations, :statuses, :start_years],
                                                                            sorts: [:sort_by, :direction])

              records = ::RecordSearch::Base.new(current_user).find_by record_params

              success! ({"all_records_count" => records[:all_size],
                         "available_filters" => records[:available_filters],
                         "records" => records[:paged].as_api_response(:light)
                       }), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "return an record data"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :edit_mode, coerce: Virtus::Attribute::Boolean, desc: '1 or 0'
          end
          get '/:id' do
            begin
              record = RecordManager.new(current_user).find(params[:id])
              success! record.as_api_response(params[:edit_mode].present? ? :basic : :view_mode), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "create a new record"
          params do
            optional :access_token, type: String, desc: 'User access token'
            requires :model, type: String, desc: 'Artwork height'
            optional :medium, type: String, desc: 'Artwork medium'
            optional :artist, type: Hash, desc: 'Artwork artist' do
              optional :brand, type: String, desc: 'Artist Name'
              optional :country, type: String, desc: 'Artist country'
              optional :founded, type: Integer, desc: 'Artist Birth year'
              optional :closed, type: Integer, desc: 'Artist Death year'
            end
            optional :year, type: Hash, desc: 'Artwork year' do
              optional :value, type: Integer, desc: 'Artwork year value'
              optional :estimated, coerce: Virtus::Attribute::Boolean, desc: 'Artwork year estimated? 1 or 0'
            end
            optional :material, type: String, desc: 'Artwork material'
            optional :system, type: String, values: %w(standard metric), default: 'metric', desc: 'system, can standard or metric'
            optional :weight, type: Float, desc: 'Artwork weight'
            optional :duration, type: Hash, desc: 'Artwork duration' do
              optional :hours, type: Integer, desc: 'duration hours'
              optional :minutes, type: Integer, desc: 'duration minutes'
              optional :seconds, type: Integer, desc: 'duration seconds'
            end
            optional :size, type: Hash, desc: 'Artwork sizes' do
              optional :height, type: Float, desc: 'Artwork height'
              optional :width, type: Float, desc: 'Artwork width'
              optional :depth, type: Float, desc: 'Artwork depth'
            end
          end
          post do
            begin
              record_params = ActionController::Parameters.new(params).permit(:model, :medium, :material, :system, :weight,
                duration: [:hours, :minutes, :seconds], artist: [:brand, :country, :founded, :closed], size: [:height, :width, :depth], year: [:value, :estimated])
              record = RecordManager.new(current_user).create_record(record_params)

              after_save record, 200, 'empty record created', :basic
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "update exist records"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :model, type: String, desc: 'Artwork height'
            optional :medium, type: String, desc: 'Artwork medium'
            optional :artist, type: Hash, desc: 'Artwork artist' do
              optional :brand, type: String, desc: 'Artist Name'
              optional :country, type: String, desc: 'Artist country'
              optional :founded, type: Integer, desc: 'Artist Birth year'
              optional :closed, type: Integer, desc: 'Artist Death year'
            end
            optional :year, type: Hash, desc: 'Artwork year' do
              optional :value, type: Integer, desc: 'Artwork year value'
              optional :estimated, coerce: Virtus::Attribute::Boolean, desc: 'Artwork year estimated? 1 or 0'
            end
            optional :material, type: String, desc: 'Artwork material'
            optional :system, type: String, desc: 'Artwork system', values: ['standard', 'metric']
            optional :weight, type: Float, desc: 'Artwork weight'
            optional :duration, type: Hash, desc: 'Artwork duration' do
              optional :hours, type: Integer, desc: 'duration hours'
              optional :minutes, type: Integer, desc: 'duration minutes'
              optional :seconds, type: Integer, desc: 'duration seconds'
            end
            optional :size, type: Hash, desc: 'Artwork sizes' do
              optional :height, type: Float, desc: 'Artwork height'
              optional :width, type: Float, desc: 'Artwork width'
              optional :depth, type: Float, desc: 'Artwork depth'
            end
          end
          put ':id' do
            begin
              record_params = ActionController::Parameters.new(params).permit(:model, :medium, :material, :system, :weight,
                                                                              duration: [:hours, :minutes, :seconds], size: [:height, :width, :depth], artist: [:brand, :country, :founded, :closed], year: [:value, :estimated]
              )

              record = RecordManager.new(current_user).update_record(params[:id], record_params)
              success! record.as_api_response(:light), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "delete exist record"
          params do
            optional :access_token, type: String, desc: 'User access token'
          end
          delete ':id' do
            begin
              record = RecordManager.new(current_user).delete_record(params[:id])
              success! record.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end
        end
      end
    end
  end
end
