module RecordSearch
  module Filters
    class Status < Base

      def to_query
        @scope.joins(:editions).where('editions.primary = (?)', true).where('editions.primary_status IN (?)', @query)
      end

    end
  end
end
