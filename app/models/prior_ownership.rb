class PriorOwnership < ActiveRecord::Base
  include ActsAs::SharedApi

  belongs_to :edition, touch: true

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :edition_id
    t.add :owner
    t.add :purchase_price
    t.add :sale_price
    t.add :purchased_through
    t.add :date_of_purchase
    t.add :sold_through
    t.add :date_of_sale
    t.add :created_at
  end
end
