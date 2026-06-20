require "test_helper"

class HabitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "lists only the signed in user's habits" do
    get habits_url

    assert_response :success
    assert_select "link[rel='stylesheet'][href*='tailwind']"
    assert_select "h2", text: habits(:one).name
    assert_select "h2", text: habits(:two).name, count: 0
  end

  test "creates a habit owned by the signed in user" do
    assert_difference -> { users(:one).habits.count }, 1 do
      post habits_url, params: { habit: { name: "Meditate", color: "#8b5cf6" } }
    end

    assert_redirected_to %r{/\#habit_\d+}
  end

  test "creates a number habit with a unit" do
    assert_difference -> { users(:one).habits.count }, 1 do
      post habits_url, params: { habit: { name: "Read", color: "#8b5cf6", tracking_type: "number", unit: "pages" } }
    end

    habit = users(:one).habits.order(:created_at).last
    assert habit.number?
    assert_equal "pages", habit.unit
  end

  test "renders number entry as a modal dialog" do
    habit = users(:one).habits.create!(name: "Read", color: "#8b5cf6", tracking_type: "number", unit: "pages")

    get habits_url(log_habit_id: habit.id)

    assert_select "article[data-controller='number-entry'][data-number-entry-open-value='true']" do
      assert_select "dialog[data-number-entry-target='dialog']"
    end
  end

  test "cannot delete another user's habit" do
    assert_no_difference -> { Habit.count } do
      delete habit_url(habits(:two))
    end

    assert_response :not_found
  end
end
