CarrierWave.configure do |config|

  if Rails.env.production? || Rails.env.staging?
    config.fog_credentials = {
        :provider               => 'AWS',                        # required
        :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],                        # required
        :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
        :region                 => 'us-west-1'   # required
    }
    config.fog_public     = true                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}

    config.fog_directory  = ENV['S3_BUCKET_NAME']                     # required
  end

end