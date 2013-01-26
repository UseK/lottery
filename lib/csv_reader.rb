#encoding:utf-8
require "csv"
module CSVReader
  def self.read_account file_path
    csv_id =  CSV.read(file_path, :headers => true, :header_converters => :symbol)
    print_invalid_id csv_id
  end

  private
  def self.print_invalid_id csv_id
    csv_id.each do |row|
      puts "警告: 会員番号が8桁の整数ではありません => #{row}" unless row[:id].match(/^\d{8}$/)
      puts "警告: パスワードが4桁の整数ではありません => #{row}" unless row[:pass].match(/^\d{4}$/)
      puts "警告: 土曜の開始時間が1,2桁の整数ではありません => #{row}" unless row[:time_start].match(/^\d{1,2}$/)
    end
  end
end

if $0 == __FILE__
  root_directory = File.dirname(__FILE__) + "/../"
  file_path = root_directory + "input/id_sample.csv"
  CSVReader.read_account file_path
end
