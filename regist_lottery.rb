# encoding : utf-8
require 'rubygems'
require 'mechanize'
require 'kconv'

#id_arr = [id number,pass word,name,ordinal of saturday,time of saturday]
def register_unit(id_arr,date_in,range_time='17')
	agent = Mechanize.new
	agent.get('http://www.hyogo-park.or.jp/yoyaku/lottery/calendar.asp?ins_id=8&ins_type=4')
	puts agent.page.uri
	#http://www.hyogo-park.or.jp/yoyaku/lottery/calendar.asp?ins_id=8&ins_type=4
	agent.page.link_with(:href => "timetable.asp?date=" +date_in.chomp).click
	puts agent.page.uri
	#http://www.hyogo-park.or.jp/yoyaku/lottery/timetable.asp?date=2011/**/**
	agent.page.form_with(:name => 'form1').click_button
	puts agent.page.uri
	#http://www.hyogo-park.or.jp/yoyaku/lottery/auth.asp
	agent.page.form_with(:name => 'form1'){|f|
		f.field_with(:name => 'mem_number').value = id_arr[0]
		f.field_with(:name => 'mem_password').value = id_arr[1]
		f.click_button
	}
	puts agent.page.uri
	#http://www.hyogo-park.or.jp/yoyaku/lottery/timetable_input.asp
	agent.page.form_with(:name => 'form1'){|f|
		f.field_with(:name => 'opening_time').option_with(:value => range_time).select
		f.field_with(:name => 'eqp_count').option_with(:value => '1').select
		f.field_with(:name => 'usage').option_with(:value => '21').select
		f.field_with(:name => 'adults').value = '25'
		f.click_button
	}
	puts agent.page.uri
	#http://www.hyogo-park.or.jp/yoyaku/lottery/confirm.asp
	agent.page.form_with(:name => 'form1').click_button
	puts agent.page.uri
	#http://www.hyogo-park.or.jp/yoyaku/errors.asp
	#http://www.hyogo-park.or.jp/yoyaku/lottery/success.asp
	agent.page.link_with(:href => "http://www.hyogo-park.or.jp/yoyaku/kaiin/logout.asp").click
	puts agent.page.uri
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
	puts id_name
	id_file = open(id_name,"r")
	date_file = open(date_name,"r")
	log_file = open('output/log.txt',"a+")
	id_file.each do |id_text|
		if(/^[^0-9]/ =~id_text)
			print("skip!(",id_text.chomp,")\n")
			next
		end
		id_array = id_text.split(/,/)
		if(is_saturday == '-s')then
			date_array = date_file.read.split(/\n/)
			begin
				sleep(3)
				timeout(30){
					print(id_array[2].chomp,",",date_array[ordinal2int(id_array[3])],",",id_array[4])
					register_unit(id_array,date_array[ordinal2int(id_array[3])],id_array[4].chomp)
					log_file.print(id_array[2].chomp,",",date_array[ordinal2int(id_array[3])],",",id_array[4])
				}
			rescue => ex
				puts ex.message
				retry
			end
		else
			while date_text = date_file.gets
				begin
					timeout(30){
						print(id_array[2].chomp,",",date_text)
						register_unit(id_array,date_text)
						log_file.print(id_array[2].chomp,",",date_text)
					}
				rescue Timeout::Error
					puts("retry")
					retry
				rescue NoMethodError
					puts("NoMeehodError")
					retry
				rescue => ex
					puts ex.message
					retry
				end
			end
		end
		date_file.rewind
	end
	date_file.close
	id_file.close
	log_file.close
end
def error_print
	agent.page.search('td')[0..200].each do |t|
		text = t.inner_text
		if(/ありません/ =~ text)then
			print text
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
register_all(id_name,date_name,is_saturday)
