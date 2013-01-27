#encoding:utf-8
root_dir = File.dirname(__FILE__) + "/../"
$LOAD_PATH << root_dir + "lib"
require "intent"
intent_file = root_dir + "input/intent.txt"
intent_lottery = Intent.new
intent_lottery.verify_intent(intent_file)

