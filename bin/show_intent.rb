#encoding : utf-8
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "intent"
require "sortdate"
root_dir = File.dirname(__FILE__) + "/../"
csv_account_path = root_dir + "input/account.csv"
file_intent_path = root_dir + "output/intent.txt"
file_intent_path_sorted = root_dir + "input/intent.txt"
Intent.new.show_intent(csv_account_path, file_intent_path)
sortdate(file_intent_path, file_intent_path_sorted)
puts "予約承認の結果をinput/intent.txt へ保存しました"
puts "予約承認を行わない日程を削除し，bin/verify_intent.rb を実行してください"



