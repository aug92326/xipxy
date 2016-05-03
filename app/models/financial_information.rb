class FinancialInformation < ActiveRecord::Base
  include ActsAs::SharedApi

  belongs_to :edition, touch: true
  has_many :appraisals, dependent: :destroy
  has_many :attachments, :as => :attachable, dependent: :destroy

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :default do |t|
    t.add :id
    t.add :edition_id
    t.add :price
    t.add :insured_price
    t.add :insured_type
    t.add :insurance_provider
    t.add lambda{ |art| art.attachments.as_api_response(:basic) rescue nil }, as: :attachments
    t.add :policy
    t.add :created_at
  end

  api_accessible :basic, extend: :default do |t|
    t.add lambda{ |art| art.appraisals.as_api_response(:basic) rescue nil }, as: :appraisals
  end

  api_accessible :view_mode, extend: :default do |t|
    t.add lambda{ |art| art.appraisals.first(3).as_api_response(:basic) rescue nil }, as: :appraisals
    t.add lambda{ |art| art.appraisals.size rescue 0 }, as: :appraisals_all_size
  end
end
