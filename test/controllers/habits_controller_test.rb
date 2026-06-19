require "test_helper"

class HabitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "lists only the signed in user's habits" do
    get habits_url

    assert_response :success
    assert_select "h2", text: habits(:one).name
    assert_select "h2", text: habits(:two).name, count: 0
  end

  test "creates a habit owned by the signed in user" do
    assert_difference -> { users(:one).habits.count }, 1 do
      post habits_url, params: { habit: { name: "Meditate", color: "#8b5cf6" } }
    end

    assert_redirected_to %r{/\#habit_\d+}
  end

  test "cannot delete another user's habit" do
    assert_no_difference -> { Habit.count } do
      delete habit_url(habits(:two))
    end

    assert_response :not_found
  end
end
