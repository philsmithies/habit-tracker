class HabitEntry < ApplicationRecord
  belongs_to :habit

  validates :occurred_on, presence: true, uniqueness: { scope: :habit_id }
  validates :value, numericality: true, presence: true, if: -> { habit&.number? }
end
