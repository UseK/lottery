#encoding: utf-8
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "lottery"
require "csv_accessor"
input_dir = File.dirname(__FILE__) + "/../input/"
csv_account_path = input_dir + "account.csv"
date_weekdays_path = input_dir + "date_weekdays.txt"
date_saturday_path = input_dir + "date_saturday.txt"

n_sat = File.open(date_saturday_path, :encoding => 'utf-8').read.split("\n").length
puts "土曜は#{n_sat}週分あります"
puts "#{csv_account_path}の土曜のカラムを更新します"
CSVAccessor.update_account_sat_nth csv_account_path, n_sat

puts "以下の会員"
print File.open(csv_account_path, :encoding => 'utf-8').read
puts "", "平日の日程"
print File.open(date_weekdays_path, :encoding => 'utf-8').read
puts "", "土曜の日程"
print File.open(date_saturday_path, :encoding => 'utf-8').read

print "", "で抽選予約を行います．よろしいですか？/[yes no]>"
if /^yes$/ =~ STDIN.gets.chomp
  puts "抽選予約を行います．"
else
  puts "yesと返答されなかったので終了します"
  exit
end

Lottery.new.regist_weekdays(csv_account_path, date_weekdays_path)
Lottery.new.regist_saturday(csv_account_path, date_saturday_path)
