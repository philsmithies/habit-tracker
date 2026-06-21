require "test_helper"

class HabitsHelperTest < ActionView::TestCase
  test "scales number habit colors by the logged value" do
    habit = Habit.new(color: "#10b981", tracking_type: "number")

    assert_equal "#cff1e6", habit_entry_color(habit, HabitEntry.new(value: 0), maximum_value: 20)
    assert_equal "#70d5b3", habit_entry_color(habit, HabitEntry.new(value: 10), maximum_value: 20)
    assert_equal "#10b981", habit_entry_color(habit, HabitEntry.new(value: 20), maximum_value: 20)
  end

  test "keeps checkbox habit colors solid" do
    habit = Habit.new(color: "#10b981", tracking_type: "checkbox")

    assert_equal "#10b981", habit_entry_color(habit, HabitEntry.new, maximum_value: nil)
  end

  test "builds a complete calendar year from monday through sunday" do
    weeks = habit_calendar_weeks(2025)

    assert_equal Date.new(2024, 12, 30), weeks.first.first
    assert_equal Date.new(2026, 1, 4), weeks.last.last
    assert_equal "Jan", calendar_year_month_label_for(weeks.first, 2025)
    assert_equal "Dec", weeks.filter_map { |week| calendar_year_month_label_for(week, 2025) }.last
  end

  test "offers the current year, previous year, and years with entries" do
    habit = Habit.new
    habit.entries.build(occurred_on: Date.new(2020, 6, 1))

    assert_equal [ Date.current.year, Date.current.year - 1, 2020 ].uniq, habit_calendar_years(habit)
  end
end
