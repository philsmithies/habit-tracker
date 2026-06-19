class HabitEntry < ApplicationRecord
  belongs_to :habit

  validates :occurred_on, presence: true, uniqueness: { scope: :habit_id }
end
