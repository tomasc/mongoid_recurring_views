require 'test_helper'

describe MongoidOccurrenceViews::Aggregations::OccursBetween do
  let(:occurrence_today) { build(:occurrence, :today) }
  let(:occurrence_tomorrow) { build(:occurrence, :tomorrow) }
  let(:event) { build :event, occurrences: [occurrence_today, occurrence_tomorrow] }

  before { event.save! }

  it { subject.new(Event.criteria, occurrence_today.dtstart, occurrence_tomorrow.dtend).instantiate.size.must_equal 2 }
  it { subject.new(Event.criteria, occurrence_today.dtstart, occurrence_tomorrow.dtend).instantiate.must_include event }

  it { subject.new(Event.criteria, occurrence_today.dtstart - 1.day, occurrence_tomorrow.dtend + 1.day).instantiate.size.must_equal 2 }
  it { subject.new(Event.criteria, occurrence_today.dtstart - 1.day, occurrence_tomorrow.dtend + 1.day).instantiate.must_include event }

  it { subject.new(Event.criteria, occurrence_today.dtstart + 10.days, occurrence_tomorrow.dtend + 10.days).instantiate.wont_include event }

  describe 'dtstart & dtend' do
    let(:instantiated_event_today) { subject.new(Event.criteria, occurrence_today.dtstart, occurrence_tomorrow.dtend).instantiate[0] }
    let(:instantiated_event_tomorrow) { subject.new(Event.criteria, occurrence_today.dtstart, occurrence_tomorrow.dtend).instantiate[1] }

    it { instantiated_event_today.dtstart.must_equal occurrence_today.dtstart }
    it { instantiated_event_today.dtend.must_equal occurrence_today.dtend }

    it { instantiated_event_tomorrow.dtstart.must_equal occurrence_tomorrow.dtstart }
    it { instantiated_event_tomorrow.dtend.must_equal occurrence_tomorrow.dtend }
  end
end