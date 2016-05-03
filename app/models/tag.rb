class Tag < ActiveRecord::Base
  include ActsAs::SharedApi
  has_and_belongs_to_many :editions

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :slug
    t.add lambda{ |art| art.editions.as_api_response(:light) rescue nil }, as: :editions
  end
end
