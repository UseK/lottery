#encoding:utf-8
require "csv"
require "pp"
require "date"
class IntentData
	attr_accessor :date, :range, :id, :pass, :name
	def initialize(date, range)
		@date = validate_date(date)
	end

	def validate_date(date)
		DateTime.parse(date)
		date
	end
end

class FileScanner
	def initialize
		rdir = File.dirname(__FILE__)
		@id_file = rdir + "/../input/id.csv"
		@intent_file = rdir + "/../input/intent.txt"
	end

	def scan_id_csv
		p csv =  CSV.read(@id_file, :headers => true)
		csv.each do |c|
			puts c['name']
		end
	end

	def scan_intent
		File.foreach(@intent_file, "r") do |line|
			puts line
		end
	end
end
FileScanner.new.scan_intent

