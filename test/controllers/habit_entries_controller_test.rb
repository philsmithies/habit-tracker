require "test_helper"

class HabitEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "logs a completion for an owned habit" do
    assert_difference -> { habits(:one).entries.count }, 1 do
      post habit_entries_url(habits(:one)), params: { occurred_on: Date.current - 1.day }
    end

    assert_redirected_to %r{/\#habit_\d+}
  end

  test "cannot log a completion for another user's habit" do
    assert_no_difference -> { HabitEntry.count } do
      post habit_entries_url(habits(:two))
    end

    assert_response :not_found
  end
end
