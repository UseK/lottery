#encoding:utf-8
root_dir = File.dirname(__FILE__) + "/../"
$LOAD_PATH << root_dir + "lib"
require "intent"
def wizard(intent_path)
  print File.open(intent_path, "r", :encoding => 'utf-8').read
  print "以上の日程の意思確認を行います、よろしいですか？/[yes no]>"
  if /^yes$/ =~ STDIN.gets.chomp
    puts "意思確認を行います"
  else
    puts "yesと返答されなかったので終了します"
    exit
  end
end
intent_path = root_dir + "input/intent.txt"
wizard(intent_path)
intent_lottery = Intent.new.verify_intent(intent_path)

