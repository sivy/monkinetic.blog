module Jekyll
  module Filters
    module SignalLogFilters

      def date_with_yc_year(date)
        year = date.year
        # puts year
        yc_year = 105+(year-2003)
        # puts yc_year
        time(date).strftime("YC#{yc_year}.%m.%d")
      end

    end
  end
end

Liquid::Template.register_filter(
  Jekyll::Filters::SignalLogFilters
)