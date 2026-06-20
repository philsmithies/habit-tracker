require "test_helper"

class HabitEntryTest < ActiveSupport::TestCase
  test "only records one completion per habit and date" do
    duplicate = habits(:one).entries.new(occurred_on: habit_entries(:one).occurred_on)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:occurred_on], "has already been taken"
  end

  test "requires a value for number habits" do
    habit = users(:one).habits.create!(name: "Read", color: "#8b5cf6", tracking_type: "number", unit: "pages")

    assert_not habit.entries.new(occurred_on: Date.current).valid?
    assert habit.entries.new(occurred_on: Date.current, value: 10).valid?
  end
end
