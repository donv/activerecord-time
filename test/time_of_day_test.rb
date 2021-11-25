# frozen_string_literal: true

require File.expand_path('test_helper', File.dirname(__FILE__))

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Event < ApplicationRecord
end

class TimeOfDayTest < Minitest::Test
  def setup
    @twelve_o_clock = TimeOfDay.parse '12:00:00'
  end

  def teardown
    @twelve_o_clock = nil
  end

  def test_initialize
    tod = TimeOfDay.new(1, 2, 3)
    assert_equal 1, tod.hour
    assert_equal 2, tod.minute
    assert_equal 3, tod.second
  end

  def test_kernel_initialize
    tod = TimeOfDay(1, 2, 3)
    assert_equal 1, tod.hour
    assert_equal 2, tod.minute
    assert_equal 3, tod.second
  end

  def test_kernel_initialize_string
    tod = TimeOfDay('01:02:03')
    assert_equal 1, tod.hour
    assert_equal 2, tod.minute
    assert_equal 3, tod.second
  end

  def test_now
    tod = TimeOfDay.now
    assert tod.hour
  end

  def test_parse
    tod = TimeOfDay.parse('10:01')
    assert_equal 10, tod.hour
    assert_equal 1, tod.minute
    assert_equal 0, tod.second

    tod = TimeOfDay.parse('23:59:59')
    assert_equal 23, tod.hour
    assert_equal 59, tod.minute
    assert_equal 59, tod.second
  end

  def test_parse_immutable_string
    tod = TimeOfDay.parse('10:01')
    assert_equal 10, tod.hour
    assert_equal 1, tod.minute
    assert_equal 0, tod.second

    tod = TimeOfDay.parse('23:59:59')
    assert_equal 23, tod.hour
    assert_equal 59, tod.minute
    assert_equal 59, tod.second
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
    assert_equal({ 'start_at' => TimeOfDay.parse('12:34:56') }, hash)
  end

  def test_yaml_dump
    string = YAML.dump('start_at' => TimeOfDay.parse('12:34:56'))
    assert_match(/---\nstart_at: !!time '?12:34:56'?\n/, string)
  end

  def test_column_type
    assert_equal %i[integer string time binary], Event.columns.map(&:type)
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

    t.update! start_at: TimeOfDay.new(13)
    t.destroy
  end

  def test_activerecord_binary_column
    text = 'Some binary content'
    Event.create! content: text
    e = Event.where(content: text).first
    assert_equal text, e.content

    e.update! content: 'Other binary content'
  end

  def test_on
    tod = TimeOfDay.new(12, 59)
    assert_equal 12, tod.hour
    assert_equal 59, tod.minute

    t = tod.on(Date.new(2000, 12, 31))
    assert_equal 12, t.hour
    assert_equal 59, t.min
    assert_equal 0, t.sec
    assert_equal 2000, t.year
    assert_equal 12, t.month
    assert_equal 31, t.day
  end

  def test_minus
    tod = TimeOfDay.new(12, 0, 59)
    tod -= 60

    assert_equal 11, tod.hour
    assert_equal 59, tod.minute
    assert_equal 59, tod.second
  end

  if ActiveRecord.gem_version >= Gem::Version.new('6.1')
    def test_minus_tod
      tod1 = TimeOfDay.new(12, 0, 29)
      tod2 = TimeOfDay.new(13, 30, 59)
      duration = tod2 - tod1

      assert_equal 1, duration.in_hours.to_i
      assert_equal 30, duration.in_minutes.to_i % 60
      assert_equal 30, duration.in_seconds % 60
    end
  end

  def test_equality
    tod1 = TimeOfDay.new(12, 0, 5)
    tod2 = TimeOfDay.new(12, 0, 5)
    assert tod1 == tod2
    tod2 -= 1
    assert_equal false, tod1 == tod2
  end

  def test_spaceship
    tod1 = TimeOfDay.new(12, 0)
    tod2 = TimeOfDay.new(13, 0)
    assert_equal(-1, tod1 <=> tod2)
    assert_equal 1, tod2 <=> tod1
    assert_equal 0, tod1 <=> tod1
  end

  def test_strftime
    tod = TimeOfDay.new(6, 20, 59)
    assert_equal '06:20:59', tod.strftime('%H:%M:%S')
  end

  def test_to_s
    tod = TimeOfDay.new(12, 13, 14)
    assert_equal '12:13', tod.to_s(false)
    assert_equal '12:13:14', tod.to_s(true)
  end

  def test_to_yaml
    tod = TimeOfDay.new(12, 13, 14)
    assert_match(/--- !!time '?12:13:14'?\n/, tod.to_yaml)
  end

  def test_date_at
    tod = TimeOfDay.new(12, 13, 14)
    d = Date.new(2000, 12, 31)
    t = d.at(tod)
    assert_equal 12, t.hour
    assert_equal 13, t.min
    assert_equal 14, t.sec
    assert_equal 2000, t.year
    assert_equal 12, t.month
    assert_equal 31, t.day
  end

  def test_date_at_string
    tod = '12:13:14'
    d = Date.new(2000, 12, 31)
    t = d.at(tod)
    assert_equal 12, t.hour
    assert_equal 13, t.min
    assert_equal 14, t.sec
    assert_equal 2000, t.year
    assert_equal 12, t.month
    assert_equal 31, t.day
  end

  def test_to_json
    tod = TimeOfDay.new(12, 13)
    assert_equal '"12:13:00"', tod.to_json('foo')
  end

  def test_eql?
    a = TimeOfDay.new(10, 11, 12)
    b = TimeOfDay.new(10, 11, 12)
    assert a.eql?(b)
    assert_equal a.hash, b.hash
    hashmap = {}
    hashmap[a] = 'foo'
    hashmap[b] = 'bar'
    assert_equal hashmap, TimeOfDay.new(10, 11, 12) => 'bar'
  end

  def test_inspect
    assert_equal '#<TimeOfDay hour=10, minute=11, second=12>', TimeOfDay.new(10, 11, 12).inspect
  end
end
