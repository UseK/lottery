#encoding : utf-8
$LOAD_PATH << File.dirname(__FILE__)
require "lib/intent_lottery"
require "lib/sortdate"
id_file = "input/id.txt"
int_file = "output/intent.txt"
sort_int_file = "input/intent.txt"
intent_lottery = IntentLottery.new
intent_lottery.show_intent(id_file, int_file)
sortdate(int_file,sort_int_file)
show(sort_int_file)


