#encoding : utf-8
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "intent_lottery"
require "sortdate"
root_dir = File.dirname(__FILE__) + "/../"
id_file = root_dir + "input/id.txt"
int_file = root_dir + "output/intent.txt"
sort_int_file = root_dir + "input/intent.txt"
intent_lottery = IntentLottery.new
intent_lottery.show_intent(id_file, int_file)
sortdate(int_file, sort_int_file)
show(sort_int_file)

