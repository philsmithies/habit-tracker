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
end
