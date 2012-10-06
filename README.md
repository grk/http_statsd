# HttpStatsd

[![Build Status](https://secure.travis-ci.org/grk/http_statsd.png)](http://travis-ci.org/grk/http_statsd)

HttpStatsd provides a HTTP proxy for the statsd protocol. The use case is when
you need to collect metrics from an external source, but for obvious reasons
don't want to expose the udp interface of statsd.

It also provides a client for that proxy for easy integration with Ruby code.

## Installation

Add this line to your application's Gemfile:

    gem 'http_statsd'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_statsd

## Usage

### Server

There is an example `config.ru` file included in the repo. To use the proxy,
you need to provide at least one api key, with:

```ruby
HttpStatsd::Server.set :api_keys, {
  "username1" => "pass1",
  "username2" => "pass2"
}
```

You can also set the statsd server host and port (default is "localhost:8125"):

```ruby
HttpStatsd::Server.set :statsd_host, "statsd.example.com"
HttpStatsd::Server.set :statsd_port, 8125
```

### Client

To access the server, you can use the built in client:

```ruby
c = HttpStatsd::Client.new(base_uri: "http://statsd.example.com",
                           username: "username1", password: "pass1")
```

Then, you can use the same interface as with the
[statsd-ruby](https://github.com/github/statsd-ruby) gem:

```ruby
sample_rate = 0.1
c.increment("metric.counter", sample_rate)
c.decrement("metric.counter", sample_rate)
c.count("metric.counter", 121, sample_rate)
c.gauge("metric.gauge", 123)
c.timing("metric.timing", 15.52, sample_rate)
c.batch do |b| # this will send the metrics as one http request
  b.increment("metric.counter")
  b.gauge("metric.gauge", 120)
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
