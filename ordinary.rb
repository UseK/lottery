require 'date'
require 'date/holiday'
def ordinary
	first_date = Date.new((Date.today >> 2).year, month = (Date.today >> 2).month, 1)
	last_day = ((first_date >> 1)-1).day
	for i in 0..last_day-1 do
		d = first_date + i
		if((d.monday? || d.wednesday?) && !d.national_holiday?) then
			puts d.strftime("%Y/%m/%d")
		end
		if((d.monday? || d.wednesday?) && d.national_holiday?) then
			print(d.strftime("holiday %y/%m/%d\n"))
		end
	end
end
module Cal
	WEEK_TABLE = [
		[99, 99, 99, 99, 99, 99,  1,  2,  3,  4,  5,  6,  7],
		[ 2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14],
		[ 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21],
		[16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28],
		[23, 24, 25, 26, 27, 28, 29, 30, 31, 99, 99, 99, 99],
		[30, 31, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99],
	]
	def cal_holiday(date = Date.today)
		first_day = Date.new(date.year,date.month,1)
		start = 6 - first_day.wday
		puts start
		puts " Sun  Mon  Tue  Wed  Thu  Fri  Sat"
		WEEK_TABLE.each do |week|
			buf = ""
			week[start, 7].each do |day|
				if(day == 99) then
					buf << "     "
				else
					if ((first_day + day - 1).national_holiday?) then
						buf << sprintf(" (%2d)", day)
					else
						buf << sprintf("%5d", day)
					end
				end
			end
			puts buf
		end
	end
	module_function :cal_holiday
end
ordinary
