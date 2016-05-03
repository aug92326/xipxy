class Appraisal < ActiveRecord::Base
  include ActsAs::SharedApi

  belongs_to :financial_information, touch: true
  has_many :attachments, :as => :attachable, dependent: :destroy

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :financial_information_id
    t.add :name
    t.add :appraisal_price
    t.add :appraisal_at
    t.add lambda{ |art| art.attachments.as_api_response(:basic) rescue nil }, as: :attachments
    t.add :created_at
  end
end
