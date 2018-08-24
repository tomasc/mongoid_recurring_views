require 'mongoid_occurrence_views/version'

require 'mongoid'
require 'mongoid_ice_cube_extension'

require 'mongoid_occurrence_views/create_view'
require 'mongoid_occurrence_views/create_expanded_occurrences_view'
require 'mongoid_occurrence_views/destroy_view'
require 'mongoid_occurrence_views/event'
require 'mongoid_occurrence_views/event/query'
require 'mongoid_occurrence_views/event/create_occurrences_view'
require 'mongoid_occurrence_views/event/for_date_time_range'
require 'mongoid_occurrence_views/event/for_date_time'
require 'mongoid_occurrence_views/event/from_date_time'
require 'mongoid_occurrence_views/event/to_date_time'
require 'mongoid_occurrence_views/has_occurrence_views'
require 'mongoid_occurrence_views/occurrence'

module MongoidOccurrenceViews
  def self.event_classes
    ObjectSpace.each_object(Class).select { |c| c.included_modules.include? MongoidOccurrenceViews::Event }
  end
end
