# Traced

TraceD is a ruby library which enables you to easily trace your methods via [StatsD](https://github.com/etsy/statsd/)

## Installation

Add this line to your application's Gemfile:

    gem 'traced'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install traced

## Usage

### Configuration

Before using TraceD in your code you will have to provide it with a StatsD
Client. You can use many existing clients like [statsd-ruby](https://github.com/reinh/statsd).

```ruby
TraceD::Client.set(Statsd.new 'localhost', 9125)
```

### Usage Scenraios

Let's assume we have a Dummy class and we want to trace some_method:

```ruby
class Dummy

  include TraceD

  def some_method(arg)
  end

  statsd_trace :some_method
end
```

Simliarly, if we want to trace a class method, this is how things would look
like:

```ruby
class Dummy
  class << self
    include TraceD

    def some_method(arg)
    end

    statsd_trace :some_method
  end
end
```

## Tracing Options

### Stat Name

By default, TraceD assigns the following stat name:

```
method_tracer.<Class Name>.<Method Name>
```
For example, in the first usage scenraio, the reported stat would be
```
method_tracer.Dummy.some_method
```

You can pass your own custom stat name in the following way:

```ruby
statsd_trace :some_method, stat_name: "custom.stat.name"
```

### Execution Count

By default, TraceD will only report the execution time of the method.
You can ask it to report the number of times a method has been called in the
following way:

```ruby
statsd_trace :some_method, count: true
```
This way, both execution time and count will be reported

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
