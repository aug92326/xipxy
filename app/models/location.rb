class Location < ActiveRecord::Base
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  include ActsAs::SharedApi

  belongs_to :edition, class_name: Edition, touch: true

  # def as_indexed_json args={}
  #   self.as_json({
  #                  only: [:name, :address, :city, :country, :state, :zipcode, :sublocation, :location_notes]
  #                })
  # end
  #
  # settings analysis: {
  #              filter: { name_ngrams: { side: 'front', max_gram: 20, min_gram: 2, type: 'edgeNGram' } },
  #              analyzer: { full_name: { filter: ["standard", "lowercase", "name_ngrams"], type: 'custom', tokenizer: 'letter'} }
  #          } do
  #   mappings dynamic: 'false' do
  #     indexes :name, analyzer: 'full_name'
  #   end
  # end


  include PgSearch
  pg_search_scope :search_by_address,
    against: [:address, :city],
    using: {
        tsearch: { prefix: true, any_word: true }
    }
  pg_search_scope :search_by_name,
    against: [:name],
    using: {
        tsearch: { prefix: true, any_word: true }
    }

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :name
    t.add :address
    t.add :city
    t.add :country
    t.add :country_code
    t.add :state
    t.add :zipcode
    t.add :sublocation
    t.add :location_notes
    t.add :created_at
    t.add lambda{ |loc| loc.edition.owner.as_api_response(:basic) rescue nil }, as: :owner
  end
end
