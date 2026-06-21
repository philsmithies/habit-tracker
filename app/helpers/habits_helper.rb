module HabitsHelper
  def habit_calendar_days
    end_date = Date.current.end_of_week(:sunday)
    (end_date - 52.weeks + 1.day)..end_date
  end

  def habit_calendar_weeks(year = nil)
    days = if year
      Date.new(year, 1, 1).beginning_of_week(:monday)..Date.new(year, 12, 31).end_of_week(:monday)
    else
      habit_calendar_days
    end

    days.each_slice(7).to_a
  end

  def month_label_for(week, previous_week)
    return week.first.strftime("%b") unless previous_week

    week.first.strftime("%b") if week.first.month != previous_week.first.month
  end

  def calendar_year_month_label_for(week, year)
    week.find { |date| date.year == year && date.day == 1 }&.strftime("%b")
  end

  def habit_calendar_years(habit)
    ([ Date.current.year, Date.current.year - 1 ] + habit.entries.map { |entry| entry.occurred_on.year }).uniq.sort.reverse
  end

  def habit_entry_color(habit, entry, maximum_value:)
    return habit.color unless habit.number?

    maximum = maximum_value.to_d
    intensity = maximum.positive? ? (entry.value.to_d / maximum).clamp(0, 1) : 1
    blend_hex_with_white(habit.color, 0.2 + (intensity * 0.8))
  end

  private
    def blend_hex_with_white(color, intensity)
      channels = color.delete_prefix("#").scan(/../).map { |channel| channel.to_i(16) }
      blended = channels.map { |channel| (255 - ((255 - channel) * intensity)).round }

      "##{blended.map { |channel| channel.to_s(16).rjust(2, "0") }.join}"
    end
end
