class HabitsController < ApplicationController
  def index
    @habits = Current.user.habits.includes(:entries)
    @habits = @habits.where("name LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%") if params[:q].present?
    @habit = Current.user.habits.new
  end

  def create
    habit = Current.user.habits.create!(
      habit_params.merge(position: Current.user.habits.maximum(:position).to_i + 1)
    )
    redirect_to root_path(anchor: ActionView::RecordIdentifier.dom_id(habit)), notice: "Habit created."
  rescue ActiveRecord::RecordInvalid => error
    @habits = Current.user.habits.includes(:entries)
    @habit = error.record
    render :index, status: :unprocessable_entity
  end

  def destroy
    Current.user.habits.find(params[:id]).destroy!
    redirect_to root_path, notice: "Habit deleted."
  end

  private
    def habit_params
      params.expect(habit: [ :name, :color ])
    end
end
