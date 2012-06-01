#encoding : utf-8
require "./intent_lottery.rb"
require "./sortdate"
id_file = "input/id.txt"
int_file = "output/intent.txt"
sort_int_file = "input/intent.txt"
intent_lottery = IntentLottery.new
intent_lottery.check_only(id_file, int_file)
sortdate(int_file,sort_int_file)
show(sort_int_file)


