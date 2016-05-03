class RecordsUser < ActiveRecord::Base
  scope :owner, -> { where(owner: true)[0] }

  belongs_to :user
  belongs_to :record
end
