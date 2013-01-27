#encoding:utf-8
require "date"
$LOAD_PATH << File.dirname(__FILE__)
require "intent_agent"
require "csv_accessor"

class Intent
	def initialize
		@il_unit = IntentAgent.new
	end

	def show_intent(csv_account_path, csv_intent_path)
		csv_intent = open(csv_intent_path, "w", :encoding => 'utf-8')
    csv_account = CSVAccessor.read_account(csv_account_path)
		csv_account.each do |account|
			puts
			puts "#{account[:name]}さんの抽選結果を調べています..."
			@il_unit.show_unit(account[:id], account[:pass], account[:name], csv_intent)
		end
		csv_intent.close
	end

	def verify_intent(csv_intent_path)
		wizard(csv_intent_path)
		open(csv_intent_path, :encoding => 'utf-8').each_line do |line|
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

  private
	def wizard(csv_intent_path)
		print File.open(csv_intent_path, "r", :encoding => 'utf-8').read
		print "以上の日程の意思確認を行います、よろしいですか？/[yes no]>"
		if /^yes$/ =~ STDIN.gets.chomp
			puts "意思確認を行います"
		else
			puts "yesと返答されなかったので終了します"
			exit
		end
	end
end
