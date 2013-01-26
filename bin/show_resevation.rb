#encoding: utf-8
require "rubygems"
require "mechanize"
require "kconv"
require "date"
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require "csv_reader"
class Resevation
	def show_all csv_account_path, output_path
    csv_id = CSVReader.read_id(csv_account_path)
    out_file = open(output_path, "w")
    csv_id.each do |id_row|
      puts "#{id_row[:name]}さんの予約情報を取得しています..."
			check_unit(id_row, out_file)
		end
		out_file.close
	end

  CANCEL = "https://www.hyogo-park.or.jp/yoyaku/cancel/cancel.asp"
	LOGOUT = "http://www.hyogo-park.or.jp/yoyaku/kaiin/logout.asp"
	def check_unit(id_row, out_file)
		@agent = Mechanize.new()
		@agent.get(CANCEL)

		@agent.page.form_with(:name => 'form1'){|f|
			f.field_with(:name => 'mem_number').value = id_row[:id]
			f.field_with(:name => 'mem_password').value = id_row[:pass]
			f.click_button
		}

		@agent.page.search('tr/td/table[@width="400"]')[0..50].each do |p|
			if /(未入金)/ =~ p.inner_text
        print_resevation_unit(p, id_row, "未入金", out_file)
			end
			if /(入金済)/ =~ p.inner_text
        print_resevation_unit(p, id_row, "入金済", out_file)
			end
		end

		@agent.page.link_with(:href => LOGOUT).click
	end

  private
  def print_resevation_unit p, id_row, charged, out_file
    resevation_unit = []
    if /([0-9]*年[0-9]*月[0-9]*日)/ =~ p.inner_text
      resevation_unit << $1
    end
    if /([0-9]*時〜[0-9]*時)/ =~ p.inner_text
      resevation_unit << $1
    end
    resevation_unit << id_row[:name]
    resevation_unit << charged
    str = resevation_unit.join(",")
    puts str
    out_file.puts str
  end
end
root_dir = File.dirname(__FILE__) + "/../"
csv_account_path = root_dir + "input/account.csv"
output_path = root_dir + "output/register" + DateTime.now.strftime("%Y%B%H%M") + ".txt"
puts "#{output_path} へ保存します"
Resevation.new.show_all csv_account_path, output_path
puts "#{output_path} へ保存しました"
