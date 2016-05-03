require 'api_error'

module API
  module Concern
    module RecordsSearch
      extend ActiveSupport::Concern
      included do
        segment :records_search do
          desc "return all records data by search"
          params do
            optional :access_token, type: String, desc: 'User access token'
            optional :term, type: String, desc: 'search term'
          end

          get do
            begin
              query = params[:term].gsub('"', %q(\\\")).gsub("/", %q(\\\/))
              results = Record.search query: { match: { model: query } }, highlight: { fields: { keyword: {} } }

              success! results.records.as_api_response(:search_results), 200
            rescue => e
              throw_error! 403, e.class.to_s, e.message
            end
          end

        end
      end
    end
  end
end
