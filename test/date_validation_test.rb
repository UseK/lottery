require "test/unit"

$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
require "date_validation"

class TestDateValidation < Test::Unit::TestCase
	def test_must_valid_date
		dv = DateValidation.new("data/08ordinary.txt")
	end
end
