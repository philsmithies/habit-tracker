module HabitsHelper
  def habit_calendar_days
    end_date = Date.current.end_of_week(:sunday)
    (end_date - 52.weeks + 1.day)..end_date
  end

  def habit_calendar_weeks
    habit_calendar_days.each_slice(7).to_a
  end

  def month_label_for(week, previous_week)
    return week.first.strftime("%b") unless previous_week

    week.first.strftime("%b") if week.first.month != previous_week.first.month
  end
end
