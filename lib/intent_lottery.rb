#encoding:utf-8
require "date"
$LOAD_PATH << File.dirname(__FILE__)
require "intent_lottery_unit"
require "csv_reader"

class IntentLottery
	def initialize
		@il_unit = IntentLotteryUnit.new
	end

	def show_intent(filename_id, filename_out)
		out_file = open(filename_out, "w")
    csv_id = CSVReader.read_id(filename_id)
		csv_id.each do |row|
			puts
			puts "#{row[:name]}さんの抽選結果を調べています..."
			@il_unit.show_unit(row[:id], row[:pass], row[:name], out_file)
		end
		out_file.close
	end

	def verify_intent(filename_intent)
		wizard(filename_intent)
		open(filename_intent).each_line do |line|
			if(/----/ =~ line) then
				puts "next day"
				next
			end
			date, range_time, id, password, name = line.split(/,/)
			puts
			print line,  "以上の日程の意思確認を行っています...\n"
			@il_unit.verify_unit(id, password, name, date, range_time)
		end
	end

  private
	def wizard(filename_id)
		open(filename_id).each_line do |line|
		puts line
		#date, range_time, id, password, name = line.split(/,/)
		#d = Date.strptime(date, "%Y年%m月%d日")
		end
		puts "以上の日程の意思確認を行います、よろしいですか？/[yes no]>"
		if /^yes$/ =~ STDIN.gets.chomp
			puts "意思確認を行います"
		else
			puts "yesと返答されなかったので終了します"
			exit
		end
	end
end
