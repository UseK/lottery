# encoding : utf-8
#encoding: utf-8
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "lottery"
id_name = ARGV[0]
if(ARGV[1])then
	date_name = ARGV[1]
else
	print("Usage:autoregister.rb  id_file date_file (-s)\n")
	exit
end
is_saturday = ARGV[2]
Lottery.new.register_all(id_name,date_name,is_saturday)
