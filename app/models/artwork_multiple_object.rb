class ArtworkMultipleObject < ActiveRecord::Base
  include ActsAs::SharedApi
  belongs_to :record, touch: true

  store_accessor :size, :height, :width, :depth
  store_accessor :weight, :standard, :metric
  store_accessor :duration, :hours, :minutes, :seconds

  # validates :name, presence: true, :uniqueness => {:scope => :record_id}
  validate :system_valid

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :record_id
    t.add :name
    t.add :material
    t.add lambda{ |art| DurationManager.new(art).view_convertor rescue nil }, as: :duration
    t.add :system
    t.add lambda{ |art| BaseUnitSystem.weight_to_json(art.weight) rescue nil }, as: :weight
    t.add lambda{ |art| BaseUnitSystem.size_to_json(art.size) rescue nil }, as: :size
    t.add :created_at
  end

  private

  def system_valid
    errors.add(:system, "Can't be something") unless ['metric','standard'].include? system
  end
end
