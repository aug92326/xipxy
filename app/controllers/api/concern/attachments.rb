require 'api_error'
require 'api_file_preprocessor'

module API
  module Concern
    module Attachments
      extend ActiveSupport::Concern
      included do
        segment :attachments do
          desc "return all attachments by attachable type and id"
          params do
            optional :access_token, type: String, desc: 'User access token'
            requires :attachable_type, type: String, values: Attachment.all_polymorphic_types(:attachable).map(&:to_s)
            requires :attachable_id, type: Integer
            optional :page, type: Integer, desc: 'page number for attachments list', default: 1
            optional :per_page, type: Integer, desc: 'specify how many attachments in a page, default to 25', default: 25
          end
          get do
            begin
              attachments = AttachmentManager.new(current_user).latest(params[:attachable_type], params[:id])
              attachments = attachments.order('created_at DESC').page(page).per(per_page)
              success! attachments.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "return an attachment data"
          params do
            optional :access_token, type: String, desc: 'User access token'
          end
          get '/:id' do
            begin
              attachment = AttachmentManager.new(current_user).find(params[:id])
              success! attachment.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "create a new attachment"
          params do
            optional :access_token, type: String, desc: 'User access token'
            requires :attachable_type, type: String, values: Attachment.all_polymorphic_types(:attachable).map(&:to_s)
            requires :attachable_id, type: Integer
            requires :name, type: String
            optional :public, coerce: Virtus::Attribute::Boolean
            optional :file, type: Hash do
              optional :data, type: String, desc: 'Base64-encoded file data'
              optional :file_name, type: String, desc: 'file file name'
              optional :content_type, type: String, values: %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document), desc: 'file content type'
            end
          end
          post do
            begin
              attachment_params = ActionController::Parameters.new(params).permit(:name, :attachable_type, :attachable_id, :public)
              tmp_file = ApiFilePreprocessor.new(params.file)
              attachment = AttachmentManager.new(current_user).new_attachment(attachment_params)
              attachment.file = tmp_file.process
              attachment.save
              tmp_file.clean

              after_save attachment, 200, 'attachment created', :basic
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "update exist attachment"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :attachable_type, type: String, values: Attachment.all_polymorphic_types(:attachable).map(&:to_s)
            optional :attachable_id, type: Integer
            optional :name, type: String
            optional :public, coerce: Virtus::Attribute::Boolean
            optional :file, type: Hash do
              optional :data, type: String, desc: 'Base64-encoded file data'
              optional :file_name, type: String, desc: 'file file name'
              optional :content_type, type: String, values: %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document), desc: 'file content type'
            end
          end
          put ':id' do
            begin
              attachment_params = ActionController::Parameters.new(params).permit(:name, :attachable_type, :attachable_id, :public)
              attachmentl = AttachmentManager.new(current_user).find(params[:id])
              attachment = AttachmentManager.new(current_user).update_attachment(params[:id], attachment_params)
              if params.file.present? && params.file.keys.length == 3 &&
                  params.file.keys.all? { |key| %i(content_type file_name data).include?key.to_sym }
                @tmp_file = ApiFilePreprocessor.new(params.file)
                attachmentl.update(file: @tmp_file.process)
              end

              @tmp_file.clean if params.file.present?

              after_save attachment, 200, 'attachment updated', :light
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

          desc "delete exist attachment"
          params do
            optional :access_token, type: String, desc: 'User access token'
          end
          delete ':id' do
            begin
              attachment = AttachmentManager.new(current_user).delete_attachment(params[:id])
              success! attachment.as_api_response(:basic), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end
        end
      end
    end
  end
end
