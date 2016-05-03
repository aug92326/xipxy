class EditionAdmin < ActiveRecord::Base
  include ActsAs::SharedApi

  belongs_to :edition

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :edition_id
    t.add :xipsy_artwork_id
    t.add :xipsy_record_number
    t.add :inventory_number
    t.add :record_date
    t.add :copyright
  end
end