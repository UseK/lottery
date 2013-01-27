#encoding:utf-8
require "date"
$LOAD_PATH << File.dirname(__FILE__)
require "intent_agent"
require "csv_accessor"

class Intent
	def initialize
		@il_unit = IntentAgent.new
	end

	def show_intent(csv_account_path, intent_path)
		file_intent = open(intent_path, "w", :encoding => 'utf-8')
    csv_account = CSVAccessor.read_account(csv_account_path)
		csv_account.each do |account|
			puts
			puts "#{account[:name]}さんの抽選結果を調べています..."
			@il_unit.show_unit(account[:id], account[:pass], account[:name], file_intent)
		end
		file_intent.close
	end

	def verify_intent(intent_path)
		open(intent_path, :encoding => 'utf-8').each_line do |line|
			if(/^-+/ =~ line) then
				puts "next day"
				next
			end
			date, range_time, id, pass, name = line.split(/,/)
			puts
			print line,  "以上の日程の意思確認を行っています...\n"
			@il_unit.verify_unit(id, pass, date, range_time)
		end
	end

end
