#encoding: utf-8
if ARGV[0].nil?
	puts "Usage: ruby mine_lottery.rb output/intent.txt"
	exit
end
saturday = File.new(ARGV[0], "r").read.split(/\s/).select {|line| /土曜日/ =~ line}
#saturday.inject(Hash.new(0)){|hash, i| hash[i] += 1}
hash = Hash.new(0)
saturday.each do |line|
	hash[line] += 1
end
hash.each do |h|
	p h
end


