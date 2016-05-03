require 'api_error'
require 'api_file_preprocessor'

module API
  module Concern
    module EditionsDocuments
      extend ActiveSupport::Concern
      included do
        segment :records do
          route_param :record_id do
            segment :editions do
              route_param :edition_id do
                desc "show list of documents "
                params do
                  optional :access_token, type: String, desc: 'User access token'
                  optional :page, type: Integer, desc: 'page number for documents list', default: 1
                  optional :per_page, type: Integer, desc: 'specify how many documents in a page, default to 25', default: 25
                end
                get '/documents' do
                  begin
                    files = RecordManager.new(current_user).files(params[:edition_id])
                    files = files.order('created_at DESC').page(page).per(per_page)
                    success! files.as_api_response(:basic), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "show documents file"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                end
                get '/documents/:id' do
                  begin
                    file = RecordManager.new(current_user).find_file(params[:id])
                    success! file.as_api_response(:basic), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "create document file"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                  optional :title, type: String
                  optional :public, coerce: Virtus::Attribute::Boolean
                  optional :file, type: Hash do
                    optional :data, type: String, desc: 'Base64-encoded file data'
                    optional :file_name, type: String, desc: 'file file name'
                    optional :content_type, type: String, values: %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document), desc: 'file content type'
                  end
                end
                post '/documents' do
                  begin
                    file_params = ActionController::Parameters.new(params).permit(:title, :public)
                    tmp_file = ApiFilePreprocessor.new(params.file)
                    edition = Edition.find params[:edition_id]
                    file = RecordManager.new(current_user).new_file(edition, file_params)
                    file.file = tmp_file.process
                    file.save
                    tmp_file.clean

                    after_save file, 200, 'file created', :basic
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "update document file"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                  optional :title, type: String
                  optional :public, coerce: Virtus::Attribute::Boolean
                  optional :file, type: Hash do
                    optional :data, type: String, desc: 'Base64-encoded file data'
                    optional :file_name, type: String, desc: 'file file name'
                    optional :content_type, type: String, values: %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document), desc: 'file content type'
                  end
                end
                put '/documents/:id' do
                  begin
                    file_params = ActionController::Parameters.new(params).permit(:title, :public)
                    filel = Document.find params[:id]
                    file = RecordManager.new(current_user).update_file(filel.id, file_params)
                    if params.file.present? && params.file.keys.length == 3 &&
                      params.file.keys.all? { |key| %i(content_type file_name data).include?key.to_sym }
                      @tmp_file = ApiFilePreprocessor.new(params.file)
                      filel.update(file: @tmp_file.process)
                    end
                    @tmp_file.clean if params.file.present?

                    after_save file, 200, 'file updated', :light
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "detele document file"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                end
                delete '/documents/:id' do
                  begin
                    file = RecordManager.new(current_user).delete_file(params[:id])
                    success! file.as_api_response(:basic), 200
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
