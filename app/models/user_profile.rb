class UserProfile < ActiveRecord::Base
  include ActsAs::SharedApi

  belongs_to :user

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :first_name
    t.add :last_name
    t.add :mailing_address
    t.add :country
    t.add :city
    t.add :state
    t.add :zipcode
    t.add :phone
    t.add :alternative_email
    t.add :created_at
  end
end
