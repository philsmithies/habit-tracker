class Habit < ApplicationRecord
  belongs_to :user
  has_many :entries, class_name: "HabitEntry", dependent: :destroy

  validates :name, presence: true, length: { maximum: 80 }
  validates :color, format: { with: /\A#[0-9a-f]{6}\z/i }

  def current_streak(today = Date.current)
    completed_dates = entries.map(&:occurred_on).to_set
    date = completed_dates.include?(today) ? today : today - 1.day

    date.downto(Date.new(1970, 1, 1)).take_while { |day| completed_dates.include?(day) }.length
  end
end
