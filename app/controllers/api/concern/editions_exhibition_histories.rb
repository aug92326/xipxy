require 'api_error'

module API
  module Concern
    module EditionsExhibitionHistories
      extend ActiveSupport::Concern
      included do
        segment :records do
          route_param :record_id do
            segment :editions do
              route_param :edition_id do
                desc "show list of edition exhibition histories"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                  optional :page, type: Integer, desc: 'page number for histories list'
                  optional :per_page, type: Integer, desc: 'specify how many histories in a page'
                end
                get '/exhibition_histories' do
                  begin
                    exhibition_histories = EditionManager.new(current_user).exhibition_histories(params[:edition_id])
                    exhibition_histories = exhibition_histories.page(page).per(per_page) if params[:per_page].present?
                    success! exhibition_histories.as_api_response(:basic), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "show edition exhibition history"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                end
                get '/exhibition_histories/:id' do
                  begin
                    exhibition_histories = EditionManager.new(current_user).find_exhibition_history(params[:id])
                    success! exhibition_histories.as_api_response(:basic), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "create edition exhibition history"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                  optional :displayed_by, type: String
                  optional :displayed_at, type: String
                  optional :title, type: String
                  optional :start_date, type: DateTime
                  optional :end_date, type: DateTime
                end
                post '/exhibition_histories' do
                  begin
                    exhibition_history_params = ActionController::Parameters.new(params).permit(:displayed_by, :displayed_at, :title, :start_date, :end_date)
                    exhibition_history = EditionManager.new(current_user).create_exhibition_history(params[:edition_id], exhibition_history_params)
                    success! exhibition_history.as_api_response(:basic), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "update edition exhibition_history"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                  optional :displayed_by, type: String
                  optional :displayed_at, type: String
                  optional :title, type: String
                  optional :start_date, type: DateTime
                  optional :end_date, type: DateTime
                end
                put '/exhibition_histories/:id' do
                  begin
                    exhibition_history_params = ActionController::Parameters.new(params).permit(:displayed_by, :displayed_at, :title, :start_date, :end_date)
                    exhibition_history = EditionManager.new(current_user).update_exhibition_history(params[:id], exhibition_history_params)
                    success! exhibition_history.as_api_response(:light), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "detele edition exhibition_history"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                end
                delete '/exhibition_histories/:id' do
                  begin
                    exhibition_history = EditionManager.new(current_user).delete_exhibition_history(params[:id])
                    success! exhibition_history.as_api_response(:basic), 200
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
