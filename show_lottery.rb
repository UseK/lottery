#encoding: utf-8
require "rubygems"
require "mechanize"
require "kconv"
require "date"
def check_unit(id, pass, name, out_file)
	agent = Mechanize.new()
	agent.get("https://www.hyogo-park.or.jp/yoyaku/cancel/cancel.asp")
	#puts agent.page.uri
	agent.page.form_with(:name => 'form1'){|f|
		f.field_with(:name => 'mem_number').value = id
		f.field_with(:name => 'mem_password').value = pass
		f.click_button
	}
	agent.page.link_with(:href => 'cancel_lottery.asp').click
	out_file.puts name
	agent.page.search('tr/td/table[@width="400"]').each do |lottery|
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
if ARGV[1].nil?
	puts "Usage: check_lottery file_id file_out"
	exit
end
out_file = File.open(ARGV[1], "w")
File.open(ARGV[0], "r").read.each_line do |line|
	p line
	id, pass, name = line.split(/,/)
	check_unit(id, pass, name, out_file)
end

