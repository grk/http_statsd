require 'statsd'
require 'sinatra'

module HttpStatsd
  class Server < Sinatra::Base
    set :api_keys, {}
    set :statsd_host, "localhost"
    set :statsd_port, 8125

    def statsd
      @statsd ||= Statsd.new(settings.statsd_host, settings.statsd_port)
    end

    use Rack::Auth::Basic do |username, password|
      settings.api_keys[username] == password
    end

    get '/increment' do
      args = [params["name"]]
      args << params["sample_rate"].to_f if params["sample_rate"]
      statsd.increment(*args)
      204
    end

    get '/decrement' do
      args = [params["name"]]
      args << params["sample_rate"].to_f if params["sample_rate"]
      statsd.decrement(*args)
      204
    end

    get '/count' do
      args = [params["name"], params["value"].to_f]
      args << params["sample_rate"].to_f if params["sample_rate"]
      statsd.count(*args)
      204
    end

    get '/gauge' do
      args = [params["name"], params["value"].to_f]
      statsd.gauge(*args)
      204
    end

    get '/timing' do
      args = [params["name"], params["value"].to_f]
      args << params["sample_rate"].to_f if params["sample_rate"]
      statsd.timing(*args)
      204
    end

    get '/' do
      200
    end
  end
end
