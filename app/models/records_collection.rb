class RecordsCollection < ActiveRecord::Base
  include ActsAs::SharedApi
  belongs_to :user
  has_many :collections_lists, class_name: 'RecordsCollectionsList', foreign_key: :records_collection_id, dependent: :destroy
  has_many :records, through: :collections_lists, source: :record

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add lambda{ |art| art.owner.user.as_api_response(:basic) rescue nil }, as: :owner
    t.add lambda{ |art| art.records.as_api_response(:light) rescue nil }, as: :records
    t.add :name
    t.add :public
  end
end
