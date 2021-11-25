# frozen_string_literal: true

require 'yaml'

class TimeOfDay
  include Comparable

  attr_accessor :hour # 0 - 23
  attr_accessor :minute # 0 - 59
  attr_accessor :second # 0 - 59

  def initialize(hour, minute = 0, second = 0)
    if hour == 24
      unless minute == 0 && second == 0
        raise "Invalid TimeOfDay. #{hour}:#{minute}:#{second} given, but highest allowed value is 24:00:00"
      end
    else
      raise "Invalid hour: #{hour}" unless hour >= 0 && hour <= 23
    end
    raise "Invalid minute: #{minute}" unless minute >= 0 && minute <= 59
    raise "Invalid second: #{second}" unless second >= 0 && second <= 59

    @hour = hour
    @minute = minute
    @second = second
  end

  def init_with(coder)
    parts = self.class.parse_parts(coder.scalar)
    initialize(*parts)
  end

  def encode_with(coder)
    coder.tag = 'tag:yaml.org,2002:time'
    coder.scalar = to_s
  end

  def self.now
    Time.now.time_of_day # rubocop: disable Rails/TimeZone
  end

  def self.parse(string)
    return nil if string.blank?

    tod = _parse(string)
    raise ArgumentError, "Illegal time format: '#{string}'" unless tod

    tod
  end

  def self._parse(string)
    parts = parse_parts(string)
    return unless parts

    new(*parts)
  end

  def self.parse_parts(string)
    return nil if string.blank?
    return unless /^(?<hours>\d{1,2}):?(?<minutes>\d{2})?(?::(?<seconds>\d{1,2}))?$/ =~ string.strip

    [hours.to_i, minutes.to_i, seconds.to_i]
  end

  def acts_like_time?
    true
  end

  def in_time_zone(*)
    self
  end

  def to_time
    on Date.today
  end

  def on(date)
    Time.local(date.year, date.month, date.day, hour, minute, second) # rubocop: disable Rails/TimeZone
  end

  def +(other)
    raise "Illegal argument: #{other.inspect}" unless other.is_a? Numeric

    t = Time.local(0, 1, 1, hour, minute, second) # rubocop: disable Rails/TimeZone
    t += other
    self.class.new(t.hour, t.min, t.sec)
  end

  def -(other)
    case other
    when TimeOfDay
      t1 = Time.local(0, 1, 1, hour, minute, second) # rubocop: disable Rails/TimeZone
      t2 = Time.local(0, 1, 1, other.hour, other.minute, other.second) # rubocop: disable Rails/TimeZone
      (t1 - t2).seconds
    when Numeric
      self.+(-other)
    else
      raise "Illegal argument: #{other.inspect}"
    end
  end

  def <=>(other)
    return -1 unless other

    other_tod = if other.is_a?(TimeOfDay)
                  other
                elsif other.respond_to?(:time_of_day)
                  other.time_of_day
                else
                  other
                end

    to_a <=> [other_tod.hour, other_tod.minute, other_tod.second]
  end

  # Referring to the same H/M/S makes objects equal.
  # and we only want one hash key.
  def hash
    @hour.hash ^ @minute.hash ^ @second.hash
  end

  # Referring to the same H/M/S makes objects equal.
  def eql?(other)
    hash == other.hash
  end

  def strftime(format)
    on(Date.today).strftime(format)
  end

  def to_s(with_seconds = true)
    if with_seconds
      '%02d:%02d:%02d' % to_a
    else
      '%02d:%02d' % [@hour, @minute]
    end
  rescue
    "#{@hour.inspect}:#{@minute.inspect}:#{@second.inspect}"
  end

  def inspect
    "#<#{self.class} hour=#{@hour}, minute=#{@minute}, second=#{@second}>"
  end

  def to_a
    [@hour, @minute, @second]
  end

  def to_json(*)
    %("#{self}")
  end
end
