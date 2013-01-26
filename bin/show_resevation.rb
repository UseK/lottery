#encoding: utf-8
root_dir = File.dirname(__FILE__) + "/../"
$LOAD_PATH << root_dir + "lib"
require "resevation"
csv_account_path = root_dir + "input/account.csv"
output_path = root_dir + "output/resavation.txt"
puts "予約情報を#{output_path} へ保存します"
Resevation.new.show_all csv_account_path, output_path
puts "予約情報を#{output_path} へ保存しました"
