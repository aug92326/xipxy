module API
  module Concern::Status
    extend ActiveSupport::Concern
    included do
      desc "Returns the status of the API"
      get '/status' do
        { status: 'ok', time: DateTime.now, version: '1.0.1' }
      end
    end
  end
end
