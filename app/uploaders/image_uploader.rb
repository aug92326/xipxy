# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
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

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Process files as they are uploaded:
  process :resize_to_limit => [550, nil]

  version :large do
    # process :cropper
    process :resize_to_limit => [550, nil]
  end

  version :medium do
    # process :cropper
    process :resize_to_limit => [350, nil]
  end

  version :small do
    process :resize_to_limit => [120, nil]
  end

  def cropper
    manipulate! do |img|
      x = model.crop_x.to_i
      y = model.crop_y.to_i
      w = model.crop_w.to_i
      h = model.crop_h.to_i
      img.crop "#{w}x#{h}+#{x}+#{y}"
      img
    end
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
    random_token = Digest::SHA2.hexdigest("#{Time.now.utc}--#{model.id.to_s}").first(40)
    ivar = "@#{mounted_as}_secure_token"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, random_token)
    "#{token}.#{file.extension}" if original_filename
  end

end