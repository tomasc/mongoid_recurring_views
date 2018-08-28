require 'test_helper'

describe MongoidOccurrenceViews::Queries::DateTimeRange do
  let(:today) { DateTime.now.beginning_of_day }
  let(:query) { subject.criteria(klass, query_dtstart, query_dtend) }
  let(:query_for_last_year) { subject.criteria(klass, query_dtstart - 1.year, query_dtend - 1.year) }

  describe 'Querying Events' do
    let(:klass) { Event }

    describe 'spanning one day' do
      before { create(:event, :today) }

      let(:query_dtstart) { today }
      let(:query_dtend) { today.end_of_day }

      it { query.count.must_equal 1 }
      it { query_for_last_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 1 } }
      it { with_expanded_occurrences_view { query_for_last_year.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      it { with_occurrences_ordering_view { query_for_last_year.count.must_equal 0 } }
    end

    describe 'spanning multiple days' do
      before { create(:event, :today_until_tomorrow) }

      let(:query_dtstart) { today }
      let(:query_dtend) { today + 1.day }

      it { query.count.must_equal 1 }
      it { query_for_last_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 2 } }
      it { with_expanded_occurrences_view { query_for_last_year.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      it { with_occurrences_ordering_view { query_for_last_year.count.must_equal 0 } }
    end

    describe 'recurring' do
      before { create(:event, :recurring_daily_this_week) }

      let(:query_dtstart) { today + 2.days }
      let(:query_dtend) { query_dtstart + 5.day }

      it { query.count.must_equal 1 }
      it { query_for_last_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 5 } }
      it { with_expanded_occurrences_view { query_for_last_year.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      it { with_occurrences_ordering_view { query_for_last_year.count.must_equal 0 } }
    end
  end

  describe 'Querying Parent with Embedded Events' do
    let(:klass) { EventParent }

    describe 'spanning one day' do
      before { create(:event_parent, :today) }

      let(:query_dtstart) { today }
      let(:query_dtend) { today.end_of_day }

      it { query.count.must_equal 1 }
      it { query_for_last_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 1 } }
      it { with_expanded_occurrences_view { query_for_last_year.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      it { with_occurrences_ordering_view { query_for_last_year.count.must_equal 0 } }
    end

    describe 'spanning multiple days' do
      before { create(:event_parent, :today_until_tomorrow) }

      let(:query_dtstart) { today }
      let(:query_dtend) { today + 1.day }

      it { query.count.must_equal 1 }
      it { query_for_last_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 2 } }
      it { with_expanded_occurrences_view { query_for_last_year.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      it { with_occurrences_ordering_view { query_for_last_year.count.must_equal 0 } }
    end

    describe 'recurring' do
      before { create(:event_parent, :recurring_daily_this_week) }

      let(:query_dtstart) { today + 2.days }
      let(:query_dtend) { query_dtstart + 5.day }

      it { query.count.must_equal 1 }
      it { query_for_last_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 5 } }
      it { with_expanded_occurrences_view { query_for_last_year.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      it { with_occurrences_ordering_view { query_for_last_year.count.must_equal 0 } }
    end
  end

  private

  def with_occurrences_ordering_view(&block)
    klass.with_occurrences_ordering_view(&block)
  end

  def with_expanded_occurrences_view(&block)
    klass.with_expanded_occurrences_view(&block)
  end
end
