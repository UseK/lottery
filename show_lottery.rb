#encoding: utf-8
require "rubygems"
require "mechanize"
require "kconv"
require "date"

class Account
	attr_reader :id, :pass, :name
	def initialize(id, pass, name)
		@id = id
		@pass = pass
		@name = name
	end
end

class ShowLottery
	LOGOUT = "http://www.hyogo-park.or.jp/yoyaku/kaiin/logout.asp"
	def check_unit(account, out_file)
		@agent = Mechanize.new()
		access
		login(account)
		@agent.page.link_with(:href => 'cancel_lottery.asp').click
		search(out_file)
		logout
	end

	private
	def access
		@agent.get("https://www.hyogo-park.or.jp/yoyaku/cancel/cancel.asp")
	end

	def login(account)
		@agent.page.form_with(:name => 'form1'){|f|
			f.field_with(:name => 'mem_number').value = account.id
			f.field_with(:name => 'mem_password').value = account.pass
			f.click_button
		}
	end

	def search(out_file)
		@agent.page.search('tr/td/table[@width="400"]').each do |lottery|
			#puts lottery.inner_text
			if /([0-9]*)年\s*([0-9]*)月\s*([0-9]*)日/ =~ lottery.inner_text
				dt = sprintf("%d年%d月%d日", $1, $2, $3)
				print dt
				out_file.print dt
				if Date.new($1.to_i, $2.to_i, $3.to_i).wday == 6
					print '土曜日'
					out_file.print '土曜日'
				end
			end
			if /(\d+時)/ =~ lottery.inner_text
				print ",", $1, "\n"
				out_file.print ",", $1, "\n"
			end
		end
	end

	def logout
		@agent.page.link_with(:href => LOGOUT).click
	end
end
out_file = File.open("output/lottry.txt", "w")
File.open("input/id.txt", "r").read.each_line do |line|
	p line
	id, pass, name = line.split(/,/)
	ShowLottery.new.check_unit(Account.new(id, pass, name), out_file)
end

