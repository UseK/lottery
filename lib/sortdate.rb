#encoding:utf-8
def sortdate(filename_in,filename_out)
	if(filename_in && filename_out)then
	else
		puts("Usage:createtex.rb input_file.txt (>output/file.txt)")
		exit
	end
	file_out = open(filename_out,"w")
	int_file = open(filename_in,"r")
	int_line = int_file.read.split(/\n/)
	int_line.each do |p|
		if (/月([0-9])日/=~p)then
				p.sub!(/月([0-9])日/,'月0' + $1 +'日')
		end
	end
	int_line.sort!
	int_line.each do |p|
		p.sub!(/月0/,'月')
	end
	date = ""
	range = ""
	int_line.each do |p|
		if(/月([0-9]*)日,([0-9][0-9])/=~p)then
			if(date != $1||range != $2)then
				file_out.puts("----")
			end
			file_out.puts p
			date = $1
			range = $2
		end
	end
end
def show(file_name)
	file = open(file_name, "r")
	file.each do |f|
		puts f
	end
	file.close
end
