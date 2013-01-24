#encoding:utf-8
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "intent_lottery"
if ARGV[0].nil?
	puts "Usage: ruby verify_intent.rb input/intent_verify.txt"
	exit
end
intent_file = ARGV[0]
intent_lottery = IntentLottery.new
intent_lottery.verify_intent(intent_file)

