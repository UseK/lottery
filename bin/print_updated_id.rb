#encoding:utf-8
require "pp"
if ARGV[1].nil?
	puts "Usage: ruby update_saturday.rb id.txt saturday.txt"
	exit
end
saturday = File.open(ARGV[1], "r")
id = File.open(ARGV[0], "r").read.split(/\n/).map {|line| line.split(/,/)[0..2] }
id.each do |item|
	day = saturday.gets
	if !day
		saturday.rewind
		day = saturday.gets
	end
	print item.join(",").chomp, ",", day
end

