# MkTime

## Introduction

This is a gem library which converts from UTC time to another time system.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mk_time'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mk_time

## Usage

### Instantiation

    t = MkTime.new("20160726")
    t = MkTime.new("20160726123456")
    t = MkTime.new("20160726123456123")
    t = MkTime.new

* You can set TDB formatted "YYYYMMDD" or "YYYYMMDDHHMMSS" or "YYYYMMDDHHMMSSU..." as an argument. (`U`: microseconds)
* If you don't set an argument, this class considers the system time to have been set as an argument.

### Conversion

    puts "     UTC: #{t.utc.instance_eval { '%s.%03d' % [strftime('%Y-%m-%d %H:%M:%S'), (usec / 1000.0).round] }}"
    puts "     JST: #{t.jst.instance_eval { '%s.%03d' % [strftime('%Y-%m-%d %H:%M:%S'), (usec / 1000.0).round] }}"
    puts "      JD: #{t.jd} day"
    puts "       T: #{t.t} century"
    puts " UTC-TAI: #{t.utc_tai} sec"
    puts "LEAP_SEC: #{t.leap_sec} sec"  # = tuc_tai
    puts "    DUT1: #{t.dut1} sec"
    puts "  deltaT: #{t.dt} sec"
    puts "     TAI: #{t.tai.instance_eval { '%s.%03d' % [strftime('%Y-%m-%d %H:%M:%S'), (usec / 1000.0).round] }}"
    puts "     UT1: #{t.ut1.instance_eval { '%s.%03d' % [strftime('%Y-%m-%d %H:%M:%S'), (usec / 1000.0).round] }}"
    puts "      TT: #{t.tt .instance_eval { '%s.%03d' % [strftime('%Y-%m-%d %H:%M:%S'), (usec / 1000.0).round] }}"
    puts "     TCG: #{t.tcg.instance_eval { '%s.%03d' % [strftime('%Y-%m-%d %H:%M:%S'), (usec / 1000.0).round] }}"
    puts "     TCB: #{t.tcb.instance_eval { '%s.%03d' % [strftime('%Y-%m-%d %H:%M:%S'), (usec / 1000.0).round] }}"
    puts "     TDB: #{t.tdb.instance_eval { '%s.%03d' % [strftime('%Y-%m-%d %H:%M:%S'), (usec / 1000.0).round] }}"

* To check times under 1 second, I use `instance_eval` method.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/komasaru/mk_time.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

