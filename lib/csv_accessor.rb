#encoding:utf-8
require "csv"
require "fileutils"
module CSVAccessor
  SAT_NTH = ["1st", "2nd", "3rd", "4th", "5th"]
  OPENING_TIME = ["15", "15", "17"]

  def self.update_account_sat_nth file_path, n_sat
    raise "月に第#{n_sat}週は存在しません" if n_sat >= 6
    file_path_back = file_path + ".bak"
    FileUtils.cp(file_path, file_path_back)
    tmp_arr = []
    each_updated_account(file_path_back, n_sat) do |updated_account|
      tmp_arr << updated_account.join(",")
    end
    tmp_arr
    new_csv = File.open(file_path, "w", :encoding => 'utf-8')
    new_csv.puts("id,pass,name,nth_sat,opening_time")
    tmp_arr.each do |line|
      new_csv.puts line
    end
    new_csv.close
  end

  def self.each_updated_account file_path, n_sat
    csv_account = read_account file_path
    index = 0
    while index < csv_account.length
      for i in 0..n_sat-1
        OPENING_TIME.each do |opening_time|
          acc = csv_account[index]
          yield [acc[:id], acc[:pass], acc[:name], SAT_NTH[i], opening_time]
          index += 1
          break if index >= csv_account.length
        end
        break if index >= csv_account.length
      end
    end
  end

  def self.read_account file_path
    csv_account =  CSV.read(file_path, :headers => true, :header_converters => :symbol, :encoding => 'utf-8')
    print_invalid_id csv_account
  end

  private
  def self.print_invalid_id csv_account
    csv_account.each do |row|
      puts "警告: 会員番号が8桁の整数ではありません => #{row}" unless row[:id].match(/^\d{8}$/)
      puts "警告: パスワードが4桁の整数ではありません => #{row}" unless row[:pass].match(/^\d{4}$/)
      puts "警告: 土曜の開始時間が1,2桁の整数ではありません => #{row}" unless row[:opening_time].match(/^\d{1,2}$/)
    end
  end
end

if $0 == __FILE__
  root_directory = File.dirname(__FILE__) + "/../"
  file_path = root_directory + "input/account.csv"
  CSVAccessor.read_account file_path
  CSVAccessor.update_account_sat_nth file_path, 2
  csv_account = CSVAccessor.read_account file_path
  csv_account.each do |row|
    puts row
  end
end
