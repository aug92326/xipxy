module RecordSearch
  module Filters
    class Artist < Base

      def to_query
        @scope.joins(:artist).where('records_artists.brand IN (?)', @query)
      end

    end
  end
end
