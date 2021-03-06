require 'mongoid_occurrences/aggregations/aggregation'

module MongoidOccurrences
  module Aggregations
    class OccursBetween < Aggregation
      def initialize(base_criteria, dtstart, dtend, options = {})
        @base_criteria = base_criteria
        @dtstart = dtstart
        @dtend = dtend
        @options = options
      end

      private

      def criteria
        base_criteria.occurs_between(dtstart, dtend)
      end

      def pipeline
        [
          { '$addFields' => { '_daily_occurrences' => '$daily_occurrences' } },
          { '$unwind' => { 'path' => '$_daily_occurrences' } },
          { '$addFields' => { '_dtstart' => '$_daily_occurrences.ds', '_dtend' => '$_daily_occurrences.de' } },
          { '$project' => { '_daily_occurrences' => 0 } },
          { '$match' => Queries::OccursBetween.criteria(base_criteria, dtstart, dtend, dtstart_field: '_dtstart', dtend_field: '_dtend').selector },
          { '$sort' => { sort_key => { asc: 1, desc: -1 }[sort_order] } }
        ]
      end

      attr_reader :dtstart, :dtend, :options
    end
  end
end
