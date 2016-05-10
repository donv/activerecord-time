# activerecord-time

[![Build Status](https://travis-ci.org/donv/activerecord-time.svg)](https://travis-ci.org/donv/activerecord-time)

A handler for storing TimeOfDay objects in ActiveRecord objects as SQL time values.

Also adds load/dump of TimeOfDay objects to and from YAML streams, so you can use
them in fixtures.

Also adds JSON encode/decode.

The gem supports MRI and JRuby at Ruby language level 1.9.3 and later.  Other
Ruby implementations may work.

ActiveRecord 3.2 and later supported.

Ruby 1.9.3 to 2.3.1 supported, including JRuby.


## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-time'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-time

## Usage

Create your tables with fields with type :time and you will be able to access
them as TimeOfDay objects.

```Ruby
create_table :schedules do |t|
  ...
  t.time :start_at
  ...
end
```

or

```Ruby
create_table :schedules do |table|
  ...
  t.column :start_at, :time
  ...
end
```

or

```Ruby
add_column :schedule, :start_time, :time
```

The value of the column will be a TimeOfDay object:

```Ruby
schedule = Schedule.new
schedule.start_time = TimeOfDay.parse('08:34')
```

or

```Ruby
schedule = Schedule.new
schedule.start_time = '08:34'
```

## TimeOfDay Kernel extension

Kernel is extended with a TimeOfDay constructor that takes either a parseable
String or one or more integers.

```Ruby
party_starts_at = TimeOfDay('17:59')
dancing_starts_at = TimeOfDay(20, 02)
```

## TimeOfDay Date extension

Ruby Date objects are extended with the `at` method that takes a TimeOfDay
argument to produce a Ruby Time object.  As a shortcut, a String that is
parseable by TimeOfDay can be given.

```Ruby
halloween = Date.parse('2015-10-31')
trick_or_treat = halloween.at(TimeOfDay.parse('18:00'))
halloween_dinner = halloween.at('20:00')
```

## TimeOfDay Time extension

Ruby Time objects are extended with the `time_of_day` method that returns a
TimeOfDay object corresponding to the time of day of the Time object.

```Ruby
Time.parse('2015-10-31 20:00').time_of_day # returns TimeOfDay(20, 0)
```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Testing

Run tests using

    rake
    
### Matrix test

    ./matrix_test.rb

This will run the tests for the same environments as travis-ci.
