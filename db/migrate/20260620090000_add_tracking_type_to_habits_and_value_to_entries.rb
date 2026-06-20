class AddTrackingTypeToHabitsAndValueToEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :habits, :tracking_type, :string, default: "checkbox", null: false
    add_column :habits, :unit, :string
    add_column :habit_entries, :value, :decimal, precision: 12, scale: 2

    add_check_constraint :habits,
      "tracking_type IN ('checkbox', 'number')",
      name: "habits_tracking_type"
  end
end
