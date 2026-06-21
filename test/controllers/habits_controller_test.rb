require "test_helper"

class HabitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "lists only the signed in user's habits" do
    get habits_url

    assert_response :success
    assert_select "link[rel='stylesheet'][href*='tailwind']"
    assert_select "link[rel='manifest'][href*='manifest']"
    assert_select "link[rel='apple-touch-icon'][sizes='180x180']"
    assert_select "meta[name='viewport'][content*='viewport-fit=cover']"
    assert_select "h2", text: habits(:one).name
    assert_select "h2", text: habits(:two).name, count: 0
    assert_select "header.site-header"
    assert_select "nav.overflow-x-auto", count: 0
    assert_select "span", text: "Profile", count: 0
    assert_select ".settings-menu"
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

    assert_select "article[data-controller~='number-entry'][data-number-entry-open-value='true']" do
      assert_select "dialog[data-number-entry-target='dialog']"
    end
  end

  test "renders logged heatmap cells without a form layout wrapper" do
    habit = users(:one).habits.create!(name: "Read", color: "#8b5cf6", tracking_type: "number", unit: "pages")
    habit.entries.create!(occurred_on: Date.current, value: 10)

    get habits_url

    assert_select "form.contents button.size-\\[13px\\]"
  end

  test "filters an individual habit heatmap by calendar year" do
    habit = habits(:one)
    selected_year = Date.current.year - 1

    get habits_url(years: { habit.id => selected_year })

    assert_select "article#habit_#{habit.id}[data-calendar-year='#{selected_year}']" do
      assert_select "[aria-label='#{selected_year} calendar']"
      assert_select "summary[title='Calendar year: #{selected_year}']"
      assert_select "span", text: "Jan"
      assert_select "span", text: "Dec"
    end
  end

  test "renders a named confirmation dialog for deleting a habit" do
    habit = habits(:one)

    get habits_url

    assert_select "article#habit_#{habit.id}[data-controller~='delete-habit'][data-delete-habit-name-value=?]", habit.name do
      assert_select "button[title='Delete #{habit.name}'][data-action='delete-habit#open'] svg"
      assert_select "dialog[data-delete-habit-target='dialog']" do
        assert_select "input[name='confirmation_name'][data-action='input->delete-habit#validate']"
        assert_select "input[type='submit'][value='Delete habit'][disabled]"
      end
    end
  end

  test "requires the exact habit name to delete it" do
    habit = habits(:one)

    assert_no_difference -> { Habit.count } do
      delete habit_url(habit), params: { confirmation_name: "Wrong name" }
    end

    assert_redirected_to %r{/\#habit_#{habit.id}}
  end

  test "deletes a habit after its name is confirmed" do
    habit = habits(:one)

    assert_difference -> { Habit.count }, -1 do
      delete habit_url(habit), params: { confirmation_name: habit.name }
    end

    assert_redirected_to root_url
  end

  test "cannot delete another user's habit" do
    assert_no_difference -> { Habit.count } do
      delete habit_url(habits(:two))
    end

    assert_response :not_found
  end
end
