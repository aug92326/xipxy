module RecordSearch
  module Filters
    class Keyword < Base

      #Artists Name, Artwork Name, Year, Notes
      def to_query
        @scope.joins([:artist, :editions]).where('editions.primary = ?', true).
            where("records_artists.brand like ? OR records.model like ? OR editions.notes like ? OR records.year -> 'value' = ?",
                  "%#{@query}%", "%#{@query}%", "%#{@query}%", @query)
      end
    end
  end
end
