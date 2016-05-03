class DetailsArtwork < ActiveRecord::Base
  include ActsAs::SharedApi
  belongs_to :edition, touch: true

  validate :system_valid

  store_accessor :frame, :height, :width, :depth

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :edition_id
    t.add :manufacturer
    t.add :designer
    t.add :period
    t.add :packaging
    t.add :unique_marks
    t.add :additional_information
    t.add :system
    t.add lambda{ |art| BaseUnitSystem.size_to_json(art.frame) rescue nil }, as: :frame
    t.add :created_at
  end

  private
  def system_valid
    errors.add(:system, "Can't be something") unless ['metric','standard'].include? system
  end

end
