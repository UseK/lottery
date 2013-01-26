#encoding: utf-8
require 'rubygems'
require 'mechanize'
require 'kconv'

class LotteryAgent
  LOTTERY_URL ="http://www.hyogo-park.or.jp/yoyaku/lottery/calendar.asp?ins_id=8&ins_type=4"
  ERROR_URL = "http://www.hyogo-park.or.jp/yoyaku/errors.asp"
  LOGOUT_URL = "http://www.hyogo-park.or.jp/yoyaku/kaiin/logout.asp"

  def regist_unit(id, pass, date, range_time='17')
    @agent = Mechanize.new
    @agent.get(LOTTERY_URL)
    if @agent.page.uri.to_s == ERROR_URL
      error_page
      exit
    end
    @agent.page.link_with(:href => "timetable.asp?date=" + date).click
    @agent.page.form_with(:name => 'form1').click_button
    @agent.page.form_with(:name => 'form1'){|f|
      f.field_with(:name => 'mem_number').value = id
      f.field_with(:name => 'mem_password').value = pass
      f.click_button
    }
    @agent.page.form_with(:name => 'form1'){|f|
      f.field_with(:name => 'opening_time').option_with(:value => range_time).select
      f.field_with(:name => 'eqp_count').option_with(:value => '1').select
      f.field_with(:name => 'usage').option_with(:value => '21').select
      f.field_with(:name => 'adults').value = '25'
      f.click_button
    }
    @agent.page.form_with(:name => 'form1').click_button
    error_page if @agent.page.uri.to_s == ERROR_URL
    @agent.page.link_with(:href => LOGOUT_URL).click
  end

  def error_page
    puts @agent.page.at('table/tr/td/center/font').inner_text.strip
  end
end
