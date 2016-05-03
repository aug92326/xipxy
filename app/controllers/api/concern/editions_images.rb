require 'api_error'
require 'api_image_preprocessor'

module API
  module Concern
    module EditionsImages
      extend ActiveSupport::Concern
      included do
        segment :records do
          route_param :record_id do
            segment :editions do
              route_param :edition_id do
                desc "show list of edition images"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                  optional :page, type: Integer, desc: 'page number for images list', default: 1
                  optional :per_page, type: Integer, desc: 'specify how many images in a page, default to 25', default: 25
                end
                get '/images' do
                  begin
                    images = RecordManager.new(current_user).images(params[:edition_id])
                    images = images.order('created_at DESC').page(page).per(per_page)
                    success! images.as_api_response(:basic), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "show edition image"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                end
                get '/images/:id' do
                  begin
                    image = RecordManager.new(current_user).find_image(params[:id])
                    success! image.as_api_response(:basic), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "create edition image"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                  optional :copyright_holder, type: String
                  optional :licensing_agency, type: String
                  optional :resolution, type: String
                  optional :credit_line, type: String
                  optional :licensing_fee, type: String
                  optional :download, coerce: Virtus::Attribute::Boolean
                  optional :primary, coerce: Virtus::Attribute::Boolean
                  optional :image, type: Hash do
                    optional :data, type: String, desc: 'Base64-encoded image data'
                    optional :file_name, type: String, desc: 'image file name'
                    optional :content_type, type: String, values: ['image/jpeg', 'image/jpg', 'image/png'], desc: 'image content type, default is image/jpeg'
                  end
                end
                post '/images' do
                  begin
                    image_params = ActionController::Parameters.new(params).permit(:copyright_holder, :licensing_agency, :resolution, :credit_line, :licensing_fee, :download, :primary)
                    tmp_image = ApiImagePreprocessor.new(params.image)
                    edition = Edition.find params[:edition_id]
                    image = RecordManager.new(current_user).new_image(edition, image_params)
                    image.image = tmp_image.process
                    image.save
                    tmp_image.clean

                    images = RecordManager.new(current_user).images(params[:edition_id])
                    success! images.as_api_response(:basic), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "update edition image"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                  optional :copyright_holder, type: String
                  optional :licensing_agency, type: String
                  optional :resolution, type: String
                  optional :credit_line, type: String
                  optional :licensing_fee, type: String
                  optional :download, coerce: Virtus::Attribute::Boolean
                  optional :primary, coerce: Virtus::Attribute::Boolean
                  optional :image, type: Hash do
                    optional :data, type: String, desc: 'Base64-encoded image data'
                    optional :file_name, type: String, desc: 'image file name'
                    optional :content_type, type: String, values: ['image/jpeg', 'image/jpg', 'image/png'], desc: 'image content type, default is image/jpeg'
                  end
                end
                put '/images/:id' do
                  begin
                    image_params = ActionController::Parameters.new(params).permit(:copyright_holder, :licensing_agency, :resolution, :credit_line, :licensing_fee, :download, :primary)
                    img = Image.find params[:id]
                    image = RecordManager.new(current_user).update_image(img.id, image_params)
                    if params.image.present? && params.image.keys.length == 3 &&
                      params.image.keys.all? { |key| %i(content_type file_name data).include?key.to_sym }
                      @tmp_image = ApiImagePreprocessor.new(params.image)
                      img.update(image: @tmp_image.process)
                    end
                    @tmp_image.clean if params.image.present?

                    images = RecordManager.new(current_user).images(params[:edition_id])
                    success! images.as_api_response(:basic), 200
                  rescue => e
                    throw_error! 403, e.class.to_s, e.message
                  end
                end

                desc "detele edition image"
                params do
                  optional :access_token, type: String, desc: 'User access token'
                end
                delete '/images/:id' do
                  begin
                    image = RecordManager.new(current_user).delete_image(params[:id])

                    images = RecordManager.new(current_user).images(params[:edition_id])
                    success! images.as_api_response(:basic), 200
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
