class Edition < ActiveRecord::Base
  include ActsAs::SharedApi

  belongs_to :record, touch: true
  has_one :location, class_name: Location, foreign_key: :edition_id, dependent: :destroy
  has_one :financial_information, dependent: :destroy
  has_many :appraisals, through: :financial_information
  has_many :exhibition_histories, dependent: :destroy
  has_many :ownerships, class_name: PriorOwnership, foreign_key: :edition_id, dependent: :destroy
  has_many :publications, dependent: :destroy
  has_and_belongs_to_many :tags, dependent: :destroy

  has_one :details, class_name: DetailsArtwork, foreign_key: :edition_id, dependent: :destroy
  has_one :admin, class_name: EditionAdmin, foreign_key: :edition_id, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :attachments, :as => :attachable, dependent: :destroy
  has_many :financial_informations_attachments, through: :financial_information, source: :attachments
  has_many :appraisals_attachments, through: :appraisals, source: :attachments


  after_create :ensure_financial_information, :ensure_location, :ensure_details, :ensure_admin, unless: :is_from_primary

  delegate :owner, :to => :record

  api_accessible :light do |t|
    t.add :id
    t.add :record_id
  end

  api_accessible :statuses do |t|
    t.add :primary_status
    t.add :secondary_status
  end

  api_accessible :default do |t|
    t.add :id
    t.add :record_id
    t.add :edition_type
    t.add :primary_status
    t.add :secondary_status
    t.add :authenticator
    t.add :authenticity_id
    t.add :notes
    t.add :primary
    t.add lambda{ |art| art.location.as_api_response(:basic) rescue nil }, as: :location
    t.add lambda{ |art| art.tags.as_api_response(:basic) rescue nil }, as: :tags
    t.add lambda{ |art| art.admin.as_api_response(:basic) rescue nil }, as: :admin
    t.add lambda{ |art| art.details.as_api_response(:basic) rescue nil }, as: :details
    t.add lambda{ |art| art.images.as_api_response(:basic) rescue nil }, as: :images
    t.add lambda{ |art| art.all_attachments.as_api_response(:basic) rescue nil }, as: :attachments

    t.add :created_at
  end

  api_accessible :basic, extend: :default do |t|
    t.add lambda{ |art| art.exhibition_histories.as_api_response(:basic) rescue nil }, as: :exhibition_histories
    t.add lambda{ |art| art.ownerships.as_api_response(:basic) rescue nil }, as: :ownerships
    t.add lambda{ |art| art.publications.as_api_response(:basic) rescue nil }, as: :publications
    t.add lambda{ |art| art.financial_information.as_api_response(:basic) rescue nil }, as: :financial_information
  end

  api_accessible :view_mode, extend: :default do |t|
    t.add lambda{ |art| art.exhibition_histories.first(3).as_api_response(:basic) rescue nil }, as: :exhibition_histories
    t.add lambda{ |art| art.ownerships.first(3).as_api_response(:basic) rescue nil }, as: :ownerships
    t.add lambda{ |art| art.publications.first(3).as_api_response(:basic) rescue nil }, as: :publications
    t.add lambda{ |art| art.exhibition_histories.size rescue 0 }, as: :exhibitions_all_size
    t.add lambda{ |art| art.ownerships.size rescue 0 }, as: :ownerships_all_size
    t.add lambda{ |art| art.publications.size rescue 0 }, as: :publications_all_size
    t.add lambda{ |art| art.financial_information.as_api_response(:view_mode) rescue nil }, as: :financial_information
  end


  def all_attachments
    attachments + financial_informations_attachments + appraisals_attachments
  end

  def ensure_financial_information
    create_financial_information
    true
  end

  def ensure_location
    create_location
    true
  end

  def ensure_details
    create_details
    true
  end

  def ensure_admin
    create_admin(record_date: DateTime.now, xipsy_artwork_id: sprintf('%04d', id), xipsy_record_number: id)
    true
  end
end
