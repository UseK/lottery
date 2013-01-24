# encoding : utf-8
require 'rubygems'
require 'mechanize'
require 'kconv'

class RegisterUnit
	LOTTERY_URL ="http://www.hyogo-park.or.jp/yoyaku/lottery/calendar.asp?ins_id=8&ins_type=4"
	ERROR_URL = "http://www.hyogo-park.or.jp/yoyaku/errors.asp"
	LOGOUT_URL = "http://www.hyogo-park.or.jp/yoyaku/kaiin/logout.asp"

	def register_unit(id, pass, date, range_time='17')
		@agent = Mechanize.new
		@agent.get(LOTTERY_URL)
		if @agent.page.uri.to_s == ERROR_URL
      error_page
      exit
    end
		@agent.page.link_with(:href => "timetable.asp?date=" + date).click
		@agent.page.form_with(:name => 'form1').click_button
		@agent.page.form_with(:name => 'form1'){|f|
			f.field_with(:name => 'mem_number').value = id
			f.field_with(:name => 'mem_password').value = pass
			f.click_button
		}
		@agent.page.form_with(:name => 'form1'){|f|
			f.field_with(:name => 'opening_time').option_with(:value => range_time).select
			f.field_with(:name => 'eqp_count').option_with(:value => '1').select
			f.field_with(:name => 'usage').option_with(:value => '21').select
			f.field_with(:name => 'adults').value = '25'
			f.click_button
		}
		@agent.page.form_with(:name => 'form1').click_button
		error_page if @agent.page.uri.to_s == ERROR_URL
		@agent.page.link_with(:href => LOGOUT_URL).click
	end

	def error_page
		puts @agent.page.at('table/tr/td/center/font').inner_text.strip
	end

	def ordinal2int(ordinal)
		case ordinal
		when "1st" then return 0
		when "2nd" then return 1
		when "3rd" then return 2
		when "4th" then return 3
		when "5th" then return 4
		else $stderr.print("Error:out of ordinal in ordinal2int")
		end
	end

	def register_all(id_name,date_name,is_saturday)
		date_file = open(date_name,"r")
		open(id_name,"r").each_line do |id_line|
			if(is_saturday == '-s')then
				regist_saturday(date_file, id_line)
			else
				regist_ordinary(date_file, id_line)
			end
			date_file.rewind
		end
		date_file.close
	end

	def regist_saturday(date_file, id_line)
		date_array = date_file.read.split(/\n/)
		id, pass, name, strth, time_range = id_line.split(',')
		begin
			timeout(30){
				print name ,",",date_array[ordinal2int(strth)],",",time_range
				register_unit(id, pass, date_array[ordinal2int(strth)], time_range.chomp)
			}
		rescue => ex
			puts ex.message
			retry
		end
	end

	def regist_ordinary(date_file, id_line)
		id, pass, name = id_line.split(',')
		while date = date_file.gets
			begin
				timeout(30){
					print(name, ",", date)
					register_unit(id, pass, date.chomp)
				}
			rescue => ex
				puts ex.message
				retry
			end
		end
	end
end
id_name = ARGV[0]
if(ARGV[1])then
	date_name = ARGV[1]
else
	print("Usage:autoregister.rb  id_file date_file (-s)\n")
	exit
end
is_saturday = ARGV[2]
RegisterUnit.new.register_all(id_name,date_name,is_saturday)
