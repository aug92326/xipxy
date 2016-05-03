class Publication < ActiveRecord::Base
  include ActsAs::SharedApi

  belongs_to :edition, touch: true

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :edition_id
    t.add :source
    t.add :title
    t.add :author
    t.add :date
    t.add :link
    t.add :created_at
  end
end
