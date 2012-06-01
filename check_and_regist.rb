#encoding:utf-8
require "./intent_lottery"
intent_file = "input/intent_regist.txt"
out_file = "output/int_out.txt"
intent_lottery = IntentLottery.new
intent_lottery.check_and_regist(intent_file, out_file)

