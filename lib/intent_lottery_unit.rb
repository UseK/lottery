#encoding:utf-8
require 'rubygems'
require 'mechanize'
require 'kconv'

class IntentLotteryUnit
	INTENT_URL = 'http://www.hyogo-park.or.jp/yoyaku/intention/auth.asp?ch=0'
	LOGOUT_URL = "http://www.hyogo-park.or.jp/yoyaku/kaiin/logout.asp"
	ERROR_URL = "http://www.hyogo-park.or.jp/yoyaku/errors.asp"

	def initialize
		@agent = Mechanize.new
	end

	def check_unit(id, pass, name, date, range_time, out_file)
		access
		login(id, pass)
		write_down_already_verified(id, pass, name, out_file)
		verify_intent(id, pass, name, date, range_time, out_file)
		logout
	rescue
		exit_errorpage
	end

	def access
		@agent.get(INTENT_URL)
		raise ErrorJumpError if @agent.page.uri.to_s == ERROR_URL
	end

	def login(id, pass)
		@agent.page.form_with(:name => 'form1') do |f|
			f.field_with(:name => 'mem_number').value = id
			f.field_with(:name => 'mem_password').value = pass
			f.click_button(f.button_with(:value => '&nbsp;次&nbsp;&nbsp;へ&nbsp;'))
		end
	end

	def write_down_already_verified(id, pass, name, out_file)
		@agent.page.search('tr/td/table[@width="400"]')[0..50].each do |p|
			if /予約は承認されました/ =~ p.inner_text
				date_time = capture_date_time(p)
				write_down(date_time, id, pass, name, "予約済み\n", out_file)
			end
		end
	end

	def verify_intent(id, pass, name, date, range_time, out_file)
		approvals = @agent.page.links_with(:text => '予約承認確認')
		approvals.each do |apr|
			apr.click
			date_time = capture_date_time_in_aprove
			write_down(date_time, id, pass, name, "\n", out_file)
			if date == date_time[0] && range_time == date_time[1]
				@agent.page.form_with(:name => 'form1') do |f|
					f.submit(f.button_with(:name => 'submi2'))
				end
			end
		end
	end

	def logout
		@agent.page.link_with(:href => LOGOUT_URL).click
	end

	private
	def exit_errorpage
		puts @agent.page.at('table/tr/td/center/font').inner_text.strip
		puts "プログラムを終了します"
		exit
	end

	def capture_date_time_in_aprove
		p = @agent.page.at('form/table[@width="400"]/tr/td/table[@width="400"]')
		capture_date_time(p)
	end

	def capture_date_time(p)
		date_time = []
		date_time << $1 if /([0-9]*年[0-9]*月[0-9]*日)/ =~ p.inner_text
		date_time << $1 if /([0-9]*時〜[0-9]*時)/ =~ p.inner_text
	end

	def write_down(date_time, id, pass, name, eol, out_file)
		line = [date_time, id, pass, name, eol].join(',')
		puts(line)
		out_file.print(line)
	end
end
