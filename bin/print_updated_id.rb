#encoding:utf-8
require "pp"
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "lottery"
require "csv_accessor"
input_dir = File.dirname(__FILE__) + "/../input/"
csv_account_path = input_dir + "account.csv"
date_weekdays_path = input_dir + "date_weekdays.txt"
date_saturday_path = input_dir + "date_saturday.txt"
n_sat = File.open(date_saturday_path).read.split("\n").length
puts "土曜は#{n_sat}週分あります"
puts "#{csv_account_path}の土曜のカラムを更新します"
CSVAccessor.update_account_sat_nth csv_account_path, n_sat
