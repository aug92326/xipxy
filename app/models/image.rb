class Image < ActiveRecord::Base
  include ActsAs::SharedApi

  belongs_to :edition, touch: true

  store_accessor :crop, :crop_x, :crop_y, :crop_w, :crop_h
  mount_uploader :image, ImageUploader

  def crop_image
    image.recreate_versions! unless crop.crop_x.blank?
  end

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :edition_id
    t.add :copyright_holder
    t.add :licensing_agency
    t.add :primary
    t.add :image_with_size, as: :image
    t.add lambda{ |img| img.image.size rescue nil }, as: :file_size
    t.add :original_filename, as: :file_name
    t.add :resolution
    t.add :credit_line
    t.add :licensing_fee
    t.add :download
    t.add :crop
    t.add :created_at
  end

  def image_with_size
    {
      large:    absolute_url(self.image.url(:large)),
      medium:   absolute_url(self.image.url(:medium)),
      small:    absolute_url(self.image.url(:small)),
    }
  end
end
