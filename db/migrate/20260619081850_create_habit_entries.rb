class CreateHabitEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :habit_entries do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :occurred_on, null: false

      t.timestamps
    end

    add_index :habit_entries, [ :habit_id, :occurred_on ], unique: true
  end
end
