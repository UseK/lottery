# encoding : utf-8
#encoding: utf-8
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "lottery"
input_dir = File.dirname(__FILE__) + "/../input/"
csv_account_path = input_dir + "account.csv"
date_weekdays_path = input_dir + "date_weekdays.txt"
date_saturday_path = input_dir + "date_saturday.txt"
Lottery.new.regist_weekdays(csv_account_path, date_weekdays_path)
Lottery.new.regist_saturday(csv_account_path, date_saturday_path)
