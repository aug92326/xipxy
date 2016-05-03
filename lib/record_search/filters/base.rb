module RecordSearch
  module Filters
    class Base

      def initialize(scope, query)
        @scope = scope
        @query = query
      end

      def to_query
        raise NotImplementedError, 'override this'
      end
    end
  end
end
