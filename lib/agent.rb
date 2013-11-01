#encoding:utf-8
require 'rubygems'
require 'mechanize'
require 'kconv'

class Agent
	LOGOUT_URL = "https://www.hyogo-park.or.jp/yoyaku/kaiin/logout.asp"
	ERROR_URL = "http://www.hyogo-park.or.jp/yoyaku/errors.asp"
  CRT_Path = "#{File.dirname(__FILE__)}/../input/ca-bundle.crt"

	def initialize
		@agent = Mechanize.new
    @agent.ca_file = CRT_Path
	end

	def login(id, pass)
		@agent.page.form_with(:name => 'form1') do |f|
			f.field_with(:name => 'mem_number').value = id
			f.field_with(:name => 'mem_password').value = pass
			f.click_button(f.button_with(:value => '&nbsp;次&nbsp;&nbsp;へ&nbsp;'))
		end
	end

	def logout
		@agent.page.link_with(:href => LOGOUT_URL).click
	end

	def exit_errorpage
		puts @agent.page.at('table/tr/td/center/font').inner_text.strip
		puts "プログラムを終了します"
		exit
	end
end
