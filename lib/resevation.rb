#encoding: utf-8
require "rubygems"
require "openssl"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require "mechanize"
require "kconv"
$LOAD_PATH << File.dirname(__FILE__)
require "csv_accessor"
require "agent"
class Resevation < Agent
  def show_all csv_account_path, output_path
    csv_account = CSVAccessor.read_account(csv_account_path)
    out_file = open(output_path, "w", :encoding => 'utf-8')
    csv_account.each do |account|
      puts "#{account[:name]}さんの予約情報を取得しています..."
      check_unit(account, out_file)
    end
    out_file.close
  end

  CANCEL_URL = "https://www.hyogo-park.or.jp/yoyaku/cancel/cancel.asp"
  def check_unit(account, out_file)
    @agent.get(CANCEL_URL)
    login(account[:id], account[:pass])

    @agent.page.search('tr/td/table[@width="400"]')[0..50].each do |p|
      print_resevation_unit(p.inner_text, account, out_file)
    end

    logout
  end

  private
  def print_resevation_unit text, account, out_file
    resevation_unit = []
    resevation_unit << text[/(\d+年\d+月\d+日)/, 1]
    resevation_unit << text[/(\d+時.\d+時)/, 1]
    resevation_unit << account[:name]
    resevation_unit << text[/(未入金|入金済)/, 1]
    str = resevation_unit.join(",")
    puts str
    out_file.puts str
  end
end
