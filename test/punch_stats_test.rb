require "test_helper"

class PunchStatsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PunchStats::VERSION
  end
end
