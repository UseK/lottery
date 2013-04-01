#encoding: utf-8
require 'rubygems'
require 'mechanize'
require 'kconv'

$LOAD_PATH << File.dirname(__FILE__)
require "agent"

class LotteryAgent < Agent
  LOTTERY_URL ="http://www.hyogo-park.or.jp/yoyaku/lottery/calendar.asp?ins_id=8&ins_type=4"

  def regist_unit(id, pass, date, opening_time='17')
    @agent.get(LOTTERY_URL)
    exit_errorpage if @agent.page.uri.to_s == ERROR_URL
    calender(date)
    timetable
    login(id, pass)
    timetable_input(opening_time)
    confirm
    error_page if @agent.page.uri.to_s == ERROR_URL
    logout
  end

  def calender date
    @agent.page.link_with(:href => "timetable.asp?date=" + date).click
  end

  def timetable
    @agent.page.form_with(:name => 'form1').click_button
  end

  def timetable_input opening_time
    @agent.page.form_with(:name => 'form1'){|f|
      f.field_with(:name => 'opening_time').option_with(:value => opening_time).select
      f.field_with(:name => 'eqp_count').option_with(:value => '1').select
      f.field_with(:name => 'usage').option_with(:value => '21').select
      f.field_with(:name => 'adults').value = '25'
      f.click_button
    }
  end

  def confirm
    @agent.page.form_with(:name => 'form1').click_button
  end

  def error_page
    puts @agent.page.at('table/tr/td/center/font').inner_text.strip
  end
end
