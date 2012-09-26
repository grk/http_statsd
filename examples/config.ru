# example config.ru

require 'rubygems'
require 'bundler'

Bundler.require

require 'http_statsd/server'

HttpStatsd::Server.set :api_keys, {
  "api1" => "pass1",
  "api2" => "pass2"
}
run HttpStatsd::Server
