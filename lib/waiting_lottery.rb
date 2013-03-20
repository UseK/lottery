#encoding: utf-8
require "rubygems"
require "openssl"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require "mechanize"
require "kconv"
require "date"

class WaitingLottery
	LOGOUT_URL = "http://www.hyogo-park.or.jp/yoyaku/kaiin/logout.asp"
	def check_unit(account, out_file)
		@agent = Mechanize.new()
		access
		login(account)
		link = @agent.page.link_with(:href => 'cancel_lottery.asp')
    if link.nil?
      puts "抽選結果待ちの確認が行えるのは１日から７日までです．"
      puts "プログラムを終了します．"
      exit
    else
      link.click
    end
		search(out_file)
		logout
	end

	private
	def access
		@agent.get("https://www.hyogo-park.or.jp/yoyaku/cancel/cancel.asp")
	end

	def login(account)
		@agent.page.form_with(:name => 'form1'){|f|
			f.field_with(:name => 'mem_number').value = account[:id]
			f.field_with(:name => 'mem_password').value = account[:pass]
			f.click_button
		}
	end

	def search(out_file)
		@agent.page.search('tr/td/table[@width="400"]').each do |lottery|
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
		@agent.page.link_with(:href => LOGOUT_URL).click
	end
end
