#encoding:utf-8
require "csv"
require "pp"
class IdScanner
	def scan_id_csv
		p csv =  CSV.read("../input/id.csv", :headers => true)
		csv.each do |c|
			puts c['name']
		end
	end
end
puts __DIR__
#IdScanner.new.scan_id_csv

