require 'api_error'

module API
  module Concern
    module Tags
      extend ActiveSupport::Concern
      included do
        segment :records do
          route_param :record_id do
            segment :editions do
              route_param :edition_id do
                segment :tags do
                  desc "return all tags data"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :page, type: Integer, desc: 'page number for tags list', default: 1
                    optional :per_page, type: Integer, desc: 'specify how many tags in a page, default to 25', default: 25
                  end
                  get do
                    begin
                      tags = EditionManager.new(current_user).tags(params[:edition_id])
                      tags = tags.order('created_at DESC').page(page).per(per_page)
                      success! tags.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "return an tag data"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                  end
                  get '/:id' do
                    begin
                      tag = EditionManager.new(current_user).find_tag(params[:id])
                      success! tag.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "create a new tag"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    requires :slug, type: String
                  end
                  post  do
                    begin
                      tag_params = ActionController::Parameters.new(params).permit(:slug)
                      tag = EditionManager.new(current_user).create_tag(params[:edition_id], tag_params)
                      success! tag.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "update exist tag"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :slug, type: String
                  end
                  put '/:id' do
                    begin
                      tag_params = ActionController::Parameters.new(params).permit(:slug)
                      tag = EditionManager.new(current_user).update_tag(params[:id], tag_params)
                      success! tag.as_api_response(:light), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "delete exist tag"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                  end
                  delete '/:id' do
                    begin
                      tag = EditionManager.new(current_user).delete_tag(params[:id])
                      success! tag.as_api_response(:basic), 200
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
end
