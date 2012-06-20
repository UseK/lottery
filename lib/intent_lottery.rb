#encoding:utf-8
require File.dirname(__FILE__) + "/intent_lottery_unit"

class IntentLottery
	def initialize
		@il_unit = IntentLotteryUnit.new
	end
	def check_only(filename_id, filename_out)
		out_file = open(filename_out,"w")
		open(filename_id).each_line do |line|
			id, password, name = line.split(/,/)
			@il_unit.check_unit(id,password,name,'tekitou','tekitou2',out_file)
		end
		out_file.close
	end

	def check_and_regist(filename_intent, filename_finish)
		finish_file = open(filename_finish,"w")
		open(filename_intent).each_line do |line|
			if(/----/ =~ line) then
				puts ("next day")
				next
			end
			date,range_time,id,password,name = line.split(/,/)
			@il_unit.check_unit(id,password,name,date,range_time,finish_file)
		end
		finish_file.close
	end
end
