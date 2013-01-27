#encoding: utf-8
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "waiting_lottery"
require "csv_accessor"
root_dir = File.dirname(__FILE__) + "/../"
out_file = File.open(root_dir + "output/lottery.txt", "w")
csv_account = CSVAccessor.read_account root_dir + "input/account.csv"
csv_account.each do |account|
	WaitingLottery.new.check_unit(account, out_file)
end

