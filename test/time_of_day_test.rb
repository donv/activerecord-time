require File.expand_path('test_helper', File.dirname(__FILE__))

class Event < ActiveRecord::Base
end

# TODO(uwe): Remove when we stop testing ActiveRecord 4.0
MiniTest::Test = Minitest::Unit unless defined? Minitest::Test
# ODOT

class TimeOfDayTest < Minitest::Test
  def setup
    @twelve_o_clock = TimeOfDay.parse '12:00:00'
  end

  def teardown
    @twelve_o_clock = nil
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

  def test_yaml_load
    hash = YAML.load('start_at: !!time 12:34:56')
    assert_equal({'start_at' => TimeOfDay.parse('12:34:56')}, hash)
  end

  def test_yaml_dump
    string = YAML.dump({'start_at' => TimeOfDay.parse('12:34:56')})
    assert_match /---\nstart_at: !!time '?12:34:56'?\n/, string
  end

  def test_column_type
    assert_equal [:integer, :string, :time], Event.columns.map(&:type)
  end

  def test_activerecord
    Event.create! name: 'Bored meeting', start_at: @twelve_o_clock
    t = Event.where(start_at: '12:00:00').first
    assert_equal TimeOfDay, t.start_at.class
    assert_equal t, Event.where(start_at: @twelve_o_clock).first
    assert_equal t, Event.where('start_at = ?', @twelve_o_clock).first
    assert_equal t, Event.where('start_at >= ?', @twelve_o_clock).first
    assert_equal t, Event.where('start_at <= ?', @twelve_o_clock).first
    assert_nil Event.where('start_at <> ?', @twelve_o_clock).first
    assert_nil Event.where('start_at < ?', @twelve_o_clock).first
    assert_nil Event.where('start_at > ?', @twelve_o_clock).first

    # TODO(uwe): Simplify when we stop supporting ActiveRecord 3
    if ActiveRecord::VERSION::MAJOR >= 4
      t.update! start_at: TimeOfDay.new(13)
    else
      t.update_attributes! start_at: TimeOfDay.new(13)
    end
    # ODOT

    t.destroy
  end

end
