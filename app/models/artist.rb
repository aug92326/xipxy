class Artist < ActiveRecord::Base
  include ActsAs::SharedApi

  include PgSearch
  pg_search_scope :search_by_brand,
    against: [:brand],
    using: {
        tsearch: { prefix: true, any_word: true }
    }

  has_many :records, dependent: :destroy
  has_many :external_artworks

  validates :brand, presence: true, :uniqueness => {:scope => :country}

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
