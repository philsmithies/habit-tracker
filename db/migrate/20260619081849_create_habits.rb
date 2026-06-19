class CreateHabits < ActiveRecord::Migration[8.1]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :color, null: false, default: "#10b981"
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :habits, [ :user_id, :position ]
  end
end
