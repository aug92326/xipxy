path = "#{Rails.root}/lib/record_search/filters"

require "#{path}/base"
Dir.foreach(path) do |fname|
  next if fname.starts_with?('.')
  require "#{path}/#{fname}"
end

module RecordSearch
  class Filter

    def initialize(scope, filters={})
      @scope = scope
      @filters = filters
    end

    def fetch
      @filters.each do |hash|
        key = hash.keys[0]
        val = hash.values[0]
        filter = "RecordSearch::Filters::#{key.to_s.classify}".constantize.new(@scope, val)
        @scope = @scope.merge filter.to_query
      end
      @scope
    end

  end
end
