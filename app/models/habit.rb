class Habit < ApplicationRecord
  belongs_to :user
  has_many :entries, class_name: "HabitEntry", dependent: :destroy

  enum :tracking_type, %w[checkbox number].index_by(&:itself), default: :checkbox

  validates :name, presence: true, length: { maximum: 80 }
  validates :color, format: { with: /\A#[0-9a-f]{6}\z/i }
  validates :unit, length: { maximum: 30 }, allow_blank: true
  validates :unit, presence: true, if: :number?

  def current_streak(today = Date.current)
    completed_dates = entries.map(&:occurred_on).to_set
    date = completed_dates.include?(today) ? today : today - 1.day

    date.downto(Date.new(1970, 1, 1)).take_while { |day| completed_dates.include?(day) }.length
  end

  def average_value
    values = entries.filter_map(&:value)
    values.any? ? values.sum / values.size : 0
  end
end
