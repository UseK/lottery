#encoding:utf-8
require "test/unit"
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
require "intent_lottery"

class IntentLotteryTest < Test::Unit::TestCase
	def setup
		@il = IntentLottery.new
		def @il.check_unit(id, password, name, date, range_time, finish_file)
			print id, password, name, date, range_time
		end
	end

	def test_must_valid_date
		load_path = File.join(File.dirname(__FILE__), "..")
		@il.show_intent(load_path + "/input/id.txt", load_path + "/output/intent.txt")
		flunk "flunked"
	end
end
