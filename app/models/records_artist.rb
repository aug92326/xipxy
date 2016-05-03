class RecordsArtist < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ActsAs::SharedApi

  def as_indexed_json args={}
    self.as_json({
                     methods: [:avatar_url],
                     only: [:id, :model, :avatar_url]
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

  belongs_to :record, touch: true

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :brand
    t.add :country
    t.add :founded
    t.add :closed
  end
end
