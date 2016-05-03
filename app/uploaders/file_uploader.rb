# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  before :cache, :save_original_filename

  def save_original_filename(file)
    model.original_filename ||= file.original_filename if file.respond_to?(:original_filename)
  end

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper
  if Rails.env.production? || Rails.env.staging?
    storage :fog
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    random_token = Digest::SHA2.hexdigest("#{Time.now.utc}--#{model.id.to_s}").first(40)
    ivar = "@#{mounted_as}_secure_token"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, random_token)
    "#{token}.#{file.extension}" if original_filename
  end

end