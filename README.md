# activerecord-time

[![Build Status](https://travis-ci.org/donv/activerecord-time.svg)](https://travis-ci.org/donv/activerecord-time)

A handler for storing TimeOfDay objects in ActiveRecord objects as SQL time values.

Also adds load/dump of TimeOfDay objects to and from YAML streams, so you can use
them in fixtures.

The gem supports MRI and JRuby at Ruby language level 1.9.3 and later.

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-time'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-time

## Usage

Create your tables with fields with type :time and you will be able to access them as
TimeOfDay objects.

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



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
