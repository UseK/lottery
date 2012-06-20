#encoding : utf-8
RPATH = File.dirname(__FILE__)
require RPATH + "/lib/intent_lottery"
require RPATH + "/lib/sortdate"
id_file = "input/id.txt"
int_file = "output/intent.txt"
sort_int_file = "input/intent.txt"
intent_lottery = IntentLottery.new
intent_lottery.check_only(id_file, int_file)
sortdate(int_file,sort_int_file)
show(sort_int_file)


