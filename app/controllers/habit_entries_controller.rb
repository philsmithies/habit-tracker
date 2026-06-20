class HabitEntriesController < ApplicationController
  before_action :set_habit

  def create
    @habit.entries.create!(occurred_on: entry_date, value: entry_value)
    redirect_to root_path(anchor: ActionView::RecordIdentifier.dom_id(@habit)), notice: "Progress logged."
  rescue ActiveRecord::RecordInvalid => error
    redirect_to root_path(anchor: ActionView::RecordIdentifier.dom_id(@habit)), alert: error.record.errors.full_messages.to_sentence
  end

  def destroy
    @habit.entries.find(params[:id]).destroy!
    redirect_to root_path(anchor: ActionView::RecordIdentifier.dom_id(@habit)), notice: "Entry removed."
  end

  private
    def set_habit
      @habit = Current.user.habits.find(params[:habit_id])
    end

    def entry_date
      value = params.dig(:habit_entry, :occurred_on) || params[:occurred_on]
      value.present? ? value.to_date : Date.current
    rescue Date::Error
      Date.current
    end

    def entry_value
      return unless @habit.number?

      params.dig(:habit_entry, :value) || params[:value]
    end
end
