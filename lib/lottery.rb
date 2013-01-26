#encoding: utf-8
$LOAD_PATH << File.dirname(__FILE__)
require "lottery_agent"

class Lottery

	def ordinal2int(ordinal)
		case ordinal
		when "1st" then return 0
		when "2nd" then return 1
		when "3rd" then return 2
		when "4th" then return 3
		when "5th" then return 4
		else $stderr.print("Error:out of ordinal in ordinal2int")
		end
	end

	def register_all(id_name,date_name,is_saturday)
		date_file = open(date_name,"r")
		open(id_name,"r").each_line do |id_line|
			if(is_saturday == '-s')then
				regist_saturday(date_file, id_line)
			else
				regist_ordinary(date_file, id_line)
			end
			date_file.rewind
		end
		date_file.close
	end

	def regist_saturday(date_file, id_line)
		date_array = date_file.read.split(/\n/)
		id, pass, name, strth, time_range = id_line.split(',')
		begin
			timeout(30){
				print name ,",",date_array[ordinal2int(strth)],",",time_range
				LotteryAgent.new.regist_unit(id, pass, date_array[ordinal2int(strth)], time_range.chomp)
			}
		rescue => ex
			puts ex.message
			retry
		end
	end

	def regist_ordinary(date_file, id_line)
		id, pass, name = id_line.split(',')
		while date = date_file.gets
			begin
				timeout(30){
					print(name, ",", date)
					LotteryAgent.new.regist_unit(id, pass, date.chomp)
				}
			rescue => ex
				puts ex.message
				retry
			end
		end
	end
end
