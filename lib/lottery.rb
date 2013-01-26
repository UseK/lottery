#encoding: utf-8
$LOAD_PATH << File.dirname(__FILE__)
require "lottery_agent"
require "csv_reader"

class Lottery

  def regist_weekdays csv_account_path, date_path
    csv_account = CSVReader.read_account csv_account_path
    date_arr = File.open(date_path).read.split("\n")
    csv_account.each do |account|
      date_arr.each do |date|
        puts "#{account[:name]}さんの平日予約 #{date}, 17 を行います..."
        regist_unit account[:id], account[:pass], date, '17'
      end
    end
  end

  def regist_saturday csv_account_path, date_path
    csv_account = CSVReader.read_account csv_account_path
    date_arr = File.open(date_path).read.split("\n")
    csv_account.each do |account|
      date = ordinal2date(account[:nth_sat], date_arr)
      puts "#{account[:name]}さんの土曜予約 #{date}, #{account[:opening_time]} を行います..."
      regist_unit account[:id], account[:pass], date, account[:opening_time]
    end
  end

  private
  def regist_unit id, pass, date, opening_time
    begin
      timeout(30) {
        LotteryAgent.new.regist_unit(id, pass, date, opening_time)
      }
    rescue => ex
      puts ex.message
      retry
    end
  end

  ORDINAL2INDEX = {"1st" => 0, "2nd" => 1, "3rd" => 2 , "4th" => 3, "5th" => 4}
	def ordinal2date(ordinal, date_arr)
    index = ORDINAL2INDEX[ordinal]
    date = date_arr[index]
    unless date
      puts "土曜の抽選日程のファイルには#{date_arr.length}日分の日程しか書かれていません．"
      puts "#{ordinal}は範囲外です．"
      puts "プログラムを終了します"
      exit
    end
    date
	end
end

if $0 == __FILE__
  input_dir = File.dirname(__FILE__) + "/../input/"
  lottery = Lottery.new
  def lottery.regist_unit id, pass, date, opening_time
    p [id, pass, date, opening_time]
  end
  lottery.regist_weekdays(input_dir + "account.csv", input_dir + "date_weekdays.txt")
  print "\n\n\n\n"
  lottery.regist_saturday(input_dir + "account.csv", input_dir + "date_saturday.txt")
end
