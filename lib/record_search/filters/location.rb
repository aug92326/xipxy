module RecordSearch
  module Filters
    class Location < Base

      def to_query
        @scope.joins(:locations).where('editions.primary = (?)', true).where('locations.name IN (?)', @query)
      end

    end
  end
end
