class ExhibitionHistory < ActiveRecord::Base
  include ActsAs::SharedApi

  belongs_to :edition, touch: true

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :edition_id
    t.add :displayed_by
    t.add :displayed_at
    t.add :title
    t.add :start_date
    t.add :end_date
    t.add :created_at
  end
end
