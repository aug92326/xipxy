class ExternalArtwork < ActiveRecord::Base
  include ActsAs::SharedApi
  belongs_to :artist

  validate :system_valid

  include PgSearch
  pg_search_scope :search_by_model,
    against: [:model],
    using: {
        tsearch: { prefix: true, any_word: true }
    }

  store_accessor :size, :height, :width, :depth
  store_accessor :weight, :standard, :metric
  store_accessor :duration, :hours, :minutes, :seconds

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :model
    t.add :year
    t.add :material
    t.add :system
    t.add lambda{ |art| BaseUnitSystem.weight_to_json(art.weight) rescue nil }, as: :weight
    t.add lambda{ |art| DurationManager.new(art).view_convertor rescue nil }, as: :duration
    t.add lambda{ |art| BaseUnitSystem.size_to_json(art.size) rescue nil }, as: :size
    t.add :created_at
    t.add lambda{ |art| art.artist.as_api_response(:basic) rescue nil }, as: :artist
  end

  private
  def system_valid
    errors.add(:system, "Can't be something") unless ['metric','standard'].include? system
  end
end