require 'yaml'

# rubocop: disable Rails/TimeZone, Rails/Date
class TimeOfDay
  attr_accessor :hour # 0 - 23
  attr_accessor :minute # 0 - 59
  attr_accessor :second # 0 - 59

  def initialize(hour, minute = 0, second = 0)
    raise "Invalid hour: #{hour}" unless hour >= 0 && hour <= 23
    raise "Invalid minute: #{minute}" unless minute >= 0 && minute <= 59
    raise "Invalid second: #{second}" unless second >= 0 && hour <= 59
    @hour, @minute, @second = hour, minute, second
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
    Time.now.time_of_day
  end

  def self.parse(string)
    return nil if string.blank?
    new(*parse_parts(string))
  end

  def self.parse_parts(string)
    string = string.strip
    raise "Illegal time format: '#{string}'" unless string =~ /^(\d{1,2}):?(\d{2})?(?::(\d{1,2}))?$/
    [Regexp.last_match(1).to_i, Regexp.last_match(2).to_i, Regexp.last_match(3).to_i]
  end

  def on(date)
    Time.local(date.year, date.month, date.day, hour, minute, second)
  end

  def +(other)
    raise "Illegal argument: #{other.inspect}" unless other.is_a? Numeric
    t = Time.local(0, 1, 1, hour, minute, second)
    t += other
    self.class.new(t.hour, t.min, t.sec)
  end

  def -(other)
    raise "Illegal argument: #{other.inspect}" unless other.is_a? Numeric
    self.+(-other)
  end

  def <=>(other)
    [@hour, @minute, @second] <=> [other.hour, other.minute, other.second]
  end

  def ==(other)
    return false unless other.is_a? TimeOfDay
    (self <=> other) == 0
  end

  def <(other)
    return false unless other.is_a? TimeOfDay
    (self <=> other) < 0
  end

  def <=(other)
    return false unless other.is_a? TimeOfDay
    (self <=> other) <= 0
  end

  def >(other)
    return false unless other.is_a? TimeOfDay
    (self <=> other) > 0
  end

  def >=(other)
    return false unless other.is_a? TimeOfDay
    (self <=> other) >= 0
  end

  def strftime(format)
    on(Date.today).strftime(format)
  end

  def to_s(with_seconds = true)
    if with_seconds
      '%02d:%02d:%02d' % [@hour, @minute, @second]
    else
      '%02d:%02d' % [@hour, @minute]
    end
  end

  def to_json(*)
    %("#{self}")
  end
end

class Time
  def time_of_day
    TimeOfDay.new(hour, min, sec)
  end
end

class Date
  def at(time_of_day)
    time_of_day = TimeOfDay.parse(time_of_day) if time_of_day.is_a?(String)
    Time.local(year, month, day, time_of_day.hour, time_of_day.minute, time_of_day.second)
  end
end

module Kernel
  def TimeOfDay(string_or_int, *ints) # rubocop: disable Style/MethodName
    if string_or_int.is_a? String
      raise(ArgumentError, 'TimeOfDay() takes a string or multiple integers as arguments') unless ints.empty?
      TimeOfDay.parse(string_or_int)
    else
      TimeOfDay.new(string_or_int, *ints)
    end
  end
end

YAML.add_tag 'tag:yaml.org,2002:time', TimeOfDay
