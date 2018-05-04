require 'time_of_day'

class Time
  def time_of_day
    TimeOfDay.new(hour, min, sec)
  end
end

class Date
  def at(time_of_day)
    time_of_day = TimeOfDay.parse(time_of_day) if time_of_day.is_a?(String)
    zone = Time.zone || Time
    zone.local(year, month, day, time_of_day.hour, time_of_day.minute, time_of_day.second)
  end
end

module Kernel
  def TimeOfDay(string_or_int, *ints) # rubocop: disable Naming/MethodName
    if string_or_int.is_a? String
      unless ints.empty?
        raise(ArgumentError, 'TimeOfDay() takes a string or multiple integers as arguments')
      end
      TimeOfDay.parse(string_or_int)
    else
      TimeOfDay.new(string_or_int, *ints)
    end
  end
end

YAML.add_tag 'tag:yaml.org,2002:time', TimeOfDay
