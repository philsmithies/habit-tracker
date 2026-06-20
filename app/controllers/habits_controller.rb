class HabitsController < ApplicationController
  def index
    @habits = Current.user.habits.includes(:entries)
    @habits = @habits.where("name LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%") if params[:q].present?
    @habit = Current.user.habits.new(tracking_type: params[:tracking_type])
    @show_habit_form = @habit.errors.any? || params[:tracking_type].present?
    @log_habit_id = params[:log_habit_id].to_i if params[:log_habit_id].present?
  end

  def create
    habit = Current.user.habits.create!(
      habit_params.merge(position: Current.user.habits.maximum(:position).to_i + 1)
    )
    redirect_to root_path(anchor: ActionView::RecordIdentifier.dom_id(habit)), notice: "Habit created."
  rescue ActiveRecord::RecordInvalid => error
    @habits = Current.user.habits.includes(:entries)
    @habit = error.record
    @show_habit_form = true
    render :index, status: :unprocessable_entity
  end

  def destroy
    Current.user.habits.find(params[:id]).destroy!
    redirect_to root_path, notice: "Habit deleted."
  end

  private
    def habit_params
      params.expect(habit: [ :name, :color, :tracking_type, :unit ])
    end
end
