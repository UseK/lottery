#encoding:utf-8
require 'rubygems'
require 'mechanize'
require 'kconv'

class IntentLottery
	LOGOUT = "http://www.hyogo-park.or.jp/yoyaku/kaiin/logout.asp"

	def initialize
		@agent = Mechanize.new
	end

	def check_only(filename_id, filename_out)
		out_file = open(filename_out,"w")
		open(filename_id).each_line do |line|
			id, password, name = line.split(/,/)
			check_unit(id,password,name,'tekitou','tekitou2',out_file)
		end
		out_file.close
	end

	def check_and_regist(filename_intent, filename_finish)
		finish_file = open(filename_finish,"w")
		open(filename_intent).each_line do |line|
			if(/----/ =~ line) then
				puts ("next day")
				next
			end
			date,range_time,id,password,name = line.split(/,/)
			check_unit(id,password,name,date,range_time,finish_file)
		end
		finish_file.close
	end

	private
	def check_unit(id, password, name, date, range_time, out_file)
		@agent.get('http://www.hyogo-park.or.jp/yoyaku/intention/auth.asp?ch=0')
		authenticate(id, password)
		write_down_already_verified(id, password, name, out_file)
		verify_intent(id, password, name, date, range_time, out_file)
		@agent.page.link_with(:href => LOGOUT).click
	end

	private
	def authenticate(id, password)
		@agent.page.form_with(:name => 'form1'){|f|
			f.field_with(:name => 'mem_number').value =id
			f.field_with(:name => 'mem_password').value = password
			f.click_button(f.button_with(:value => '&nbsp;次&nbsp;&nbsp;へ&nbsp;'))
		}
	end

	private
	def write_down_already_verified(id, password, name, out_file)
		@agent.page.search('tr/td/table[@width="400"]')[0..50].each do |p|
			if(/(予約は承認されました。)/ =~ p.inner_text)then
				date_time = capture_date_time(p)
				write_down(date_time, id, password, name, "予約済み\n", out_file)
			end
		end
	end

	private
	def verify_intent(id, password, name, date, range_time, out_file)
		approvals = @agent.page.links_with(:text => '予約承認確認')
		approvals.each do |apr|
			apr.click
			date_time = capture_date_time_in_aprove
			write_down(date_time, id, password, name, "\n", out_file)
			if (date == date_time[0] && range_time == date_time[1]) then
				@agent.page.form_with(:name => 'form1'){|f|
					f.submit(f.button_with(:name => 'submi2'))
				}
			end
		end
	end

	private
	def capture_date_time_in_aprove
		arr = Array.new
		p = @agent.page.at('form/table[@width="400"]/tr/td/table[@width="400"]')
		arr = capture_date_time(p)
		return arr
	end

	private
	def capture_date_time(p)
		arr = Array.new
		if(/([0-9]*年[0-9]*月[0-9]*日)/ =~ p.inner_text) then
			arr << $1
		end
		if(/([0-9]*時〜[0-9]*時)/ =~ p.inner_text) then
			arr << $1
		end
		return arr
	end

	private
	def write_down(date_time, id, password, name, eol, out_file)
		line = Array.new
		line << date_time
		line << [id, password, name, eol]
		puts(line.join(','))
		out_file.print(line.join(','))
	end
end
