module RecordSearch
  module Filters
    class Category < Base

      def to_query
        @scope.where('records.medium IN (?)', @query)
      end

    end
  end
end
