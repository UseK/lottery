require "date"
require "holiday_japan"
module TheMonthAfterNext
  def self.print_weekdays
    date_tman = Date.today >> 2
    first_date = Date.new(date_tman.year, date_tman.month, 1)
    last_day = ((first_date >> 1)-1).day
    for i in 0..last_day-1 do
      d = first_date + i
      if((d.monday? || d.wednesday?) && !d.national_holiday?) then
        puts d.strftime("%Y/%m/%d")
      end
      if((d.monday? || d.wednesday?) && d.national_holiday?) then
        puts(d.strftime("holiday %y/%m/%d"))
      end
    end
  end
end
TheMonthAfterNext.print_weekdays
