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
end
