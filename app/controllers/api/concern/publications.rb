require 'api_error'

module API
  module Concern
    module Publications
      extend ActiveSupport::Concern
      included do
        segment :records do
          route_param :record_id do
            segment :editions do
              route_param :edition_id do
                segment :publications do
                  desc "return all publications data"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :page, type: Integer, desc: 'page number for publications list'
                    optional :per_page, type: Integer, desc: 'specify how many publications in a page'
                  end
                  get do
                    begin
                      publications = EditionManager.new(current_user).publications(params[:edition_id])
                      publications = publications.page(page).per(per_page) if params[:per_page].present?
                      success! publications.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "return an publication data"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                  end
                  get '/:id' do
                    begin
                      publication = EditionManager.new(current_user).find_publication(params[:id])
                      success! publication.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "create a new publication"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :source, type: String
                    optional :title, type: String
                    optional :author, type: String
                    optional :date, type: DateTime
                    optional :link, type: String
                  end
                  post  do
                    begin
                      publication_params = ActionController::Parameters.new(params).permit(:source, :title, :date, :link, :author)
                      publication = EditionManager.new(current_user).create_publication(params[:edition_id], publication_params)
                      success! publication.as_api_response(:basic), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "update exist publication"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                    optional :source, type: String
                    optional :title, type: String
                    optional :author, type: String
                    optional :date, type: DateTime
                    optional :link, type: String
                  end
                  put '/:id' do
                    begin
                      publication_params = ActionController::Parameters.new(params).permit(:source, :title, :date, :link, :author)
                      publication = EditionManager.new(current_user).update_publication(params[:id], publication_params)
                      success! publication.as_api_response(:light), 200
                    rescue => e
                      throw_error! 403, e.class.to_s, e.message
                    end
                  end

                  desc "delete exist publication"
                  params do
                    optional :access_token, type: String, desc: 'User access token'
                  end
                  delete '/:id' do
                    begin
                      publication = EditionManager.new(current_user).delete_publication(params[:id])
                      success! publication.as_api_response(:basic), 200
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
