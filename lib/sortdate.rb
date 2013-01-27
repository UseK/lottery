#encoding:utf-8
def sortdate(filename_in,filename_out)
	file_out = open(filename_out,"w")
	int_line = open(filename_in,"r").read.split(/\n/)
	int_line.each do |p|
    if /月(\d)日/ =~ p
      p.sub!(/月(\d)日/,'月0' + $1 +'日')
    end
	end
	int_line.sort!
	int_line.each do |p|
		p.sub!(/月0/,'月')
	end
	date = ""
	range = ""
	int_line.each do |p|
		if /月(\d{1,2})日,(\d{1,2})/ =~ p
			if date != $1 || range != $2
				file_out.puts("----")
			end
			file_out.puts p
			date = $1
			range = $2
		end
	end
end
