class Record < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ActsAs::SharedApi
  include PgSearch

  def as_indexed_json args={}
    self.as_json({
                   methods: [:avatar_url_small],
                   only: [:id, :model, :avatar_url_small]
                 })
  end

  settings analysis: {
      filter: { model_ngrams: { side: 'front', max_gram: 20, min_gram: 2, type: 'edgeNGram' } },
      analyzer: { full_model_name: { filter: ["standard", "lowercase", "model_ngrams"], type: 'custom', tokenizer: 'letter'} }
    } do
      mappings dynamic: 'false' do
        indexes :model, analyzer: 'full_model_name'
      end
  end

  pg_search_scope :search_by_model,
    against: [:model],
    using: {
        tsearch: { prefix: true, any_word: true }
    }

  LIST_OF_MEDIUM = [
    'Book',
    'Design & Objects',
    'Documentation',
    'Film & Video',
    'Installation & Mixed Media',
    'New Media',
    'Painting',
    'Photography',
    'Performance',
    'Prints & Multiples',
    'Sculpture',
    'Sound',
    'Work on Paper'
  ]

  has_one :artist, class_name: RecordsArtist, foreign_key: :record_id, dependent: :destroy
  has_many :multiple_objects, class_name: ArtworkMultipleObject, foreign_key: :record_id, dependent: :destroy
  has_many :editions, dependent: :destroy

  has_many :locations, class_name: 'Location', through: :editions, source: :location

  has_many :images, -> {where(editions: {primary: true})}, class_name: 'Image', through: :editions, source: :images
  has_and_belongs_to_many :users
  has_many :collections_lists, class_name: 'RecordsCollectionsList', foreign_key: :record_id, dependent: :destroy
  has_many :collections, through: :collections_lists, source: :records_collection

  validates :model, presence: true
  validate :system_valid

  after_create :ensure_primary_edition

  store_accessor :size, :height, :width, :depth
  store_accessor :weight, :standard, :metric
  store_accessor :year, :estimated, :value
  store_accessor :duration, :hours, :minutes, :seconds

  api_accessible :light do |t|
    t.add :id
    t.add lambda{ |art| art.owner.user.as_api_response(:basic) rescue nil }, as: :owner
    t.add :avatar_url
    t.add lambda{ |art| art.artist.as_api_response(:basic) rescue nil }, as: :artist
    t.add lambda{ |art| art.primary_edition.financial_information.price rescue nil }, as: :price
    t.add lambda{ |art| art.primary_edition.as_api_response(:statuses) rescue nil }, as: :statuses
    t.add :model
    t.add :updated_at
    t.add lambda{ |art| art.convert_year rescue nil }, as: :year
  end

  api_accessible :search_results do |t|
    t.add :id
    t.add :model
    t.add :avatar_url
    t.add :updated_at
  end

  api_accessible :default do |t|
    t.add :id
    t.add :model
    t.add :medium
    t.add lambda{ |art| art.convert_year rescue nil }, as: :year
    t.add :material
    t.add :system
    t.add lambda{ |art| BaseUnitSystem.weight_to_json(art.weight) rescue nil }, as: :weight
    t.add lambda{ |art| DurationManager.new(art).view_convertor rescue nil }, as: :duration
    t.add lambda{ |art| BaseUnitSystem.size_to_json(art.size) rescue nil }, as: :size
    t.add :created_at
    t.add :updated_at
    t.add lambda{ |art| art.artist.as_api_response(:basic) rescue nil }, as: :artist
    t.add lambda{ |art| art.owner.user.as_api_response(:basic) rescue nil }, as: :owner
  end

  api_accessible :basic, extend: :default do |t|
    t.add lambda{ |art| art.multiple_objects.as_api_response(:basic) rescue nil }, as: :multiple_objects
    t.add lambda{ |art| art.editions.order('').as_api_response(:basic) rescue nil }, as: :editions
  end

  api_accessible :view_mode, extend: :default do |t|
    t.add lambda{ |art| art.multiple_objects.size rescue 0 }, as: :multiples_all_size
    t.add lambda{ |art| art.multiple_objects.first(3).as_api_response(:basic) rescue nil }, as: :multiple_objects
    t.add lambda{ |art| art.editions.order('').as_api_response(:view_mode) rescue nil }, as: :editions
  end

  def convert_year
    {estimated: year['estimated'] == "true", value: year['value']}
  end

  def avatar_url
    image = images.where(primary: true)[0]
    if image.present?
      image.image_with_size
    else
      { small: ActionController::Base.helpers.asset_path('default_artwork_picture.png') }
    end
  end

  def avatar_url_small
    image = images.where(primary: true)[0]
    image.present? ? absolute_url(image.image.url(:small)) : ActionController::Base.helpers.asset_path('default_artwork_picture.png')
  end

  def primary_edition
    editions.where(primary: true).first
  end

  def owner
    RecordsUser.where(record_id: id).owner
  end

  def set_owner user
    RecordsUser.create({user_id: user.id, record_id: id, owner: true})
  end

  private

  def ensure_primary_edition
    editions.create(primary: true)
    true
  end

  def system_valid
    errors.add(:system, "Can't be something") unless ['metric','standard'].include? system
  end
end