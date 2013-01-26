# encoding : utf-8
#encoding: utf-8
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "lottery"
csv_account_path = ARGV[0]
date_weekdays_path = ARGV[1]
if ARGV[2]
  date_saturday_path = ARGV[2]
else
	print("Usage: ruby bin/regist_lottery.rb  input/date_weekdays.txt input/date_saturday.txt \n")
	exit
end
lottery = Lottery.new
lottery.regist_weekdays(csv_account_path, date_weekdays_path)
lottery.regist_saturday(csv_account_path, date_saturday_path)
