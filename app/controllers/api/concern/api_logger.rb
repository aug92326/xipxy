module API
  class Concern::ApiLogger < Grape::Middleware::Base
  
    def before
      Rails.logger.info "[api] Requested: #{request_log_data}\n" +
       "[api] #{response_log_data[:description]} #{response_log_data[:source_file]}:#{response_log_data[:source_line]}"
    end
    
  private
   
    def request_log_data
      # Escape the ampersand in the POST data.
      # rack_input = env["rack.input"].gets

      request_data = {
        method: env['REQUEST_METHOD'],
        path:   env['PATH_INFO'],
        ip:     env['REMOTE_ADDR'],
        query:  env['QUERY_STRING'],
        data: env['rack.request.form_hash']
      }.to_s.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
      request_data
    end

    def response_log_data
      {
        description: env['api.endpoint'].options[:route_options][:description],
        source_file: env['api.endpoint'].source.source_location[0][(Rails.root.to_s.length+1)..-1],
        source_line: env['api.endpoint'].source.source_location[1]
      }
    end
   
  end
end