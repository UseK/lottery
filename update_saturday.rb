#encoding:utf-8
if ARGV[1].nil?
	puts "Usage: ruby update_saturday.rb id.txt saturday.txt"
	exit
end
saturday = File.open(ARGV[1], "r")
File.open(ARGV[0], "r").each_line do |line|
	day = saturday.gets
	if !day
		saturday.rewind
		day = saturday.gets
	end
	item = line.split(/,/)
	print item[0..2].join(",").chomp, ",", day
end

