#encoding: utf-8
require "date"
require "rubygems"
require "holiday_japan"
module TheMonthAfterNext

  def self.generate_weekdays date_weekdays_path
    date_weekdays_file = File.open(date_weekdays_path, "w")
    each_date_in_month do |d|
      if d.monday? || d.wednesday?
        date_str = d.strftime("%Y/%m/%d")
        if d.national_holiday?
          puts "#{date_str}は祝日です． 出力ファイルへは書き出されません"
        else
          puts date_str
          date_weekdays_file.puts date_str
        end
      end
    end
  end

  def self.generate_saturday date_saturday_path
    date_saturday_file = File.open(date_saturday_path, "w")
    each_date_in_month do |d|
      if d.saturday?
        date_str = d.strftime("%Y/%m/%d")
        puts date_str
        date_saturday_file.puts date_str
      end
    end
  end

  def self.each_date_in_month
    date_tman = Date.today >> 2
    first_date = Date.new(date_tman.year, date_tman.month, 1)
    last_day = ((first_date >> 1)-1).day
    for i in 0..last_day-1 do
      yield first_date + i
    end
  end
end

input_dir = File.dirname(__FILE__) + "/../input/"
date_weekdays_path = input_dir + "date_weekdays.txt"
date_saturday_path = input_dir + "date_saturday.txt"
TheMonthAfterNext.generate_weekdays date_weekdays_path
puts "#{date_weekdays_path}へ書き出しました"
puts
TheMonthAfterNext.generate_saturday date_saturday_path
puts "#{date_saturday_path}へ書き出しました"
puts "抽選予約を行わない日程を削除し，regist_lottery.rb を実行ください"
