#encoding : utf-8
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "intent"
require "sortdate"
root_dir = File.dirname(__FILE__) + "/../"
csv_account_path = root_dir + "input/account.csv"
csv_intent_path = root_dir + "output/intent.txt"
csv_intent_path_sorted = root_dir + "input/intent.txt"
Intent.new.show_intent(csv_account_path, csv_intent_path)
sortdate(csv_intent_path, csv_intent_path_sorted)
show(csv_intent_path_sorted)


