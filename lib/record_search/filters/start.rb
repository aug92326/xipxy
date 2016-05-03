module RecordSearch
  module Filters
    class Start < Base

      def to_query
        @scope.where("year -> 'value' in (?)", @query)
      end

    end
  end
end
