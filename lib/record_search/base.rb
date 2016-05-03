require 'record_search/filter'

module RecordSearch
  class Base
    DEFAULT_OPTIONS = {
      page: 1,
      per_page: 25
    }

    def initialize(user)
      @user = user
      @_filters = []
      @available_filters = {}
      @records = RecordManager.new(@user).latest
    end

    def find_by(filters={})
      @filters = filters
      filters_preprocessing!

      ensure_available_filters! unless @filters[:search_keyword].present?

      @sorting = @filters[:sorts]
      sanitize_filters!
      ensure_sorting!
      @records = Filter.new(@records, @_filters).fetch

      if @filters[:search_keyword].present?
        ensure_available_filters!
        @filters.delete(:search_keyword)
      end
      {
        all_size: @records.size,
        available_filters: @available_filters,
        paged: @records.order("#{@sort_by} #{@sort_direction}").page(@page).per(@limit)
      }
    end

    private

    def search_by_keyword!
      return unless @filters[:search_keyword]
      @_filters << { keyword: @filters[:search_keyword] }
    end

    def filters_preprocessing!
      applied_filters = @filters[:filters]
      return if applied_filters.blank?
      applied_filters.each { |filter| applied_filters[filter[0]] = filter[1].split(', ') }
      if applied_filters.present?
        @filters.delete(:filters)
        @filters.merge!(applied_filters)
      end
    end

    def ensure_available_filters!
      primary_editions = Edition.where("editions.primary=true").where("record_id IN (?)", @records.map(&:id))
      @available_filters =
      {
        artists: RecordsArtist.where("record_id IN (?)", @records.map(&:id)).map(&:brand).uniq_sorting,
        categories: @records.map(&:medium).uniq,
        locations: Location.where("edition_id IN (?)", primary_editions.map(&:id)).map(&:name).uniq_sorting,
        statuses: primary_editions.map(&:primary_status).uniq_sorting,
        start_year: @records.map(&:year).map { |x| x['value'] }.uniq.sort_by(&:to_i)
      }
    end

    def ensure_sorting!
      if @sorting.present?
        @sort_by = 'model' # if @sorting[:sort_by].present? && @sorting[:sort_by] == 'alphabetical'
        @sort_direction = @sorting[:direction].present? ? @sorting[:direction] : 'desc'
      end
    end

    def sanitize_filters!
      extract_page_and_limit!
      search_by_keyword!
      ensure_artist!
      ensure_category!
      ensure_location!
      ensure_status!
      ensure_date_range!
    end

    def ensure_artist!
      return unless @filters[:artists]
      @_filters << { artist: @filters[:artists] }
      @filters.delete(:artists)
    end

    def ensure_category!
      return unless @filters[:categories]
      @_filters << { category: @filters[:categories] }
      @filters.delete(:categories)
    end

    def ensure_status!
      return unless @filters[:statuses]
      @_filters << { status: @filters[:statuses] }
      @filters.delete(:statuses)
    end

    def ensure_date_range!
      return unless @filters[:start_years]
      @_filters << { start: @filters[:start_years] }
      @filters.delete(:start)
    end

    def ensure_location!
      return unless @filters[:locations]
      @_filters << { location: @filters[:locations] }
      @filters.delete(:locations)
    end

    def extract_page_and_limit!
      @page = @filters.delete(:page) { |k| @filters[:page] }
      @limit = @filters.delete(:per_page) { |k| @filters[:per_page] }
    end

  end
end
