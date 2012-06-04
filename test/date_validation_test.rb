require "test/unit"
require "../lib/date_validation"

class TestDateValidation < Test::Unit::TestCase
	def test_must_valid_date
		dv = DateValidation.new("data/08ordinary.txt")
	end
end
