require "test_helper"

class HabitTest < ActiveSupport::TestCase
  test "requires a name and valid color" do
    habit = users(:one).habits.new(name: "", color: "green")

    assert_not habit.valid?
    assert_includes habit.errors[:name], "can't be blank"
    assert_includes habit.errors[:color], "is invalid"
  end

  test "calculates a streak ending today" do
    habit = habits(:one)
    habit.entries.delete_all
    habit.entries.create!(occurred_on: Date.current - 2.days)
    habit.entries.create!(occurred_on: Date.current - 1.day)
    habit.entries.create!(occurred_on: Date.current)

    assert_equal 3, habit.current_streak
  end

  test "allows a streak to end yesterday" do
    habit = habits(:one)
    habit.entries.delete_all
    habit.entries.create!(occurred_on: Date.current - 1.day)

    assert_equal 1, habit.current_streak
  end

  test "averages values for number habits" do
    habit = users(:one).habits.create!(name: "Read", color: "#8b5cf6", tracking_type: "number", unit: "pages")
    habit.entries.create!(occurred_on: Date.current - 1.day, value: 10)
    habit.entries.create!(occurred_on: Date.current, value: 20)

    assert_equal 15, habit.average_value
  end
end
