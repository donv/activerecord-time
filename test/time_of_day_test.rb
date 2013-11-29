require File.expand_path('test_helper', File.dirname(__FILE__))

class TimeOfDayTest < Test::Unit::TestCase
  def setup
    @twelve_o_clock = TimeOfDay.parse '12:00:00'
  end

  def teardown
  end

  def test_parse_full
    assert_equal @twelve_o_clock, TimeOfDay.parse('12:00:00')
  end

  def test_parse_hour_and_minute
    assert_equal @twelve_o_clock, TimeOfDay.parse('12:00')
  end

  def test_parse_hour_only
    assert_equal @twelve_o_clock, TimeOfDay.parse('12')
  end

end
