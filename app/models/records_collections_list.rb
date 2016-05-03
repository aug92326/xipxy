class RecordsCollectionsList < ActiveRecord::Base
  belongs_to :record
  belongs_to :records_collection
end
