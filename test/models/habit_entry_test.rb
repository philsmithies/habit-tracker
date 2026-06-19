require "test_helper"

class HabitEntryTest < ActiveSupport::TestCase
  test "only records one completion per habit and date" do
    duplicate = habits(:one).entries.new(occurred_on: habit_entries(:one).occurred_on)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:occurred_on], "has already been taken"
  end
end
