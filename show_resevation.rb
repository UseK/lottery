#encoding: utf-8
require "rubygems"
require "mechanize"
require "kconv"
require "date"
def check_unit(id_arr,out_file)
	agent = Mechanize.new()
	agent.get("https://www.hyogo-park.or.jp/yoyaku/cancel/cancel.asp")
	#puts agent.page.uri
	agent.page.form_with(:name => 'form1'){|f|
		f.field_with(:name => 'mem_number').value = id_arr[0]
		f.field_with(:name => 'mem_password').value = id_arr[1]
		f.click_button
	}
	#puts agent.page.uri
	agent.page.search('tr/td/table[@width="400"]')[0..50].each do |p|
		if(/(未入金)/ =~ p.inner_text)then
			if(/([0-9]*年[0-9]*月[0-9]*日)/ =~ p.inner_text) then
				print($1,(','))
				#puts p.inner_text
				out_file.print($1,(','))
			end
			if(/([0-9]*時〜[0-9]*時)/ =~ p.inner_text) then
				print($1,(','))
				#puts p.inner_text
				out_file.print($1,(','),id_arr[2],(','))
			end
			puts("yet_charged\n")
			out_file.print("yet\n")
			#------------------------------------------------------------
			#warning!operate cancel register temporarily.
			#agent.page.form_with(:name => 'form1'){|f|
			#f.checkbox_with(:name =>'rsv_number').check
			#f.click_button
			#puts agent.page.uri
			#agent.page.form_with(:name => 'form1').click_button
			#puts agent.page.uri
			#}
			#------------------------------------------------------------
		end
		if(/(入金済)/ =~ p.inner_text)then
			if(/([0-9]*年[0-9]*月[0-9]*日)/ =~ p.inner_text) then
				print($1,(','))
				#puts p.inner_text
				out_file.print($1,(','))
			end
			if(/([0-9]*時〜[0-9]*時)/ =~ p.inner_text) then
				print($1,(','))
				#puts p.inner_text
				out_file.print($1,(','),id_arr[2],(','))
			end
			puts("already_charged\n")
			out_file.print("already\n")
		end
	end
end
id_file = open("input/id.txt","r")
t = DateTime.now
out_file_name = "output/register" + t.strftime("%Y%B%H%M") + ".txt"
out_file = open(out_file_name,"w")
while (id_text = id_file.gets)do
	id_arr = id_text.split(/,/)
	puts id_arr[2]
	check_unit(id_arr,out_file)
end
id_file.close
out_file.print("That's all!\n")
out_file.close


