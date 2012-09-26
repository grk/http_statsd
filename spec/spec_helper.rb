require 'rubygems'
require 'bundler/setup'

require 'rack/test'
require 'webmock/rspec'

require 'http_statsd'

def app
  HttpStatsd::Server
end

app.set :environment, :test
app.set :raise_errors, true
app.set :logging, false

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
